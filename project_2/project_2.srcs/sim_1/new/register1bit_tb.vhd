----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.03.2022 11:13:37
-- Design Name: 
-- Module Name: register1bit_tb - Behavioral
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

entity register1bit_tb is
--  Port ( );
end register1bit_tb;

architecture Behavioral of register1bit_tb is

    constant CLK_P : time := 10 ns;
    
    signal D : std_logic := '0';
    signal clk : std_logic := '0';
    
    signal ql : std_logic;
    signal qff : std_logic;
begin

    clk <= not clk after CLK_P/2;
    
    dut : entity work.register1bit
        Port map(
           clk  => clk,
           D  => D, 
           ql  => ql,
           qff => qff
        );
        
    tb: process
    begin
        wait for 5.1 ns;
        D <= not D;
    end process;

end Behavioral;
