library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-------------------------------------------------------------------------------------------------
entity Procesador_Top is
 port(
  clk : in std_logic;
  switch : in std_logic_vector(1 downto 0);
  Displays : out std_logic_vector(3 downto 0);
  Segmentos : out std_logic_vector(7 downto 0)
 );
end entity;
-------------------------------------------------------------------------------------------------
architecture behavioral of Procesador_Top is

 -- FSM: Definición de Estados
 type t_estado is (S_INIT, S_FETCH, S_EXECUTE);
 signal estado_actual, estado_siguiente : t_estado;
 
 -- Registros Principales del CPU
 -- CAMBIO: PC y PC_next ahora son 'unsigned' para poder usar '+' de numeric_std
 signal PC : unsigned(5 downto 0);
 signal PC_next : unsigned(5 downto 0);
 signal MAR : std_logic_vector(5 downto 0); -- Sigue siendo std_logic_vector
 signal IR : std_logic_vector(23 downto 0);
 signal ACC_resultado : std_logic_vector(9 downto 0);
 
 -- Banderas de la ALU
 signal flag_zero_out : std_logic;
 -- (otras banderas...)
 
 -- Lógica de Retardo (Hardware Wait)
 constant CLKS_5_SEGUNDOS : unsigned(27 downto 0) := to_unsigned(250000000, 28);
 signal delay_counter : unsigned(27 downto 0) := (others => '0');

 -- Señales de conexión
 signal rom_data_out : std_logic_vector(23 downto 0);
 signal bcd_out : std_logic_vector(15 downto 0);
 
 -- (Señales del Display omitidas por brevedad... son las mismas del Paso 3)
 signal output_uni_aux : std_logic_vector(7 downto 0); 
 signal output_dec_aux : std_logic_vector(7 downto 0);
 signal output_cen_aux : std_logic_vector(7 downto 0); 
 signal output_mil_aux : std_logic_vector(7 downto 0); 
 signal cuenta : integer range 0 to 100000;
 signal Seleccion : unsigned(1 downto 0) := "00"; 
 signal Mostrar : std_logic_vector(3 downto 0) := "0000";
 
 
 -- Componentes (igual que en Paso 3)
 component Memoria_Instrucciones
  port(
   input : in std_logic_vector(5 downto 0);
   output : out std_logic_vector(23 downto 0)
 );
 end component;
 
 component Unidad_Ejecucion
  port(
   input_ex : in std_logic_vector(23 downto 0);
   output_ex : out std_logic_vector(9 downto 0);
   flag_zero : out std_logic;
   flag_signo : out std_logic;
   flag_acarreo : out std_logic;
   flag_overflow : out std_logic
 );
 end component;
 
 component Converti
  Port ( 
   S : in  std_logic_vector(11 downto 0); 
   output_bcd : out std_logic_vector(15 downto 0) 
  );
 end component;
 
 component Parte2 
  Port(    
   input : in std_logic_vector(3 downto 0); 
   output: out std_logic_vector(7 downto 0) 
  );
 end component;
 
