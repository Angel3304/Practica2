library ieee; 
use ieee.std_logic_1164.all; 
 
entity Divi is 
port( 
A,B: in std_logic_vector(4 downto 0);  
R:out std_logic_vector(4 downto 0); 
C:out std_logic_vector(4 downto 0); 
flag_zero: out std_logic; 
flag_signo:out std_logic; 
flag_acarreo:out std_logic; 
flag_overflow:out std_logic 
); 
end Divi; 
 
architecture A of Divi is 
signal Result,Result1,Result2,Result3,Result4,Result5: std_logic_vector(9 downto 
0):="0000000000"; 
signal R1,R2,R3,R4: std_logic_vector(9 downto 0):="0000000000"; 
signal carry:std_logic_vector(4 downto 0); 
signal divisor:std_logic_vector(9 downto 0):="0000000000"; 
signal Rest1,Rest2,Rest3,Rest4,Rest5:std_logic_vector(9 downto 0); 
signal B1,B2: std_logic_vector(9 downto 0); 
signal c_carry:std_logic; 
 
Component Full_adder_Vector_de_bits 
 port( 
  A, B : in std_logic_vector(9 downto 0); 
  Carry : out std_logic; 
  Res : out std_logic_vector(9 downto 0); 
  flag_zero : out std_logic; 
  flag_signo : out std_logic; 
  flag_acarreo : out std_logic;  
  flag_overflow : out std_logic 
 ); 
end component; 
 
Component Complemento2 
 port( 
  input_c2_a : in std_logic_vector(9 downto 0); 
  carry_c2 : out std_logic; 
  output_c2_a : out std_logic_vector(9 downto 0) 
 ); 
end component; 
 
begin 
 result(5 downto 1)<=A;  
 B1<="00000" & B(4 downto 0); 
  
 Complemento: Complemento2 port map( 
 input_c2_a=>B1, 
 carry_c2=> c_carry, 
 output_c2_a=>B2 
 ); 
  
 divisor(9 downto 5)<= B2(4 downto 0); 
  
 Res0: Full_adder_Vector_de_bits port map( 
 A=> result, 
 B=> divisor, 
 Carry=> Carry(0), 
 Res=> Rest1 
 ); 
  
Result1(0) <= Result(0) when carry(0) = '0' else carry(0); 
Result1(1) <= Result(1) when carry(0) = '0' else Rest1(1); 
Result1(2) <= Result(2) when carry(0) = '0' else Rest1(2); 
Result1(3) <= Result(3) when carry(0) = '0' else Rest1(3); 
Result1(4) <= Result(4) when carry(0) = '0' else Rest1(4); 
Result1(5) <= Result(5) when carry(0) = '0' else Rest1(5); 
Result1(6) <= Result(6) when carry(0) = '0' else Rest1(6); 
Result1(7) <= Result(7) when carry(0) = '0' else Rest1(7); 
Result1(8) <= Result(8) when carry(0) = '0' else Rest1(8); 
Result1(9) <= Result(9) when carry(0) = '0' else Rest1(9); 
 
R1(0) <= Result1(9); 
R1(1) <= Result1(0); 
R1(2) <= Result1(1); 
R1(3) <= Result1(2); 
R1(4) <= Result1(3); 
R1(5) <= Result1(4); 
R1(6) <= Result1(5); 
R1(7) <= Result1(6); 
R1(8) <= Result1(7); 
R1(9) <= Result1(8); 
 
Res1: Full_adder_Vector_de_bits port map( 
 A=> R1, 
 B=> divisor, 
 Carry=> Carry(1), 
 Res=> Rest2 
 ); 
  
  
Result2(0) <= R1(0) when carry(1) = '0' else Carry(1); 
Result2(1) <= R1(1) when carry(1) = '0' else Rest2(1); 
Result2(2) <= R1(2) when carry(1) = '0' else Rest2(2); 
Result2(3) <= R1(3) when carry(1) = '0' else Rest2(3); 
Result2(4) <= R1(4) when carry(1) = '0' else Rest2(4); 
Result2(5) <= R1(5) when carry(1) = '0' else Rest2(5); 
Result2(6) <= R1(6) when carry(1) = '0' else Rest2(6); 
Result2(7) <= R1(7) when carry(1) = '0' else Rest2(7); 
Result2(8) <= R1(8) when carry(1) = '0' else Rest2(8); 
Result2(9) <= R1(9) when carry(1) = '0' else Rest2(9); 
 
