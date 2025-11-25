library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

PACKAGE ULA_PACKAGE IS
	COMPONENT RIPPLE4_SOM_SUB IS
	PORT 	  (x, y : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
				Cin : IN STD_LOGIC;
				s : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
				Cout, OVERFLOW : OUT STD_LOGIC
				);
	END COMPONENT;
END ULA_PACKAGE;
