library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use IEEE.numeric_std.all;

library STD;
use STD.textio;


package instruc_type is
--OPCODES 

--nop
constant NOP_OP : std_logic_vector(2 downto 0) := "000";

--tipo-R
constant ADD_OP : std_logic_vector(2 downto 0) := "011";
constant SUB_OP : std_logic_vector(2 downto 0) := "011";

--tipo-I
constant LW_OP  : std_logic_vector(2 downto 0) := "001";
constant SW_OP  : std_logic_vector(2 downto 0) := "010";
constant BEQ_OP : std_logic_vector(2 downto 0) := "100";

--tipo-J
constant J_OP   : std_logic_vector(2 downto 0) := "101";

--funções tipo-R
constant ADD_FUNCT : std_logic := 0;
constant SUB_FUNCT : std_logic := 1;

type FORMATO_INSTRUCAO is (TIPO_R, TIPO_I, TIPO_J, NOP, INVALIDA);

type TIPO_INSTRUCAO is (
    ADD,
    SUB,
    LW,
    SW,
    BEQ,
    J,
    NOP,
    INVALIDA
);

type INSTRUCAO is record
    formato      : FORMATO_INSTRUCAO;
    tipo         : TIPO_INSTRUCAO;
    rs           : integer range 0 to 15;
    rt           : integer range 0 to 15;
    rd           : integer range 0 to 15;
    imediato     : integer;
    endereco_j   : integer;

    rs_vet : std_logic_vector(3 downto 0);
    rt_vet : std_logic_vector(3 downto 0);
    rd_vet : std_logic_vector(3 downto 0);
    imediato_vet : std_logic_vector(4 downto 0);
    addr_vet : std_logic_vector(12 downto 0);

    intrucao_vet : std_logic_vector(15 downto 0);
end record INSTRUCAO;

type instrucao_array is array (natural range <>) of INSTRUCAO;

function getFormatoInstrucao(instrucao : std_logic_vector(15 downto 0)) return FORMATO_INSTRUCAO;

function getTipoInstrucao(instrucao : std_logic_vector(15 downto 0)) return TIPO_INSTRUCAO;

function getInstrucao(instrucao : std_logic_vector(15 downto 0)) return INSTRUCAO;

function fazInstrucao(opcode : std_logic_vector(2 downto 0); rs: integer; rt : integer; rd : integer;
                  func: std_logic) return INSTRUCAO;

function fazInstrucao(opcode : std_logic_vector(2 downto 0); rs: integer; rt : integer; 
                  imediato : integer) return INSTRUCAO;

function fazInstrucao(opcode : std_logic_vector(2 downto 0); endereco_j : integer) return INSTRUCAO;

function fazInstrucaoNop return INSTRUCAO;
function faz_j(instrucao : INSTRUCAO) return boolean;
function faz_beq(instrucao : INSTRUCAO) return boolean;

end package instruc_type;

