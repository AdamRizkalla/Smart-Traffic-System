----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.12.2024 02:50:29
-- Design Name: 
-- Module Name: buzzer_trigger - Behavioral
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

entity buzzer_trigger is
  Port ( 
        clk : in STD_LOGIC;
        led_ns : in STD_LOGIC_VECTOR(2 downto 0);
        led_ew : in STD_LOGIC_VECTOR(2 downto 0);
        cm_north : in INTEGER;
        cm_south : in INTEGER;
        cm_east : in INTEGER;
        cm_west : in INTEGER;
        buzzer : out STD_LOGIC
  );
end buzzer_trigger;

architecture Behavioral of buzzer_trigger is

signal buzzer_intermediate : STD_LOGIC;
signal d : INTEGER := 5;
begin
process(clk)
begin
if (led_ns(2) = '1') then 
    if (cm_north < d or cm_south < d) then 
        buzzer_intermediate <= '1';
    end if;
end if;
if (led_ew(2) = '1') then
    if (cm_east < d or cm_west < d) then
        buzzer_intermediate <= '1';
    end if;
end if;
end process;
buzzer <= buzzer_intermediate;
end Behavioral;
