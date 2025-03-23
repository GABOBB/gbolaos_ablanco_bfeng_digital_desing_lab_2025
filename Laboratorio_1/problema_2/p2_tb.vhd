library IEEE;
use IEEE.STD_LOGIC_1164.ALL;  -- Librería para STD_LOGIC
use IEEE.NUMERIC_STD.ALL;

entity p2_tb is
end p2_tb;

architecture Behavioral of p2_tb is

    -- Declarar señales de entrada y salida
    signal A    : STD_LOGIC_VECTOR(3 downto 0);  -- Entradas A
    signal B    : STD_LOGIC_VECTOR(3 downto 0);  -- Entradas B
    signal Cin  : STD_LOGIC;                      -- Entrada de acarreo
    signal S    : STD_LOGIC_VECTOR(3 downto 0);  -- Salida S
    signal Cout : STD_LOGIC;                      -- Salida de acarreo
    
    -- Instanciación del DUT
    component p2 is
        Port ( A    : in  STD_LOGIC_VECTOR(3 downto 0);
               B    : in  STD_LOGIC_VECTOR(3 downto 0);
               Cin  : in  STD_LOGIC;
               S    : out STD_LOGIC_VECTOR(3 downto 0);
               Cout : out STD_LOGIC);
    end component;

begin
    -- Instanciación del módulo bajo prueba
    UUT: p2
        Port map (
            A => A,
            B => B,
            Cin => Cin,
            S => S,
            Cout => Cout
        );

    -- Proceso para generar las señales de prueba
    stimulus_process: process
    begin
        -- Prueba 1: 0110 + 1001, Cin = 1
        A <= "0110"; B <= "1001"; Cin <= '0';
        wait for 10 ns;  -- Esperar 40 ns

        -- Prueba 2: 0011 + 0101, Cin = 0
        A <= "0011"; B <= "0101"; Cin <= '0';
        wait for 10 ns;  -- Esperar 40 ns

        -- Prueba 3: 0111 + 1000, Cin = 0
        A <= "0111"; B <= "1000"; Cin <= '0';
        wait for 10 ns;  -- Esperar 40 ns

        -- Prueba 4: 1111 + 0001, Cin = 0
        A <= "1111"; B <= "0001"; Cin <= '0';
        wait for 10 ns;  -- Esperar 40 ns
		  
        -- Terminar la simulación
        wait;
    end process;

end Behavioral;



