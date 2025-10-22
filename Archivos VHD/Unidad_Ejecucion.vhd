library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

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
    
    -- Señales internas
    signal dato1 : std_logic_vector(9 downto 0);
    signal dato2 : std_logic_vector(9 downto 0);
    signal result_alu : std_logic_vector(9 downto 0);
    
    signal flag_zero_int : std_logic;
    signal flag_signo_int : std_logic;
    signal flag_acarreo_int : std_logic;
    signal flag_overflow_int : std_logic;
    
    -- RAM interna (8 posiciones de 10 bits)
    type RAM_Array is array (0 to 7) of std_logic_vector(9 downto 0);
    signal Memory : RAM_Array := (others => (others => '0'));
    
    -- Constantes (desde Mux_Constantes)
    constant CONST_13 : std_logic_vector(9 downto 0) := "0000001101"; -- 13
    constant CONST_23 : std_logic_vector(9 downto 0) := "0000010111"; -- 23
    constant CONST_4  : std_logic_vector(9 downto 0) := "0000000100"; -- 4
    constant CONST_5  : std_logic_vector(9 downto 0) := "0000000101"; -- 5
    constant CONST_30 : std_logic_vector(9 downto 0) := "0000011110"; -- 30
    constant CONST_2  : std_logic_vector(9 downto 0) := "0000000010"; -- 2
    constant CONST_7  : std_logic_vector(9 downto 0) := "0000000111"; -- 7
    constant CONST_W  : std_logic_vector(9 downto 0) := "0000001010"; -- 10
    constant CONST_X  : std_logic_vector(9 downto 0) := "0000000011"; -- 3
    constant CONST_Y  : std_logic_vector(9 downto 0) := "0000000110"; -- 6
    constant CONST_Z  : std_logic_vector(9 downto 0) := "0000001000"; -- 8
    
    -- Componente ALU simplificado
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
    
