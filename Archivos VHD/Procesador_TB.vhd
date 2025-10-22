library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- 1. La entidad del Testbench siempre está vacía
entity Procesador_TB is
end entity Procesador_TB;

architecture behavioral of Procesador_TB is

    -- 2. Declarar el componente que vamos a probar
    component Procesador_Top
        port(
            clk       : in  std_logic;
            switch    : in  std_logic_vector(1 downto 0);
            Displays  : out std_logic_vector(3 downto 0);
            Segmentos : out std_logic_vector(7 downto 0)
        );
    end component;

    -- 3. Crear señales "virtuales" para conectar al componente
    -- Entradas
    signal tb_clk    : std_logic := '0';
    signal tb_switch : std_logic_vector(1 downto 0) := (others => '0');
    -- Salidas (para poder verlas en el simulador)
    signal tb_Displays : std_logic_vector(3 downto 0);
    signal tb_Segmentos : std_logic_vector(7 downto 0);

    -- Constante para el reloj (50 MHz = 20 ns de periodo)
    constant CLK_PERIOD : time := 20 ns;

begin

    -- 4. Instanciar el "Device Under Test" (DUT)
    -- Conectamos nuestro procesador a las señales virtuales
    UUT: entity work.Procesador_Top(behavioral)
        port map(
            clk       => tb_clk,
            switch    => tb_switch,
            Displays  => tb_Displays,
            Segmentos => tb_Segmentos
        );

    -- 5. Generador de Reloj
    -- Este proceso crea un reloj que oscila cada 10 ns (medio periodo)
    process
    begin
        tb_clk <= '0';
        wait for CLK_PERIOD / 2;
        tb_clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;


    -- 6. Proceso de Estímulos (Aquí controlamos la simulación)
    process
    begin
        report "--- Iniciando Simulación ---";

        -- PRUEBA 1: Ejecutar Programa 1 (Switch = "00")
        report "Iniciando Programa 1 (Switch 00)";
        tb_switch <= "00";
        
        -- Dejamos que corra por 6 segundos (para ver el delay de 5s)
        wait for 6 sec; 

        -- PRUEBA 2: Resetear y Ejecutar Programa 2 (Switch = "01")
        report "Reseteando y iniciando Programa 2 (Switch 01)";
        tb_switch <= "11"; -- Ponemos el switch en RESET
        wait for 100 ns;   -- Esperamos unos ciclos para que el reset actúe
        
        tb_switch <= "01"; -- Seleccionamos Programa 2
        wait for 6 sec;    -- Dejamos que corra 6 segundos

        -- PRUEBA 3: Resetear y Ejecutar Programa 3 (Switch = "10")
        report "Reseteando y iniciando Programa 3 (Switch 10)";
        tb_switch <= "11"; -- Reset
        wait for 100 ns;
        
        tb_switch <= "10"; -- Seleccionamos Programa 3
        wait for 6 sec;    -- Dejamos que corra 6 segundos

        report "--- Simulación Terminada ---";
        wait; -- Detiene la simulación
    end process;

end architecture behavioral;