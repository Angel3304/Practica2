 
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all; ----------------------------------------------------------------------------------------------- 
entity Memoria_Instrucciones is 
 port( 
  input : in std_logic_vector(5 downto 0);
  output : out std_logic_vector(23 downto 0)
 ); 
end entity; ------------------------------------------------------------------------------------------------------ 
architecture behavioral of Memoria_Instrucciones is 
	-- Opcode 100001 = WAIT_5S
	-- Opcode 001111 = HALT
 
 type Rom_instrucciones is array(0 to 40) of std_logic_vector(23 downto 0); 
 constant TR : Rom_instrucciones := ( 
  0 => "000000000000100000100011", --13X
  1 => "000000010001100100100101", --23Y 
  2 => "000000100111001000110111", --w/4 
  3 => "000000110000000000000010", --Lectura primera posicion ram 
  4 => "000001000000000000000100", --Lectura segunda posicion ram 
  5 => "000001010000000000000011", --Operacion compuesta 1 
  6 => "000001100000000000000010", --Lecturua primera posicoin ram 
  7 => "000001110000000000000110", --Lectura segunda posicion ram 
  8 => "000010000000000000010011", --Operacion compuesta final  
  9 => "000010010000000000000010", --Lectura del resultado 
  --------------------------------------------------------------- 
  10 => "001000010000000000000000", -- Opcode WAIT_5S
  11 => "000011110000000000000000", -- Opcode HALT
  
  12 => "000010101000100000100011", --x * x 
  13 => "000010110000000000000010", --Lectura operacion simple 1 
  14 => "000011000000000000100011", --13x2 
  15 => "000011010100100000100101", --30X 
  16 => "000011101010010100110111", --Z/2 
  17 => "000011110000000000000010", --Lectura operacion simple 1 
  18 => "000100000000000000000100", --Lectura operacion simple 2 
  19 => "000100010000000000000101", --Operacion compuesta 1 
  20 => "000100100000000000000100", --Lectura operacion compuesta 1 
  21 => "000100110000000000000110", --Lectura operacion simple 4 
  22 => "000101000000000000010011", --Operacion final 
  23 => "000101010000000000000010", --Lectura operacion final 
  ---------------------------------------------------------------- 
  24 => "001000010000000000000000", -- Opcode WAIT_5S
  25 => "000011110000000000000000", -- Opcode HALT
  
  26 => "000101101000100000100011", --X al cuadrado
  27 => "000101110000000000000010", --Lectura operacion anterior Ram
  28 => "000110000110100000100011", --7 por X al cuadrado
  29 => "000110010011101000100101", --5 por Z
  30 => "000110100111001100110111", -- W entre 5
  31 => "000110110000000000000010", --Lectura primera operacion
  32 => "000111000000000000000100", --Lectura segunda operacion
  33 => "000111010000000000000101", --Primera operacion + segunda operacion
  34 => "000111100000000000000100", --Lectura segunda operacion 
  35 => "000111110000000000000110", --Lectura 3da operacion
  36 => "001000000000000000010111", --Operacion final 
  37 => "001000010000000000000110",--Lectura final
  
  38 => "001000010000000000000000", -- Opcode WAIT_5S
  39 => "000011110000000000000000", -- Opcode HALT
  others => "000011110000000000000000"); 
begin
	output <= TR(to_integer(unsigned(input))); 
end architecture; 