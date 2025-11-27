LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.CPU_PACKAGE.ALL;
USE work.instruc_type.ALL;

ENTITY UC IS
    PORT (
        clk      : IN  STD_LOGIC;
        reset    : IN  STD_LOGIC;
        instr    : IN  INSTRUCAO;
        reg_write : OUT STD_LOGIC;
        mem_read  : OUT STD_LOGIC;
        mem_write : OUT STD_LOGIC;
        alu_src   : OUT STD_LOGIC;
        reg_dst   : OUT STD_LOGIC;
        branch    : OUT STD_LOGIC
    );
END UC;

ARCHITECTURE logica OF UC IS
BEGIN
    process(clk, reset)
    begin
        if reset = '1' then
            reg_write <= '0';
            mem_read  <= '0';
            mem_write <= '0';
            alu_src   <= '0';
            reg_dst   <= '0';
            branch    <= '0';
        elsif rising_edge(clk) then
            -- Sinais padrão
            reg_write <= '0';
            mem_read  <= '0';
            mem_write <= '0';
            alu_src   <= '0';
            reg_dst   <= '0';
            branch    <= '0';

            case instr.opcode is
                when "000" => -- NOP
                when "011" => -- ADD/SUB
                    reg_write <= '1';
                    reg_dst   <= '1';
                    alu_src   <= '0';
                when "001" => -- LW
                    reg_write <= '1';
                    mem_read  <= '1';
                    alu_src   <= '1';
                    reg_dst   <= '0';
                when "010" => -- SW
                    mem_write <= '1';
                    alu_src   <= '1';
                when "101" => -- JMP 
                    branch    <= '1';
                when others =>
                    -- tudo zero
            end case;
        end if;
    end process;
END LOGICFUNC;
