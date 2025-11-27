library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Adicionar o tipo de instrução
use work.instruc_type.all;

entity Exec is
    port(
        clk : in std_logic;
        reset : in std_logic;
        instrucao_in : in INSTRUCAO;
        A : in std_logic_vector(15 downto 0);
        B : in std_logic_vector(15 downto 0);
        ula_result : out std_logic_vector(15 downto 0);
        signal_extend : out std_logic_vector(15 downto 0);
        instrucao_out : out INSTRUCAO;
        B_out : out std_logic_vector(15 downto 0);
        reg_dst : out std_logic_vector(3 downto 0);
    );
end entity Exec;

architecture logica of Exec is
    signal in_A : std_logic_vector(15 downto 0);
    signal in_B : std_logic_vector(15 downto 0);
    signal result : std_logic_vector(15 downto 0);
begin
    alu: port map(
        x => in_A,
        y => in_B,
        intruc_type => instrucao_in.TIPO_INSTRUCAO,
        s => result(31 downto 0)
    );
    ula_result <= result(15 downto 0);
    B_out <= B;
    reg_dst <= instrucao_in.rd_vet;
    
    operacoes: process(A, B, instrucao_in)
    begin
        case instrucao_in.TIPO_INSTRUCAO is
            when ADD | SUB =>
                in_A <= A;
                in_B <= B;
                signal_extend <= (others => '0');
            when LW | SW =>
                in_A <= A;
                in_B <= (others => '0');
                signal_extend <= signal_extend(instrucao_in.imediato_vet);
            when others =>
                in_A <= (others => '0');
                in_B <= (others => '0');
                signal_extend <= (others => '0');
        end case;
    end process operacoes;
end architecture logica;


