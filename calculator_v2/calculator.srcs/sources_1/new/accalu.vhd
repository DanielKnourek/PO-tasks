----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.03.2022 11:29:06
-- Design Name: 
-- Module Name: accalu - Behavioral
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

entity accalu is
generic(
    C_WIDTH: integer := 8
);
  Port ( 
    clk: in std_logic;
    rst: in std_logic;
    opcode: in std_logic_vector(3 downto 0);
    data: in std_logic_vector(C_WIDTH - 1 downto 0);
    acc : out std_logic_vector(C_WIDTH  - 1 downto 0);
    sign: out std_logic;
    flag_of : out std_logic;
    flag_carry : out std_logic;
    ena : in std_logic
  );
end accalu;

architecture Behavioral of accalu is

signal accumulator : unsigned(15 downto 0) := (others => '0');
signal unsigned_data : unsigned(7 downto 0) := (others => '0');

begin

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                flag_of <= '0';
                flag_carry <= '0';
                sign <= '0';
                acc <= (others => '0');
            elsif ena = '1' then
                unsigned_data <= unsigned(data);
                case opcode is 
                    when X"0" => 
                        accumulator <= accumulator + unsigned_data;
                    when X"1" => 
                        accumulator <= accumulator - unsigned_data;
                    when X"2" =>
                        accumulator <= accumulator(7 downto 0) * unsigned_data;
                    when X"3" =>
                        accumulator <= accumulator / unsigned_data;
                    when X"4" =>
                        accumulator <= shift_left(accumulator, 1);
                    when X"5" =>
                        accumulator <= shift_right(accumulator, 1);
                    when X"6" =>
                        accumulator <= rotate_left(accumulator, 1);
                    when X"7" =>
                        accumulator <= rotate_right(accumulator, 1);
                    when X"8" =>
                        accumulator <= (others => '0');
                    when X"9" =>
                        accumulator(7 downto 0) <= unsigned_data;                                        
                    when others =>
                         null;               
                end case;
                acc <= std_logic_vector(accumulator(7 downto 0));                    
            end if;
        end if;
    end process;
end Behavioral;
