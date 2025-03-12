library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity p2 is
    Port ( A    : in  STD_LOGIC_VECTOR(3 downto 0);
           B    : in  STD_LOGIC_VECTOR(3 downto 0);
           Cin  : in  STD_LOGIC;
           S    : out STD_LOGIC_VECTOR(3 downto 0);
           Cout : out STD_LOGIC;
           HEX0 : out STD_LOGIC_VECTOR(6 downto 0);  -- Display para S[0]
           HEX1 : out STD_LOGIC_VECTOR(6 downto 0);  -- Display para S[1]
           HEX2 : out STD_LOGIC_VECTOR(6 downto 0);  -- Display para S[2]
           HEX3 : out STD_LOGIC_VECTOR(6 downto 0)   -- Display para S[3]
         );
end p2;

architecture Behavioral of p2 is

    signal C : STD_LOGIC_VECTOR(4 downto 0);  -- Señales de acarreo
    signal S_internal : STD_LOGIC_VECTOR(3 downto 0); -- Señal interna para S

    -- Componente del sumador completo de 1 bit
    component SumadorCompleto1Bit is
        Port ( A    : in  STD_LOGIC;
               B    : in  STD_LOGIC;
               Cin  : in  STD_LOGIC;
               S    : out STD_LOGIC;
               Cout : out STD_LOGIC);
    end component;

    -- Función para conversión a 7 segmentos
    function conv_7seg(val : STD_LOGIC_VECTOR(3 downto 0)) return STD_LOGIC_VECTOR is
    begin
        case val is
            when "0000" => return "1000000"; -- 0
            when "0001" => return "1111001"; -- 1
            when "0010" => return "0100100"; -- 2
            when "0011" => return "0110000"; -- 3
            when "0100" => return "0011001"; -- 4
            when "0101" => return "0010010"; -- 5
            when "0110" => return "0000010"; -- 6
            when "0111" => return "1111000"; -- 7
            when "1000" => return "0000000"; -- 8
            when "1001" => return "0010000"; -- 9
            when others => return "1111111"; -- Apagado
        end case;
    end function;

begin
    -- Inicialización de las señales de acarreo
    C(0) <= Cin;

    -- Instanciación de los sumadores de 1 bit
    SUM0: SumadorCompleto1Bit port map (A(0), B(0), C(0), S_internal(0), C(1));
    SUM1: SumadorCompleto1Bit port map (A(1), B(1), C(1), S_internal(1), C(2));
    SUM2: SumadorCompleto1Bit port map (A(2), B(2), C(2), S_internal(2), C(3));
    SUM3: SumadorCompleto1Bit port map (A(3), B(3), C(3), S_internal(3), C(4));

    -- Asignación del acarreo de salida
    Cout <= C(4);

    -- Asignación de la señal interna a la salida S
    S <= S_internal;

    -- Conversión de las salidas S a las señales de los displays de 7 segmentos
    HEX0 <= conv_7seg("000" & S_internal(0));
    HEX1 <= conv_7seg("000" & S_internal(1));
    HEX2 <= conv_7seg("000" & S_internal(2));
    HEX3 <= conv_7seg("000" & S_internal(3));

end Behavioral;



