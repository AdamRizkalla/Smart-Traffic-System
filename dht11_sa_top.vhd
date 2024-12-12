library unisim;
use unisim.vcomponents.all;


library ieee;
use ieee.std_logic_1164.all;

entity dht11_sa_top is
  port(
    clk:      in    std_ulogic;
    rst:      in    std_ulogic; -- Active high synchronous reset
    btn:      in    std_ulogic;
    data:     inout std_logic;
    temperature : out STD_ULOGIC_VECTOR(7 downto 0)
  );
end entity dht11_sa_top;

architecture rtl of dht11_sa_top is

  signal data_in:  std_ulogic;
  signal data_drv: std_ulogic;
  signal data_drvn: std_ulogic;

begin

  u0: entity work.dht11_sa(rtl)
  port map(
    clk      => clk,
    rst      => rst,
    btn      => btn,
    data_in  => data_in,
    data_drv => data_drv,
    temperature => temperature
  );

  u1 : iobuf
    generic map (
      drive => 12,
      iostandard => "lvcmos33",
      slew => "slow")
    port map (
      o  => data_in,
      io => data,
      i  => '0',
      t  => data_drvn
  );

data_drvn <= not data_drv;

end architecture rtl;
