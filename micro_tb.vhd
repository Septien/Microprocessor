library ieee;
use ieee.std_logic_1164.all;

entity tbm is
end tbm;

architecture bench of tbm is
  signal clk, rst : std_logic := '0';
  signal DP1, DP2, DP3, DP4 : std_logic_vector(6 downto 0);
  signal leds : std_logic_vector(7 downto 0);
  
  component master is
  port(
    clk, rst : in std_logic;
    DP1, DP2, DP3, DP4 : out std_logic_vector(6 downto 0);
    leds : out std_logic_vector(7 downto 0)
  );
  end component;
begin
  M : master port map(clk, rst, DP1, DP2, DP3, DP4, leds);
  clk <= not clk after 10 ns;
  rst <= '0', '1' after 10 ns;
end bench;
