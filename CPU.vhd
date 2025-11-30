LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.CPU_PACKAGE.ALL;

use work.tipos.all;


ENTITY CPU IS
    PORT (
        CLOCK_50 : IN STD_LOGIC;
        LEDR : OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
        LEDG : OUT STD_LOGIC_VECTOR (8 DOWNTO 0);
        HEX0 : OUT STD_LOGIC_VECTOR (0 TO 6);
        HEX1 : OUT STD_LOGIC_VECTOR (0 TO 6);
        HEX2 : OUT STD_LOGIC_VECTOR (0 TO 6);
        HEX3 : OUT STD_LOGIC_VECTOR (0 TO 6);
        HEX4 : OUT STD_LOGIC_VECTOR (0 TO 6);
        HEX5 : OUT STD_LOGIC_VECTOR (0 TO 6);
        HEX6 : OUT STD_LOGIC_VECTOR (0 TO 6);
        HEX7 : OUT STD_LOGIC_VECTOR (0 TO 6);
        DONE : OUT STD_LOGIC
    );
END CPU;

ARCHITECTURE LOGICFUNC OF CPU IS
    -- Sinais intermediários entre estágios e registradores de pipeline
    signal pc_if : integer := 0;
    signal instr_if : std_logic_vector(15 downto 0);
    signal stall_ifid : std_logic := '0';

    signal pc_id : integer := 0;
    signal instr_id : std_logic_vector(15 downto 0);

    signal instr_idex : std_logic_vector(15 downto 0);
    signal rs_idex, rt_idex : std_logic_vector(15 downto 0);
    signal rd_add_idex, rt_add_idex, rs_add_idex : std_logic_vector(3 downto 0);
    signal signal_ext_idex : std_logic_vector(15 downto 0);

    signal instr_ex : std_logic_vector(15 downto 0);
    signal rs_ex, rt_ex : std_logic_vector(15 downto 0);
    signal rd_add_ex, rt_add_ex, rs_add_ex : std_logic_vector(3 downto 0);
    signal signal_ext_ex : std_logic_vector(15 downto 0);

    signal alu_exmem : std_logic_vector(15 downto 0);
    signal rt_exmem : std_logic_vector(15 downto 0);
    signal imediato_exmem : std_logic_vector(15 downto 0);
    signal regdst_exmem : std_logic_vector(3 downto 0);

    signal alu_mem : std_logic_vector(15 downto 0);
    signal rt_mem : std_logic_vector(15 downto 0);
    signal imediato_mem : std_logic_vector(15 downto 0);
    signal regdst_mem : std_logic_vector(3 downto 0);

    signal data_read_memwb : std_logic_vector(15 downto 0);
    signal imediato_memwb : std_logic_vector(15 downto 0);
    signal address_memwb : std_logic_vector(15 downto 0);
    signal regdst_memwb : std_logic_vector(3 downto 0);

    signal wb_data : std_logic_vector(15 downto 0);

    -- Sinais para estágios
    signal instr_decode_out : std_logic_vector(15 downto 0);
    signal writeback_instruction : std_logic_vector(15 downto 0);
    signal writeback_data : std_logic_vector(15 downto 0);
    signal val_a, val_b : std_logic_vector(15 downto 0);
    signal i_signal_extend : std_logic_vector(15 downto 0);
    signal reg_file_out : array_reg;
    signal write_reg, reset_reg : std_logic := '0';
    signal stall_in, stall_out : std_logic := '0';
    signal opcode_out : std_logic_vector(3 downto 0);

    signal ula_result : std_logic_vector(15 downto 0);
    signal signal_extend_ex : std_logic_vector(15 downto 0);
    signal instrucao_out_ex : std_logic_vector(15 downto 0);
    signal B_out_ex : std_logic_vector(15 downto 0);
    signal reg_dst_ex : std_logic_vector(3 downto 0);

    signal mem_read_data : std_logic_vector(15 downto 0);
    signal ula_result_mem : std_logic_vector(15 downto 0);
    signal reg_dst_mem : std_logic_vector(3 downto 0);
    signal instruction_out_mem : std_logic_vector(15 downto 0);

    signal reg_dst_wb : std_logic_vector(3 downto 0);

    -- Sinais de controle da UC
    signal reg_write : std_logic;
    signal mem_read  : std_logic;
    signal mem_write : std_logic;
    signal alu_src   : std_logic;
    signal reg_dst   : std_logic;
    signal branch    : std_logic;

