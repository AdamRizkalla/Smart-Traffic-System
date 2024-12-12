library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dht11_sa is
  port(
    clk:      in  std_ulogic;
    rst:      in  std_ulogic;                    -- Active high synchronous reset
    btn:      in  std_ulogic;
    data_in:  in  std_ulogic;
    data_drv: out std_ulogic;
    temperature : out STD_ULOGIC_VECTOR(7 downto 0)
  );
end entity dht11_sa;

architecture rtl of dht11_sa is

  signal start             : std_ulogic;
  signal pe                : std_ulogic;
  signal b		   : std_ulogic;
  signal do                : std_ulogic_vector(39 downto 0);
  signal srstn		   : std_ulogic;
begin
	
  srstn <= NOT(rst);

  deb: entity work.debouncer(rtl)
  port map(
    clk   => clk,
    rst   => rst,
    d     => btn,
    q     => open,
    r     => start,
    f     => open,
    a     => open
  );

  u0: entity work.dht11_ctrl(rtl)
  port map(
    clk      => clk,
    srstn    => srstn,
    start    => start,
    data_in  => data_in,
    data_drv => data_drv,
    pe       => pe,
    b        => b,
    do       => do
  );
  
  temperature <= do(23 downto 16);

end architecture rtl;
