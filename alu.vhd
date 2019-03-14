library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ALU1 is
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
end ALU1;

architecture arch_ALU of ALU1 is
signal Ae, Be, Fe : std_logic_vector ( bn downto 0 );	-- Input and output with an extra bit, for carry
signal zero : std_logic_vector ( bn downto 0 ) := ( others => '0' );
signal ones : std_logic_vector( bn downto 0 ) := ( others => '1' );
begin
	Ae <= '0' & A;
	Be <= '0' & B;
	
	comb: process (Ae, Be, Fn)
	begin	
		-- Which operation?	
		case Fn is
			when "0000" =>										-- ADD
			Fe <= Ae + Be;
			flags( 5 downto 1 ) <= "0000" & Fe(bn);
			
			when "0001" =>										-- AND
			Fe <= Ae and Be;
			flags( 5 downto 1 ) <= "00000";
			
			when "0010" =>										-- CLEAR
			Fe <= ( others => '0' );
			flags( 5 downto 1 ) <= "00000";
			
			when "0011" =>										-- Complement
			Fe <= not Ae;
			flags( 5 downto 1 ) <= "00000";
			
			when "0100" =>										-- Comparison
			if (Ae > Be) then
				flags( 5 downto 1 ) <= "10000";
			elsif (Ae < Be) then
				flags( 5 downto 1 ) <= "01000";
			else
				flags( 5 downto 1 ) <= "00100";
			end if;
			Fe <= ( others => '0' );
			
			when "0101" =>										-- DECREASE
			Fe <= Ae - 1;
			if ( Ae = zero ) then
				flags( 5 downto 1 ) <= "00010";
			else
				flags ( 5 downto 1 ) <= "00000";
			end if;
			
			when "0110" => 										-- INCREASE
			Fe <= Ae + 1; 
			if ( Ae( bn - 1 downto 0 ) = ones( bn - 1 downto 0 ) ) then
			--if ( Ae = ones ) then		-- Overflow
				flags( 5 downto 1 ) <= "00010";	   
			else
				flags( 5 downto 1 ) <= "00000";
			end if;
			
			when "0111" =>										-- OR
			Fe <= Ae or Be;
			flags(5 downto 1) <= "00000";
			
			when "1000" =>										-- MOV
			Fe <= Ae;
			flags( 5 downto 1 ) <= "00000";
			
			when "1001" => 										-- NEG (2s complement)
			Fe <= ( not Ae ) + 1;
			flags( 5 downto 1 ) <= "00000";
			
			when "1010" =>										-- Left rotate
			Fe <= '0' & Ae( bn - 2 downto 0 ) & Ae( bn - 1 );
			flags( 5 downto 1 ) <= "00000";
			
			when "1011" => 										-- Rigth rotate
			Fe <= '0' & Ae( 0 ) & Ae( bn - 1 downto 1);
			flags(5 downto 1) <= "00000";
			
			when "1100" => 										-- Set to 1
			Fe <= ( others => '1' );
			flags( 5 downto 1 ) <= "00000";
			
			when "1101" => 										-- Substract
			Fe <= Ae - Be;
			if ( Be > Ae ) then 		-- overflow
				flags( 5 downto 1 ) <= "00010";
			else
				flags( 5 downto 1 ) <= "00000";
			end if;
			
			when "1110" =>										-- Swap MSB with LSB
			Fe <= '0' & Ae( bn - 5 downto 0 ) & Ae ( bn - 1 downto 4 );
			flags(5 downto 1) <= "00000";
			
			when others =>										-- XOR
			Fe <= Ae xor Be;
			flags(5 downto 1) <= "00000";
			
		end case;
		-- Verify if result of operations is zero
		if ( fe( bn - 1 downto 0 ) = zero ) then
			flags( 0 ) <= '1';
		else
			flags( 0 ) <= '0';
		end if;

	end process;
        -- Output result
        result <= fe ( bn - 1 downto 0 );
end arch_ALU;