BEGIN
    -- Instância da UC
    UC_inst : UC
        PORT MAP (
            clk       => CLOCK_50,
            reset     => '0',
            instr     => instr_id, 
            reg_write => reg_write,
            mem_read  => mem_read,
            mem_write => mem_write,
            alu_src   => alu_src,
            reg_dst   => reg_dst,
            branch    => branch
        );

    -- Estágio IF
    estagio_fetch_inst : estagio_fetch
        PORT MAP (
            clk => CLOCK_50,
            reset => '0',
            stall => stall_ifid,
                instrucao_out => instr_if,
            PC => open,
            mem_addr => open,
            mem_le => open,
            mem_data_out => (others => '0')
        );

    --IF/ID
    IF_ID_inst : IF_ID
        PORT MAP (
            clock => CLOCK_50,
            stall => stall_ifid,
            pc_in => pc_if,
            pc_out => pc_id,
            instr_in => instr_if,
            instr_out => instr_id
        );

    --Estágio Decode
    estagio_decode_inst : estagio_decode
        PORT MAP (
            clk => CLOCK_50,
            reset => '0',
                instrucao_in => instr_id,
            instruction_out => instr_decode_out,
            writeback_instruction => writeback_instruction,
            writeback_data => writeback_data,
            val_a => val_a,
            val_b => val_b,
            i_signal_extend => i_signal_extend,
            PC_out => open,
            reg_file_out => reg_file_out,
            write_reg => reg_write, -- <- controle da UC
            reset_reg => reset_reg,
            stall_in => stall_in,
            stall_out => stall_out,
            opcode_out => opcode_out
        );

    --ID/EX
    ID_EX_inst : ID_EX
        PORT MAP (
            clock => CLOCK_50,
            stall => stall_out,
            instr_in => instr_decode_out,
            instr_out => instr_idex,
            rs_in => val_a, 
            rs_out => rs_idex,
            rt_in => val_b, 
            rt_out => rt_idex,
            rd_add_in => (others => '0'),
            rd_add_out => rd_add_idex,
            rt_add_in => (others => '0'),
            rt_add_out => rt_add_idex,
            rs_add_in => (others => '0'),
            rs_add_out => rs_add_idex,
            signal_ext_in => i_signal_extend,
            signal_ext_out => signal_ext_idex
        );

    --Estágio EX
    Exec_inst : Exec
        PORT MAP (
            clk => CLOCK_50,
            reset => '0',
            instrucao_in => instr_idex,
            A => rs_idex,
            B => rt_idex,
            ula_result => ula_result,
            signal_extend => signal_extend_ex,
            instrucao_out => instrucao_out_ex,
            B_out => B_out_ex,
            reg_dst => reg_dst_ex
        );

    --EX/MEM
    EX_MEM_inst : EX_MEM
        PORT MAP (
            clock => CLOCK_50,
            alu_in => ula_result,
            alu_out => alu_exmem,
            rt_in => B_out_ex,
            rt_out => rt_exmem,
            imediato_in => signal_extend_ex,
            imediato_out => imediato_exmem,
            regDST_in => reg_dst_ex,
            regDST_out => regdst_exmem
        );

    --Estágio MEM
    estagio_memoria_inst : estagio_memoria
        PORT MAP (
            clk => CLOCK_50,
            reset => '0',
            instruction_in => instrucao_out_ex,
            ula_result_in => alu_exmem,
            escrebe_data_in => rt_exmem,
            reg_dst_in => regdst_exmem,
            mem_read_data_out => mem_read_data,
            ula_result_out => ula_result_mem,
            reg_dst_out => reg_dst_mem,
            instruction_out => instruction_out_mem
            -- Use mem_read/mem_write se necessário dentro do componente
        );

    --MEM/WB
    MEM_WB_inst : MEM_WB
        PORT MAP (
            clock => CLOCK_50,
            data_read_in => mem_read_data,
            data_read_out => data_read_memwb,
            imediato_in => imediato_exmem,
            imediato_out => imediato_memwb,
            address_in => ula_result_mem,
            address_out => address_memwb,
            regDST_in => reg_dst_mem,
            regDST_out => regdst_memwb
        );

    --Estágio WB
    estagio_WB_inst : estagio_WB
        PORT MAP (
            clk => CLOCK_50,
            reset => '0',
            instruction_in => instruction_out_mem,
            ula_result_in => address_memwb,
            mem_read_data_in => data_read_memwb,
            reg_dst_in => regdst_memwb,
            reg_dst_out => reg_dst_wb,
            writeback_instruction => writeback_instruction,
            writeback_data => writeback_data
        );

    --Saídas

    HEX0 <= (others => '0');
    HEX1 <= (others => '0');
    HEX2 <= (others => '0');
    HEX3 <= (others => '0');
    HEX4 <= (others => '0');
    HEX5 <= (others => '0');
    HEX6 <= (others => '0');
    HEX7 <= (others => '0');
    DONE <= '0';

END LOGICFUNC;