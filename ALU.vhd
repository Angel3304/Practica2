library ieee; 
use ieee.std_logic_1164.all; 
----------------------------------------------------------------------------------------------------- 
entity Alu is 
 port( 
  input_a : in std_logic_vector(9 downto 0); 
  input_b : in std_logic_vector(9 downto 0); 
  sel_alu  : in std_logic_vector(3 downto 0); 
  flag_zero_main : out std_logic; 
  flag_signo_main : out std_logic; 
  flag_acarreo_main : out std_logic; 
  flag_overflow_main : out std_logic; 
  output        : out std_logic_vector(9 downto 0) 
 ); 
end entity; -------------------------------------------------------------------------------------------------------- 
architecture behavioral of Alu is 
 
 --Señales 
  --Señales de datos para los componentes 
 signal input_a_aux : std_logic_vector(9 downto 0); 
 signal input_b_aux : std_logic_vector(9 downto 0); 
 signal output_suma : std_logic_vector(9 downto 0); 
 signal output_resta : std_logic_vector(9 downto 0); 
 signal output_multi : std_logic_vector(10 downto 0); 
 signal output_divi : std_logic_vector(4 downto 0); 
  
 signal flag_zero : std_logic_vector(3 downto 0); 
 signal flag_signo : std_logic_vector(3 downto 0); 
 signal flag_acarreo : std_logic_vector(3 downto 0); 
 signal flag_overflow : std_logic_vector(3 downto 0); 
 ------------------------------------------------------- 
  
 --Componentes 
  --Sumador 
 component Full_adder_Vector_de_bits  
  port( 
   A, B : in std_logic_vector(9 downto 0); 
   Carry : out std_logic; 
   Res : out std_logic_vector(9 downto 0); 
   flag_zero : out std_logic; 
   flag_signo : out std_logic; 
   flag_acarreo : out std_logic;  
   flag_overflow : out std_logic 
  ); 
 end component; 
  
  --Restador 
 component Restador10_bits 
  port( 
   A,B: in std_logic_vector(9 downto 0);  
   S:out std_logic_vector(9 downto 0); 
   flag_zero: out std_logic; 
   flag_signo:out std_logic; 
   flag_acarreo:out std_logic; 
   flag_overflow:out std_logic 
  ); 
 end component; 
  
  --Multiplicador  
 component Multiplicador 
  port( 
    A, B: in std_logic_vector(4 downto 0); 
    Cout:out std_logic; 
        ResultadoF: out std_logic_vector(10 downto 0); 
    flag_zero: out std_logic; 
    flag_signo:out std_logic; 
    flag_acarreo:out std_logic; 
    flag_overflow:out std_logic 
  ); 
   end component; 
    
  --Divisor 
 component Divi 
  port( 
   A,B: in std_logic_vector(4 downto 0);  
   R:out std_logic_vector(4 downto 0); 
   C:out std_logic_vector(4 downto 0); 
   flag_zero: out std_logic; 
   flag_signo:out std_logic; 
   flag_acarreo:out std_logic; 
   flag_overflow:out std_logic 
  ); 
 end component; 
begin 
  
 process(sel_alu) 
 begin 
  if sel_alu = "0000" then --Suma de A con B 
   input_a_aux <= input_a; 
   input_b_aux <= input_b; 
  elsif sel_alu = "0001" then --Resta de A con B 
   input_a_aux <= input_a; 
   input_b_aux <= input_b; 
  elsif sel_alu = "0010" then --Multiplicacion de A con B 
   input_a_aux <= input_a; 
   input_b_aux <= input_b; 
  elsif sel_alu = "0011" then --Division de A con B 
   input_a_aux <= input_a; 
   input_b_aux <= input_b; 
  else 
   NULL; 
  end if; 
 end process; 
  
 --Declaracion de componentes 
 Comp1 : Full_adder_Vector_de_bits 
  port map( 
   A => input_a_aux, 
   B => input_b_aux, 
   Res => output_suma, 
   flag_zero => flag_zero(0), 
   flag_signo => flag_signo(0), 
   flag_acarreo => flag_acarreo(0), 
   flag_overflow => flag_overflow(0) 
  ); 
   
 Comp2 : Restador10_bits 
  port map( 
   A => input_a_aux, 
   B => input_b_aux, 
   S => output_resta, 
   flag_zero => flag_zero(1), 
   flag_signo => flag_signo(1), 
   flag_acarreo => flag_acarreo(1), 
   flag_overflow => flag_overflow(1) 
  ); 
   
 Comp3 : Multiplicador 
  port map( 
   A => input_a_aux(4 downto 0), 
   B => input_b_aux(4 downto 0), 
   ResultadoF => output_multi, 
   flag_zero => flag_zero(2), 
   flag_signo => flag_signo(2), 
   flag_acarreo => flag_acarreo(2), 
   flag_overflow => flag_overflow(2) 
  ); 
   
 Comp4 : Divi 
  port map( 
   A => input_a_aux(4 downto 0), 
   B => input_b_aux(4 downto 0), 
   C => output_divi, 
   flag_zero => flag_zero(3), 
   flag_signo => flag_signo(3), 
   flag_acarreo => flag_acarreo(3), 
   flag_overflow => flag_overflow(3) 
  ); 
   
 process(output_suma,output_resta,output_multi,output_divi) 
 begin 
  if sel_alu = "0000" then --Suma 
   output <= output_suma; 
   flag_zero_main <= flag_zero(0); 
   flag_signo_main <= flag_signo(0); 
   flag_acarreo_main <= flag_acarreo(0); 
   flag_overflow_main <= flag_overflow(0); 
  elsif sel_alu = "0001" then --Resta 
   output <= output_resta; 
   flag_zero_main <= flag_zero(1); 
   flag_signo_main <= flag_signo(1); 
   flag_acarreo_main <= flag_acarreo(1); 
   flag_overflow_main <= flag_overflow(1); 
  elsif sel_alu = "0010" then --Multiplicacion 
   output <= output_multi(9 downto 0); 
   flag_zero_main <= flag_zero(2); 
   flag_signo_main <= flag_signo(2); 
   flag_acarreo_main <= flag_acarreo(2); 
   flag_overflow_main <= flag_overflow(2); 
  elsif sel_alu = "0011" then --Divi 
   output <= "00000" & output_divi; 
   flag_zero_main <= flag_zero(3); 
   flag_signo_main <= flag_signo(3); 
   flag_acarreo_main <= flag_acarreo(3); 
   flag_overflow_main <= flag_overflow(3); 
  else 
   output <= "0000000000"; 
  end if; 
 end process;
 end architecture;