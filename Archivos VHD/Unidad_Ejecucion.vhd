
library ieee; 
use ieee.std_logic_1164.all; -------------------------------------------------------------------------- 
entity Unidad_Ejecucion is  
port( 
clk : in std_logic;
reset : in std_logic;
input_ex : in std_logic_vector(23 downto 0); 
output_ex : out std_logic_vector(9 downto 0); 
flag_zero : out std_logic; 
flag_signo : out std_logic; 
flag_acarreo : out std_logic; 
flag_overflow : out std_logic 
); 
end entity; ------------------------------------------------------------------------------------ 
architecture behavioral of Unidad_Ejecucion is  --Señales 
signal input_mux_a_aux : std_logic_vector(3 downto 0); 
 signal input_mux_b_aux : std_logic_vector(3 downto 0); 
 signal output_mux_a_aux : std_logic_vector(9 downto 0); 
 signal output_mux_b_aux : std_logic_vector(9 downto 0); 
  
 signal sel_alu_aux : std_logic_vector(3 downto 0); 
 signal output_alu_aux : std_logic_vector(9 downto 0); 
 signal output_alu_aux2 : std_logic_vector(9 downto 0); 
  
 signal writeEnable_aux : std_logic; 
 signal address_aux : std_logic_vector(2 downto 0); 
 signal datain_aux : std_logic_vector(9 downto 0); 
 signal dataout_aux : std_logic_vector(9 downto 0); 
  
 signal dato1 : std_logic_vector(9 downto 0); 
 signal dato2 : std_logic_vector(9 downto 0); 
  
 signal res1 : std_logic_vector(9 downto 0); 
 signal res2 : std_logic_vector(9 downto 0); 
 signal res3 : std_logic_vector(9 downto 0); 
  
 signal flag_zero_aux : std_logic; 
 signal flag_signo_aux : std_logic; 
 signal flag_acarreo_aux : std_logic; 
 signal flag_overflow_aux : std_logic; 
  ---------------------------------------------------- 
  
 --Componentes 
  
  --Componente Mux numeros  
 component Mux_Constantes 
  port( 
   input : in std_logic_vector(3 downto 0); 
   output : out std_logic_vector(9 downto 0) 
  ); 
 end component; 
  
  --Componente ALU  
 component Alu 
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
 end component; 
  
  --Componente Ram 
 component Banco_Registros 
        port( 
            clk : in STD_LOGIC;
            WriteEnable : in STD_LOGIC;
            Address : in STD_LOGIC_VECTOR(2 downto 0);
            DataIn : in STD_LOGIC_VECTOR(9 downto 0);
            DataOut : out STD_LOGIC_VECTOR(9 downto 0)
        );
    end component; 
