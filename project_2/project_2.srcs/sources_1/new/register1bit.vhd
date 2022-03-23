----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.03.2022 11:12:33
-- Design Name: 
-- Module Name: register1bit - Behavioral
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

entity register1bit is
  Port ( 
    D : in std_logic;
    clk : in std_logic;
    
    ql : out std_logic;
    qff : out std_logic
  );
end register1bit;

architecture Behavioral of register1bit is
    signal DFF : std_logic := '0';
    signal DL : std_logic := '0';
begin
    FF : process(clk)
    begin 
        if rising_edge(clk) then
            DFF <= D;
        end if;
     end process;
    Latch : process(clk, d)
    begin 
        if clk = '1' then
            DL <= D;
        end if;
     end process;
     
     ql <= DL;
     qff <= DFF;


end Behavioral;
