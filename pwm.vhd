LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY pwm IS
    PORT (
        CLOCK_50 : IN std_logic;
        duty : IN std_logic_vector(15 DOWNTO 0);
        pwm : OUT std_logic);
END pwm;

ARCHITECTURE behaviour OF pwm IS

    COMPONENT clkdiv IS
        PORT (
            clock_50 : IN std_logic;
            clr : IN std_logic;
            clock_q : OUT std_logic);
    END COMPONENT;

    SIGNAL count : std_logic_vector(15 DOWNTO 0);
    SIGNAL clk, pwm_sig : std_logic;
    SIGNAL period : std_logic_vector(15 DOWNTO 0);
    SIGNAL clr : std_logic;

BEGIN
    period <= X"00C3"; --
    clr <= '0';

    PROCESS (clk, clr)
    BEGIN
        IF (clr = '1') THEN
            count <= X"0000";
        ELSIF (clk'event AND clk = '1') THEN
            IF (count = period - 1) THEN
                count <= X"0000";
            ELSE
                count <= count + 1;
            END IF;
        END IF;
    END PROCESS;

    PROCESS (count)
    BEGIN
        IF (count < duty) THEN
            pwm_sig <= '1';
        ELSIF (count > duty) THEN
            pwm_sig <= '0';
        END IF;
    END PROCESS;

    pwm <= pwm_sig;
    CLOCK : clkdiv PORT MAP(clock_50, '0', clk); -- divide 50Mhz clock to clk_q6

END ARCHITECTURE;