begin 
    
    -- Instancia de ALU
    ALU_inst : Alu port map(
        input_a => dato1,
        input_b => dato2,
        sel_alu => input_ex(23 downto 20),  -- Usar bits 23:20 como selector ALU
        flag_zero_main => flag_zero_int,
        flag_signo_main => flag_signo_int,
        flag_acarreo_main => flag_acarreo_int,
        flag_overflow_main => flag_overflow_int,
        output => result_alu
    );
    
    -- ============================================
    -- PROCESO PRINCIPAL: Ejecución de Instrucciones
    -- ============================================
    process(clk, reset)
        variable opcode : std_logic_vector(5 downto 0);
        variable addr : integer range 0 to 7;
    begin
        if reset = '1' then
            -- Reset: Limpiar todo
            Memory <= (others => (others => '0'));
            output_ex <= (others => '0');
            flag_zero <= '0';
            flag_signo <= '0';
            flag_acarreo <= '0';
            flag_overflow <= '0';
            dato1 <= (others => '0');
            dato2 <= (others => '0');
            
        elsif rising_edge(clk) then
            opcode := input_ex(23 downto 18);
            addr := to_integer(unsigned(input_ex(2 downto 0)));
            
            -- ========================================
            -- PROGRAMA 1 (Opcodes 000000 - 001000)
            -- ========================================
            case opcode is
                when "000000" =>  -- 13 * X → RAM[1]
                    dato1 <= CONST_13;
                    dato2 <= CONST_X;
                    -- Esperar 1 ciclo para resultado ALU
                when "000001" =>  -- 23 * Y → RAM[2]
                    Memory(1) <= result_alu;  -- Guardar resultado anterior
                    dato1 <= CONST_23;
                    dato2 <= CONST_Y;
                when "000010" =>  -- W / 4 → RAM[3]
                    Memory(2) <= result_alu;
                    dato1 <= CONST_W;
                    dato2 <= CONST_4;
                when "000011" =>  -- Leer RAM[1] → dato1
                    Memory(3) <= result_alu;
                    dato1 <= Memory(1);
                when "000100" =>  -- Leer RAM[2] → dato2
                    dato2 <= Memory(2);
                when "000101" =>  -- dato1 + dato2 → RAM[1]
                    -- ALU hace suma automáticamente
                    null;
                when "000110" =>  -- Leer RAM[1] → dato1
                    Memory(1) <= result_alu;
                    dato1 <= Memory(1);
                when "000111" =>  -- Leer RAM[3] → dato2
                    dato2 <= Memory(3);
                when "001000" =>  -- dato1 * dato2 → RAM[1]
                    null;
                    
                -- ========================================
                -- PROGRAMA 2 (Opcodes 010000 - 011010)
                -- ========================================
                when "010000" =>  -- X * X → RAM[1]
                    Memory(1) <= result_alu;  -- Guardar resultado P1
                    dato1 <= CONST_X;
                    dato2 <= CONST_X;
                when "010001" =>  -- Leer RAM[1] → dato1
                    Memory(1) <= result_alu;
                    dato1 <= Memory(1);
                when "010010" =>  -- dato1 * 13 → RAM[1]
                    dato2 <= CONST_13;
                when "010011" =>  -- 30 * X → RAM[2]
                    Memory(1) <= result_alu;
                    dato1 <= CONST_30;
                    dato2 <= CONST_X;
                when "010100" =>  -- Z / 2 → RAM[3]
                    Memory(2) <= result_alu;
                    dato1 <= CONST_Z;
                    dato2 <= CONST_2;
                when "010101" =>  -- Leer RAM[1] → dato1
                    Memory(3) <= result_alu;
                    dato1 <= Memory(1);
                when "010110" =>  -- Leer RAM[2] → dato2
                    dato2 <= Memory(2);
                when "010111" =>  -- dato1 + dato2 → RAM[2]
                    null;
                when "011000" =>  -- Leer RAM[2] → dato1
                    Memory(2) <= result_alu;
                    dato1 <= Memory(2);
                when "011001" =>  -- Leer RAM[3] → dato2
                    dato2 <= Memory(3);
                when "011010" =>  -- dato1 - dato2 → RAM[1]
                    null;
                    
                -- ========================================
                -- PROGRAMA 3 (Opcodes 100000 - 101010)
                -- ========================================
                when "100000" =>  -- X * X → RAM[1]
                    Memory(1) <= result_alu;  -- Guardar resultado P2
                    dato1 <= CONST_X;
                    dato2 <= CONST_X;
                when "100001" =>  -- Leer RAM[1] → dato1
                    Memory(1) <= result_alu;
                    dato1 <= Memory(1);
                when "100010" =>  -- dato1 * 7 → RAM[1]
                    dato2 <= CONST_7;
                when "100011" =>  -- 5 * Z → RAM[2]
                    Memory(1) <= result_alu;
                    dato1 <= CONST_5;
                    dato2 <= CONST_Z;
                when "100100" =>  -- W / 5 → RAM[3]
                    Memory(2) <= result_alu;
                    dato1 <= CONST_W;
                    dato2 <= CONST_5;
                when "100101" =>  -- Leer RAM[1] → dato1
                    Memory(3) <= result_alu;
                    dato1 <= Memory(1);
                when "100110" =>  -- Leer RAM[2] → dato2
                    dato2 <= Memory(2);
                when "100111" =>  -- dato1 + dato2 → RAM[2]
                    null;
                when "101000" =>  -- Leer RAM[2] → dato1
                    Memory(2) <= result_alu;
                    dato1 <= Memory(2);
                when "101001" =>  -- Leer RAM[3] → dato2
                    dato2 <= Memory(3);
                when "101010" =>  -- dato1 - dato2 → RAM[3]
                    null;
                    
                -- ========================================
                -- LECTURA DE RESULTADOS
                -- ========================================
                when "110001" =>  -- Leer resultado Programa 1
                    Memory(1) <= result_alu;
                    output_ex <= Memory(addr);  -- addr viene de input_ex(2:0)
                    flag_zero <= flag_zero_int;
                    flag_signo <= flag_signo_int;
                    flag_acarreo <= flag_acarreo_int;
                    flag_overflow <= flag_overflow_int;
                    
                when "110010" =>  -- Leer resultado Programa 2
                    Memory(1) <= result_alu;
                    output_ex <= Memory(addr);
                    flag_zero <= flag_zero_int;
                    flag_signo <= flag_signo_int;
                    flag_acarreo <= flag_acarreo_int;
                    flag_overflow <= flag_overflow_int;
                    
                when "110011" =>  -- Leer resultado Programa 3
                    Memory(3) <= result_alu;
                    output_ex <= Memory(addr);
                    flag_zero <= flag_zero_int;
                    flag_signo <= flag_signo_int;
                    flag_acarreo <= flag_acarreo_int;
                    flag_overflow <= flag_overflow_int;
                    
                when others =>
                    null;
            end case;
        end if;
    end process;
    
end architecture;