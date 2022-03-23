----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.03.2022 18:48:24
-- Design Name: 
-- Module Name: stopwatch_tb - Behavioral
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

entity stopwatch_tb is
    generic(
        C_WIDTH : integer := 4
    );
    --  Port ( );
end stopwatch_tb;

architecture Behavioral of stopwatch_tb is
    constant CLK_P : time := 10 ns;

    signal clk : std_logic := '0';
begin
    clk <= not clk after CLK_P / 2;

    stopwatch_inst : entity work.stopwatch
        port map(
            clk => clk
        );

end Behavioral;
