library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Decode_subida IS
PORT (
    data : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    clock: in STD_LOGIC;
    data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
);
END Decode_subida;

ARCHITECTURE logica OF Decode_subida IS  
BEGIN 
    PROCESS(clock)
    BEGIN
        if rising_edge(clock) then
            if unsigned(data) < 16 then
                data_out <= (others => '0');
                data_out(to_integer(unsigned(data))) <= '1';
            else
                data_out <= (others => '0');
            end if;
        end if;
    END PROCESS;

END logica;