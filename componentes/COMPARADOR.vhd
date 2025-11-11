library ieee;
use ieee.std_logic_1164.all;

ENTITY COMPARADOR IS 
	PORT (X, Y : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			EQU, LST, GRT : OUT STD_LOGIC
			);
END COMPARADOR;

ARCHITECTURE LogicFunc OF COMPARADOR IS 
BEGIN
	EQU <= (x(3) xnor y(3)) and (x(2) xnor y(2)) and (x(1) xnor y(1)) and (x(0) xnor y(0));
	GRT <= (not y(3) and x(3)) or ((x(3) xnor y(3)) and (not y(2)) and x(2)) or ((x(3) xnor y(3)) and (x(2) xnor y(2)) and (not y(1)) and x(1)) or ((x(3) xnor y(3)) and (x(2) xnor y(2)) and (x(1) xnor y(1)) and (not y(1)) and x(1));
	LST <=  EQU XNOR GRT;
END LogicFunc;