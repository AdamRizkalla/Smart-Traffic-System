----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.12.2024 04:59:59
-- Design Name: 
-- Module Name: relay_controller - Behavioral
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

entity relay_controller is
  Port ( 
  clk : in STD_LOGIC;
  led_ns : in STD_LOGIC_VECTOR(2 downto 0); -- RED YELLOW GREEN
  led_ew : in STD_LOGIC_VECTOR(2 downto 0);
  IN1_relay1 : out STD_LOGIC;
  IN2_relay1 : out STD_LOGIC;
  IN1_relay2 : out STD_LOGIC;
  IN2_relay2 : out STD_LOGIC;
  IN1_relay3 : out STD_LOGIC;
  IN2_relay3 : out STD_LOGIC
  );
end relay_controller;

architecture Behavioral of relay_controller is

signal IN1_relay1_sig : STD_LOGIC := '0';
signal IN2_relay1_sig : STD_LOGIC := '0';
signal IN1_relay2_sig : STD_LOGIC := '0';
signal IN2_relay2_sig : STD_LOGIC := '0';
signal IN1_relay3_sig : STD_LOGIC := '0';
signal IN2_relay3_sig : STD_LOGIC := '0';


begin

process(led_ns)
begin
case led_ns is
    when "100" => --red north/south
        IN1_relay1_sig <= '0';
    when "010" => --yellow north
        IN1_relay2_sig <= '0';
    when "001" => --green north
        IN1_relay3_sig <= '0';
    when others => 
        IN1_relay1_sig <= '0';
        IN1_relay2_sig <= '0';
        IN1_relay3_sig <= '0';
end case;

case led_ew is
    when "100" => --red east/west
        IN2_relay1_sig <= '0';
    when "010" => --yellow east/west
        IN2_relay2_sig <= '0';
    when "001" => --green east/west
        IN2_relay3_sig <= '0';
    when others =>
        IN2_relay1_sig <= '0';
        IN2_relay2_sig <= '0';
        IN2_relay3_sig <= '0';
end case;
end process;

IN1_relay1 <= IN1_relay1_sig;
IN1_relay2 <= IN1_relay2_sig;
IN1_relay3 <= IN1_relay3_sig;
IN2_relay1 <= IN2_relay1_sig;
IN2_relay2 <= IN2_relay2_sig;
IN2_relay3 <= IN2_relay3_sig;

end Behavioral;
