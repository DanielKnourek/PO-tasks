----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.02.2022 15:16:59
-- Design Name: 
-- Module Name: muxprocess - Behavioral
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

entity muxprocess is
    Port ( 
        a, b, c, d : in std_logic;
        sel : in std_logic_vector (1 downto 0);
        q : out std_logic
    );
end muxprocess;

architecture Behavioral of muxprocess is

begin

    process(sel, a, b, c, d)
        begin 
        case sel is
            when "00" => 
                q <= a;
            when "01" => 
                q <= b;
            when "10" => 
                q <= c;
            when others => 
                q <= d;
        end case;
    end process;

end Behavioral;
