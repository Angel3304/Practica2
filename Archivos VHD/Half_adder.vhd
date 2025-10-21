 library ieee; 
use ieee.std_logic_1164.all; 
 ------------------------------------------------------------------------------------ 
entity Half_adder is 
 port (  
  A, B : in std_logic; 
  Sum, Cout : out std_logic 
 ); 
end entity; ------------------------------------------------------------------------------- 
architecture Behavioral of Half_adder is 
begin 
 Sum <= A xor B; 
 Cout <= A and B; 
end architecture;