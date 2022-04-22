----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.04.2022 10:54:04
-- Design Name: 
-- Module Name: pwm - Behavioral
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

entity pwm is
    Generic(
        C_PWM_WIDTH       : integer := 8;
        C_PRESCALER_WIDTH : integer := 16
    );
    Port(
        clk       : in  std_logic;
        rst       : in  std_logic;
        pwm       : out std_logic;
        prescaler : in  unsigned(C_PRESCALER_WIDTH - 1 downto 0);
        pwm_value : in  unsigned(C_PWM_WIDTH - 1 downto 0)
    );
end pwm;

architecture Behavioral of pwm is

    signal pwm_en : std_logic;

begin

    process(clk)
        variable prescaler_cnt : unsigned(prescaler'range) := (others => '0');
    begin
        if rising_edge(clk) then
            pwm_en <= '0';
            if rst = '1' then
                prescaler_cnt := (others => '0');
            else
                prescaler_cnt := prescaler_cnt + 1;
                if prescaler_cnt > prescaler then
                    prescaler_cnt := (others => '0');
                    pwm_en        <= '1';
                end if;
            end if;
        end if;
    end process;

    process(clk)
        variable pwm_cnt : unsigned(pwm_value'range) := (others => '0');
    begin
        if rising_edge(clk) then
            if rst = '1' then
                pwm_cnt := (others => '0');
            else
                if pwm_value = 0 then
                    pwm <= '0';
                elsif pwm_value >= pwm_cnt then
                    pwm <= '1';
                else
                    pwm <= '0';
                end if;
                if pwm_en = '1' then
                    pwm_cnt := pwm_cnt + 1;
                end if;
            end if;
        end if;
    end process;

end Behavioral;
