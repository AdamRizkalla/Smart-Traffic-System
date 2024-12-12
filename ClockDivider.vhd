----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2024 18:49:50
-- Design Name: 
-- Module Name: clkdiv - Behavioral
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

entity clkdiv is
  Port ( 
  clk, clear : in STD_LOGIC;
  clkd : out STD_LOGIC);
end clkdiv;

architecture Behavioral of clkdiv is

signal temp : STD_LOGIC;
signal count : integer range 0 to 100000000 := 0;

begin

process(clk, clear)
begin
    if(clear = '1') then
        temp <= '0';
        count <= 0;
    elsif (rising_edge(clk)) then
        if (count = 99999999) then 
            temp <= not temp;
            count <= 0;
        else 
            count <= count + 1;
        end if;
    end if;
end process;
clkd <= temp;
end Behavioral;
