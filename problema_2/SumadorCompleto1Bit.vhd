library IEEE;
use IEEE.STD_LOGIC_1164.ALL;  -- Declarar la librería para STD_LOGIC
use IEEE.NUMERIC_STD.ALL;

entity SumadorCompleto1Bit is
    Port ( A    : in  STD_LOGIC;
           B    : in  STD_LOGIC;
           Cin  : in  STD_LOGIC;
           S    : out STD_LOGIC;
           Cout : out STD_LOGIC);
end SumadorCompleto1Bit;

architecture Behavioral of SumadorCompleto1Bit is
begin
    -- Implementación de la lógica del sumador de 1 bit
    S <= A XOR B XOR Cin;  -- Suma
    Cout <= (A AND B) OR (Cin AND (A XOR B));  -- Acarreo
end Behavioral;
