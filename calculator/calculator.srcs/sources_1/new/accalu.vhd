----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.03.2022 11:01:54
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

entity accalu is
    generic(
        C_WIDTH : integer := 8
    );
    Port(
        clk       : in  std_logic;
        rst       : in  std_logic;
        ena       : in  std_logic;
        opcode    : in  std_logic_vector(3 downto 0);
        data      : in  std_logic_vector(C_WIDTH - 1 downto 0);
        data_sign : in  std_logic;
        acc       : out std_logic_vector(C_WIDTH - 1 downto 0);
        acc_sign  : out std_logic;
        flag_of   : out std_logic;
        flag_cr   : out std_logic
    );
end accalu;

architecture Behavioral of accalu is
    signal accumulator : signed(C_WIDTH * 2 - 1 downto 0);
begin
    process(clk)
        variable data_signed : signed(accumulator'range);
    begin
        if rising_edge(clk) then
            if rst = '1' then
                accumulator <= (others => '0');
            else
                if ena = '1' then
                    if data_sign = '0' then
                        data_signed := resize(signed(data), accumulator'length);
                    else
                        data_signed := resize(-1 * signed(data), accumulator'length);
                    end if;
                    case opcode is
                        when X"1" =>    -- + add
                            accumulator <= accumulator + data_signed;
                        when X"2" =>    -- - subb
                            accumulator <= accumulator - data_signed;
                        when X"3" =>    -- * mult
                            accumulator <= accumulator - data_signed;
                        when X"4" =>    -- / div
                            accumulator <= accumulator - data_signed;
                        when X"5" =>    -- shr
                            accumulator <= shift_right(accumulator, 1);
                        when X"6" =>    -- shl
                            accumulator <= shift_left(accumulator, 1);
                        when X"7" =>    -- ror
                            accumulator <= rotate_right(accumulator, 1);
                        when X"8" =>    -- rol
                            accumulator <= rotate_left(accumulator, 1);
                        when others =>
                            accumulator <= accumulator;
                    end case;
                end if;
            end if;
        end if;
    end process;

    acc <= std_logic_vector(accumulator(accumulator'low + C_WIDTH - 1 downto accumulator'low));
    --    flag_of <= '0' when (0 >= unsigned(abs (accumulator))(accumulator'high downto accumulator'low + C_WIDTH)) else
    --               '1';

    --    flag_of  <= '0' when (0 >= unsigned(std_logic_vector(accumulator(accumulator'high downto accumulator'low + C_WIDTH)))) else
    --                '1';
    flag_of  <= '0';
    flag_cr  <= '1';
    acc_sign <= '0' when accumulator >= 0 else
                '1';
end Behavioral;
