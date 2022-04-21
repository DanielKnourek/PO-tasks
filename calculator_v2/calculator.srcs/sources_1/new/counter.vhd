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

entity counter is
    generic(
        C_WIDTH : integer := 4;
        C_MAX   : integer := 9
    );
    Port(
        clk    : in  std_logic;
        rst    : in  std_logic;
        en     : in  std_logic;
        q      : out unsigned(C_WIDTH - 1 downto 0);
        max : out std_logic
    );
end counter;

architecture Behavioral of counter is
    signal cnt : unsigned(C_WIDTH - 1 downto 0) := to_unsigned(0, C_WIDTH);
begin

    counter : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                cnt <= (others => '0');
            elsif en = '1' then
                if cnt >= to_unsigned(C_MAX, cnt'length) then
                    cnt <= (others => '0');
                else
                    cnt <= cnt + 1;
                end if;
            end if;
        end if;
    end process;

    max <= '1' when cnt >= to_unsigned(C_MAX, cnt'length) else '0';
    q      <=   cnt;

end Behavioral;