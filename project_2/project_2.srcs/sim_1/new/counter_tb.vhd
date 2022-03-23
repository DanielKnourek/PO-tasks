----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.03.2022 00:36:35
-- Design Name: 
-- Module Name: counter_tb - Behavioral
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

entity counter_tb is
    generic(
        C_WIDTH : integer := 4
    );
--  Port ( );
end counter_tb;

architecture Behavioral of counter_tb is

    constant CLK_P : time := 10 ns;
    
    signal clk : std_logic := '0';
    signal en : std_logic := '1';
    signal rst : std_logic := '0';
    
    signal cnt1 : std_logic_vector(C_WIDTH - 1 downto 0);
    signal overflow1 : std_logic;
    signal cnt2 : std_logic_vector(C_WIDTH - 1 downto 0);
    signal overflow2 : std_logic;
begin

    clk <= not clk after CLK_P/2;
    
    counter_bits1_4 : entity work.counter
    generic map(
            C_WIDTH => C_WIDTH
        )
    Port map(
        clk  => clk,
        en  => en, 
        rst => rst,
        Q => cnt1,
        overflow => overflow1
     );
     
    counter_bits5_8 : entity work.counter
    generic map(
            C_WIDTH => C_WIDTH
        )
    Port map(
        clk  => overflow1,
        en  => en, 
        rst => rst,
        Q => cnt2,
        overflow => overflow2
     );

end Behavioral;
