library ieee;
use ieee.std_logic_1164.all;

entity DemuxAddr is
  port(
    D1       :  in std_logic_vector(8 downto 0);
    addrSel  :  in std_logic;
    literalV :  out std_logic_vector(8 downto 0);
    addr     :  out std_logic_vector(8 downto 0)
  );
end DemuxAddr;

architecture opt of DemuxAddr is
begin
  process(D1, addrSel)
  begin
    if (addrSel = '0') then
      addr <= D1;
    else
      literalV <= D1;
    end if;
  end process;
end opt;
