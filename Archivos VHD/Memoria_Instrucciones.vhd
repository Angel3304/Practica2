library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all; 
----------------------------------------------------------------------------------------------- 
entity Memoria_Instrucciones is 
 port( 
  input : in std_logic_vector(5 downto 0);
  output : out std_logic_vector(23 downto 0)
 );
end entity; 
------------------------------------------------------------------------------------------------------ 
architecture behavioral of Memoria_Instrucciones is
	-- Opcode 100001 = WAIT_5S
	-- Opcode 001111 = HALT
    -- Opcode 110001 = READ_PROG_1
    -- Opcode 110010 = READ_PROG_2
    -- Opcode 110011 = READ_PROG_3
 
 type Rom_instrucciones is array(0 to 40) of std_logic_vector(23 downto 0);
 constant TR : Rom_instrucciones := ( 
  -- Programa 1 (inicia en 0)
  0 => "000000000000100000100011", --13X
  1 => "000001000001100100100101", --23Y (Opcode 000001)
  2 => "000010000111001000110111", --w/4 (Opcode 000010)
  3 => "000011000000000000000010", --Lectura primera posicion ram (Opcode 000011)
  4 => "000100000000000000000100", --Lectura segunda posicion ram (Opcode 000100)
  5 => "000101000000000000000011", --Operacion compuesta 1 (Opcode 000101)
  6 => "000110000000000000000010", --Lecturua primera posicoin ram (Opcode 000110)
  7 => "000111000000000000000110", --Lectura segunda posicion ram (Opcode 000111)
  8 => "001000000000000000010011", --Operacion compuesta final (Opcode 001000)
  
  -- ###############################################################
  -- # CAMBIO AQUI: Opcode "Leer Prog 1"
  -- ###############################################################
  9 => "110001000000000000000010", --Lectura del resultado (Opcode 110001)
  
  10 => "100001000000000000000000", -- Opcode WAIT_5S
  11 => "001111000000000000000000", -- Opcode HALT
  
  -- Programa 2 (inicia en 12)
  12 => "001010001000100000100011", --x * x (Opcode 001010)
  13 => "001011000000000000000010", --Lectura operacion simple 1 (Opcode 001011)
  14 => "001100000000000000100011", --13x2 (Opcode 001100)
  15 => "001101000100100000100101", --30X (Opcode 001101)
  16 => "001110001010010100110111", --Z/2 (Opcode 001110)
  17 => "001111000000000000000010", --Lectura operacion simple 1 (Opcode 001111)
  18 => "010000000000000000000100", --Lectura operacion simple 2 (Opcode 010000)
  19 => "010001000000000000000101", --Operacion compuesta 1 (Opcode 010001)
  20 => "010010000000000000000100", --Lectura operacion compuesta 1 (Opcode 010010)
  21 => "010011000000000000000110", --Lectura operacion simple 4 (Opcode 010011)
  22 => "010100000000000000010011", --Operacion final (Opcode 010100)
  
  -- ###############################################################
  -- # CAMBIO AQUI: Opcode "Leer Prog 2"
  -- ###############################################################
  23 => "110010000000000000000010", --Lectura operacion final (Opcode 110010)
  
  24 => "100001000000000000000000", -- Opcode WAIT_5S
  25 => "001111000000000000000000", -- Opcode HALT
  
  -- Programa 3 (inicia en 26)
  26 => "010110001000100000100011", --X al cuadrado (Opcode 010110)
  27 => "010111000000000000000010", --Lectura operacion anterior Ram (Opcode 010111)
  28 => "011000000110100000100011", --7 por X al cuadrado (Opcode 011000)
  
  -- ###############################################################
  -- # CAMBIO AQUI: Línea corregida (añadido un '0')
  -- ###############################################################
  29 => "011001000011101000100101", --5 por Z (Opcode 011001)

  30 => "011010000111001100110111", -- W entre 5 (Opcode 011010)
  31 => "011011000000000000000010", --Lectura primera operacion (Opcode 011011)
  32 => "011100000000000000000100", --Lectura segunda operacion (Opcode 011100)
  33 => "011101000000000000000101", --Primera operacion + segunda operacion (Opcode 011101)
  34 => "011110000000000000000100", --Lectura segunda operacion (Opcode 011110)
  35 => "011111000000000000000110", --Lectura 3da operacion (Opcode 011111)
  36 => "100000000000000000010111", --Operacion final (Opcode 100000)
  
  -- ###############################################################
  -- # CAMBIO AQUI: Opcode "Leer Prog 3"
  -- ###############################################################
  37 => "110011000000000000000110", --Lectura final (Opcode 110011)
  
  38 => "100001000000000000000000", -- Opcode WAIT_5S
  39 => "001111000000000000000000", -- Opcode HALT
  
  others => "001111000000000000000000" -- HALT por defecto
 );
begin
	output <= TR(to_integer(unsigned(input))); 
end architecture;