----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.03.2022 13:45:15
-- Design Name: 
-- Module Name: stopwatch - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use work.types.all;

entity stopwatch is
    Port(
        CLK100MHZ         : in  std_logic;
        out_7seg    : out std_logic_vector(6 downto 0);
        out_seg_sel : out std_logic_vector(7 downto 0)
    );
end stopwatch;

architecture Behavioral of stopwatch is
    constant EN_STOPWATCH : std_logic := '1';
    constant DIGITS       : integer   := 8;

    signal rst        : std_logic := '0';
    signal is_max_cnt : std_logic_vector(DIGITS - 1 + 1 downto 0);

    signal counters_q : q_cnt_t;

    constant DL_WIDTH : integer := 3 + 10;
    signal dl_cnt     : std_logic_vector(DL_WIDTH - 1 downto 0);

    constant SEL_SIZE    : integer := 3;
    signal current_sel   : std_logic_vector(SEL_SIZE - 1 downto 0);
    signal current_digit : q_cnt;

    constant CLK_P : time      := 10 ns;
    signal clk     : std_logic := '0';
begin
--    clk <= not clk after CLK_P / 2;
    clk <= CLK100MHZ;
    cnt_ds : entity work.counter
        generic map(
            C_WIDTH => 32,
            C_MAX   => 10_000
        )
        port map(
            clk    => clk,
            rst    => rst,
            en     => EN_STOPWATCH,
            q      => open,
            is_max => is_max_cnt(0)
        );

    cnt_digits : for i in 0 to DIGITS - 1 generate
        cnt_i : entity work.counter
            generic map(
                C_WIDTH => C_WIDTH,
                C_MAX   => C_MAX
            )
            port map(
                clk         => clk,
                rst         => rst,
                en          => and(is_max_cnt(i downto 0)),
                unsigned(q) => counters_q(i),
                is_max      => is_max_cnt(i + 1)
            );
    end generate cnt_digits;

    digit_looper : entity work.counter
        generic map(
            C_WIDTH => DL_WIDTH,
            C_MAX   => -1
        )
        port map(
            clk    => clk,
            rst    => rst,
            en     => EN_STOPWATCH,
            q      => dl_cnt,
            is_max => open
        );

    current_sel <= dl_cnt((DL_WIDTH - 1) downto (DL_WIDTH - 1) - 2);

    mux_digits : entity work.mux
        generic map(
            SEL_SIZE => SEL_SIZE
        )
        port map(
            v_i => counters_q,
            sel => current_sel,
            q   => current_digit
        );

    digit_seg : entity work.dec7seg
        port map(
            bcd  => std_logic_vector(current_digit),
            sseg => out_7seg
        );

    sel_seg : entity work.dec1_n
        port map(
            bcd     => std_logic_vector(current_sel),
            sel_seg => out_seg_sel
        );

        --    out_seg_sel <= (
        --        to_integer(unsigned(current_sel)) => '1',
        --        others                            => '0'
        --    );
end Behavioral;
