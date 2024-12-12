----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2024 20:23:02
-- Design Name: 
-- Module Name: bin_to_bcd - Behavioral
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

entity bin_to_bcd is
  Port ( 
  clk : in STD_LOGIC;
  bin : in STD_LOGIC_VECTOR(8 downto 0);
  m : out INTEGER;
  cm : out INTEGER
  );
end bin_to_bcd;

architecture Behavioral of bin_to_bcd is
signal cm_temp : INTEGER;
signal cm_temp2 : INTEGER;
signal m_temp : INTEGER;
begin

process(clk)
begin
cm_temp <= TO_INTEGER(UNSIGNED(bin));
if (cm_temp /= 0) then
    m_temp <= cm_temp/100;
    cm_temp2 <= cm_temp-(m_temp*100);
    cm <= cm_temp2;
    m <= m_temp;
end if;
end process;

end Behavioral;
