library ieee; 
use ieee.std_logic_1164.all;  ----------------------------------------------------------------------------- 
entity Complemento2 is 
 port( 
  input_c2_a : in std_logic_vector(9 downto 0); 
  carry_c2 : out std_logic; 
  output_c2_a : out std_logic_vector(9 downto 0); 
  flag_zero : out std_logic; 
  flag_signo : out std_logic; 
  flag_acarreo : out std_logic;  
  flag_overflow : out std_logic 
 ); 
end entity; ------------------------------------------------------------------------------------- 
architecture Behavioral of Complemento2 is 
 -- Componente Full adder 
 component Full_adder_Vector_de_bits 
  Port (  
   A, B : in std_logic_vector(9 downto 0); 
   Carry : out std_logic; 
   Res : out std_logic_vector(9 downto 0); 
   flag_zero : out std_logic; 
   flag_signo : out std_logic; 
   flag_acarreo : out std_logic;  
   flag_overflow : out std_logic 
  ); 
 end component; 
 --Signals 
 signal carry_c2_aux : std_logic; 
 signal output_c2_a_aux : std_logic_vector(9 downto 0); 
 signal input_a_not_aux : std_logic_vector(9 downto 0);
begin 

 input_a_not_aux <= not input_c2_a;
 
 Comp2 : Full_adder_Vector_de_bits 
  port map( 
   A => input_a_not_aux, 
   B => "0000000001", 
   Carry => carry_c2_aux, 
   Res => output_c2_a_aux 
  ); 
   
 output_c2_a <= output_c2_a_aux; 
  
 process(output_c2_a_aux) 
 begin 
  if output_c2_a_aux = "0000000000" then 
   flag_zero <= '1'; 
  else 
   flag_zero <= '0'; 
  end if; 
 end process; 
  
 flag_signo <= '0'; 
  
 process(output_c2_a_aux) 
 begin 
  if carry_c2_aux = '1' then 
   flag_acarreo <= '1'; 
   flag_overflow <= '1'; 
  else 
   flag_acarreo <= '0'; 
   flag_overflow <= '0'; 
  end if; 
 end process;  
end architecture; 