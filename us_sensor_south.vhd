----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.12.2024 23:20:22
-- Design Name: 
-- Module Name: us_sensor_north - Behavioral
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

entity us_south is
     Port ( 
       clk : in STD_LOGIC;
       echo : in STD_LOGIC;
       trigger : out STD_LOGIC;
       --m : out INTEGER;
       cm : out INTEGER
       );
end us_south;

architecture Behavioral of us_south is

signal d  : STD_LOGIC_VECTOR(8 downto 0);
signal m  : INTEGER;
component distance_calculator is
    Port ( 
      clk : in STD_LOGIC;
      echo : in STD_LOGIC;
      distance : out STD_LOGIC_VECTOR(8 downto 0)
      );
end component;

component trigger_generator is 
    Port ( 
      clk : in STD_LOGIC;
      trigger : out STD_LOGIC
      );
end component;

component bin_to_bcd is
    Port ( 
      clk : in STD_LOGIC;
      bin : in STD_LOGIC_VECTOR(8 downto 0);
      m : out INTEGER;
      cm : out INTEGER
      );
end component;

begin

trigger_gen : trigger_generator port map(clk => clk, trigger => trigger);
pulse_width : distance_calculator port map(clk => clk, echo => echo, distance => d);
bintobcd : bin_to_bcd port map(clk, d, m, cm);

end Behavioral;
