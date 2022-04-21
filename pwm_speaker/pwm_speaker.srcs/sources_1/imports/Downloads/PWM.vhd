library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PWM is
    generic(
        C_PWM_WIDTH       : integer := 8;
        C_PRESCALER_WIDTH : integer := 32
    );
    port(
        clk       : in  std_logic;
        rst       : in  std_logic;
        pwm       : out std_logic;
        prescaler : in  unsigned(C_PRESCALER_WIDTH - 1 downto 0);
        pwm_value : in  unsigned(C_PWM_WIDTH - 1 downto 0)
    );
end entity PWM;

architecture RTL of PWM is

    signal prescaler_cnt : unsigned(prescaler'range);
    signal pwm_cnt       : unsigned(pwm_value'range);

    signal ena : std_logic;

begin

    prescaler_counter : entity work.counter
        generic map(
            C_WIDTH => C_PRESCALER_WIDTH,
            C_MAX   => C_PRESCALER_WIDTH
        )
        port map(
            clk         => clk,
            rst         => rst,
            en          => '1',
            unsigned(q) => prescaler_cnt,
            is_max      => open
        );

    ena <= '1' when prescaler_cnt >= prescaler else '0';

    pwm_counter : entity work.counter
        generic map(
            C_WIDTH => C_PWM_WIDTH,
            C_MAX   => C_PWM_WIDTH
        )
        port map(
            clk         => clk,
            rst         => rst,
            en          => ena,
            unsigned(q) => pwm_cnt,
            is_max      => open
        );

    pwm <= '1' when pwm_cnt >= pwm_value else '0';

    -- create prescaler_cnt counter in process
    -- value limited cyclic counter
    -- generates enable pulse when reaches prescaler value, resets to 0

    -- create pwm counter in process
    -- cyclic counter
    -- compare its value with pwm_value -> pwm 0/1
    -- watch out for 0/max limits (no peaks, full filling) 

end architecture RTL;
