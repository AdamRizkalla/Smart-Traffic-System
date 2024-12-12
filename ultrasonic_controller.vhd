----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2024 16:40:54
-- Design Name: 
-- Module Name: ultrasonic_controller - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ultrasonic_controller is
  Port ( 
        clk : in STD_LOGIC;
        echo : in STD_LOGIC_VECTOR(3 downto 0);
        trigger : out STD_LOGIC_VECTOR(3 downto 0);
        cm_north : out INTEGER;
        cm_south : out INTEGER;
        cm_east : out INTEGER;
        cm_west : out INTEGER
        );
end ultrasonic_controller;

architecture Behavioral of ultrasonic_controller is

signal d_north : STD_LOGIC_VECTOR(8 downto 0);
signal d_south : STD_LOGIC_VECTOR(8 downto 0);
signal d_east : STD_LOGIC_VECTOR(8 downto 0);
signal d_west : STD_LOGIC_VECTOR(8 downto 0);


component us_north is 
Port ( 
       clk : in STD_LOGIC;
       echo : in STD_LOGIC;
       trigger : out STD_LOGIC;
       cm : out INTEGER
       );
end component;

component us_south is
Port ( 
       clk : in STD_LOGIC;
       echo : in STD_LOGIC;
       trigger : out STD_LOGIC;
       cm : out INTEGER
       );
end component;

component us_east is
Port ( 
       clk : in STD_LOGIC;
       echo : in STD_LOGIC;
       trigger : out STD_LOGIC;
       cm : out INTEGER
       );
end component;

component us_west is
Port ( 
       clk : in STD_LOGIC;
       echo : in STD_LOGIC;
       trigger : out STD_LOGIC;
       cm : out INTEGER
       );
end component;

begin


usnorth : us_north port map (clk, echo(0), trigger(0), cm_north);
ussouth : us_south port map (clk, echo(1), trigger(1), cm_south);
useast  : us_east port map (clk, echo(2), trigger(2), cm_east);
uswest  : us_west port map (clk, echo(3), trigger(3), cm_west);

end Behavioral;
