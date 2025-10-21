library ieee; 
use ieee.std_logic_1164.all; 
 ----------------------------------------------------------------------------- 
entity Full_adder_Vector_de_bits is 
 Port (  
  A, B : in std_logic_vector(9 downto 0); 
  Carry : out std_logic; 
  Res : out std_logic_vector(9 downto 0); 
  flag_zero : out std_logic; 
  flag_signo : out std_logic; 
  flag_acarreo : out std_logic;  
  flag_overflow : out std_logic 
 ); 
end entity; ------------------------------------------------------------------------------- 
architecture Behavioral of Full_adder_Vector_de_bits is 
 component Half_adder 
  Port ( 
   A, B : in std_logic; 
   Sum, Cout : out std_logic 
  ); 
 end component; 
  
 component Full_adder 
  Port ( 
   A, B, Cin : in std_logic; 
   Sum, Cout : out std_logic 
  ); 
 end component; 
  
 signal C : std_logic_vector(9 downto 0); 
 signal Carry_aux : std_logic; 
 signal Res_aux : std_logic_vector(9 downto 0); 
  
begin 
 HA0: Half_adder port map(A(0), B(0), Res_aux(0), C(0)); 
 FA0: Full_adder port map(A(1), B(1), C(0), Res_aux(1), C(1)); 
 FA1: Full_adder port map(A(2), B(2), C(1), Res_aux(2), C(2)); 
 FA2: Full_adder port map(A(3), B(3), C(2), Res_aux(3), C(3)); 
 FA3: Full_adder port map(A(4), B(4), C(3), Res_aux(4), C(4)); 
 FA4: Full_adder port map(A(5), B(5), C(4), Res_aux(5), C(5)); 
 FA5: Full_adder port map(A(6), B(6), C(5), Res_aux(6), C(6)); 
 FA6: Full_adder port map(A(7), B(7), C(6), Res_aux(7), C(7)); 
 FA7: Full_adder port map(A(8), B(8), C(7), Res_aux(8), C(8)); 
 FA8: Full_adder port map(A(9), B(9), C(8), Res_aux(9), Carry_aux); 
  
 Carry <= Carry_aux; 
 Res <= Res_aux; 
  
 process(Res_aux) 
 begin 
  if Res_aux = "0000000000" then 
   flag_zero <= '1'; 
  else 
   flag_zero <= '0'; 
  end if; 
 end process; 
  
 flag_signo <= '0'; 
  
 process(Res_aux) 
 begin 
  if Carry_aux = '1' then  
   flag_acarreo <= '1'; 
   flag_overflow <= '1'; 
  else 
   flag_acarreo <= '0'; 
   flag_overflow <= '0'; 
  end if; 
 end process; 
  
end architecture;