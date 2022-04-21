----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.03.2022 22:48:47
-- Design Name: 
-- Module Name: mux - Behavioral
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

use work.types.all;

entity mux is
    generic(
        SEL_SIZE : integer := 3
    );
    Port(
        v_i : in  q_cnt_t;
        sel : in  std_logic_vector(SEL_SIZE - 1 downto 0);
        q   : out q_cnt
    );
end mux;

architecture Behavioral of mux is

begin
    q <= v_i(to_integer(unsigned(sel)));
end Behavioral;