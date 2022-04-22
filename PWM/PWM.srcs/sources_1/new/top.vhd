library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

Library UNISIM;
use UNISIM.vcomponents.all;

Library xpm;
use xpm.vcomponents.all;

entity top is
    port(
        clk                          : in    std_logic; -- 100 MHz clock
        rstn                         : in    std_logic; -- Red CPU_RESETN (negative reset)
        btnl, btnr, btnu, btnd, btnc : in    std_logic; -- Cross buttons
        SW                           : in    std_logic_vector(15 downto 0); -- Switches
        LED                          : out   std_logic_vector(15 downto 0);
        -- controls cathodes (segments within 7seg display). Negative logic.
        -- sorted A, B, C, D, E, F, G
        display_segments             : out   std_logic_vector(6 downto 0);
        -- controls anodes (display). Negative logic.
        display_positions            : out   std_logic_vector(7 downto 0);
        -- there are two RGB LEDs that can be controlled via PWM
        LED_R, LED_G, LED_B          : out   std_logic_vector(1 downto 0);
        -- Mono audio out Jack+AMP. Open drain output. 0 for 0, Z for 1
        AUD_PWM                      : inout std_logic;
        -- AMP enable(make 1 to enable it)
        AUD_SD                       : out   std_logic
    );
end top;

architecture Behavioral of top is

    -- positive reset
    signal rst       : std_logic;
    -- this is audio PWM output, real audio PWM output, all other audio PWM outputs are just imitating 
    signal audio_pwm : std_logic;

    constant C_ROM_ADDR_WIDTH : integer := 17;
    constant C_ROM_DATA_WIDTH : integer := 8;
    signal rom_data           : std_logic_vector(C_ROM_DATA_WIDTH - 1 downto 0);
    signal rom_addr           : std_logic_vector(C_ROM_ADDR_WIDTH - 1 downto 0);
    signal rom_ena            : std_logic;

    constant C_PWM_WIDTH       : integer                                  := 8;
    constant C_PRESCALER_WIDTH : integer                                  := 8;
    constant prescaler         : unsigned(C_PRESCALER_WIDTH - 1 downto 0) := to_unsigned(7, C_PRESCALER_WIDTH);

    type pwm_values_t is array (5 downto 0) of unsigned(C_PWM_WIDTH - 1 downto 0);
    signal pwm_value  : pwm_values_t;
    signal LED_values : std_logic_vector(5 downto 0);

    signal LED_select : unsigned(2 downto 0);
    signal LED_update : std_logic;
    signal LED_value  : unsigned(C_PWM_WIDTH - 1 downto 0);

    type ram_t is array (15 downto 0) of std_logic_vector(7 downto 0);
    signal ram               : ram_t := (others => (others => '0'));
    signal addrrd, addrwr    : unsigned(3 downto 0);
    signal data_in, data_out : std_logic_vector(7 downto 0);
    signal we                : std_logic;

    constant num_samples    : integer := 71052;
    constant sample_freq_Hz : integer := 8000;

    signal ena_read : std_logic := '0';

