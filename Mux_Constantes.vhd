library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all; --------------------------------------------------------------------------------- 
entity Mux_Constantes is 
 port( 
  input : in std_logic_vector(3 downto 0); 
  output : out std_logic_vector(9 downto 0) 
 ); 
end entity; ---------------------------------------------------------------------------------- 
architecture behavioral of Mux_Constantes is 
begin 
 process(input) 
 begin 
  case input is 
   --Numeros de las ecuaciones 
   when "0000" => 
    output <= "0000001101"; --13 
   when "0001" => 
    output <= "0000010111"; --23 
   when "0010" =>  
    output <= "0000000100"; --4 
   when "0011" => 
    output <= "0000000101"; --5  
   when "0100" => 
    output <= "0000011110"; --30 
   when "0101" =>  
    output <= "0000000010"; --2 
   when "0110" => 
    output <= "0000000111"; --7 
   --Numeros constantes 
    --Constate w 
   when "0111" => 
    output <= "0000001010"; --10 
    --Constante x 
   when "1000" => 
    output <= "0000000011"; --3 
    --Constante y 
   when "1001" => 
    output <= "0000000110"; --6 
    --Constante z 
   when "1010" => 
    output <= "0000001000"; --8 
   when others => 
    output <= "0000000000"; 
  end case; 
 end process; 
end architecture; 