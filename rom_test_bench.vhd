library ieee;
use ieee.std_logic_1164.all;

entity rom_test_bench is
end rom_test_bench;

architecture Bench of rom_test_bench is
  component ROM
    generic(
      nbitsaddr : integer := 4;
      nbitsdata : integer := 2
      );
    port(
      addr : in std_logic_vector( nbitsaddr - 1 downto 0 );
      data : out std_logic_vector( nbitsdata - 1 downto 0 )
      );
  end component;

  signal addrS : std_logic_vector( 3 downto 0);
  signal dataS : std_logic_vector( 1 downto 0);

begin

  -- ROM instance
  romIns: ROM
    generic map (nbitsaddr => 4, nbitsdata => 2)
    port map (addrS, dataS);

  romProc : process
  begin
    addrs <= "0000";
    wait for 100 ns;
    addrs <= "0001";
    wait for 100 ns;
    addrs <= "0010";
    wait for 100 ns;
    addrs <= "0011";
    wait for 100 ns;
    addrs <= "0100";
    wait for 100 ns;
    addrs <= "0101";
    wait for 100 ns;
    addrs <= "0110";
    wait for 100 ns;
    addrs <= "0111";
    wait for 100 ns;
    addrs <= "1000";
    wait for 100 ns;
    addrs <= "1001";
    wait for 100 ns;
    addrs <= "1010";
    wait for 100 ns;
    addrs <= "1011";
    wait for 100 ns;
    addrs <= "1100";
    wait for 100 ns;
    addrs <= "1101";
    wait for 100 ns;
    addrs <= "1110";
    wait for 100 ns;
    addrs <= "1111";
    wait;
  end process romProc;
end Bench;

