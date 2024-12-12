----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2024 17:01:50
-- Design Name: 
-- Module Name: distance_calculator - Behavioral
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
use IEEE.numeric_std;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity distance_calculator is
  Port ( 
  clk : in STD_LOGIC;
  echo : in STD_LOGIC;
  distance : out STD_LOGIC_VECTOR(8 downto 0)
  );
end distance_calculator;

architecture Behavioral of distance_calculator is
signal count1 : STD_LOGIC_VECTOR(22 downto 0);
signal temp : STD_LOGIC_VECTOR(8 downto 0);
signal int : INTEGER range 0 to 2500000;
signal int2 : INTEGER range 0 to 916; -- max distance for sensor is 458cm
begin

process(clk, echo) --calculate distance

begin
if (rising_edge(clk)) then
    if (echo = '1') then
        int <= conv_integer(count1(22 downto 0));
        int2 <= ((int)*3)/16384; -- to change number of cycles to cm we have to multiply by 1/5800
        temp <= CONV_STD_LOGIC_VECTOR(int2,9);
        count1 <= count1 + "00000000000000000000001";
    else
        distance <= temp;
        count1 <= "00000000000000000000000";
    end if;
end if;        
end process;

end Behavioral;