R2(0) <= Result2(9); 
R2(1) <= Result2(0); 
R2(2) <= Result2(1); 
R2(3) <= Result2(2); 
R2(4) <= Result2(3); 
R2(5) <= Result2(4); 
R2(6) <= Result2(5); 
R2(7) <= Result2(6); 
R2(8) <= Result2(7); 
R2(9) <= Result2(8); 
  
 Res2: Full_adder_Vector_de_bits port map( 
 A=> R2, 
 B=> divisor, 
 Carry=> Carry(2), 
 Res=> Rest3 
 ); 
  
Result3(0) <= R2(0) when carry(2) = '0' else Carry(2); 
Result3(1) <= R2(1) when carry(2) = '0' else Rest3(1); 
Result3(2) <= R2(2) when carry(2) = '0' else Rest3(2); 
Result3(3) <= R2(3) when carry(2) = '0' else Rest3(3); 
Result3(4) <= R2(4) when carry(2) = '0' else Rest3(4); 
Result3(5) <= R2(5) when carry(2) = '0' else Rest3(5); 
Result3(6) <= R2(6) when carry(2) = '0' else Rest3(6); 
Result3(7) <= R2(7) when carry(2) = '0' else Rest3(7); 
Result3(8) <= R2(8) when carry(2) = '0' else Rest3(8); 
Result3(9) <= R2(9) when carry(2) = '0' else Rest3(9); 
 
R3(0) <= Result3(9); 
R3(1) <= Result3(0); 
R3(2) <= Result3(1); 
R3(3) <= Result3(2); 
R3(4) <= Result3(3); 
R3(5) <= Result3(4); 
R3(6) <= Result3(5); 
R3(7) <= Result3(6); 
R3(8) <= Result3(7); 
R3(9) <= Result3(8); 
 
 Res3: Full_adder_Vector_de_bits port map( 
 A=> R3, 
 B=> divisor, 
 Carry=> Carry(3), 
 Res=> Rest4 
 ); 
 
Result4(0) <= R3(0) when carry(3) = '0' else Carry(3); 
Result4(1) <= R3(1) when carry(3) = '0' else Rest4(1); 
Result4(2) <= R3(2) when carry(3) = '0' else Rest4(2); 
Result4(3) <= R3(3) when carry(3) = '0' else Rest4(3); 
Result4(4) <= R3(4) when carry(3) = '0' else Rest4(4); 
Result4(5) <= R3(5) when carry(3) = '0' else Rest4(5); 
Result4(6) <= R3(6) when carry(3) = '0' else Rest4(6); 
Result4(7) <= R3(7) when carry(3) = '0' else Rest4(7); 
Result4(8) <= R3(8) when carry(3) = '0' else Rest4(8); 
Result4(9) <= R3(9) when carry(3) = '0' else Rest4(9); 
 
R4(0) <= Result4(9); 
R4(1) <= Result4(0); 
R4(2) <= Result4(1); 
R4(3) <= Result4(2); 
R4(4) <= Result4(3); 
R4(5) <= Result4(4); 
R4(6) <= Result4(5); 
R4(7) <= Result4(6); 
R4(8) <= Result4(7); 
R4(9) <= Result4(8); 
  
 Res4: Full_adder_Vector_de_bits port map( 
 A=> R4, 
 B=> divisor, 
 Carry=> Carry(4), 
 Res=> Rest5 
 ); 
 
Result5(0) <= R4(0) when carry(4) = '0' else Carry(4); 
Result5(1) <= R4(1) when carry(4) = '0' else Rest5(1); 
Result5(2) <= R4(2) when carry(4) = '0' else Rest5(2); 
Result5(3) <= R4(3) when carry(4) = '0' else Rest5(3); 
Result5(4) <= R4(4) when carry(4) = '0' else Rest5(4); 
Result5(5) <= R4(5) when carry(4) = '0' else Rest5(5); 
Result5(6) <= R4(6) when carry(4) = '0' else Rest5(6); 
Result5(7) <= R4(7) when carry(4) = '0' else Rest5(7); 
Result5(8) <= R4(8) when carry(4) = '0' else Rest5(8); 
Result5(9) <= R4(9) when carry(4) = '0' else Rest5(9); 
 
C<=result5(4 downto 0); 
R<=result5(9 downto 5); 
 
flag_zero<= '1' when result5(4 downto 0) = "00000" else '0'; 
flag_signo <= '0'; 
flag_acarreo <= '0'; 
flag_overflow <= '0'; --Como es desvordamiento no sobrepoasa los 5 bits 
 
end A;