----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.12.2024 18:44:49
-- Design Name: 
-- Module Name: sevenseg_display - Behavioral
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
use IEEE.STD_LOGIC_SIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sevenseg_display is
  Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        int : in INTEGER;
        dec : in INTEGER;
        seg : out STD_LOGIC_VECTOR(7 downto 0);   
        an : out STD_LOGIC_VECTOR(3 downto 0)
   );
end sevenseg_display;

architecture Behavioral of sevenseg_display is
    
    signal seg_temp : STD_LOGIC_VECTOR(7 downto 0);
    signal refresh : STD_LOGIC_VECTOR(19 downto 0);
    signal an_activator : STD_LOGIC_VECTOR(1 downto 0);
    signal tens : integer := 0;    
    signal unit : integer := 0;    
    signal decimal_1 : integer := 0;
    signal decimal_2 : integer := 0;
    
begin

process(int, dec)
    begin
        tens <= int / 10;  -- Get tens digit
        unit <= int mod 10;  -- Get units digit
--        sec <= count;
        decimal_1 <= dec / 10;  -- Get tens digit
        decimal_2 <= dec mod 10;
--        ms <= count_milli;
        
end process;
    
process(clk, reset)
    begin
        if(reset='1') then
            refresh <= (others => '0');
        elsif (rising_edge(clk)) then
            refresh <= refresh + 1;
        end if;
end process;
    
an_activator <= refresh(19 downto 18);
    
process(clk, an_activator)
begin
    case an_activator is
        when "00" => an <= "1110";
        when "01" => an <= "1101";
        when "10" => an <= "1011";
        when "11" => an <= "0111";
    end case;
end process; 

process(clk, an_activator)
        begin
        case an_activator is 
            when "00" =>
                case decimal_2 is
                    when 0 => seg_temp <= "10000001";  -- 0
                    when 1 => seg_temp <= "11001111";  -- 1
                    when 2 => seg_temp <= "10010010";  -- 2
                    when 3 => seg_temp <= "10000110";  -- 3
                    when 4 => seg_temp <= "11001100";  -- 4
                    when 5 => seg_temp <= "10100100";  -- 5
                    when 6 => seg_temp <= "10100000";  -- 6
                    when 7 => seg_temp <= "10001111";  -- 7
                    when 8 => seg_temp <= "10000000";  -- 8
                    when 9 => seg_temp <= "10000100";  -- 9
                    when others => seg_temp <= "11111111";
                end case;
                an <= "1110";  --enable first display (10ms)
            when "01" =>
                case decimal_1 is
                    when 0 => seg_temp <= "10000001";  -- 0
                    when 1 => seg_temp <= "11001111";  -- 1
                    when 2 => seg_temp <= "10010010";  -- 2
                    when 3 => seg_temp <= "10000110";  -- 3
                    when 4 => seg_temp <= "11001100";  -- 4
                    when 5 => seg_temp <= "10100100";  -- 5
                    when 6 => seg_temp <= "10100000";  -- 6
                    when 7 => seg_temp <= "10001111";  -- 7
                    when 8 => seg_temp <= "10000000";  -- 8
                    when 9 => seg_temp <= "10000100";  -- 9
                    when others => seg_temp <= "11111111";
                end case;
                an <= "1101";  -- enable second display (100ms)
            when "10" =>
                case unit is
                    when 0 => seg_temp <= "00000001";  -- 0
                    when 1 => seg_temp <= "01001111";  -- 1
                    when 2 => seg_temp <= "00010010";  -- 2
                    when 3 => seg_temp <= "00000110";  -- 3
                    when 4 => seg_temp <= "01001100";  -- 4
                    when 5 => seg_temp <= "00100100";  -- 5
                    when 6 => seg_temp <= "00100000";  -- 6
                    when 7 => seg_temp <= "00001111";  -- 7
                    when 8 => seg_temp <= "00000000";  -- 8
                    when 9 => seg_temp <= "00000100";  -- 9
                    when others => seg_temp <= "01111111";
                end case;
                an <= "1011";  --enable third display (units)
            when "11" =>
                case tens is
                    when 0 => seg_temp <= "10000001";  -- 0
                    when 1 => seg_temp <= "11001111";  -- 1
                    when 2 => seg_temp <= "10010010";  -- 2
                    when 3 => seg_temp <= "10000110";  -- 3
                    when 4 => seg_temp <= "11001100";  -- 4
                    when 5 => seg_temp <= "10100100";  -- 5
                    when 6 => seg_temp <= "10100000";  -- 6
                    when 7 => seg_temp <= "10001111";  -- 7
                    when 8 => seg_temp <= "10000000";  -- 8
                    when 9 => seg_temp <= "10000100";  -- 9
                    when others => seg_temp <= "11111111";
                end case;
                an <= "0111";  -- enable fourth display (units)
        end case;
        seg <= seg_temp;
    end process;
end Behavioral;