begin 
  
 --Proceso de asignacion de entradas y toma de datos de la RAM 
 process(input_ex) 
 begin 
  if input_ex(23 downto 18) = "000000" then 
   input_mux_a_aux <= "0000"; 
   input_mux_b_aux <= "1000"; 
   sel_alu_aux <= "0010"; 
  elsif input_ex(23 downto 18) = "000001" then 
   input_mux_a_aux <= "0001"; 
   input_mux_b_aux <= "1001"; 
   sel_alu_aux <= "0010"; 
  elsif input_ex(23 downto 18) = "000010" then 
   input_mux_a_aux <= "0111"; 
   input_mux_b_aux <= "0010"; 
   sel_alu_aux <= "0011"; 
  elsif input_ex(23 downto 18) = "000011" then 
   dato1 <= dataout_aux; 
  elsif input_ex(23 downto 18) = "000100" then 
   dato2 <= dataout_aux; 
  elsif input_ex(23 downto 18) = "000101" then 
   sel_alu_aux <= "0000"; 
  elsif input_ex(23 downto 18) = "000110" then 
   dato1 <= dataout_aux; 
  elsif input_ex(23 downto 18) = "000111" then 
   dato2 <= dataout_aux; 
  elsif input_ex(23 downto 18) = "001000" then 
   sel_alu_aux <= "0010"; 
  elsif input_ex(23 downto 18) = "001001" then 
   res1 <= dataout_aux; 
  ----------------------------------------------- 
  elsif input_ex(23 downto 18) = "001010" then 
   input_mux_a_aux <= "1000"; 
   input_mux_b_aux <= "1000"; 
   sel_alu_aux <= "0010"; 
  elsif input_ex(23 downto 18) = "001011" then 
   dato1 <= dataout_aux; 
  elsif input_ex(23 downto 18) = "001100" then 
   dato2 <= "0000001101"; 
   sel_alu_aux <= "0010"; 
  elsif input_ex(23 downto 18) = "001101" then 
   input_mux_a_aux <= "0100"; 
   input_mux_b_aux <= "1000"; 
   sel_alu_aux <= "0010"; 
  elsif input_ex(23 downto 18) = "001110" then 
   input_mux_a_aux <= "1010"; 
   input_mux_b_aux <= "0101"; 
   sel_alu_aux <= "0011"; 
  elsif input_ex(23 downto 18) = "001111" then 
   dato1 <= dataout_aux; 
  elsif input_ex(23 downto 18) = "010000" then 
   dato2 <= dataout_aux; 
  elsif input_ex(23 downto 18) = "010001" then 
   sel_alu_aux <= "0000"; 
  elsif input_ex(23 downto 18) = "010010" then 
   dato1 <= dataout_aux; 
  elsif input_ex(23 downto 18) = "010011" then 
   dato2 <= dataout_aux; 
  elsif input_ex(23 downto 18) = "010100" then 
   sel_alu_aux <= "0001"; 
  elsif input_ex(23 downto 18) = "010101" then 
   res2 <= dataout_aux; 
  ------------------------------------------------- 
  elsif input_ex(23 downto 18) = "010110" then 
   input_mux_a_aux <= "1000"; 
   input_mux_b_aux <= "1000"; 
   sel_alu_aux <= "0010"; 
  elsif input_ex(23 downto 18) = "010111" then 
   dato1 <= dataout_aux; 
  elsif input_ex(23 downto 18) = "011000" then 
   input_mux_a_aux <= "0110"; 
   input_mux_b_aux <= "0000"; 
   sel_alu_aux <= "0010"; 
  elsif input_ex(23 downto 18) = "011001" then 
   input_mux_a_aux <= "0011"; 
   input_mux_b_aux <= "1010"; 
   sel_alu_aux <= "0010"; 
  elsif input_ex(23 downto 18) = "011010" then 
   input_mux_a_aux <= "0111"; 
   input_mux_b_aux <= "0011"; 
   sel_alu_aux <= "0011"; 
  elsif input_ex(23 downto 18) = "011011" then 
   dato1 <= dataout_aux; 
  elsif input_ex(23 downto 18) = "011100" then 
   dato2 <= dataout_aux; 
  elsif input_ex(23 downto 18) = "011101" then 
   sel_alu_aux <= "0000"; 
  elsif input_ex(23 downto 18) = "011110" then 
   dato1 <= dataout_aux; 
  elsif input_ex(23 downto 18) = "011111" then 
   dato2 <= dataout_aux; 
  elsif input_ex(23 downto 18) = "100000" then 
   sel_alu_aux <= "0001"; 
  elsif input_ex(23 downto 18) = "100001" then 
   res3 <= dataout_aux; 
  end if; 
 end process; 
  
 --Proceso de componentes de operaciones  
 Comp1 : Mux_Constantes port map( 
  input => input_mux_a_aux, 
  output => output_mux_a_aux 
 ); 
  
 Comp2 : Mux_Constantes port map( 
  input => input_mux_b_aux, 
  output => output_mux_b_aux 
 ); 
  
 Comp3 : Alu port map( 
  input_a => output_mux_a_aux, 
  input_b => output_mux_b_aux, 
  sel_alu => sel_alu_aux, 
  output => output_alu_aux 
 ); 
  
 Comp4 : Alu port map( 
  input_a => dato1, 
  input_b => dato2, 
  sel_alu => sel_alu_aux, 
  flag_zero_main => flag_zero_aux, 
  flag_signo_main => flag_signo_aux,   
  flag_acarreo_main => flag_acarreo_aux, 
  flag_overflow_main => flag_overflow_aux, 
  output => output_alu_aux2 
 ); 
  
 --Proceso de guardado y lectura de datos en la RAM 
 process(input_ex,output_mux_a_aux,output_mux_b_aux) 
 begin 
  if input_ex(21 downto 16) = "000000" then 
   writeEnable_aux <= '1'; 
   address_aux <= "001"; 
   datain_aux <= output_alu_aux; 
  elsif input_ex(21 downto 16) = "000001" then  
   writeEnable_aux <= '1'; 
   address_aux <= "010"; 
   datain_aux <= output_alu_aux; 
  elsif input_ex(21 downto 16) = "000010" then  
   writeEnable_aux <= '1'; 
   address_aux <= "011"; 
   datain_aux <= output_alu_aux; 
  elsif input_ex(21 downto 16) = "000011" then 
   writeEnable_aux <= '0'; 
   address_aux <= "001"; 
  elsif input_ex(21 downto 16) = "000100" then  
   writeEnable_aux <= '0'; 
   address_aux <= "010"; 
  elsif input_ex(21 downto 16) = "000101" then  
   writeEnable_aux <= '1'; 
   address_aux <= "001"; 
   datain_aux <= output_alu_aux2; 
  elsif input_ex(21 downto 16) = "000110" then  
   writeEnable_aux <= '0'; 
   address_aux <= "001"; 
  elsif input_ex(21 downto 16) = "000111" then  
   writeEnable_aux <= '0'; 
   address_aux <= "011"; 
  elsif input_ex(21 downto 16) = "001000" then  
   writeEnable_aux <= '1'; 
   address_aux <= "001"; 
   datain_aux <= output_alu_aux2; 
  elsif input_ex(21 downto 16) = "001001" then  
   writeEnable_aux <= '0'; 
   address_aux <= "001"; 
  elsif input_ex(21 downto 16) = "001010" then  
   writeEnable_aux <= '1'; 
   address_aux <= "001"; 
   datain_aux <= output_alu_aux; 
  elsif input_ex(21 downto 16) = "001011" then  
   writeEnable_aux <= '0'; 
   address_aux <= "001"; 
  elsif input_ex(21 downto 16) = "001100" then  
   writeEnable_aux <= '1'; 
   address_aux <= "001"; 
   datain_aux <= output_alu_aux2; 
  elsif input_ex(21 downto 16) = "001101" then  
   writeEnable_aux <= '1'; 
   address_aux <= "010"; 
   datain_aux <= output_alu_aux; 
  elsif input_ex(21 downto 16) = "001110" then  
   writeEnable_aux <= '1'; 
   address_aux <= "011"; 
   datain_aux <= output_alu_aux; 
  elsif input_ex(21 downto 16) = "001111" then 
   writeEnable_aux <= '0'; 
   address_aux <= "001"; 
  elsif input_ex(21 downto 16) = "010000" then  
   writeEnable_aux <= '0'; 
   address_aux <= "010"; 
  elsif input_ex(21 downto 16) = "010001" then  
   writeEnable_aux <= '1'; 
   address_aux <= "010"; 
   datain_aux <= output_alu_aux2; 
  elsif input_ex(21 downto 16) = "010010" then  
   writeEnable_aux <= '0'; 
   address_aux <= "010"; 
  elsif input_ex(21 downto 16) = "010011" then  
   writeEnable_aux <= '0'; 
   address_aux <= "011"; 
  elsif input_ex(21 downto 16) = "010100" then  
   writeEnable_aux <= '1'; 
   address_aux <= "001"; 
   datain_aux <= output_alu_aux2; 
  elsif input_ex(21 downto 16) = "010101" then  
   writeEnable_aux <= '0'; 
   address_aux <= "001"; 
  elsif input_ex(21 downto 16) = "010110" then  
   writeEnable_aux <= '1'; 
   address_aux <= "001"; 
   datain_aux <= output_alu_aux; 
  elsif input_ex(21 downto 16) = "010111" then  
   writeEnable_aux <= '0'; 
