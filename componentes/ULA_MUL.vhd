library ieee;
use ieee.std_logic_1164.all;
use work.FULLADDER_PACKAGE.all;

ENTITY ULA_MUL IS
PORT 		(x, y : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			 r : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
			 );
END ULA_MUL;

ARCHITECTURE LogicFunc OF ULA_MUL IS
SIGNAL AUX : STD_LOGIC_VECTOR(3 DOWNTO 0); 
SIGNAL Cin : STD_LOGIC;
SIGNAL MX, MY : STD_LOGIC_VECTOR (1 DOWNTO 0);
BEGIN 
	
	MX <= x(1 DOWNTO 0);
	MY <= y(1 DOWNTO 0);
	
	AUX(3) <= (MX(0) AND MY(0));
	AUX(2) <= (MX(0) AND MY(1));
	AUX(1) <= (MX(1) AND MY(0));
	AUX(0) <= (MX(1) AND MY(1));
	
	r(0) <= AUX(3);
	
	stage0 : FULLADDER PORT MAP ('0', AUX(2), AUX(1), r(1), Cin);
	stage1 : FULLADDER PORT MAP ('0', Cin, AUX(0), r(2), r(3));
	
END LogicFunc;
	