LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY three_ultrasonic IS
    PORT (
        fpgaclk : IN std_logic;
        pulse : IN std_logic_vector(2 DOWNTO 0);
        triggerOut : OUT std_logic_vector(2 DOWNTO 0);
        ultrasonic_out : OUT std_logic_vector(2 DOWNTO 0));
END ENTITY;
ARCHITECTURE behaviour OF three_ultrasonic IS
    COMPONENT ultrasonic IS
        PORT (
            fpgaclk : IN std_logic;
            pulse : IN std_logic; -- echo
            triggerOut : OUT std_logic; -- trigger out
            obstacle : OUT std_logic);
    END COMPONENT;
BEGIN
    ultrasonic_Left : ultrasonic PORT MAP(fpgaclk, pulse(0), triggerOut(0), ultrasonic_out(0));
    ultrasonic_Middle : ultrasonic PORT MAP(fpgaclk, pulse(1), triggerOut(1), ultrasonic_out(1));
    ultrasonic_Right : ultrasonic PORT MAP(fpgaclk, pulse(2), triggerOut(2), ultrasonic_out(2));
END ARCHITECTURE;
