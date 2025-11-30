library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.tipos.all;

entity estagio_decode is
    generic(
        bit_width : integer := 16
    );
    port(
        clk : in std_logic;
        reset : in std_logic;
        instrucao_in : in std_logic_vector(15 downto 0); 
        instruction_out : out std_logic_vector(15 downto 0); 
        writeback_instruction : in std_logic_vector(15 downto 0); 
        writeback_data : in std_logic_vector(15 downto 0);
        val_a : out std_logic_vector(15 downto 0);
        val_b : out std_logic_vector(15 downto 0);
        i_signal_extend : out std_logic_vector(15 downto 0);
        PC_out : out integer;
        reg_file_out : out array_reg;
        write_reg : in std_logic; -- Sinal de escrita
        reset_reg : in std_logic;   
        stall_in : in std_logic;
        stall_out : out std_logic;
        opcode_out : out std_logic_vector(3 downto 0)
    );
end entity estagio_decode;

architecture logica of estagio_decode is
    function signal_extend(imediato : std_logic_vector (7 downto 0)) 
        return std_logic_vector is
            begin 
            if (imediato(7) = '0') then
                return "00000000" & imediato;
            else
                return "11111111" & imediato;
            end if;
    end function;

    signal stall_signal : std_logic := '0';
    signal reg_dest, reg_src1, reg_src2 : std_logic_vector(3 downto 0); 
    signal imediato : std_logic_vector(7 downto 0);

    -- Sinais para leitura e escrita dos registradores
    signal reg_out1, reg_out2 : std_logic_vector(15 downto 0);

begin
    -- Decodificação da instrução
    -- RS está em bits 12-9, RT em bits 8-5, RD em bits 4-1
    process(instrucao_in)
    begin
        reg_src1 <= instrucao_in(12 downto 9); -- RS
        reg_src2 <= instrucao_in(8 downto 5);  -- RT
        reg_dest <= instrucao_in(4 downto 1);  -- RD
        imediato <= instrucao_in(7 downto 0);  -- Imediato (bits 7-0)
    end process;

    -- Leitura e escrita nos registradores
    banco_regs_inst: entity work.BANCO_REGS
        port map (
            read_reg  => '1',
            write_reg => write_reg,
            clock     => clk,
            reg_data  => writeback_data,
            reg_in1   => reg_src1,
            reg_in2   => reg_src2,
            reg_in3   => reg_dest,
            reg_out1  => reg_out1,
            reg_out2  => reg_out2,
            reg_file_out => reg_file_out
        );

    -- Extensão de sinal
    i_signal_extend <= signal_extend(imediato);

    -- Controle de stall
    process(stall_in)
    begin
        if stall_in = '1' then
            stall_signal <= '1';
        else
            stall_signal <= '0';
        end if;
    end process;

    stall_out <= stall_signal;

    -- Saídas
    val_a <= reg_out1;
    val_b <= reg_out2;
    PC_out <= 0;
    instruction_out <= instrucao_in;

end architecture logica;