LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY trigger_generator IS
    PORT (
        clk : IN std_logic;
        trigg : OUT std_logic);
END ENTITY;
ARCHITECTURE behaviour OF trigger_generator IS
    COMPONENT counter IS
        GENERIC (n : POSITIVE := 10);
        PORT (
            clk : IN std_logic;
            enable : IN std_logic;
            reset : IN std_logic; -- active low
            counter_output : OUT std_logic_vector(n - 1 DOWNTO 0));
        15
    END COMPONENT;
    SIGNAL resetCounter : std_logic;
    SIGNAL outputCounter : std_logic_vector(23 DOWNTO 0);
BEGIN
    trigger_gen : counter GENERIC MAP(24)
    PORT MAP(clk, '1', resetCounter, outputCounter);
    PROCESS (clk)
        CONSTANT ms100 : std_logic_vector(23 DOWNTO
        0) := "010011000100101101000000";--20ns/100ms
        -- constant ms100And20us: std_logic_vector(23 downto
        0) := "010011000100111100100110";
        CONSTANT ms100And20us : std_logic_vector(23 DOWNTO
        0) := "010011000100110100110011";--20ns/(100ms+20us)
    BEGIN
        IF (outputCounter > ms100 AND outputCounter <
            ms100And20us) THEN
            trigg <= '1';
        ELSE
            trigg <= '0';
        END IF;
        IF (outputCounter = ms100and20us OR
            outputCounter = "XXXXXXXXXXXXXXXXXXXXXXXX") THEN
            resetCounter <= '0';
        ELSE
            resetCounter <= '1';
        END IF;
    END PROCESS;
END ARCHITECTURE;
