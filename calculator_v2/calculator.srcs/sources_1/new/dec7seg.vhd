----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.03.2022 03:54:27
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
    Port(
        bcd  : in  std_logic_vector(3 downto 0);
        sseg : out std_logic_vector(6 downto 0)
    );
end dec7seg;

architecture Behavioral of dec7seg is
    signal segled : std_logic_vector(6 downto 0) := "0000000";
begin
    process(bcd)
    begin
        case bcd is
            when "0001" =>
                segled <= "0000110";
            when "0010" =>
                segled <= "1011011";
            when "0011" =>
                segled <= "1001111";
            when "0100" =>
                segled <= "1100110";
            when "0101" =>
                segled <= "1101101";
            when "0110" =>
                segled <= "1111100";
            when "0111" =>
                segled <= "0000111";
            when "1000" =>
                segled <= "1111111";
            when "1001" =>
                segled <= "1100111";
            when others =>
                segled <= "0111111";
        end case;
    end process;

    sseg <= not segled;

end Behavioral;