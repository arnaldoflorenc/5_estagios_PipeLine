library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.instruc_type.all;

entity estagio_memoria is
    generic(
        bit_width : integer := 16
    );
    port(
        clk : in std_logic;
        reset : in std_logic;
        instruction_in : in INSTRUCAO;
        ula_result_in : in std_logic_vector(31 downto 0);
        escrebe_data_in : in std_logic_vector(15 downto 0);
        reg_dst_in : in std_logic_vector(3 downto 0);
        mem_read_data_out : out std_logic_vector(15 downto 0);
        reg_dst_out : out std_logic_vector(3 downto 0);
        instruction_out : out INSTRUCAO
    );
end entity estagio_memoria;

architecture logica of estagio_memoria is
    -- Sinal interno para o endereço da memória
    signal address : std_logic_vector(15 downto 0);

begin
    -- Instanciar o componente MEM
    mem_inst: entity work.MEM
        port map (
            clk       => clk,
            rst       => reset,
            memRead   => std_logic(instruction_in.tipo = LW),  -- Sinal de leitura (LW)
            memWrite  => std_logic(instruction_in.tipo = SW),  -- Sinal de escrita (SW)
            address   => ula_result_in(15 downto 0),           
            writeData => escrebe_data_in,                     
            readData  => mem_read_data_out                   
        );

    -- Propagar a instrução para a saída
    instruction_out <= instruction_in;
    reg_dst_out <= reg_dst_in;

end architecture logica;
