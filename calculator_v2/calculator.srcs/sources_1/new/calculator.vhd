----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.03.2022 11:00:52
-- Design Name: 
-- Module Name: calculator - Behavioral
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

entity calculator is
    Port(
        clk  : in  std_logic;
        rstn : in  std_logic;
        SW   : in  std_logic_vector(15 downto 0);
        LED  : out std_logic_vector(15 downto 0);
        btns : in  std_logic_vector(4 downto 0);
        CA   : out std_logic_vector(7 downto 0);
        AN   : out std_logic_vector(7 downto 0)
        --        acc  : out std_logic_vector(7 downto 0);
        --        ena  : in  std_logic
    );
end calculator;

architecture Behavioral of calculator is
    constant C_WIDTH : integer := 8;

    signal rst           : std_logic;
    signal data          : std_logic_vector(C_WIDTH * 4 - 1 downto 0);
    signal en            : std_logic := '1';
    signal ac            : std_logic_vector(7 downto 0);
    signal pulse         : std_logic;
    signal ac_unsigned   : unsigned(ac'range);
    signal data_unsigned : unsigned(data'range);

begin

    rst <= not rstn;
    --    data(15 downto 12) <= SW(15 downto 12);

    display : entity work.disp
        port map(
            clk  => clk,
            rst  => rst,
            CA   => CA,
            AN   => AN,
            data => data
        );

    ALU : entity work.accalu
        generic map(
            C_WIDTH => C_WIDTH
        )
        port map(
            clk    => clk,
            rst    => rst,
            opcode => SW(15 downto 12),
            data   => SW(7 downto 0),
            acc    => ac,
            ena    => en
        );

    pul : entity work.pulse
        port map(
            clk   => clk,
            btn   => btns(0),
            pulse => pulse
        );

    process(clk)
        variable ac_unsigned   : unsigned(ac'range);
        variable data_unsigned : unsigned(data'range);
        variable tmp           : unsigned(ac'range);
    begin
        if rst = '1' then
            data <= (others => '0');
        else
            if pulse = '1' then
                --                data(7 downto 0) <= ac;
                ac_unsigned                           := unsigned(ac);
                tmp                                   := ac_unsigned mod 10;
                data_unsigned(0 * 4 + 3 downto 0 * 4) := tmp(3 downto 0);
                ac_unsigned                           := ac_unsigned / 10;
                tmp                                   := ac_unsigned mod 10;
                data_unsigned(1 * 4 + 3 downto 1 * 4) := tmp(3 downto 0);
                ac_unsigned                           := ac_unsigned / 10;
                tmp                                   := ac_unsigned mod 10;
                data_unsigned(2 * 4 + 3 downto 2 * 4) := tmp(3 downto 0);

                data <= std_logic_vector(data_unsigned);
            end if;
        end if;
    end process;

end Behavioral;
