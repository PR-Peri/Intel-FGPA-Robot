LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY robot IS
    PORT (
        fpgaclk : IN std_logic;
        echo : IN std_logic_vector(2 DOWNTO 0);
        trigger : OUT std_logic_vector(2 DOWNTO 0);
        led : OUT std_logic_vector(2 DOWNTO 0);
        Motor_L_forward, Motor_R_forward, Motor_L_backward, Motor_R_backward : OUT std_logic);
END ENTITY;

ARCHITECTURE behaviour OF robot IS
    COMPONENT pwm IS
        --generic(N : integer:=7);
        PORT (
            CLOCK_50 : IN std_logic;
            duty : IN std_logic_vector(15 DOWNTO 0);
            pwm : OUT std_logic);
    END COMPONENT;

    COMPONENT three_ultrasonic IS
        PORT (
            fpgaclk : IN std_logic;
            pulse : IN std_logic_vector(2 DOWNTO 0);
            triggerOut : OUT std_logic_vector(2 DOWNTO 0);
            ultrasonic_out : OUT std_logic_vector(2 DOWNTO 0));
    END COMPONENT;

    SIGNAL ultrasonic : std_logic_vector(2 DOWNTO 0);
    SIGNAL pwm_1, pwm_2 : std_logic;
    SIGNAL forward, backward, turn_left, turn_right : std_logic;
    SIGNAL duty_1, duty_2 : std_logic_vector(15 DOWNTO 0);

BEGIN
    PWM1 : pwm PORT MAP(fpgaclk, duty_1, pwm_1); -- generate pwm for the motors
    PWM2 : pwm PORT MAP(fpgaclk, duty_2, pwm_2);

    -- motion control selection of the motor --
    PROCESS (forward, backward, turn_left, turn_right)
    BEGIN
        IF (forward = '1') THEN
            motor_R_forward <= pwm_1;
            motor_L_forward <= pwm_2;
            motor_L_backward <= '0';
            motor_R_backward <= '0';
        ELSIF (backward = '1') THEN
            motor_R_backward <= pwm_2;
            motor_L_backward <= pwm_1;
            motor_R_forward <= '0';
            motor_L_forward <= '0';
        ELSIF (turn_right = '1') THEN
            motor_L_forward <= pwm_2;
            motor_R_backward <= pwm_1;
            motor_R_forward <= '0';
            motor_L_backward <= '0';
        ELSIF (turn_left = '1') THEN
            motor_R_forward <= pwm_2;
            motor_L_backward <= pwm_1;
            motor_R_backward <= '0';
            motor_L_forward <= '0';
        END IF;
    END PROCESS;

    range_sensor : three_ultrasonic PORT MAP(fpgaclk, echo, trigger, ultrasonic);
    PROCESS (ultrasonic)
    BEGIN
        CASE (ultrasonic) IS
            WHEN "000" =>
                forward <= '1';
                backward <= '0';
                turn_right <= '0';
                turn_left <= '0';
                duty_1 <= X"00BE";
                duty_2 <= X"00C3";
            WHEN "001" =>
                forward <= '0';
                backward <= '0';
                turn_right <= '0';
                turn_left <= '1';
                duty_1 <= X"00C3";
                duty_2 <= X"00C3";
            WHEN "010" =>
                backward <= '1';
                forward <= '0';
                turn_right <= '0';
                turn_left <= '0';
                duty_1 <= X"0041";
                duty_2 <= X"00C3";
            WHEN "011" =>
                turn_left <= '0';
                backward <= '1';
                forward <= '0';
                turn_right <= '0';
                duty_1 <= X"00C3";
                duty_2 <= X"0041";
            WHEN "100" =>
                forward <= '0';
                backward <= '0';
                turn_right <= '1';
                turn_left <= '0';
                duty_1 <= X"00C3";
                duty_2 <= X"00C3";
            WHEN "101" =>
                forward <= '1';
                backward <= '0';
                turn_right <= '0';
                turn_left <= '0';
                duty_1 <= X"00BE";
                duty_2 <= X"00C3";
            WHEN "110" =>
                turn_right <= '0';
                turn_left <= '0';
                backward <= '1';
                forward <= '0';
                duty_1 <= X"0041";
                duty_2 <= X"00C3";
            WHEN "110" =>
                turn_right <= '1';
                turn_left <= '0';
                backward <= '1';
                forward <= '0';
                duty_1 <= X"00C3";
                duty_2 <= X"00C3";
            WHEN "111" =>
                backward <= '1';
                forward <= '0';
                turn_right <= '0';
                turn_left <= '0';
                duty_1 <= X"00C3";
                duty_2 <= X"0041";
        END CASE;
    END PROCESS;

    led(2) <= NOT(ultrasonic(2));
    led(1) <= NOT(ultrasonic(1));
    led(0) <= NOT(ultrasonic(0));

END ARCHITECTURE;
