----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2024 18:27:13
-- Design Name: 
-- Module Name: trigger_generator - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity trigger_generator is
  Port ( 
  clk : in STD_LOGIC;
  trigger : out STD_LOGIC
  );
end trigger_generator;

architecture Behavioral of trigger_generator is
signal count : STD_LOGIC_VECTOR(22 downto 0) := "00000000000000000000000";
begin

process(clk)
begin
if(rising_edge(clk)) then
    if(count <= "0000000000010010110000") then -- 12us have passed (1200 clock cycle)
        trigger <= '1';
        count <= count + "00000000000000000000001";
    else 
        trigger <= '0';
        count <= count + "00000000000000000000001";
        if(count = "10011000100101101000000") then
            count <= "00000000000000000000000";
        end if;
    end if;
end if;                
end process;

end Behavioral;
