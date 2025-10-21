library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Converti is
    Port ( 
        S          : in  std_logic_vector(11 downto 0);
        output_bcd : out std_logic_vector(15 downto 0)
    );
end Converti;

architecture Behavioral of Converti is
    signal Temp16 : std_logic_vector(15 downto 0) := (others => '0'); -- salida temporal
begin
    process(S)
        variable Temp : std_logic_vector(27 downto 0);
        variable i    : integer;
    begin
        -- Inicializar Temp
        Temp := (others => '0');
        Temp(11 downto 0) := S;

        -- Algoritmo Double Dabble (Shift-and-Add-3)
        for i in 0 to 11 loop
            -- Unidades
            if unsigned(Temp(15 downto 12)) > 4 then
                Temp(15 downto 12) := std_logic_vector(unsigned(Temp(15 downto 12)) + 3);
            end if;
            -- Decenas
            if unsigned(Temp(19 downto 16)) > 4 then
                Temp(19 downto 16) := std_logic_vector(unsigned(Temp(19 downto 16)) + 3);
            end if;
            -- Centenas
            if unsigned(Temp(23 downto 20)) > 4 then
                Temp(23 downto 20) := std_logic_vector(unsigned(Temp(23 downto 20)) + 3);
            end if;
            -- Miles
            if unsigned(Temp(27 downto 24)) > 4 then
                Temp(27 downto 24) := std_logic_vector(unsigned(Temp(27 downto 24)) + 3);
            end if;

            -- Shift izquierdo
            Temp(27 downto 1) := Temp(26 downto 0);
            Temp(0) := '0';
        end loop;

        -- Guardar los 16 bits de BCD en la salida
        Temp16 <= Temp(27 downto 12);
        output_bcd <= Temp16;
    end process;
end Behavioral;
