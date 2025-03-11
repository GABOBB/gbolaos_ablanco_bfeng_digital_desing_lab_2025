library IEEE;
use IEEE.STD_LOGIC_1164.ALL;  -- Declarar la librería para STD_LOGIC y STD_LOGIC_VECTOR
use IEEE.NUMERIC_STD.ALL;

entity p2 is
    Port ( A    : in  STD_LOGIC_VECTOR(3 downto 0);  -- Declarar A como STD_LOGIC_VECTOR
           B    : in  STD_LOGIC_VECTOR(3 downto 0);  -- Declarar B como STD_LOGIC_VECTOR
           Cin  : in  STD_LOGIC;                     -- Declarar Cin como STD_LOGIC
           S    : out STD_LOGIC_VECTOR(3 downto 0);  -- Declarar S como STD_LOGIC_VECTOR
           Cout : out STD_LOGIC);                    -- Declarar Cout como STD_LOGIC
end p2;

architecture Behavioral of p2 is
    -- Declarar señal C para los acarreos
    signal C : STD_LOGIC_VECTOR(4 downto 0);  -- Declarar C como STD_LOGIC_VECTOR
begin
    -- Inicialización del primer acarreo
    C(0) <= Cin;

    -- Instanciación de los sumadores de 1 bit
    Sumador0 : entity work.SumadorCompleto1Bit
        port map (
            A    => A(0),
            B    => B(0),
            Cin  => C(0),
            S    => S(0),
            Cout => C(1)
        );

    Sumador1 : entity work.SumadorCompleto1Bit
        port map (
            A    => A(1),
            B    => B(1),
            Cin  => C(1),
            S    => S(1),
            Cout => C(2)
        );

    Sumador2 : entity work.SumadorCompleto1Bit
        port map (
            A    => A(2),
            B    => B(2),
            Cin  => C(2),
            S    => S(2),
            Cout => C(3)
        );

    Sumador3 : entity work.SumadorCompleto1Bit
        port map (
            A    => A(3),
            B    => B(3),
            Cin  => C(3),
            S    => S(3),
            Cout => C(4)
        );

    -- El acarreo de salida
    Cout <= C(4);
end Behavioral;

