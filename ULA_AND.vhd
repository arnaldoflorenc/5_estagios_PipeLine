library ieee;
use ieee.std_logic_1164.all;

ENTITY ULA_AND IS
PORT ( x, y : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		 r : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
	   );
END ULA_AND;

ARCHITECTURE LogicFunc OF ULA_AND IS
BEGIN 
			r <= x AND y;
			
END LogicFunc;

		
		 