library ieee;
use ieee.std_logic_1164.all;
use work.FULLADDER_PACKAGE.all;
use work.ULA_PACKAGE.all;

ENTITY RIPPLE4_SOM_SUB IS
	PORT (x, y : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			Cin : IN STD_LOGIC;
			s : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
			Cout, OVERFLOW : OUT STD_LOGIC
			);
END RIPPLE4_SOM_SUB;

ARCHITECTURE LogicFunc of RIPPLE4_SOM_SUB IS
	SIGNAL C : STD_LOGIC_VECTOR (0 TO 2);
	SIGNAL ny : STD_LOGIC_VECTOR (3 DOWNTO 0);
BEGIN 

	ny(3) <= Cin XOR y(3);
	ny(2) <= Cin XOR y(2);
	ny(1) <= Cin XOR y(1);
	ny(0) <= Cin XOR y(0);

	stage0 : FULLADDER PORT MAP (x(0), ny(0), Cin,  s(0), C(0));
	stage1 : FULLADDER PORT MAP (x(1), ny(1), C(0), s(1), C(1));
	stage2 : FULLADDER PORT MAP (x(2), ny(2), C(1), s(2), C(2));
	stage3 : FULLADDER PORT MAP (x(3), ny(3), C(2), s(3), Cout);
	
	
	OVERFLOW <= Cout XOR c(2);

END LogicFunc;