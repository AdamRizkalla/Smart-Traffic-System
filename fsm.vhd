----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2024 19:07:05
-- Design Name: 
-- Module Name: fsm - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fsm is
  Port ( 
  clk, clear : in STD_LOGIC;
  --s : out INTEGER;
  c : out STD_LOGIC_VECTOR(4 downto 0);
  lights_ns : out STD_LOGIC_VECTOR (2 downto 0);
  lights_ew : out STD_LOGIC_VECTOR (2 downto 0));
end fsm;

architecture Behavioral of fsm is

type STATES is (s0, s1, s2, s3);
signal state : STATES;
signal count : STD_LOGIC_VECTOR (4 downto 0);
constant big_delay : STD_LOGIC_VECTOR (4 downto 0) := "10011"; -- delay of 20 seconds for green light
constant small_delay : STD_LOGIC_VECTOR (3 downto 0) := "0100"; -- delay of 5 seconds for the yellow and red light 

begin

state_transition : process(clk, clear)
begin
    if(clear = '1') then
        state <= s0;
        count <= "00000";
    elsif (rising_edge(clk)) then
        case state is
            when s0 => if (count < big_delay) then 
                            state <= s0;
                            count <= count + 1;
                       else
                            state <= s1;
                            count <= "00000";
                       end if;
             when s1 => if (count < small_delay) then 
                            state <= s1; 
                            count <= count + 1;
                        else 
                            state <= s2;
                            count <= "00000";
                        end if;
             when s2 => if (count < big_delay) then
                            state <= s2;
                            count <= count + 1;
                        else 
                            state <= s3;
                            count <= "00000";
                        end if;
              when s3 => if (count < small_delay) then
                            state <= s3;
                            count <= count + 1;
                         else 
                            state <= s0;
                            count <= "00000";
                         end if;
              when others => state <= s0;
        end case;
    end if;
end process;

output : process(state)
begin
    case state is 
        when s0 => lights_ns <= "001"; lights_ew <= "100"; --s<=0;
        when s1 => lights_ns <= "010"; lights_ew <= "100"; --s<=1;
        when s2 => lights_ns <= "100"; lights_ew <= "001"; --s<=3;
        when s3 => lights_ns <= "100"; lights_ew <= "010"; --s<=4;
    end case;
end process;  

c <= count;   
end Behavioral;
