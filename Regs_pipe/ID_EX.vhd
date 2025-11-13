LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.instruction_tools.all;

entity ID_EX is
    port(
        clock : in std_logic;
        stall : in std_logic;
        instr_in : in std_logic_vector(15 downto 0);
        instr_out : out std_logic_vector(15 downto 0)
        rs_in : in integer;
        rs_out : out integer;
        rt_in : in integer;
        rt_out : out integer;
        signal_ext_in : in integer;
        signal_ext_out : out integer;
        reg_data_in : in std_logic_vector(15 downto 0);
        reg_data_out : out std_logic_vector(15 downto 0)
    );
end ID_EX;

architecture logica of ID_EX is
    signal instr_intermediario : std_logic_vector(15 downto 0);
    signal rs_intermediario : integer;
    signal rt_intermediario : integer;
    signal signal_ext_intermediario : integer;
    signal reg_data_intermediario : std_logic_vector(15 downto 0);

begin
    instr_out <= instr_intermediario;
    rs_out <= rs_intermediario;
    rt_out <= rt_intermediario;
    signal_ext_out <= signal_ext_intermediario;
    reg_data_out <= reg_data_intermediario;
    id_ex_process : process(clock)
    begin
        if rising_edge(clock) then
            if stall = '0' then
                instr_intermediario <= instr_in;
                rs_intermediario <= rs_in;
                rt_intermediario <= rt_in;
                signal_ext_intermediario <= signal_ext_in;
                reg_data_intermediario <= reg_data_in;
            end if;
        end if;
    end process id_ex_process;
end logica;