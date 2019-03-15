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
	dataOut   : out std_logic_vector(m - 1 downto 0)
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
	
end mainMemory;
