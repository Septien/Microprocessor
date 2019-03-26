-- Program Counter

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
	generic(
	n : integer := 9
	);
	port(
	clk, rst : in std_logic;
	address : in std_logic_vector(n-1 downto 0);
	inc, inc2, load : in std_logic;
	pAddress : out std_logic_vector(n-1 downto 0)
	);
end PC;

architecture counter of PC is
	signal Qp, Qn : unsigned(n-1 downto 0);
begin
	combinational : process(Qp, inc, inc2, load, address)
	begin
	  if (load = '1') then
	    Qn <= unsigned(address);
	  elsif (inc = '1') then
	    Qn <= Qp + to_unsigned(1, n-1);
	  elsif (inc2 = '1') then
	    Qn <= Qp + to_unsigned(2, n-1);
	  else
	    Qn <= Qp;
	  end if;		
	end process combinational;
	Qp <= (others => '0') when rst = '0' else Qn when rising_edge(clk);
	pAddress <= std_logic_vector(Qp);
end counter;
										   