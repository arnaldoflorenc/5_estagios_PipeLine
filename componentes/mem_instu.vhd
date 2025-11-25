library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_instu is
    port (
        clk         : in  std_logic;
        addr        : in  std_logic_vector(3 downto 0);
        data_in     : in  std_logic_vector(15 downto 0);
        data_out    : out std_logic_vector(15 downto 0)
    );
end entity mem_instu;

architecture logica of mem_instu is
    type rom_type is array (0 to 15) of std_logic_vector(15 downto 0);
    
    signal rom : rom_type := (
        0 => "00000000000000000", 
        1 => "00000000000000001",
        2 => "00000000000000010",
        3 => "00000000000000011",
        4 => "00000000000000100",
        5 => "00000000000000101",
        6 => "00000000000000110",
        7 => "00000000000000111",
        8 => "00000000000001000",
        9 => "00000000000001001",
        10 => "00000000000001010",
        11 => "00000000000001011",
        12 => "00000000000001100",
        13 => "00000000000001101",
        14 => "00000000000001110",
        15 => "00000000000001111"
    );  
begin
    process(clk)
    begin
        if rising_edge(clk) then
            data_out <= rom(unsigned(addr(3 downto 0)));
        end if;
    end process;
end architecture logica;