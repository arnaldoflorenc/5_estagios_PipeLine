library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity signalextend is
    port (
        sinal_entrada  : in  std_logic_vector(4 downto 0);
        sinal_saida    : out std_logic_vector(15 downto 0)
    );
end entity signalextend;

architecture logica of signalextend is
begin
    process(sinal_entrada)
    begin
        if sinal_entrada(4) = '0' then
            sinal_saida <= "0000000000" & sinal_entrada;
        else
            sinal_saida <= "1111111111" & sinal_entrada;
        end if;
    end process;
end architecture logica;