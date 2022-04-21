----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.03.2022 11:03:59
-- Design Name: 
-- Module Name: disp - Behavioral
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

entity disp is
    Port(
        clk  : in  std_logic;
        rst  : in  std_logic;
        CA   : out std_logic_vector(7 downto 0);
        AN   : out std_logic_vector(7 downto 0);
        data : in  std_logic_vector(8 * 4 - 1 downto 0)
    );
end disp;

architecture Behavioral of disp is

    constant C_WIDTH_SELCNT : integer := 14;
    signal sel_cnt          : unsigned(C_WIDTH_SELCNT - 1 downto 0);
begin

    sel_counter : entity work.counter
        generic map(
            C_WIDTH => C_WIDTH_SELCNT,
            C_MAX   => -1
        )
        port map(
            clk => clk,
            rst => rst,
            en  => '1',
            q   => sel_cnt,
            max => open
        );

    dec1of8 : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                AN <= (others => '1');
            else
                AN                                                            <= (others => '0');
                AN(to_integer(sel_cnt(sel_cnt'high downto sel_cnt'high - 2))) <= '0';
            end if;
        end if;
    end process;

    dec7seg : process(clk)
        variable idx : integer := 0;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                CA <= (others => '0');
            else
                idx := (to_integer(sel_cnt(sel_cnt'high downto sel_cnt'high - 2)) + 1) * 4 - 1;
            end if;
        end if;
        case data(idx downto idx - 3) is
            when "0001" =>
                CA <= "00000110";
            when "0010" =>
                CA <= "01011011";
            when "0011" =>
                CA <= "01001111";
            when "0100" =>
                CA <= "01100110";
            when "0101" =>
                CA <= "01101101";
            when "0110" =>
                CA <= "01111100";
            when "0111" =>
                CA <= "00000111";
            when "1000" =>
                CA <= "01111111";
            when "1001" =>
                CA <= "01100111";
            when others =>
                CA <= "00111111";
        end case;
    end process;

end Behavioral;
