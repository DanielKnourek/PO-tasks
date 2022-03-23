----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.03.2022 10:48:39
-- Design Name: 
-- Module Name: counterV2 - Behavioral
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

entity counterV2 is
    generic (
        C_WIDTH : integer := 4;
        OVERFLOW_VAL : integer := 9
    );
    Port (
        clk : in std_logic;
        rst : in std_logic;
        en : in std_logic;

        max : out std_logic
    );
end counterV2;

architecture Behavioral of counterV2 is
    signal cnt : unsigned(C_WIDTH -1 downto 0) := to_unsigned(0, C_WIDTH);
    signal overflow_internal : std_logic := '0';
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                cnt <= (others => '0');
            elsif en = '1' then
                cnt <= cnt + 1;
                if cnt + 1 >= to_unsigned(OVERFLOW_VAL, cnt'length) then
                    overflow_internal <= '0';
                else
                    overflow_internal <= '1';
                end if;
            end if;
        end if;
    end process;

    max <= overflow_internal;


end Behavioral;
