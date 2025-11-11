LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.CPU_PACKAGE.ALL;

ENTITY UC IS 
	PORT (SW : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
			CLOCK: IN STD_LOGIC;
			OPCODE : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			RS : IN STD_LOGIC_VECTOR (1 DOWNTO 0); 
			RD : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			RESET : IN STD_LOGIC;
			R1_IN, R1_OUT : OUT STD_LOGIC;
			R2_IN, R2_OUT : OUT STD_LOGIC;
			R3_IN, R3_OUT : OUT STD_LOGIC;
			AIN, AOUT : OUT STD_LOGIC;
			GIN, GOUT : OUT STD_LOGIC;
			BIN, BOUT : OUT STD_LOGIC;
			EXTERN : OUT STD_LOGIC;
			DONE : OUT STD_LOGIC;
			ENABLE : IN STD_LOGIC
		  );
END UC;

ARCHITECTURE LOGICFUNC OF UC IS  

-- TODOS OS ESTADOS DA UNIDADE DE CONTROLE;
TYPE S_TYPE IS (INICIO, 
					 OP, OP1, OP2, OP3, OP1_WAIT, OP2_WAIT, OP3_WAIT,
					 LOAD, LOADR1, LOADR2, LOADR3,
					 SWAP1, SWAP2, SWAP3, SWAP_WAIT1, SWAP_WAIT2
					);
