library ieee; 
use ieee.std_logic_1164.all; 

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
end entity; 

architecture behavioral of Unidad_Ejecucion is  
    -- Señales existentes (sin cambios)
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
    
    signal flag_zero_aux : std_logic; 
    signal flag_signo_aux : std_logic; 
    signal flag_acarreo_aux : std_logic; 
    signal flag_overflow_aux : std_logic; 
    
    -- Componentes (sin cambios)
    component Mux_Constantes 
        port( 
            input : in std_logic_vector(3 downto 0); 
            output : out std_logic_vector(9 downto 0) 
        ); 
    end component; 
    
    component Alu 
        port( 
            input_a : in std_logic_vector(9 downto 0); 
            input_b : in std_logic_vector(9 downto 0); 
            sel_alu  : in std_logic_vector(3 downto 0); 
            flag_zero_main : out std_logic; 
            flag_signo_main : out std_logic; 
            flag_acarreo_main : out std_logic; 
            flag_overflow_main : out std_logic; 
            output : out std_logic_vector(9 downto 0) 
        ); 
    end component; 
    
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
    
    -- ========================================
    -- PROCESO 1: Decodificación de operaciones ALU
    -- ========================================
    process(input_ex) 
    begin 
        -- Valores por defecto
        input_mux_a_aux <= "0000";
        input_mux_b_aux <= "0000";
        sel_alu_aux <= "0000";
        
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
        -- PROGRAMA 2
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
        -- PROGRAMA 3
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
        end if; 
    end process; 
    
    -- Instanciación de componentes ALU
    Comp1 : Mux_Constantes port map(input_mux_a_aux, output_mux_a_aux); 
    Comp2 : Mux_Constantes port map(input_mux_b_aux, output_mux_b_aux); 
    Comp3 : Alu port map(output_mux_a_aux, output_mux_b_aux, sel_alu_aux, open, open, open, open, output_alu_aux); 
    Comp4 : Alu port map(dato1, dato2, sel_alu_aux, flag_zero_aux, flag_signo_aux, flag_acarreo_aux, flag_overflow_aux, output_alu_aux2); 
    
    -- ========================================
    -- PROCESO 2: Control de RAM (CORREGIDO)
    -- ========================================
    process(input_ex, output_alu_aux, output_alu_aux2) 
    begin 
        -- Valores por defecto
        writeEnable_aux <= '0';
        address_aux <= "000";
        datain_aux <= (others => '0');
        
        case input_ex(21 downto 16) is
            when "000000" => writeEnable_aux <= '1'; address_aux <= "001"; datain_aux <= output_alu_aux;
            when "000001" => writeEnable_aux <= '1'; address_aux <= "010"; datain_aux <= output_alu_aux;
            when "000010" => writeEnable_aux <= '1'; address_aux <= "011"; datain_aux <= output_alu_aux;
            when "000011" => writeEnable_aux <= '0'; address_aux <= "001";
            when "000100" => writeEnable_aux <= '0'; address_aux <= "010";
            when "000101" => writeEnable_aux <= '1'; address_aux <= "001"; datain_aux <= output_alu_aux2;
            when "000110" => writeEnable_aux <= '0'; address_aux <= "001";
            when "000111" => writeEnable_aux <= '0'; address_aux <= "011";
            when "001000" => writeEnable_aux <= '1'; address_aux <= "001"; datain_aux <= output_alu_aux2;
            when "001010" => writeEnable_aux <= '1'; address_aux <= "001"; datain_aux <= output_alu_aux;
            when "001011" => writeEnable_aux <= '0'; address_aux <= "001";
            when "001100" => writeEnable_aux <= '1'; address_aux <= "001"; datain_aux <= output_alu_aux2;
            when "001101" => writeEnable_aux <= '1'; address_aux <= "010"; datain_aux <= output_alu_aux;
            when "001110" => writeEnable_aux <= '1'; address_aux <= "011"; datain_aux <= output_alu_aux;
            when "001111" => writeEnable_aux <= '0'; address_aux <= "001";
            when "010000" => writeEnable_aux <= '0'; address_aux <= "010";
            when "010001" => writeEnable_aux <= '1'; address_aux <= "010"; datain_aux <= output_alu_aux2;
            when "010010" => writeEnable_aux <= '0'; address_aux <= "010";
            when "010011" => writeEnable_aux <= '0'; address_aux <= "011";
            when "010100" => writeEnable_aux <= '1'; address_aux <= "001"; datain_aux <= output_alu_aux2;
            when "010110" => writeEnable_aux <= '1'; address_aux <= "001"; datain_aux <= output_alu_aux;
            when "010111" => writeEnable_aux <= '0'; address_aux <= "001";
            when "011000" => writeEnable_aux <= '1'; address_aux <= "001"; datain_aux <= output_alu_aux;
            when "011001" => writeEnable_aux <= '1'; address_aux <= "010"; datain_aux <= output_alu_aux;
            when "011010" => writeEnable_aux <= '1'; address_aux <= "011"; datain_aux <= output_alu_aux;
            when "011011" => writeEnable_aux <= '0'; address_aux <= "001";
            when "011100" => writeEnable_aux <= '0'; address_aux <= "010";
            when "011101" => writeEnable_aux <= '1'; address_aux <= "010"; datain_aux <= output_alu_aux2;
            when "011110" => writeEnable_aux <= '0'; address_aux <= "010";
            when "011111" => writeEnable_aux <= '0'; address_aux <= "011";
            when "100000" => writeEnable_aux <= '1'; address_aux <= "011"; datain_aux <= output_alu_aux2;
            when others => writeEnable_aux <= '0'; address_aux <= "000";
        end case;
        
        -- ⭐ CORRECCIÓN CRÍTICA: Opcodes de lectura final
        -- Estos deben apuntar a la dirección correcta de la RAM donde se guardó el resultado
        if input_ex(23 downto 18) = "110001" then      -- Leer resultado Prog 1
            writeEnable_aux <= '0'; 
            address_aux <= "001";  -- El Prog 1 guarda su resultado final en dirección 001
        elsif input_ex(23 downto 18) = "110010" then   -- Leer resultado Prog 2
            writeEnable_aux <= '0'; 
            address_aux <= "001";  -- El Prog 2 también usa dirección 001
        elsif input_ex(23 downto 18) = "110011" then   -- Leer resultado Prog 3
            writeEnable_aux <= '0'; 
            address_aux <= "011";  -- El Prog 3 guarda en dirección 011
        end if;
    end process; 
    
    -- Instanciación RAM
    Comp5 : Banco_Registros port map(clk, writeEnable_aux, address_aux, datain_aux, dataout_aux); 
    
    -- ========================================
    -- PROCESO 3: Registro de salida (CORREGIDO)
    -- ========================================
    process(clk, reset) 
    begin 
        if reset = '1' then
            output_ex <= (others => '0');
            flag_zero <= '0';
            flag_signo <= '0';
            flag_acarreo <= '0';
            flag_overflow <= '0';
            
        elsif rising_edge(clk) then
            -- ⭐ CORRECCIÓN: Leer directamente de dataout_aux cuando se ejecutan los opcodes de lectura final
            if input_ex(23 downto 18) = "110001" or 
               input_ex(23 downto 18) = "110010" or 
               input_ex(23 downto 18) = "110011" then
                output_ex <= dataout_aux;  -- Lectura directa desde RAM
                flag_zero <= flag_zero_aux; 
                flag_signo <= flag_signo_aux;
                flag_acarreo <= flag_acarreo_aux; 
                flag_overflow <= flag_overflow_aux; 
            end if; 
        end if;
    end process;
    
end architecture;