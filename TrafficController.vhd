----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2024 18:36:31
-- Design Name: 
-- Module Name: TrafficController - Behavioral
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

entity TrafficController is
  Port ( 
  clk : in STD_LOGIC;
  reset : in STD_LOGIC;
  echo : in STD_LOGIC_VECTOR(3 downto 0);
  seg_select : in STD_LOGIC; -- if 1 output temp, if 0 output range;
  vccin_led : in STD_LOGIC;
  --sw1_relay1 : in STD_LOGIC;--test led
  --sw2_relay2 : in STD_LOGIC;--test led
  button : in STD_LOGIC;
  dht_data : inout STD_LOGIC;  
  trigger : out STD_LOGIC_VECTOR(3 downto 0);
  --cfsm : out STD_LOGIC_VECTOR(4 downto 0); -- for tb
  led_ns : out STD_LOGIC_VECTOR(2 downto 0); -- traffic lights for north and south road (red yellow green)
  led_ew : out STD_LOGIC_VECTOR(2 downto 0); -- traffic lights for east and west road (red yellow green) 
  lcd_enable : out STD_LOGIC;
  buzzer : out STD_LOGIC; ----------------------------------------
  --vccout_led : out STD_LOGIC;
  in1_led : out STD_LOGIC; --test led
  in2_led : out STD_LOGIC; --test led
  --temp_value_ready : out STD_LOGIC; --led to test when temp value is ready 
  IN1_relay1 : out STD_LOGIC;
  IN2_relay1 : out STD_LOGIC;
  IN1_relay2 : out STD_LOGIC;
  IN2_relay2 : out STD_LOGIC;
  IN1_relay3 : out STD_LOGIC;
  IN2_relay3 : out STD_LOGIC;
  seg : out STD_LOGIC_VECTOR(7 downto 0);
  an : out STD_LOGIC_VECTOR(3 downto 0)
  );
end TrafficController;

architecture Structural of TrafficController is
component clkdiv
port (
    clk, clear : in STD_LOGIC;
    clkd : out STD_LOGIC);
end component;    

component fsm
port (
    clk, clear : in STD_LOGIC;
    --s : out INTEGER;    
    c : out STD_LOGIC_VECTOR(4 downto 0);
    lights_ns : out STD_LOGIC_VECTOR(2 downto 0); -- traffic lights for north and south road (red yellow green)
    lights_ew : out STD_LOGIC_VECTOR(2 downto 0)); -- traffic lights for east and west road (red yellow green)
end component;

component sevenseg_display
port(
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        int : in INTEGER;
        dec : in INTEGER;
        seg : out STD_LOGIC_VECTOR(7 downto 0);   
        an : out STD_LOGIC_VECTOR(3 downto 0)
);
end component;

component ultrasonic_controller is
Port ( 
                clk : in STD_LOGIC;
                echo : in STD_LOGIC_VECTOR(3 downto 0);
                trigger : out STD_LOGIC_VECTOR(3 downto 0);
                cm_north : out INTEGER;
                cm_south : out INTEGER;
                cm_east : out INTEGER;
                cm_west : out INTEGER
                );
end component;

component buzzer_trigger is
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
end component;

component dht11_sa_top
port(
    clk:      in    std_logic;
    rst:      in    std_logic; -- Active high synchronous reset
    btn:      in    std_logic;
    data:     inout std_logic;
    temperature : out STD_ULOGIC_VECTOR(7 downto 0)
  );
end component;

component relay_controller
Port(
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
end component;

signal clear, clkd : STD_LOGIC;
signal lns, lew : STD_LOGIC_VECTOR(2 downto 0);
signal cf : STD_LOGIC_VECTOR(4 downto 0);
signal temperature_int : INTEGER;
signal temperature_dec : INTEGER;
signal temp_lcd_int : STD_ULOGIC_VECTOR(7 downto 0);
signal temp_lcd_dec : STD_LOGIC_VECTOR(7 downto 0);
signal distance_int : INTEGER;
signal distance_dec : INTEGER;
signal temp_int : INTEGER;
signal temp_dec : INTEGER;
signal temperature_state : INTEGER;
signal cm_north : INTEGER;
signal cm_south : INTEGER;
signal cm_east : INTEGER;
signal cm_west : INTEGER;
signal echo_t : STD_LOGIC_VECTOR(3 downto 0);
signal trigger_t : STD_LOGIC_VECTOR(3 downto 0);
constant num_big : INTEGER := 69;
constant num_small : INTEGER := 69;

begin

u0: clkdiv port map (clk => clk, clear => reset, clkd => clkd); 
u1: fsm port map (clk => clkd, clear => reset, c => cf, lights_ns => lns, lights_ew => lew);
u2: dht11_sa_top port map(clk, reset, button, dht_data, temp_lcd_int);
u3: ultrasonic_controller port map(clk => clk, echo => echo, trigger => trigger, cm_north => cm_north, cm_south => cm_south, cm_east => cm_east, cm_west => cm_west);
u4: sevenseg_display port map(clk, reset, temp_int, temp_dec, seg, an);
u5: buzzer_trigger port map(clk, lns, lew, cm_north, cm_south, cm_east, cm_west, buzzer);
u6: relay_controller port map(clk, lns, lew, IN1_relay1, IN2_relay1, IN1_relay2, IN2_relay2, IN1_relay3, IN2_relay3);
led_ns <= lns;
led_ew <=lew;
--cfsm <= cf;
--vccout_led <= vccin_led;
temperature_int <= TO_INTEGER(UNSIGNED(temp_lcd_int));
temperature_dec <= 0;
in1_led <= '0';
in2_led <= '0';
process(clk)
begin
    case seg_select is
        when '0' =>
            temp_int <= temperature_int;--distance_int;
            temp_dec <= 0;--distance_dec;
        when '1' =>
            temp_int <= 0;
            temp_dec <= 0;
    end case;       
end process;
end Structural;
