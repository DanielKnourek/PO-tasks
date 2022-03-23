----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.02.2022 13:45:51
-- Design Name: 
-- Module Name: dec7seg - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dec7seg is
  Port ( 
    bcd : in std_logic_vector(3 downto 0);
    sseg : out std_logic_vector(6 downto 0);
    
    selectorINPUT : in std_logic_vector(3 downto 0);
    selectorLED : out std_logic_vector(7 downto 0)
  );
end dec7seg;

architecture Behavioral of dec7seg is
    signal segled : std_logic_vector(6 downto 0) := "0000000";
    signal selectled : std_logic_vector(7 downto 0) := "00000000";
--    singal selectledX : std_logic_vector(7 downto 0) := "00000000";
begin

---- gfedcba         BCD
with bcd select segled <= 
    "0000110" when "0001",    -- 1
    "1011011" when "0010",    -- 2
    "1001111" when "0011",    -- 3
    "1100110" when "0100",    -- 4
    "1101101" when "0101",    -- 5
    "1111100" when "0110",    -- 6
    "0000111" when "0111",    -- 7
    "1111111" when "1000",    -- 8
    "1100111" when "1001",    -- 9
    "0111111" when others;    -- 0
    
--selector <= inputLED;

with selectorINPUT select selectled <= 
    "00000001" when "0001",    -- 1
    "00000010" when "0010",    -- 2
    "00000011" when "0011",    -- 3
    "00000100" when "0100",    -- 4
    "00000101" when "0101",    -- 5
    "00000110" when "0110",    -- 6
    "00000111" when "0111",    -- 7
    "00001000" when "1000",    -- 8
    "00000000" when others;    -- 8
    
selectorLED <= selectled;
sseg <= not segled;

end Behavioral;
