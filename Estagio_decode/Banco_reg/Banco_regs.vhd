library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library componentes;
use componentes.Buffers.Buffers;
use componentes.Decode_subida.Decode_subida;
use componentes.Decode_descida.Decode_descida;
use componentes.REG4.REG4;
use componentes.tipos.array_reg;

use work.tipos.all;

ENTITY BANCO_REGS IS
    PORT (
        read_reg, write_reg : IN STD_LOGIC;
        clock               : IN STD_LOGIC;
        reg_data            : IN INSTRUCAO; -- Dados a serem escritos
        reg_in1, reg_in2, reg_in3 : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        reg_out1, reg_out2  : OUT INSTRUCAO; -- Dados lidos
        reg_file_out       : OUT Banco_regs_type
    );
END BANCO_REGS;

ARCHITECTURE logica OF BANCO_REGS IS
    --Sinais de barramento
    signal barramentoRS, barramentoRT : INSTRUCAO;
    
    --Sinais de reg
    signal regs : array_reg;
    
    --Sinais de controle
    signal write_enable   : STD_LOGIC_VECTOR(15 DOWNTO 0);
    signal read_enable_rs : STD_LOGIC_VECTOR(15 DOWNTO 0);
    signal read_enable_rt : STD_LOGIC_VECTOR(15 DOWNTO 0);
    
    --Saida dos decodes de leitura e escrita
    signal decoded_rd, decoded_rs, decoded_rt : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN
    --Decode de escrita atualiza na subida
    dec_write: entity componentes.Decode_subida
        port map (
            data     => reg_in3,
            clock    => clock,
            data_out => decoded_rd
        );

    --Decode de leitura atualiza na descida (RS)
    dec_read_rs: entity componentes.Decode_descida
        port map (
            data     => reg_in1,
            clock    => clock,
            data_out => decoded_rs
        );
    --Decode de leitura atualiza na descida (RT)
    dec_read_rt: entity componentes.Decode_descida
        port map (
            data     => reg_in2,
            clock    => clock,
            data_out => decoded_rt
        );

    process(decoded_rd, decoded_rs, decoded_rt, write_reg, read_reg)
    begin
        for i in 0 to 15 loop
            write_enable(i)   <= decoded_rd(i) and write_reg;
            read_enable_rs(i) <= decoded_rs(i) and read_reg;
            read_enable_rt(i) <= decoded_rt(i) and read_reg;
        end loop;
    end process;

    --Instanciação dos 16 registradores
    gen_regs: for i in 0 to 15 generate
        reg_inst: entity work.REG4
            port map (
                D      => reg_data, -- Dados a serem escritos
                RESET  => '0',
                CLOCK  => clock,
                ENABLE => write_enable(i), -- Habilita escrita no registrador correto
                Q      => regs(i)
            );
    end generate;

    -- Ajustar buffers para saída correta
    gen_buffers_rs: for i in 0 to 15 generate
        buffer_rs: entity work.Buffers
            port map (
                INPUT  => regs(i),
                ENABLE => read_enable_rs(i),
                OUTPUT => barramentoRS
            );
    end generate;

    gen_buffers_rt: for i in 0 to 15 generate
        buffer_rt: entity work.Buffers
            port map (
                INPUT  => regs(i),
                ENABLE => read_enable_rt(i),
                OUTPUT => barramentoRT
            );
    end generate;

    reg_out1 <= barramentoRS;
    reg_out2 <= barramentoRT;
    reg_file_out <= regs;

END logica;