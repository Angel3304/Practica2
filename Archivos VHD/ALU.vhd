library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- <--- LIBRERIA CLAVE

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
end entity;
--------------------------------------------------------------------------------------------------------
architecture behavioral of Alu is

    -- Señales para operandos
    signal op_a_uns : unsigned(9 downto 0);
    signal op_b_uns : unsigned(9 downto 0);
    
    -- Señales para los 5 bits (multiplicación/división)
    signal op_a_5bit : unsigned(4 downto 0);
    signal op_b_5bit : unsigned(4 downto 0);
    
    -- Señales para resultados
    signal res_add : unsigned(10 downto 0); -- 10+10 puede dar 11 bits
    signal res_sub : unsigned(10 downto 0);
    signal res_mul : unsigned(9 downto 0);  -- 5*5 = 10 bits
    signal res_div : unsigned(4 downto 0);  -- 5/5 = 5 bits
    
begin
    -- Convertir entradas
    op_a_uns <= unsigned(input_a);
    op_b_uns <= unsigned(input_b);
    op_a_5bit <= unsigned(input_a(4 downto 0)); -- Truncar para Mul/Div
    op_b_5bit <= unsigned(input_b(4 downto 0)); -- Truncar para Mul/Div

    -- Operaciones (se calculan todas en paralelo)
    res_add <= ('0' & op_a_uns) + ('0' & op_b_uns);
    res_sub <= ('0' & op_a_uns) - ('0' & op_b_uns);
    res_mul <= op_a_5bit * op_b_5bit; -- Multiplicación de 5 bits
    
    -- Manejo de división por cero (concurrente)
    res_div <= (others => '1') when op_b_5bit = 0 else 
               (op_a_5bit / op_b_5bit);

    -- Proceso para seleccionar la salida y banderas
    process(sel_alu, res_add, res_sub, res_mul, res_div)
        variable res_10bit : std_logic_vector(9 downto 0);
    begin
        -- Valores por defecto
        res_10bit := (others => '0');
        flag_zero_main <= '0';
        flag_signo_main <= '0';
        flag_acarreo_main <= '0';
        flag_overflow_main <= '0';
    
        case sel_alu is
            when "0000" => -- Suma
                res_10bit := std_logic_vector(res_add(9 downto 0));
                flag_acarreo_main <= res_add(10); -- Carry
                flag_overflow_main <= res_add(10); -- Overflow (simplificado)
            
            when "0001" => -- Resta
                res_10bit := std_logic_vector(res_sub(9 downto 0));
                flag_acarreo_main <= res_sub(10); -- Borrow (activo bajo)
            
            when "0010" => -- Multiplicacion
                res_10bit := std_logic_vector(res_mul);
            
            when "0011" => -- Division
                res_10bit := "00000" & std_logic_vector(res_div);
            
            when others =>
                res_10bit := (others => '0');
        end case;
        
        -- Asignar banderas comunes
        if(res_10bit = "0000000000") then
            flag_zero_main <= '1';
        end if;
        flag_signo_main <= res_10bit(9);
        
        output <= res_10bit;
        
    end process;

end architecture;