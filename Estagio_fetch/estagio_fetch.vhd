library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity estagio_fetch is
    generic(
        ram_size : integer := 4096;
        bit_width : integer := 16
    );
    port(
        clk : in std_logic;
        reset : in std_logic;
        stall : in std_logic;
        instrucao_out : out std_logic_vector(15 downto 0);
        PC : out std_logic_vector(15 downto 0);
        mem_addr : out std_logic_vector(15 downto 0);
        mem_le : out std_logic;
        mem_data_out : in std_logic_vector(bit_width-1 downto 0)
        );
end entity estagio_fetch;

architecture logica of estagio_fetch is
    signal PC_reg : std_logic_vector(15 downto 0) := (others => '0');
    signal PC_next : std_logic_vector(15 downto 0);
begin
    PC <= PC_reg;
    PC_next <= "0000000000000000" when reset = '1' else
                PC_reg when unsigned(PC_reg) + 4 >= ram_size - 1 else
                PC_reg when stall = '1' else
                std_logic_vector(unsigned(PC_reg) + 4);
    PC_proccess : process(clk, reset, PC_next, stall)
    begin
        if reset = '1' then
            PC_reg <= (others => '0');
        elsif rising_edge(clk) then
            if stall = '0' then
                PC_reg <= PC_next;
            end if;
        elsif stall = '1' then
            PC_reg <= PC_reg;
        end if;
    end process PC_proccess;

    MEM_process : process(clk, reset, PC_reg)
    begin
        if reset = '1' then
            mem_addr <= (others => '0');
            mem_le <= '0';
            instrucao_out <= (others => '0');
        elsif rising_edge(clk) then
            mem_addr <= PC_reg;
            mem_le <= '1';
            instrucao_out <= mem_data_out;
        end if;
    end process MEM_process;
end architecture logica;