address_aux <= "001"; 
elsif input_ex(21 downto 16) = "011000" then  
writeEnable_aux <= '1'; 
address_aux <= "001"; 
datain_aux <= output_alu_aux; 
elsif input_ex(21 downto 16) = "011001" then  
writeEnable_aux <= '1'; 
address_aux <= "010"; 
datain_aux <= output_alu_aux; 
elsif input_ex(21 downto 16) = "011010" then  
writeEnable_aux <= '1'; 
address_aux <= "011"; 
datain_aux <= output_alu_aux; 
elsif input_ex(21 downto 16) = "011011" then  
writeEnable_aux <= '0'; 
address_aux <= "001"; 
elsif input_ex(21 downto 16) = "011100" then  
writeEnable_aux <= '0'; 
address_aux <= "010"; 
elsif input_ex(21 downto 16) = "011101" then  
writeEnable_aux <= '1'; 
address_aux <= "010"; 
datain_aux <= output_alu_aux2; 
elsif input_ex(21 downto 16) = "011110" then  
writeEnable_aux <= '0'; 
address_aux <= "010"; 
elsif input_ex(21 downto 16) = "011111" then  
writeEnable_aux <= '0'; 
address_aux <= "011"; 
elsif input_ex(21 downto 16) = "100000" then  
writeEnable_aux <= '1'; 
address_aux <= "011"; 
datain_aux <= output_alu_aux2; 
elsif input_ex(21 downto 16) = "100001" then  
writeEnable_aux <= '0'; 
address_aux <= "011"; 
end if; 
end process; 
--Componente de guardado de datos  
Comp5 : Banco_Registros port map(clk,writeEnable_aux,address_aux,datain_aux,dataout_aux); 
process(clk, reset) 
    begin 
        if reset = '1' then
            -- Limpia el display y las banderas al instante
            output_ex <= (others => '0');
            flag_zero <= '0';
            flag_signo <= '0';
            flag_acarreo <= '0';
            flag_overflow <= '0';
            
        elsif rising_edge(clk) then
            -- Lógica de registro
            
            if input_ex(23 downto 18) = "110001" then  -- Opcode "Leer Prog 1"
                output_ex <= res1; 
                flag_zero <= flag_zero_aux; 
                flag_signo <= flag_signo_aux;
                flag_acarreo <= flag_acarreo_aux; 
                flag_overflow <= flag_overflow_aux; 
                
            elsif input_ex(23 downto 18) = "110010" then  -- Opcode "Leer Prog 2"
                output_ex <= res2; 
                flag_zero <= flag_zero_aux;
                flag_signo <= flag_signo_aux; 
                flag_acarreo <= flag_acarreo_aux; 
                flag_overflow <= flag_overflow_aux; 
                
            elsif input_ex(23 downto 18) = "110011" then  -- Opcode "Leer Prog 3"
                output_ex <= res3;
                flag_zero <= flag_zero_aux; 
                flag_signo <= flag_signo_aux; 
                flag_acarreo <= flag_acarreo_aux; 
                flag_overflow <= flag_overflow_aux;  
            end if; 
        end if;
    end process;
end architecture; 