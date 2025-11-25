library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MEM is
    port(
        clk     : in  std_logic;
        rst     : in  std_logic;
        memRead : in  std_logic;
        memWrite: in  std_logic;
        address : in  std_logic_vector(15 downto 0);
        writeData: in std_logic_vector(15 downto 0);
        readData : out std_logic_vector(15 downto 0)    
    );
end entity MEM;

architecture logica of MEM is
    constant ADDR_WIDTH : integer := address'length;
    constant MEM_DEPTH  : integer := 2 ** ADDR_WIDTH;

    type mem_array is array(0 to MEM_DEPTH - 1) of std_logic_vector(15 downto 0);
    signal mem : mem_array := (others => (others => '0'));
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                mem <= (others => (others => '0'));
            else
                if memWrite = '1' then
                    mem(to_integer(unsigned(address))) <= writeData;
                end if;
            end if;
        end if;
    end process;

    process(memRead, address, mem)
    begin
        if memRead = '1' then
            readData <= mem(to_integer(unsigned(address)));
        else
            readData <= (others => '0');
        end if;
    end process;

end architecture logica;