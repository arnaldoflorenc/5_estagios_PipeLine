library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shiftleft2 is
    port (
        entrada  : in  std_logic_vector(15 downto 0);
        saida    : out std_logic_vector(15 downto 0)
    );
end entity shiftleft2;

architecture logica of shiftleft2 is
begin
    saida <= sll(entrada, 2);
end architecture logica;