begin

 -- 1. Conexión de Componentes
 Comp_ROM : Memoria_Instrucciones port map(
  input => MAR,         -- MAR (std_logic_vector) -> ROM (std_logic_vector)
  output => rom_data_out
 );
 
 Comp_Execute : Unidad_Ejecucion port map(
  input_ex => IR,
  output_ex => ACC_resultado,
  flag_zero => flag_zero_out,
  flag_signo => open, -- (No usamos las otras banderas... todavía)
  flag_acarreo => open,
  flag_overflow => open
 );
 

 -- 2. Lógica de la FSM (Unidad de Control) --
 
 -- Proceso 1: Lógica Combinacional (Transición de estados y Lógica de Salto)
 process(estado_actual, switch, IR, flag_zero_out, PC, delay_counter, rom_data_out)
 begin
  -- Valores por defecto
  estado_siguiente <= estado_actual;
  PC_next <= PC + 1; -- CAMBIO: Esto ahora funciona (unsigned + integer)
  
  case estado_actual is
  
   when S_INIT =>
    estado_siguiente <= S_FETCH;
    if switch = "00" then PC_next <= "000000";
    elsif switch = "01" then PC_next <= "001100";
    elsif switch = "10" then PC_next <= "011010";
    else PC_next <= "000000";
    end if;
    
   when S_FETCH =>
    estado_siguiente <= S_EXECUTE;
    PC_next <= PC;
    
   when S_EXECUTE =>
    case IR(23 downto 18) is
    
     when "001111" => -- HALT
      estado_siguiente <= S_EXECUTE;
      PC_next <= PC;
      
     when "100001" => -- WAIT_5S
      if (delay_counter < CLKS_5_SEGUNDOS) then
       estado_siguiente <= S_EXECUTE;
       PC_next <= PC;
      else
       estado_siguiente <= S_FETCH;
       PC_next <= PC + 1;
      end if;
      
     when "100010" => -- JMP
      estado_siguiente <= S_FETCH;
      PC_next <= unsigned(IR(5 downto 0)); -- CAMBIO: Type-cast
      
     when "100000" => -- BNZ
      if (flag_zero_out = '0') then
       estado_siguiente <= S_FETCH;
       PC_next <= unsigned(IR(5 downto 0)); -- CAMBIO: Type-cast
      else
       estado_siguiente <= S_FETCH;
       PC_next <= PC + 1;
      end if;
      
     when others => -- ALU/Memoria
      estado_siguiente <= S_FETCH;
      PC_next <= PC + 1;
      
    end case;
  end case;
  
  if switch = "11" then -- RESET
   estado_siguiente <= S_INIT;
   PC_next <= "000000";
  end if;
  
 end process;
 
 
 -- Proceso 2: Lógica Secuencial (Actualización de Registros)
 process(clk)
 begin
  if rising_edge(clk) then
  
   estado_actual <= estado_siguiente;
   PC <= PC_next;
   
   if (estado_siguiente = S_INIT) then
    MAR <= (others => '0');
    IR <= (others => '0');
    delay_counter <= (others => '0');
    
   elsif (estado_siguiente = S_FETCH) then
    MAR <= std_logic_vector(PC_next); -- CAMBIO: Type-cast
    
   elsif (estado_siguiente = S_EXECUTE) then
    if (estado_actual = S_FETCH) then
     IR <= rom_data_out;
    end if;
    
    if (IR(23 downto 18) = "100001" and delay_counter < CLKS_5_SEGUNDOS) then
     delay_counter <= delay_counter + 1;
    else
     delay_counter <= (others => '0');
    end if;
    
   end if;
  end if;
 end process;
 
 -- 3. Lógica de Visualización (Display) --
 Comp_BCD : Converti port map(
  S => "00" & ACC_resultado, -- Asumimos que ACC es 10 bits
  output_bcd => bcd_out
 );
 
 Comp_7Seg_Uni : Parte2 port map(bcd_out(3 downto 0), output_uni_aux);
 Comp_7Seg_Dec : Parte2 port map(bcd_out(7 downto 4), output_dec_aux);
 Comp_7Seg_Cen : Parte2 port map(bcd_out(11 downto 8), output_cen_aux);
 Comp_7Seg_Mil : Parte2 port map(bcd_out(15 downto 12), output_mil_aux);
 
 -- Proceso de Multiplexado del Display
 process(clk)
 begin
  if rising_edge(clk) then
   if cuenta < 10000 then
    cuenta <= cuenta + 1;
   else
    Seleccion <= Seleccion + 1;
    cuenta <= 0;
   end if;
  end if;
 end process;
 
 -- Proceso de Selección y Muestra en Display
 process(Seleccion, output_uni_aux, output_dec_aux, output_cen_aux, output_mil_aux)
 begin
  case Seleccion is
   when "00" => Mostrar <= "1110";
   when "01" => Mostrar <= "1101";
   when "10" => Mostrar <= "1011";
   when "11" => Mostrar <= "0111";
   when others => Mostrar <= "1111";
  end case;
  
  case Mostrar is
   when "1110" => Segmentos <= output_uni_aux;
   when "1101" => Segmentos <= output_dec_aux;
   when "1011" => Segmentos <= output_cen_aux;
   when "0111" => Segmentos <= output_mil_aux;
   when others => Segmentos <= "11111111";
  end case;
 end process;
 
 Displays <= Mostrar;
 
end architecture;