begin
    clk_prescaler : entity work.counter
        generic map(
            C_WIDTH => 16,
            C_MAX   => 100000000 / sample_freq_Hz
        )
        port map(
            clk => clk,
            rst => rst,
            en  => btnu,
            q   => open,
            max => ena_read
        );

    addr_counter : entity work.counter
        generic map(
            C_WIDTH => C_ROM_ADDR_WIDTH,
            C_MAX   => num_samples
        )
        port map(
            clk                 => clk,
            rst                 => rst,
            en                  => ena_read,
            std_logic_vector(q) => rom_addr,
            max                 => open
        );

    AUDIO_ROM : xpm_memory_sprom
        generic map(
            ADDR_WIDTH_A      => C_ROM_ADDR_WIDTH, -- DECIMAL
            MEMORY_INIT_FILE  => "realsound.mem", -- String
            MEMORY_INIT_PARAM => "",    -- String
            MEMORY_PRIMITIVE  => "block", -- String
            MEMORY_SIZE       => 1048576, -- DECIMAL
            READ_DATA_WIDTH_A => C_ROM_DATA_WIDTH, -- DECIMAL
            USE_MEM_INIT      => 1      -- DECIMAL
        )
        port map(
            dbiterra       => open,     -- 1-bit output: Leave open.
            douta          => rom_data, -- READ_DATA_WIDTH_A-bit output: Data output for port A read operations.
            sbiterra       => open,     -- 1-bit output: Leave open.
            addra          => rom_addr, -- ADDR_WIDTH_A-bit input: Address for port A read operations.
            clka           => ena_read, -- 1-bit input: Clock signal for port A.
            ena            => '1',      -- 1-bit input: Memory enable signal for port A. Must be high on clock
            injectdbiterra => '0',      -- 1-bit input: Do not change from the provided value.
            injectsbiterra => '0',      -- 1-bit input: Do not change from the provided value.
            regcea         => '1',      -- 1-bit input: Do not change from the provided value.
            rsta           => rst,      -- 1-bit input: Reset signal for the final port A output register stage. 
            sleep          => '0'       -- 1-bit input: sleep signal to enable the dynamic power saving feature.
        );
    -- debug show rom data
    LED(7 downto 0) <= rom_data;

    pwm_inst : entity work.pwm
        generic map(
            C_PWM_WIDTH       => C_ROM_DATA_WIDTH,
            C_PRESCALER_WIDTH => 2
        )
        port map(
            clk       => clk,
            rst       => rst,
            pwm       => audio_pwm,
            prescaler => to_unsigned(2, 2),
            pwm_value => unsigned(rom_data)
        );

    ramWR : process(clk)
        variable ram : ram_t := (others => (others => '0'));
    begin
        if rising_edge(clk) then
            --            data_out <= ram(to_integer(addrrd));
            if we = '1' then
                ram(to_integer(addrwr)) := data_in;
            end if;
            data_out <= ram(to_integer(addrrd));
        end if;
    end process ramWR;

    -- DO NOT touch
    rst    <= not rstn;
    AUD_SD <= '1';
    PWM_TRISTATE_OUTPUT : OBUFT
        generic map(
            DRIVE      => 12,
            IOSTANDARD => "DEFAULT",
            SLEW       => "SLOW")
        port map(
            O => AUD_PWM,
            I => '0',
            T => audio_pwm
        );

        --            -- PWM RGB
        --    RGBLEDs_PWMs : for i in 0 to 5 generate
        --        pwm_inst : entity work.pwm
        --            generic map(
        --                C_PWM_WIDTH       => C_PWM_WIDTH,
        --                C_PRESCALER_WIDTH => C_PRESCALER_WIDTH
        --            )
        --            port map(
        --                clk       => clk,
        --                rst       => rst,
        --                pwm       => LED_values(i),
        --                prescaler => prescaler,
        --                pwm_value => pwm_value(i)
        --            );
        --
        --    end generate RGBLEDs_PWMs;
        --
        --    (LED_R(1), LED_R(0), LED_G(1), LED_G(0), LED_B(1), LED_B(0)) <= LED_values;
        --
        --    -- LED_select  LED_update LED_value 
        --    datainsert : process(clk)
        --    begin
        --        if rising_edge(clk) then
        --            if rst = '1' then
        --                pwm_value <= (others => (others => '0'));
        --            elsif LED_update = '1' then
        --                pwm_value(to_integer(LED_select)) <= LED_value;
        --            end if;
        --        end if;
        --    end process datainsert;
        --
        --    LED_select <= unsigned(SW(15 downto 15 - LED_select'length + 1));
        --    LED_value  <= unsigned(SW(LED_value'range));
        --    LED_update <= btnc;

end Behavioral;
