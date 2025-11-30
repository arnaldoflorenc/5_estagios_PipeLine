library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.cpu_package.all;

entity Exec is
    port(
        clk : in std_logic;
        reset : in std_logic;
        instrucao_in : in std_logic_vector(15 downto 0);
        A : in std_logic_vector(15 downto 0);
        B : in std_logic_vector(15 downto 0);
        ula_result : out std_logic_vector(15 downto 0);
        signal_extend : out std_logic_vector(15 downto 0);
        instrucao_out : out std_logic_vector(15 downto 0);
        B_out : out std_logic_vector(15 downto 0);
        reg_dst : out std_logic_vector(3 downto 0)
    );
end entity Exec;

architecture logica of Exec is
    signal in_A : std_logic_vector(15 downto 0);
    signal in_B : std_logic_vector(15 downto 0);
    signal result : std_logic_vector(15 downto 0);
begin
    ula_result <= result(15 downto 0);
    B_out <= B;
    reg_dst <= instrucao_in(12 downto 9);
    
    operacoes: process(A, B, instrucao_in)
    begin
        in_A <= A;
        in_B <= B;
        signal_extend <= (others => '0');
    end process operacoes;
    
    instrucao_out <= instrucao_in;
end architecture logica;


