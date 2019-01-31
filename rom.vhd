-- Generic implementation of a ROM
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity ROM is
  generic(
    nbitsaddr : integer := 4;                    -- Address size
    nbitsdata : integer := 2                     -- Data size
    );
  port(
    addr : in std_logic_vector( nbitsaddr - 1 downto 0 );          -- Address
    data : out std_logic_vector( nbitsdata - 1 downto 0 )           -- Data
    );
end ROM;

architecture LUT of ROM is
  type mem is array ( 0 to 2**nbitsaddr - 1 ) of std_logic_vector( nbitsdata - 1 downto 0 );
  signal rom1 : mem := (
    0  => "00",
    1  => "01",
    2  => "10",
    3  => "11",
    4  => "00",
    5  => "01",
    6  => "10",
    7  => "11",
    8  => "00",
    9  => "01",
    10 => "10",
    11 => "11",
    12 => "00",
    13 => "01",
    14 => "10",
    15 => "11");
begin
  process (addr)
  begin
    data <= rom1(conv_integer(unsigned(addr)));
  end process;
end LUT;
