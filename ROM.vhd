 
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all; ----------------------------------------------------------------------------------------------- 
entity Rom is 
 port( 
  input : in std_logic_vector(5 downto 0); 
  output : out std_logic_vector(21 downto 0) 
 ); 
end entity; ------------------------------------------------------------------------------------------------------ 
architecture behavioral of Rom is 
 
 type Rom_instrucciones is array(0 to 33) of std_logic_vector(21 downto 0); 
 constant TR : Rom_instrucciones := ( 
  0 => "0000000000100000100011", --13X
  1 => "0000010001100100100101", --23Y 
  2 => "0000100111001000110111", --w/4 
  3 => "0000110000000000000010", --Lectura primera posicion ram 
  4 => "0001000000000000000100", --Lectura segunda posicion ram 
  5 => "0001010000000000000011", --Operacion compuesta 1 
  6 => "0001100000000000000010", --Lecturua primera posicoin ram 
  7 => "0001110000000000000110", --Lectura segunda posicion ram 
  8 => "0010000000000000010011", --Operacion compuesta final  
  9 => "0010010000000000000010", --Lectura del resultado 
  --------------------------------------------------------------- 
  10 => "0010101000100000100011", --x * x 
  11 => "0010110000000000000010", --Lectura operacion simple 1 
  12 => "0011000000000000100011", --13x2 
  13 => "0011010100100000100101", --30X 
  14 => "0011101010010100110111", --Z/2 
  15 => "0011110000000000000010", --Lectura operacion simple 1 
  16 => "0100000000000000000100", --Lectura operacion simple 2 
  17 => "0100010000000000000101", --Operacion compuesta 1 
  18 => "0100100000000000000100", --Lectura operacion compuesta 1 
  19 => "0100110000000000000110", --Lectura operacion simple 4 
  20 => "0101000000000000010011", --Operacion final 
  21 => "0101010000000000000010", --Lectura operacion final 
  ---------------------------------------------------------------- 
22 => "0101101000100000100011", --X al cuadrado 
23 => "0101110000000000000010", --Lectura operacion anterior Ram 
24 => "0110000110100000100011", --7 por X al cuadrado 
25 => "0110010011101000100101", --5 por Z 
26 => "0110100111001100110111", -- W entre 5 
27 => "0110110000000000000010", --Lectura primera operacion  
28 => "0111000000000000000100", --Lectura segunda operacion 
29 => "0111010000000000000101", --Primera operacion + segunda operacion  
30 => "0111100000000000000100", --Lectura segunda operacion 
31 => "0111110000000000000110", --Lectura 3da operacion  
32 => "1000000000000000010111", --Operacion final 
33 => "1000010000000000000110", --Lectura final 
others => "0000000000000000000000"); 
 begin 
output <= TR(to_integer(unsigned(input))); 
end architecture; 