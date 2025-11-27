LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.instruc_type.all;

entity EX_MEM is
    port(
        clock : in std_logic;
        alu_in : in std_logic_vector(15 downto 0);
        alu_out : out std_logic_vector(15 downto 0);
        rt_in : in std_logic_vector(15 downto 0);
        rt_out : out std_logic_vector(15 downto 0);
        imediato_in : in std_logic_vector(15 downto 0);
        imediato_out : out std_logic_vector(15 downto 0);
        regDST_in : in std_logic_vector(3 downto 0);
        regDST_out : out std_logic_vector(3 downto 0)
    );
end EX_MEM;

architecture logica of EX_MEM is
    signal alu_intermediario : std_logic_vector(15 downto 0);
    signal rt_intermediario : std_logic_vector(15 downto 0);
    signal imediato_intermediario : std_logic_vector(15 downto 0);
    signal regDST_intermediario : std_logic_vector(3 downto 0);
begin
    alu_out <= alu_intermediario;
    rt_out <= rt_intermediario;
    imediato_out <= imediato_intermediario;
    regDST_out <= regDST_intermediario;
    ex_mem_process : process(clock)
    begin
        if rising_edge(clock) then
            alu_intermediario <= alu_in;
            rt_intermediario <= rt_in;
            imediato_intermediario <= imediato_in;
            regDST_intermediario <= regDST_in;
        end if;
    end process ex_mem_process;
end logica;