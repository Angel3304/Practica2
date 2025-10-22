library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all; 
use ieee.numeric_std.all;

entity Banco_Registros is 
    Port ( 
        clk : in STD_LOGIC;
        WriteEnable : in STD_LOGIC;
        Address : in STD_LOGIC_VECTOR(2 downto 0);
        DataIn : in STD_LOGIC_VECTOR(9 downto 0);
        DataOut : out STD_LOGIC_VECTOR(9 downto 0)
    ); 
end entity; 
 
architecture Behavioral of Banco_Registros is 
    type RAM_Array is array (0 to 7) of STD_LOGIC_VECTOR(9 downto 0);
    
    -- ⭐ VERIFICAR: Inicialización de la RAM en ceros
    signal Memory : RAM_Array := (others => (others => '0'));
 
begin 
 
    -- Proceso de ESCRITURA Síncrona
    process (clk) 
    begin 
        if rising_edge(clk) then
            if WriteEnable = '1' then 
                Memory(to_integer(unsigned(Address))) <= DataIn;
            end if; 
        end if;
    end process; 
    
    -- ⭐ CRÍTICO: Lectura Asíncrona (sin proceso)
    -- Esto garantiza que DataOut se actualice inmediatamente cuando cambia Address
    DataOut <= Memory(to_integer(unsigned(Address)));

end architecture Behavioral;