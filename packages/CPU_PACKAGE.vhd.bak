library ieee;
use ieee.std_logic_1164.all;

PACKAGE CPU_PACKAGE IS
	COMPONENT REG4 IS
		PORT (D : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
				RESET, clock, enable : IN STD_LOGIC;
				Q : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
			  );
	END COMPONENT;

	COMPONENT ULA IS 
		PORT(
				x, y : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
				intruc_type : IN TIPO_INSTRUCAO;
				s : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
			);
	END COMPONENT;

	COMPONENT DISPLAY
		PORT(   ENTRADA : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
				  SAIDA : OUT STD_LOGIC_VECTOR  (6 DOWNTO 0));
	END COMPONENT;


	COMPONENT CPU IS 
		PORT ( 
				 CLOCK_50 : IN STD_LOGIC;
				 LEDR : OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
				 HEX0 : OUT STD_LOGIC_VECTOR (0 TO 6);
				 HEX1 : OUT STD_LOGIC_VECTOR (0 TO 6);
				 HEX2 : OUT STD_LOGIC_VECTOR (0 TO 6);
				 HEX3 : OUT STD_LOGIC_VECTOR (0 TO 6);
				 HEX5 : OUT STD_LOGIC_VECTOR (0 TO 6);
				 HEX7 : OUT STD_LOGIC_VECTOR (0 TO 6)
			  );
	END COMPONENT; 


	COMPONENT BUFFERS
		PORT ( INPUT : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
				 ENABLE : IN STD_LOGIC;
				 OUTPUT : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
			  );
	END COMPONENT;
	
	COMPONENT UC
		PORT (	clk      : IN  STD_LOGIC;
        		reset    : IN  STD_LOGIC;
        		instr    : IN  INSTRUCAO;
        		reg_write : OUT STD_LOGIC;
        		mem_read  : OUT STD_LOGIC;
        		mem_write : OUT STD_LOGIC;
        		alu_src   : OUT STD_LOGIC;
        		reg_dst   : OUT STD_LOGIC;
        		branch    : OUT STD_LOGIC
				);
	END COMPONENT;

	-- Componentes dos estágios do pipeline
	COMPONENT estagio_fetch IS
		PORT (
			clk : IN std_logic;
			reset : IN std_logic;
			stall : IN std_logic;
			intrucao_out : OUT INSTRUCAO;
			PC : OUT std_logic_vector(15 downto 0);
			mem_addr : OUT std_logic_vector(15 downto 0);
			mem_le : OUT std_logic;
			mem_data_out : IN std_logic_vector(15 downto 0)
		);
	END COMPONENT;

	COMPONENT estagio_decode IS
		PORT (
			clk : IN std_logic;
			reset : IN std_logic;
			intrucao_in : IN INSTRUCAO;
			instruction_out : OUT INSTRUCAO;
			writeback_instruction : IN INSTRUCAO;
			writeback_data : IN std_logic_vector(15 downto 0);
			val_a : OUT std_logic_vector(7 downto 0);
			val_b : OUT std_logic_vector(7 downto 0);
			i_signal_extend : OUT std_logic_vector(15 downto 0);
			PC_out : OUT integer;
			reg_file_out : OUT Banco_regs_type;
			write_reg : IN std_logic;
			reset_reg : IN std_logic;
			stall_in : IN std_logic;
			stall_out : OUT std_logic;
			opcode_out : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;

	COMPONENT Exec IS
		PORT (
			clk : IN std_logic;
			reset : IN std_logic;
			instrucao_in : IN INSTRUCAO;
			A : IN std_logic_vector(15 downto 0);
			B : IN std_logic_vector(15 downto 0);
			ula_result : OUT std_logic_vector(15 downto 0);
			signal_extend : OUT std_logic_vector(15 downto 0);
			instrucao_out : OUT INSTRUCAO;
			B_out : OUT std_logic_vector(15 downto 0);
			reg_dst : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;

	COMPONENT estagio_memoria IS
		PORT (
			clk : IN std_logic;
			reset : IN std_logic;
			instruction_in : IN INSTRUCAO;
			ula_result_in : IN std_logic_vector(15 downto 0);
			escrebe_data_in : IN std_logic_vector(15 downto 0);
			reg_dst_in : IN std_logic_vector(3 downto 0);
			mem_read_data_out : OUT std_logic_vector(15 downto 0);
			ula_result_out : OUT std_logic_vector(15 downto 0);
			reg_dst_out : OUT std_logic_vector(3 downto 0);
			instruction_out : OUT INSTRUCAO
		);
	END COMPONENT;

	COMPONENT estagio_WB IS
		PORT (
			clk : IN std_logic;
			reset : IN std_logic;
			instruction_in : IN INSTRUCAO;
			ula_result_in : IN std_logic_vector(15 downto 0);
			mem_read_data_in : IN std_logic_vector(15 downto 0);
			reg_dst_in : IN std_logic_vector(3 downto 0);
			reg_dst_out : OUT std_logic_vector(3 downto 0);
			writeback_instruction : OUT INSTRUCAO;
			writeback_data : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;

	-- Registradores de pipeline
	COMPONENT IF_ID IS
		PORT (
			clock : IN STD_LOGIC;
			stall : IN STD_LOGIC;
			pc_in : IN integer;
			pc_out : OUT integer;
			instr_in : IN INSTRUCAO;
			instr_out : OUT INSTRUCAO
		);
	END COMPONENT;

	COMPONENT ID_EX IS
		PORT (
			clock : IN STD_LOGIC;
			stall : IN STD_LOGIC;
			instr_in : IN INSTRUCAO;
			instr_out : OUT INSTRUCAO;
			rs_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			rs_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			rt_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			rt_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			rd_add_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			rd_add_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			rt_add_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			rt_add_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			rs_add_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			rs_add_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			signal_ext_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			signal_ext_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT EX_MEM IS
		PORT (
			clock : IN STD_LOGIC;
			alu_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			alu_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			rt_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			rt_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			imediato_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			imediato_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			regDST_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT MEM_WB IS
		PORT (
			clock : IN STD_LOGIC;
			data_read_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			data_read_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			imediato_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			imediato_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			address_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			address_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			regDST_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			regDST_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;

END PACKAGE;