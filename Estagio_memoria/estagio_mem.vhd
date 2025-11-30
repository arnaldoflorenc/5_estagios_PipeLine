library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity estagio_memoria is
    generic(
        bit_width : integer := 16
    );
    port(
        clk : in std_logic;
        reset : in std_logic;
        instruction_in : in std_logic_vector(15 downto 0);
        ula_result_in : in std_logic_vector(15 downto 0);
        escrebe_data_in : in std_logic_vector(15 downto 0);
        reg_dst_in : in std_logic_vector(3 downto 0);
        mem_read_data_out : out std_logic_vector(15 downto 0);
        ula_result_out : out std_logic_vector(15 downto 0);
        reg_dst_out : out std_logic_vector(3 downto 0);
        instruction_out : out std_logic_vector(15 downto 0)
    );
end entity estagio_memoria;

architecture logica of estagio_memoria is
    -- Sinal interno para o endereço da memória
    signal address : std_logic_vector(15 downto 0);
    -- Sinais auxiliares para controle de memória
    signal memRead_sig  : std_logic;
    signal memWrite_sig : std_logic;
begin
    -- Controle de leitura e escrita de memória
    -- opcode está nos bits 15-13
    memRead_sig  <= '1' when instruction_in(15 downto 13) = "001" else '0'; -- LW
    memWrite_sig <= '1' when instruction_in(15 downto 13) = "010" else '0'; -- SW

    -- Instanciar o componente MEM
    mem_inst: entity work.MEM
        port map (
            clk       => clk,
            rst       => reset,
            memRead   => memRead_sig,
            memWrite  => memWrite_sig,
            address   => ula_result_in(15 downto 0),           
            writeData => escrebe_data_in,                     
            readData  => mem_read_data_out                   
        );

    -- Propagar a instrução para a saída
    instruction_out <= instruction_in;
    ula_result_out <= ula_result_in;
    reg_dst_out <= reg_dst_in;

end architecture logica;
