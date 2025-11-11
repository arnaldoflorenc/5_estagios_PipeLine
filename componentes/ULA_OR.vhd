library ieee;
use ieee.std_logic_1164.all;

ENTITY ULA_OR IS
PORT ( x, y : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		 r : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
	   );
END ULA_OR;

ARCHITECTURE LogicFunc OF ULA_OR IS
BEGIN 
			r <= x OR y;
			
END LogicFunc;

		