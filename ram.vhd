library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is
	generic(
	m : integer := 8; 						-- Number of bits
	n : integer := 2;						-- Maximum number of words
	k : integer := 4						-- Number of words
	);
	port(
	clk 	  : in std_logic;
	storeAddr : in std_logic_vector(n - 1 downto 0);
	write     : in std_logic;
	read 	  : in std_logic;
	dataIn 	  : in std_logic_vector(m - 1 downto 0);
	dataOut   : out std_logic_vector(m - 1 downto 0);
	DP1, DP2, DP3, DP4 : out std_logic_vector(m - 1 downto 0);
	leds1 : out std_logic_vector(m - 1 downto 0)
	);
end RAM;

architecture mainMemory of RAM is
subtype registerWidth is std_logic_vector(m - 1 downto 0);
type memory is array(natural range <>) of registerWidth;
signal ramm : memory(0 to k - 1);
begin
	-- Read control
	ReadP : process(storeAddr, ramm, read)
	begin
		if (read = '1') then
			dataOut <= ramm(to_integer(unsigned(storeAddr)));
		else
			dataOut <= (others => 'Z');
		end if;
	end process ReadP;
	
	-- Write control
	WriteP : process(clk)
	begin
		if (clk'event and clk='1') then
			if (write = '1') then
				ramm(to_integer(unsigned(storeAddr))) <= dataIn;
			end if;
		end if;
	end process WriteP;
	-- Output to leds / 7seg displays
	DP1 <= ramm(2);
	DP2 <= ramm(3);
	DP3 <= ramm(4);
	DP4 <= ramm(5);
	leds1 <= ramm(6);
	
end mainMemory;
