library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Buffers.all;
use work.Decode_subida.all;
use work.Decode_descida.all;
use work.REG4.all;

ENTITY BANCO_REGS IS
PORT (
    read_reg, write_reg : IN STD_LOGIC;
    clock: IN STD_LOGIC;
    reg_data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
    reg_in1, reg_in2, reg_in3 : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    reg_out1, reg_out2 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
);
END BANCO_REGS;

ARCHITECTURE logica OF BANCO_REGS IS
    -- Sinais internos para os barramentos
    signal barramentoRS, barramentoRT : STD_LOGIC_VECTOR(15 DOWNTO 0);
    -- Sinais para os registradores
    signal regs : array(0 to 15) of STD_LOGIC_VECTOR(15 DOWNTO 0);
    -- Buffers para controle de escrita e leitura
    signal write_enable : array(0 to 15) of STD_LOGIC;
    signal read_enable_rs : array(0 to 15) of STD_LOGIC;
    signal read_enable_rt : array(0 to 15) of STD_LOGIC;
    -- Sinais para os decodificadores
    signal decoded_rd, decoded_rs, decoded_rt : STD_LOGIC_VECTOR(15 DOWNTO 0);
begin
    -- Decodificador para escrita (subida do clock)
    process(clock)
    begin
        if rising_edge(clock) then
            decode_rd: entity work.Decode_subida
            port map (
                data => reg_in3,
                clock => clock,
                data_out => decoded_rd
            );
        end if;
    end process;

    -- Decodificadores para leitura (descida do clock)
    process(clock)
    begin
        if falling_edge(clock) then
            decode_rs: entity work.Decode_descida
            port map (
                data => reg_in1,
                clock => clock,
                data_out => decoded_rs
            );

            decode_rt: entity work.Decode_descida
            port map (
                data => reg_in2,
                clock => clock,
                data_out => decoded_rt
            );
        end if;
    end process;

    -- Geração dos sinais de habilitação com base nos decodificadores
    process(all)
    begin
        for i in 0 to 15 loop
            write_enable(i) <= decoded_rd(i) and write_reg;
            read_enable_rs(i) <= decoded_rs(i) and read_reg;
            read_enable_rt(i) <= decoded_rt(i) and read_reg;
        end loop;
    end process;

    -- Instâncias dos registradores usando REG4
    gen_regs: for i in 0 to 15 generate
        reg_inst: entity work.REG4
        port map (
            D => reg_data,
            RESET => '0',
            CLOCK => clock,
            ENABLE => write_enable(i),
            Q => regs(i)
        );
    end generate;

    -- Buffers para leitura de RS e RT
    gen_buffers_rs: for i in 0 to 15 generate
        buffer_rs: entity work.Buffers
        port map (
            INPUT => regs(i),
            ENABLE => read_enable_rs(i),
            OUTPUT => barramentoRS
        );
    end generate;

    gen_buffers_rt: for i in 0 to 15 generate
        buffer_rt: entity work.Buffers
        port map (
            INPUT => regs(i),
            ENABLE => read_enable_rt(i),
            OUTPUT => barramentoRT
        );
    end generate;

    -- Saídas
    reg_out1 <= barramentoRS;
    reg_out2 <= barramentoRT;

end logica;


