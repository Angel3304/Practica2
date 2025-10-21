library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
 
entity Parte2 is 
 Port (  
  input : in std_logic_vector(3 downto 0); 
  output: out std_logic_vector(7 downto 0) 
 ); 
end entity; ---------------------------------------------------------------------- 
architecture Behavioral of Parte2 is 
begin 
 -- Decodificador de 7 segmentos en anodo comun con divisor   
 process(input) 
  begin 
   case input is 
   when "0000"=> 
    output<= "00000011";---- '0' 
   when "0001"=> 
    output<= "10011111";---- '1' 
   when "0010"=> 
    output<= "00100101";---- '2' 
   when "0011"=> 
    output<= "00001101";---- '3' 
   when "0100"=> 
    output<= "10011001";---- '4' 
   when "0101"=> 
    output<= "01001001";---- '5' 
   when "0110"=> 
    output<= "01000001";---- '6' 
   when "0111"=> 
    output<= "00011111";---- '7' 
   when "1000"=> 
    output<= "00000001";---- '8' 
   when "1001"=> 
    output<= "00001001";---- '9' 
   when others => 
                output <= "11111111";  --(carácter no válido) 
        end case; 
    -- elsif para los demas casos 
 end process; 
end Behavioral; 