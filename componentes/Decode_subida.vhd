library ieee;
use ieee.std_logic_1164.all;

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
        if rising_edge(clock) THEN
            with data select
                data_out <= "0000000000000001" WHEN "0000",
                            "0000000000000010" WHEN "0001",
                            "0000000000000100" WHEN "0010",
                            "0000000000001000" WHEN "0011",
                            "0000000000010000" WHEN "0100",
                            "0000000000100000" WHEN "0101",
                            "0000000001000000" WHEN "0110",
                            "0000000010000000" WHEN "0111",
                            "0000000100000000" WHEN "1000",
                            "0000001000000000" WHEN "1001",
                            "0000010000000000" WHEN "1010",
                            "0000100000000000" WHEN "1011",
                            "0001000000000000" WHEN "1100",
                            "0010000000000000" WHEN "1101",
                            "0100000000000000" WHEN "1110",
                            "1000000000000000" WHEN OTHERS;
        END IF;
    END PROCESS;

END logica;