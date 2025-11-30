library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY ULA IS
	PORT (
		x, y : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		opcode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		s : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END ULA;

ARCHITECTURE LogicFunc OF ULA IS
BEGIN
contas_process: PROCESS(x, y, opcode)
BEGIN
	case opcode is 
		when "011" => -- ADD
			s <= std_logic_vector(unsigned(x) + unsigned(y));
		when "011" => -- SUB (mesmo opcode, função em bit separado)
			s <= std_logic_vector(unsigned(x) - unsigned(y));
		when "001" | "010" => -- LW ou SW
			s <= std_logic_vector(unsigned(x) + unsigned(y));
		when others =>
			s <= (others => '0');
	end case;
END PROCESS contas_process;	
	
END LogicFunc;