LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity MEM_WB is
    port(
        clock : in std_logic;
        data_read_in : in std_logic_vector(15 downto 0);
        data_read_out : out std_logic_vector(15 downto 0);
        imediato_in : in std_logic_vector(15 downto 0);
        imediato_out : out std_logic_vector(15 downto 0);
        address_in : in std_logic_vector(15 downto 0);
        address_out : out std_logic_vector(15 downto 0);
        regDST_in : in std_logic_vector(3 downto 0);
        regDST_out : out std_logic_vector(3 downto 0)
    );
end MEM_WB;

architecture logica of MEM_WB is
    signal data_read_intermediario : std_logic_vector(15 downto 0);
    signal imediato_intermediario : std_logic_vector(15 downto 0);
    signal address_intermediario : std_logic_vector(15 downto 0);
    signal regDST_intermediario : std_logic_vector(3 downto 0);
begin
    data_read_out <= data_read_intermediario;
    imediato_out <= imediato_intermediario;
    address_out <= address_intermediario;
    regDST_out <= regDST_intermediario;
    mem_ex_process: process(clock)
    begin
        if rising_edge(clock) then
            data_read_intermediario <= data_read_in;
            imediato_intermediario <= imediato_in;
            address_intermediario <= address_in;
            regDST_intermediario <= regDST_in;
        end if;
    end process mem_ex_process; 
end logica;