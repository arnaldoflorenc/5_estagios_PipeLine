library ieee;
use ieee.std_logic_1164.all;

ENTITY ULA_NOT IS
PORT ( y : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		 r : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
	   );
END ULA_NOT;

ARCHITECTURE LogicFunc OF ULA_NOT IS
BEGIN 
			r <= NOT y;
			
END LogicFunc;

		