LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY counter IS
    GENERIC (n : POSITIVE := 10);
    PORT (
        clk : IN std_logic;
        enable : IN std_logic;
        reset : IN std_logic; -- active low
        counter_output : OUT std_logic_vector(n - 1 DOWNTO 0));
END ENTITY;

ARCHITECTURE behavioural OF counter IS
    SIGNAL count : std_logic_vector(n - 1 DOWNTO 0);
BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF (reset = '0') THEN
            count <= (OTHERS => '0');
        ELSIF (clk'event AND clk = '1') THEN
            IF (enable = '1') THEN
                count <= count + 1;
            END IF;
        END IF;
    END PROCESS;
    counter_output <= count;
END ARCHITECTURE;
