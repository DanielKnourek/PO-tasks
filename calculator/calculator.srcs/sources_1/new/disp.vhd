----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.03.2022 11:01:54
-- Design Name: 
-- Module Name: disp - Behavioral
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

entity disp is
    generic(
        C_WIDTH : integer := 8
    );
    Port(
        clk  : in  std_logic;
        rst  : in  std_logic;
        data : in  std_logic_vector(C_WIDTH * 4 - 1 downto 0);
        CA   : out std_logic_vector(7 downto 0);
        AN   : out std_logic_vector(7 downto 0)
    );
end disp;

architecture Behavioral of disp is
    constant EN_DISP : std_logic := '1';

    --    signal counters_q : q_cnt_t;

    constant DL_WIDTH : integer := 3 + 10;
    signal dl_cnt     : std_logic_vector(DL_WIDTH - 1 downto 0);

    constant SEL_SIZE    : integer := 3;
    signal current_sel   : std_logic_vector(SEL_SIZE - 1 downto 0);
    signal current_digit : q_cnt;
begin

    digit_looper : entity work.counter
        generic map(
            C_WIDTH => DL_WIDTH,
            C_MAX   => -1
        )
        port map(
            clk    => clk,
            rst    => rst,
            en     => EN_DISP,
            q      => dl_cnt,
            is_max => open
        );

    current_sel <= dl_cnt((DL_WIDTH - 1) downto (DL_WIDTH - 1) - 2);

    mux_digits : entity work.mux
        generic map(
            SEL_SIZE => SEL_SIZE
        )
        port map(
            v_i => to_q_cnt_t(data),
            sel => current_sel,
            q   => current_digit
        );

    digit_seg : entity work.dec7seg
        port map(
            bcd  => std_logic_vector(current_digit),
            sseg => CA(CA'high - 1 downto 0)
        );

    sel_seg : entity work.dec1_n
        port map(
            bcd     => std_logic_vector(current_sel),
            sel_seg => AN
        );

end Behavioral;
