library ieee;
use ieee.std_logic_1164.all;

ENTITY FULLADDER IS 
	PORT (x, y, Cin  : IN STD_LOGIC;
			s, Cout : OUT STD_LOGIC );
END FULLADDER;

ARCHITECTURE LogicFunc of FULLADDER IS
BEGIN
	s <= x XOR y XOR Cin;
	Cout <= (x AND y) OR (Cin AND x) OR (Cin AND y);
END LogicFunc;