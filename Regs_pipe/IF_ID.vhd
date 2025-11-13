LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.instruction_tools.all;

ENTITY IF_ID IS
    PORT (
        clock : IN  STD_LOGIC;
        stall : IN  STD_LOGIC;
        pc_in  : IN  integer;
        pc_out : OUT integer;
        instr_in : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
        instr_out : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
    );
END IF_ID;

ARCHITECTURE logica OF IF_ID IS
    signal pc_intermediario : integer;
    signal instr_intermediario : integer;
BEGIN
    pc_out <= pc_intermediario;
    instr_out <= instr_intermediario;

    if_id_process : PROCESS(clock)
    BEGIN
        if rising_edge(clock) then
            if stall = '0' then
                pc_intermediario <= pc_in;
                instr_intermediario <= instr_in;
            end if;
        end if;
    END PROCESS if_id_process;
END logica;