package body instruc_type is
    function tipo_jump(instrucao : INSTRUCAO) return boolean is
        begin 
            case instrucao.tipo is
                when J => 
                    return true;
                when others =>
                    return false;
            end case;
    end function tipo_jump;

    function tipo_branch(instrucao : INSTRUCAO) return boolean is
        begin 
            case instrucao.tipo is
                when BEQ => 
                    return true;
                when others =>
                    return false;
            end case;
    end function tipo_branch;

    function getFormatoInstrucao(instrucao : std_logic_vector(15 downto 0)) return FORMATO_INSTRUCAO is
        variable opcode : std_logic_vector(2 downto 0) := instrucao(15 downto 13);
        begin
            if opcode = NOP_OP then
                return NOP;
            elsif opcode = ADD_OP then
                return TIPO_R;
            elsif opcode = LW_OP or opcode = SW_OP or opcode = BEQ_OP then
                return TIPO_I;
            elsif opcode = J_OP then
                return TIPO_J;
            else
                return INVALIDA;
            end if;
        end function getFormatoInstrucao;

    function getTipoInstrucao(instrucao : std_logic_vector(15 downto 0)) return TIPO_INSTRUCAO is
        variable opcode : std_logic_vector(2 downto 0) := instrucao(15 downto 13);
        variable funct  : std_logic := instrucao(0);
        begin
        case opcode is 
            when ALU_OP =>
                case funct is
                    when ADD_FUNCT =>
                        return ADD;
                    when SUB_FUNCT =>
                        return SUB;
                    when others =>
                        return INVALIDA;
                end case;
            when LW_OP =>
                return LW;
            when SW_OP =>
                return SW;
            when BEQ_OP =>
                return BEQ;
            when J_OP =>
                return J;
            when NOP_OP=>
                return NOP;
            when others =>
                return INVALIDA;
        end case;
    end function getTipoInstrucao;

    function getInstrucao(instrucao : std_logic_vector(15 downto 0)) return INSTRUCAO is
        variable instr : INSTRUCAO;
        begin
            instr.formato := getFormatoInstrucao(instrucao);
            instr.tipo := getTipoInstrucao(instrucao);

            instr.rs_vet := instrucao(12 downto 9);
            instr.rt_vet := instrucao(8 downto 5);
            instr.rd_vet := instrucao(4 downto 1);
            instr.imediato_vet := instrucao(4 downto 0);
            instr.addr_vet := instrucao(12 downto 0);

            instr.instrucao_vet := instrucao;

            return instr;
        end function getInstrucao;

    function fazInstrucao(opcode : std_logic_vector(2 downto 0); rs: integer; rt : integer; rd : integer;
                  func: std_logic) return INSTRUCAO is
        variable instr : INSTRUCAO;
        variable intrs_vet : std_logic_vector(15 downto 0);
        variable op_vet : std_logic_vector(2 downto 0);
        variable func : std_logic;
        variable rs_vet, rt_vet, rd_vet : std_logic_vector(3 downto 0);
        begin
            op_vet := opcode;
            rs_vet := std_logic_vector(to_unsigned(rs, 4));
            rt_vet := std_logic_vector(to_unsigned(rt, 4));
            rd_vet := std_logic_vector(to_unsigned(rd, 4));
            func := func;

            intrs_vet := op_vet & rs_vet & rt_vet & rd_vet & func;

            instr := getInstrucao(intrs_vet);
            return instr;
        end function fazInstrucao;

    function fazInstrucao(opcode : std_logic_vector(2 downto 0); rs: integer; rt : integer; 
                         imediato : integer) return INSTRUCAO is
        variable instr : INSTRUCAO;
        variable intrs_vet : std_logic_vector(15 downto 0);
        variable op_vet : std_logic_vector(2 downto 0);
        variable imediato_vet : std_logic_vector(4 downto 0);
        variable rs_vet, rt_vet : std_logic_vector(3 downto 0);
        begin
            op_vet := opcode;
            rs_vet := std_logic_vector(to_unsigned(rs, 4));
            rt_vet := std_logic_vector(to_unsigned(rt, 4));
            imediato_vet := std_logic_vector(to_unsigned(imediato, 4));

            intrs_vet := op_vet & rs_vet & rt_vet & imediato_vet;

            instr := getInstrucao(intrs_vet);
            return instr;
        end function fazInstrucao;

    function fazInstrucao(opcode : std_logic_vector(2 downto 0); endereco_j : integer) return INSTRUCAO is
        variable instr : INSTRUCAO;
        variable intrs_vet : std_logic_vector(15 downto 0);
        variable op_vet : std_logic_vector(2 downto 0);
        variable endereco_j_vet : std_logic_vector(13 downto 0);
        begin
            op_vet := opcode;
            imediato_vet := std_logic_vector(to_unsigned(imediato, 13));

            intrs_vet := op_vet & endereco_j_vet;

            instr := getInstrucao(intrs_vet);
            return instr;
        end function fazInstrucao;
    function fazInstrucaoNop return INSTRUCAO is
        variable instr : INSTRUCAO;
        variable intrs_vet : std_logic_vector(15 downto 0) := (others => '0');
        begin
            instr := getInstrucao(intrs_vet);
            return instr;
        end function fazInstrucaoNop;
end package body instruc_type;