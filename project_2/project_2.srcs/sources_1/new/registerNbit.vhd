----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.03.2022 11:21:33
-- Design Name: 
-- Module Name: registerNbit - Behavioral
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

entity registerNbit is
    generic (
        C_WIDTH : integer := 16
    );
  Port ( 
    clk : in std_logic;
    D : in std_logic_vector(C_WIDTH - 1 downto 0);
    
    rst : in std_logic;
    en : in std_logic;
    shift : in std_logic;
    Sout : out std_logic;
    
    qff : out std_logic_vector(C_WIDTH - 1 downto 0)
  );
  end registerNbit;

architecture Behavioral of registerNbit is
    signal DFF : std_logic_vector(C_WIDTH - 1 downto 0);
begin
    FF: process(clk)
    begin 
        if rising_edge(clk) then
            if rst = '1' then
                DFF <= ('1', others => '0');
            end if;
            if en = '1' then
                if shift = '1' then
                    DFF <= '0' & D(D'high downto 1) ;
                else
                    DFF <= D;
                end if;
            end if;
        end if;
     end process;
    
    QFF <= DFF;
    Sout <= D(0);
    

end Behavioral;