SIGNAL STATE: S_TYPE:= INICIO;

		BEGIN
			-- PROCESSO QUE INICIA OS ESTADOS DA CPU
			PROCESS(CLOCK, ENABLE)
				BEGIN
					-- QUANDO RESET FOR '1', VOLTA PARA INICIO, ONDE RESETA-SE TODOS OS SINAIS;
					IF RESET = '1' THEN
						STATE <= INICIO;
						
					ELSIF RISING_EDGE (CLOCK) THEN	
						EXTERN  <= '0';
						R1_IN   <= '0';
						R1_OUT  <= '0';
						R2_IN   <= '0';
						R2_OUT  <= '0';
						R3_IN   <= '0';
						R3_OUT  <= '0';
						AIN     <= '0';
						AOUT 	  <= '0';
						BOUT    <= '0';
						BIN     <= '0';
						GIN     <= '0';
						GOUT    <= '0';
						DONE    <= '0';	
						
					CASE STATE IS 
						-- DEIXA COMO PADRÃO TODOS OS SINAIS IGUAL A 0;
						WHEN INICIO =>
							EXTERN  <= '0';
							R1_IN   <= '0';
							R1_OUT  <= '0';
							R2_IN   <= '0';
							R2_OUT  <= '0';
							R3_IN   <= '0';
							R3_OUT  <= '0';
							AIN     <= '0';
							AOUT 	  <= '0';
							BOUT    <= '0';
							BIN     <= '0';
							GIN     <= '0';
							GOUT    <= '0';
							DONE    <= '0';
							
							-- AVANÇA PARA OS ESTADOS DE ACORDO COM O SEU OPCODE
								-- "0000" => INICIO;
								-- "0001, 0010, 0011, 0100, 0101, 0110, 0111" => OPERAÇÃO DA ULA
								-- "1000" => LOAD;
								-- "1001" => SWAP;
							
							IF OPCODE = "0000" THEN 

								STATE <= INICIO;
									
							ELSIF OPCODE = "0001" AND ENABLE = '1' THEN
								STATE <= OP;

							ELSIF OPCODE = "0010" AND ENABLE = '1' THEN
								STATE <= OP;
								
							ELSIF OPCODE = "0011" AND ENABLE = '1' THEN
								STATE <= OP;
								
							ELSIF OPCODE = "0100" AND ENABLE = '1' THEN
								STATE <= OP;
								
							ELSIF OPCODE = "0101" AND ENABLE = '1' THEN
								STATE <= OP;
								
							ELSIF OPCODE = "0110" AND ENABLE = '1' THEN
								STATE <= OP;
							
							ELSIF OPCODE = "0111" AND ENABLE = '1' THEN
								STATE <= OP;
								
							ELSIF OPCODE = "1000" AND ENABLE = '1' THEN
								STATE <= LOAD;
											
							ELSIF OPCODE = "1001" AND ENABLE = '1' THEN
								STATE <= SWAP1;			
										
							ELSE

								STATE <= INICIO;
									
							END IF;
						
							-- DE ACORDO COM RS E RD, OS VALORES ENVIADOS PARA A E B SÃO DIFERENTES.
							-- CASO RS SEJA "01", REGISTRADOR 1 ENTRARÁ EM A, "10", O REGISTRADOR B, "11", REGISTRADOR 3;
							-- O MESMO SERVE PARA B;
							WHEN OP =>
								-- LIBERA O RS PARA A;
								IF RS = "01" THEN
									R1_OUT <= '1';
									
								ELSIF RS = "10" THEN
									R2_OUT <= '1';
									
								ELSIF RS = "11" THEN
									R3_OUT <= '1';
									
								END IF;
								
								AIN <= '1';
								STATE <= OP1_WAIT;
								
							WHEN OP1_WAIT =>
								
								STATE <= OP1;
								
							WHEN OP1 =>
								IF RS = "01" THEN
									R1_OUT <= '0';
									
								ELSIF RS = "10" THEN
									R2_OUT <= '0';
									
								ELSIF RS = "11" THEN
									R3_OUT <= '0';
								END IF;	
									
								AIN <= '0';
								
								-- FECHA A ENTRADA DE A E A SAIDA DO REGISTRADOR SELECIONADO EM RS;
								-- LIBERA RD PARA B;
								
								IF RD = "01" THEN
									R1_OUT <= '1';						
									
								ELSIF RD = "10" THEN
									R2_OUT <= '1';
									
								ELSIF RD = "11" THEN
									R3_OUT <= '1';
									
								END IF;
								
								BIN <= '1';
								STATE <= OP2_WAIT;
								
							WHEN OP2_WAIT =>
							
								STATE <= OP2;
								
							WHEN OP2 => 
								IF RD = "01" THEN
									R1_OUT <= '0';						
									
								ELSIF RD = "10" THEN
									R2_OUT <= '0';
									
								ELSIF RD = "11" THEN
									R3_OUT <= '0';
								END IF;
								BIN <= '0';
								
								-- FECHA A ENTRADA DE B E A SAIDA DO REGISTRADOR SELECIONADO EM RD;
								-- CASO A OPERAÇÃO SEJA DE COMPARAÇÃO O PRÓXIMO ESTADO IRÁ SER O INÍCIO;
								-- CASO SEJA QUALQUER OUTRA OPERAÇÃO DA ULA, SERÁ COLOCADO EM G O VALOR DA OPERAÇÃO;
								
								IF OPCODE = "0111" THEN
									IF ENABLE = '0' THEN
										DONE <= '1';
										STATE <= INICIO;
									
									ELSE 
										
										STATE <= OP2;
										
									END IF;
								ELSE
									GIN <= '1';
									STATE <= OP3_WAIT;
								END IF;
								
							WHEN OP3_WAIT =>
								
								STATE <= OP3;
								
							-- FECHA A ENTRADA DE G E LIBERA O SEU VALOR PARA BUSS E O COLOCA NO RESGISTRADOR DE RS;
								
							WHEN OP3 =>
								GIN <= '0';
								GOUT <= '1';
								
								IF RS = "01" THEN
									R1_IN <= '1';
									
								ELSIF RS = "10" THEN
									R2_IN <= '1';
									
								ELSIF RS = "11" THEN
									R3_IN <= '1';
									
								END IF;	
								
								IF ENABLE <= '0' THEN
								STATE <= INICIO;
								DONE <= '1';
								ELSE 
								STATE <= OP3;
								
								END IF;
								
							-- ESTADO QUE ARMAZENA O VALOR DE DATAIN EM UM REGISTRADOR;
								
							WHEN LOAD =>
								IF RS = "01" THEN
									STATE <= LOADR1;
									
								ELSIF RS = "10" THEN
									STATE <= LOADR2;

								ELSIF RS = "11" THEN
									STATE <= LOADR3;
									
								END IF;
										
							-- ARMAZENA EM R1;			
							WHEN LOADR1 =>
								R1_IN  <= '1';
								EXTERN <= '1';
								DONE   <= '1';
								
								IF ENABLE = '0' THEN
								
								STATE <= INICIO;
								ELSE 
								
								STATE <= LOADR1;
								
								END IF;
							
							-- ARMAZENA EM R2;
							WHEN LOADR2 =>
								R2_IN  <= '1';
								EXTERN <= '1';
								DONE   <= '1';
								
								IF ENABLE = '0' THEN
								
								STATE <= INICIO;
								ELSE 
								
								STATE <= LOADR2;	
							
								END IF;
							
							-- ARMAZENA EM R3;
							WHEN LOADR3 =>
								R3_IN  <= '1';
								EXTERN <= '1';
								DONE   <= '1';
								
								IF ENABLE = '0' THEN
								
								STATE <= INICIO;
								ELSE 
								
								STATE <= LOADR3;
								
								END IF;
								
							-- ASSIM COMO NA ULA, SELECIONA O REGISTRADOR COM RS E RD;	
							WHEN SWAP1 =>
								-- COLOCA O VALOR DE RD EM A;
								IF RD = "01" THEN
									R1_OUT <= '1';
								ELSIF RD = "10" THEN
									R2_OUT <= '1';
								ELSIF RD = "11" THEN
									R3_OUT <= '1';
								END IF;
								
								AIN <= '1';
								STATE <= SWAP_WAIT1;
								
							WHEN SWAP_WAIT1 =>
							
								STATE <= SWAP2;
								
							WHEN SWAP2 => 
								AIN <= '0';
								IF RS = "01" THEN
									R1_OUT <= '1';
								ELSIF RS = "10" THEN
									R2_OUT <= '1';
								ELSIF RS = "11" THEN
									R3_OUT <= '1';
								END IF;
								
								-- FECHA A ENTRADA DE A E LIBERA O VALOR DE RS PARA RD, JÁ QUE O VALOR DE RD ESTÁ SALVO EM A;
								
								IF RD = "01" THEN
									R1_IN <= '1';
								ELSIF RD = "10" THEN
									R2_IN <= '1';
								ELSIF RD = "11" THEN
									R3_IN <= '1';
								END IF;
								

								STATE <= SWAP_WAIT2;
								
							WHEN SWAP_WAIT2 =>
							
								STATE <= SWAP3;
								
							WHEN SWAP3 =>
								IF RS = "01" THEN
									R1_IN <= '1';
								ELSIF RS = "10" THEN
									R2_IN <= '1';
								ELSIF RS = "11" THEN
									R3_IN <= '1';
								END IF;
								
								-- LIBERA O VALOR DE A PARA RS E REALIZA A TROCA;
								
								AOUT <= '1';
								DONE <= '1';
								
								IF ENABLE = '0' THEN
								
								STATE <= INICIO;
								ELSE 
								
								STATE <= SWAP3;
								
								END IF;
								
							WHEN OTHERS =>
								EXTERN <= '0';
								R1_IN  <= '0';
								R1_OUT <= '0';
								R2_IN  <= '0';
								R2_OUT <= '0';
								R3_IN  <= '0';
								R3_OUT <= '0';
								AIN    <= '0';
								AOUT   <= '0';
								GIN    <= '0';
								GOUT   <= '0';
								DONE 	 <= '0';
						
					END CASE;
				END IF;
				
			END PROCESS;
			
END LOGICFUNC;			
				