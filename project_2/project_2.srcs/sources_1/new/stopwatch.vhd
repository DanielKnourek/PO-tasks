----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.03.2022 11:19:00
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

entity stopwatch is
    Port(
        clk : in std_logic
    );
end stopwatch;

architecture Behavioral of stopwatch is
    constant en_stopwatch : std_logic := '1';

    constant C_WIDTH : integer := 4;
    constant C_MAX   : integer := 9;

    signal rst  : std_logic;
    signal enas : std_logic_vector(7 downto 0);

    type q_cnt_t is array (0 to 7) of unsigned(C_WIDTH - 1 downto 0);
    signal counters_q : q_cnt_t;

    signal max : STD_LOGIC;

begin

    cnt_ds : entity work.counterV2
        generic map(
            C_WIDTH      => 32,
            OVERFLOW_VAL => 10_000_000
        )
        port map(
            clk => clk,
            rst => rst,
            en  => en_stopwatch,
            max => max
        );

    digitCounters : for i in 0 to 7 generate
        cnt_i : entity work.counterV2
            generic map(
                C_WIDTH      => C_WIDTH,
                OVERFLOW_VAL => C_MAX
            )
            port map(
                clk => clk,
                rst => rst,
                en  => enas(i),
                max => max
            );
    end generate digitCounters;

end Behavioral;
