library ieee; 
use ieee.std_logic_1164.all; 
 --------------------------------------------------------------------------------------- 
entity Full_adder is 
	Port (  
		A, B, Cin : in std_logic; 
		Sum, Cout : out std_logic 
	); 
end entity; ------------------------------------------------------------------------------ 

architecture Behavioral of Full_adder is 
begin 
	Sum <= (A xor B) xor Cin; 
	Cout <= (A and B) or (B and Cin) or (A and Cin); 
end architecture; 