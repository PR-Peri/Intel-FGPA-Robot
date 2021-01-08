LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std;

ENTITY ultrasonic IS
    PORT (
        fpgaclk : IN std_logic;
        pulse : IN std_logic; -- echo
        triggerOut : OUT std_logic; -- trigger out
        obstacle : OUT std_logic);
END ENTITY;

ARCHITECTURE behaviour OF ultrasonic IS
    COMPONENT counter IS
        GENERIC (n : POSITIVE := 10);
        PORT (
            clk : IN std_logic;
            enable : IN std_logic;
            reset : IN std_logic; -- active low
            counter_output : OUT std_logic_vector(n - 1 DOWNTO 0));
    END COMPONENT;

    COMPONENT trigger_generator IS
        PORT (
            clk : IN std_logic;
            trigg : OUT std_logic);
    END COMPONENT;

    SIGNAL pulse_width : std_logic_vector(21 DOWNTO 0);
    SIGNAL trigg : std_logic;

BEGIN
    counter_echo_pulse :
    counter GENERIC MAP(22) PORT MAP(fpgaclk, pulse, NOT(trigg), pulse_width);
    trigger_generation :
    trigger_generator PORT MAP(fpgaclk, trigg);

    obstacle_detection : PROCESS (pulse_width)
    BEGIN
        IF (pulse_width < 55000) THEN
            obstacle <= '1';
        ELSE
            obstacle <= '0';
        END IF;
    END PROCESS;

    triggerOut <= trigg;

END ARCHITECTURE;
