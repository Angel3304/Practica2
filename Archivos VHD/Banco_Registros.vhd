library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all;
----------------------------------------------------------------------------------------------- 
entity Banco_Registros is 
    Port ( 
        clk : in STD_LOGIC;               -- Reloj
        WriteEnable : in STD_LOGIC;       -- Habilitar escritura 
        Address : in STD_LOGIC_VECTOR(2 downto 0);  -- Dirección
        DataIn : in STD_LOGIC_VECTOR(9 downto 0);  -- Datos de entrada 
        DataOut : out STD_LOGIC_VECTOR(9 downto 0)  -- Datos de salida 
    ); 
end entity; 
 
architecture Behavioral of Banco_Registros is 
    type RAM_Array is array (0 to 7) of STD_LOGIC_VECTOR(9 downto 0);
    -- RAM inferida
    signal Memory : RAM_Array; 
 
begin 
 
    -- Proceso de ESCRITURA Síncrona
    process (clk) 
    begin 
        if rising_edge(clk) then
            if WriteEnable = '1' then 
                -- Escritura en la RAM 
                Memory(to_integer(unsigned(Address))) <= DataIn;
            end if; 
        end if;
    end process; 
    
    -- Proceso de LECTURA Asíncrona (más rápido)
    DataOut <= Memory(to_integer(unsigned(Address)));

end architecture Behavioral;