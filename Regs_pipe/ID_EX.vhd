LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.instruc_type.all;

entity ID_EX is
    port(
        clock : in std_logic;
        stall : in std_logic;
        instr_in : in INSTRUCAO;
        instr_out : out INSTRUCAO;
        rs_in : in std_logic_vector(15 downto 0);
        rs_out : out std_logic_vector(15 downto 0);
        rt_in : in std_logic_vector(15 downto 0);
        rt_out : out std_logic_vector(15 downto 0);
        rd_add_in : in std_logic_vector(3 downto 0);
        rd_add_out : out std_logic_vector(3 downto 0);
        rt_add_in : in std_logic_vector(3 downto 0);
        rt_add_out : out std_logic_vector(3 downto 0);
        rs_add_in : in std_logic_vector(3 downto 0);
        rs_add_out : out std_logic_vector(3 downto 0);
        signal_ext_in : in std_logic_vector(15 downto 0);
        signal_ext_out : out std_logic_vector(15 downto 0)
    );
end ID_EX;

architecture logica of ID_EX is
    signal instr_intermediario : INSTRUCAO;
    signal rs_intermediario : std_logic_vector(15 downto 0);
    signal rt_intermediario : std_logic_vector(15 downto 0);
    signal rt_add_intermediario : std_logic_vector(3 downto 0);
    signal rs_add_intermediario : std_logic_vector(3 downto 0);
    signal rd_add_intermediario : std_logic_vector(3 downto 0);
    signal signal_ext_intermediario : std_logic_vector(15 downto 0);

begin
    instr_out <= instr_intermediario;
    rs_out <= rs_intermediario;
    rt_out <= rt_intermediario;
    rd_add_out <= rd_add_intermediario;
    rt_add_out <= rt_add_intermediario;
    rs_add_out <= rs_add_intermediario;
    signal_ext_out <= signal_ext_intermediario;
    id_ex_process : process(clock)
    begin
        if rising_edge(clock) then
            if stall = '0' then
                instr_intermediario <= instr_in;
                rs_intermediario <= rs_in;
                rt_intermediario <= rt_in;
                rd_add_intermediario <= rd_add_in;
                rt_add_intermediario <= rt_add_in;
                rs_add_intermediario <= rs_add_in;
                signal_ext_intermediario <= signal_ext_in;
            end if;
        end if;
    end process id_ex_process;
end logica;