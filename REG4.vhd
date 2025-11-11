library ieee;
use ieee.std_logic_1164.all;

ENTITY REG4 IS
	PORT (D : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			RESET, CLOCK, ENABLE : IN STD_LOGIC;
			Q : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
		  );
END REG4;

ARCHITECTURE LogicFunc OF REG4 IS
BEGIN 
	PROCESS (RESET, CLOCK, ENABLE)
		BEGIN 
			IF Rising_edge(CLOCK) THEN
				IF RESET = '1' THEN
					Q <= "0000";
				ELSIF ENABLE = '1' THEN
					Q <= D;
				END IF;
			END IF;
	END PROCESS;
END LogicFunc;