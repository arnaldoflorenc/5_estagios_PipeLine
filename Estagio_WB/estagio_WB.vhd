library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Adicionar o tipo de instrução
use work.intruc_type.all;

entity estagio_WB is
    port(
        clk : in std_logic;
        reset : in std_logic;
        instruction_in : in INSTRUCAO;
        ula_result_in : in std_logic_vector(15 downto 0);
        mem_read_data_in : in std_logic_vector(15 downto 0);
        reg_dst_in : in std_logic_vector(3 downto 0);
        reg_dst_out : out std_logic_vector(3 downto 0);
        writeback_instruction : out INSTRUCAO;
        writeback_data : out std_logic_vector(15 downto 0)
    );
end entity estagio_WB;

architecture logica of estagio_WB is
begin
    writeback_data <= mem_read_data_in when instruction_in.tipo = LW else ula_result_in;
    writeback_instruction <= instruction_in;
    reg_dst_out <= reg_dst_in;
end architecture logica;