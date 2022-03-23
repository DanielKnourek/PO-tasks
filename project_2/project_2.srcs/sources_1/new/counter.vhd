----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.03.2022 12:05:08
-- Design Name: 
-- Module Name: counter - Behavioral
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
    generic (
        C_WIDTH : integer := 4
    );
    Port (
        clk : in std_logic;
        rst : in std_logic;
        en : in std_logic;

        Q : out std_logic_vector(C_WIDTH - 1 downto 0);
        overflow : out std_logic
    );
end counter;

architecture Behavioral of counter is
    signal cnt : unsigned(Q'range) := to_unsigned(0, C_WIDTH);
    signal overflow_internal : std_logic := '0';

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                cnt <= (others => '0');
            elsif en = '1' then
                cnt <= cnt + 1;
                if cnt + 1 > cnt then
                    overflow_internal <= '0';
                else
                    overflow_internal <= '1';
                end if;
            end if;
        end if;
    end process;

    overflow <= overflow_internal;
    Q <= std_logic_vector(cnt);

end Behavioral;
