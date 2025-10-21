library ieee; 
use ieee.std_logic_1164.all; ------------------------------------------------------------------------------------------- 
entity Restador10_bits is 
 port( 
  A,B: in std_logic_vector(9 downto 0);  
  S:out std_logic_vector(9 downto 0); 
  flag_zero: out std_logic; 
  flag_signo:out std_logic; 
  flag_acarreo:out std_logic; 
  flag_overflow:out std_logic); 
end Restador10_bits; --------------------------------------------------------------------------------- 
architecture recurrente of Restador10_bits is 
 signal c: std_logic_vector(10 downto 0); 
 signal rt:std_logic_vector(9 downto 0); 
 signal ci : std_logic := '0'; 
begin 
 process(A,B,c,ci) 
 begin 
 c(0)<= not ci; --acarreo de entrada 
 for i in 0 to 9 loop 
 rt(i)<= (A(i) xor (not B(i))) xor c(i); -- suma recurrente 
 c(i+1)<= ((A(i)and (not B(i)))or (A(i)and c(i))) or ((not B(i))and c(i)); -- acarreo recurrente 
 end loop; 
 end process; 
  
 flag_zero <= '1' when rt = "0000000000" else '0'; 
 flag_signo <= rt(9); 
 flag_acarreo <= '0'; 
 flag_overflow <= (A(9) and not B(9) and not rt(9)) or (not A(9) and B(9) and rt(9)); 
 S<=rt; 
 end recurrente; 