library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.instruc_type.all;
ENTITY ULA IS
	PORT (
		x, y : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		intruc_type : IN TIPO_INSTRUCAO;
		s : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	);
END ULA;

ARCHITECTURE LogicFunc OF ULA IS
BEGIN
contas_process: PROCESS(x, y, intruc_type)
BEGIN
	case instruc_type is 
		when ADD | LW | SW => 
		s <= std_logic_vector(x + y);
		when SUB =>
		s <= std_logic_vector(x - y);
		when others =>
		s <= (others => '0');
	end case;
END PROCESS contas_process;	
	
END LogicFunc;