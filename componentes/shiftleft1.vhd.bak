library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shiftleft1 is
    port (
        entrada  : in  std_logic_vector(15 downto 0);
        saida    : out std_logic_vector(15 downto 0)
    );
end entity shiftleft1;
architecture logica of shiftleft1 is
begin
    saida <= sll(entrada, 1);
end architecture logica;