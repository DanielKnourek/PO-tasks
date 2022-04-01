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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity calculator is
    generic(
        C_WIDTH : integer := 8
    );
    Port(
        clk  : in  std_logic;
        rstn : in  std_logic;
        SW   : in  std_logic_vector(15 downto 0);
        LED  : out std_logic_vector(15 downto 0);
        btns : in  std_logic_vector(4 downto 0);
        CA   : out std_logic_vector(7 downto 0);
        AN   : out std_logic_vector(7 downto 0)
    );
end calculator;

architecture Behavioral of calculator is
    signal ena  : std_logic;
    signal rst  : std_logic;
    signal data : std_logic_vector(C_WIDTH * 4 - 1 downto 0);
    signal acc  : std_logic_vector(C_WIDTH - 1 downto 0);
begin
    rst <= rstn;

    data(C_WIDTH - 1 downto 0) <= SW(SW'low + C_WIDTH - 1 downto SW'low);

    alu : entity work.accalu
        generic map(
            C_WIDTH => C_WIDTH
        )
        port map(
            clk       => clk,
            rst       => rst,
            ena       => ena,
            opcode    => SW(SW'high downto SW'high - 3),
            data      => SW(SW'low + C_WIDTH - 1 downto SW'low),
            data_sign => SW(SW'low + C_WIDTH),
            acc       => acc,
            acc_sign  => LED(15),
            flag_of   => LED(0),
            flag_cr   => LED(1)
        );

    pulse_inst : entity work.pulse
        port map(
            clk   => clk,
            btn   => btns(0),
            pulse => ena
        );

    disp : entity work.disp
        generic map(
            C_WIDTH => C_WIDTH
        )
        port map(
            clk  => clk,
            rst  => rst,
            data => data,
            CA   => CA,
            AN   => AN
        );

end Behavioral;
