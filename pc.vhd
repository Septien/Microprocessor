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
	address : in std_logic_vector(n downto 0);
	opt : std_logic_vector(1 downto 0);
	pAddress : out std_logic_vector(n-1 downto 0)
	);
end PC;

architecture counter of PC is
	signal Qp, Qn : unsigned(n-1 downto 0);
begin
	combinational : process(Qp, opt, address)
	begin
		case opt is
			when "00" =>						-- Load address
			Qn <= unsigned(address);
			
			when "01" =>						-- Increment by 1
			Qn <= Qp + to_unsigned(1, n-1);
			
			when "10" =>						-- Increment by 2
			Qn <= Qp + to_unsigned(2, n-1);
			
			when others =>
			Qn <= Qp;
		end case;
		
	end process combinational;
	Qp <= (others => '0') when rst = '0' else Qn when rising_edge(clk);
	pAddress <= std_logic_vector(Qp);
end counter;
										   