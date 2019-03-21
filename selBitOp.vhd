-- This look up table has as purpose to indicate which bit operation to select:
--		- Set
--		- Clear
--		- Toggle

library ieee;
use ieee.std_logic_1164.all;

entity BitOpLUT is
	port(
	instruction : in std_logic_vector(3 downto 0);
	bitOp : out std_logic_vector(2 downto 0)
	);
end BitOpLUT;

architecture LUT of BitOpLUT is
begin
	process(instruction)
	begin
		case instruction is
			when "0001" => 						-- Clear bit
			bitOp <= "011";
			when "0010" =>						-- Set bit
			bitOp <= "100";
			when "0011" | "0100" | "0101" =>	-- Toggle
			bitOp <= "101";
			when others =>
			bitOp <= "001";
		end case;
	end process;
end LUT;
