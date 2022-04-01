----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.03.2022 00:54:31
-- Design Name: 
-- Module Name: types - Behavioral
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

package types is

    constant C_WIDTH : integer := 4;
    constant C_MAX   : integer := 9;
    subtype q_cnt is unsigned(C_WIDTH - 1 downto 0);

    type q_cnt_t is array (0 to 7) of q_cnt;

    function to_q_cnt_t(
        data_vec : in STD_LOGIC_VECTOR(8*C_WIDTH -1 downto 0))
    return q_cnt_t;
end package types;

-- Package Body Section
package body types is

    function to_q_cnt_t(data_vec : STD_LOGIC_VECTOR(8*C_WIDTH -1 downto 0)) return q_cnt_t is
        variable data_t : q_cnt_t;
    begin
        for i in data_t'range loop
            --            slv((i * 32) + 31 downto (i * 32)) := slvv(i);
            data_t(i) := unsigned(data_vec(((i + 1) * C_WIDTH) - 1 downto i * C_WIDTH));
        end loop;
        return data_t;
    end function;
end package body types;

