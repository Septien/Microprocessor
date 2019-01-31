library ieee;
use ieee.std_logic_1164.all;

entity alu_test_bench is
end alu_test_bench;

architecture Bench of alu_test_bench is
component ALU1 
	generic(
	bn : integer := 8
	);
	port(
	A, B : in std_logic_vector( bn - 1 downto 0 );
	S : in std_logic_vector( 3 downto 0 );
	f : out std_logic_vector( bn - 1 downto 0 );
	--[ >, <, =, NEG, SF, ZERO ]
	flags : out std_logic_vector( 5 downto 0 )
	);
end component;

signal As, Bs, f : std_logic_vector( 7 downto 0 );
signal Ss : std_logic_vector( 3 downto 0 );	  
signal flags : std_logic_vector( 5 downto 0 );
begin
	aluIns : ALU1
	generic map ( bn => 8 )
	port map ( As, Bs, Ss, f, flags );
	
	aluProc : process
	begin
		-- Test cases for the XOR operation
		Ss <= "1111";
		As <= "11111111";
		Bs <= "11111111";
		wait for 50 ns;
		Ss <= "1111";
		As <= "00000000";
		Bs <= "11111111";
		wait for 50 ns;
		Ss <= "1111";
		As <= "01010101";
		Bs <= "10101010";
		wait for 50 ns;
		Ss <= "1111";
		As <= "10101010";
		Bs <= "01010101";
		wait for 50 ns;
		Ss <= "1111";
		As <= "01010101";
		Bs <= "01010101";
		wait for 50 ns;
		Ss <= "1111";
		As <= "00001111";
		Bs <= "11110000";
		wait for 50 ns;
		Ss <= "1111";
		As <= "00001111";
		Bs <= "11111000";
		wait for 50 ns;
		Ss <= "1111";
		As <= "11111000";
		Bs <= "00001111";
		wait for 50 ns;
		-- Test cases for the ADD
		Ss <= "0000";
		As <= "00000000";
		Bs <= "00000000";
		wait for 50 ns;
		Ss <= "0000";
		As <= "00000000";
		Bs <= "11111111";
		wait for 50 ns;
		Ss <= "0000";
		As <= "11111111";
		Bs <= "00000000";
		wait for 50 ns;
		Ss <= "0000";
		As <= "01111111";
		Bs <= "01111111";
		wait for 50 ns;
		Ss <= "0000";
		As <= "10000000";
		Bs <= "10000000";
		wait for 50 ns;
		-- Test cases for the AND op
		Ss <= "0001";
		As <= "00000000";
		Bs <= "10101010";
		wait for 50 ns;
		Ss <= "0001";
		As <= "00000000";
		Bs <= "01010101";
		wait for 50 ns;
		Ss <= "0001";
		As <= "11111111";
		Bs <= "11111111";
		wait for 50 ns;
		Ss <= "0001";
		As <= "10101010";
		Bs <= "01010101";
		wait for 50 ns;
		Ss <= "0001";
		As <= "01010101";
		Bs <= "10101010";
		wait for 50 ns;
		Ss <= "0001";
		As <= "10101010";
		Bs <= "10101010";
		wait for 50 ns;
		Ss <= "0001";
		As <= "01010101";
		Bs <= "01010101";
		wait for 50 ns;
	end process aluProc;
end Bench;
