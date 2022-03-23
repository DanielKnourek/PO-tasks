----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.03.2022 04:12:09
-- Design Name: 
-- Module Name: dec1_n - Behavioral
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

entity dec1_n is
    Port(
        bcd     : in  std_logic_vector(2 downto 0);
        sel_seg : out std_logic_vector(7 downto 0)
    );
end dec1_n;

architecture Behavioral of dec1_n is
    signal segled : std_logic_vector(7 downto 0) := "00000000";
begin
    process(bcd)
    begin
        case bcd is
            when "001" =>
                segled <= "00000010";
            when "010" =>
                segled <= "00000100";
            when "011" =>
                segled <= "00001000";
            when "100" =>
                segled <= "00010000";
            when "101" =>
                segled <= "00100000";
            when "110" =>
                segled <= "01000000";
            when "111" =>
                segled <= "10000000";
            when others =>
                segled <= "00000001";
        end case;
    end process;

    sel_seg <= not segled;

end Behavioral;
