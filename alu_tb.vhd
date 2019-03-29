library ieee;
use ieee.std_logic_1164.all;

entity alutb is
end alutb;

architecture bench of alutb is
  signal A, B : std_logic_vector(7 downto 0);
  signal Fn : std_logic_vector(3 downto 0);
  signal result : std_logic_vector(7 downto 0);
  signal flags : std_logic_vector(5 downto 0);

  component ALU1 is
	generic (
	bn : integer := 8
	);
	port (
	-- A -> From memory / literal, B -> From working register
	A, B : in std_logic_vector( bn - 1 downto 0 );
	Fn : in std_logic_vector( 3 downto 0 );
	result : out std_logic_vector( bn - 1 downto 0 );
	--[ >, <, =, NEG, V, ZERO ]
	flags : out std_logic_vector( 5 downto 0 )
	);
  end component;
begin
  ALU : ALU1 port map(A, B, Fn, result, flags);
  Fn <= "0000", "0001" after 10 ns, "0010" after 20 ns;
  A <= "00000001";
  B <= "00000010";
end bench;
