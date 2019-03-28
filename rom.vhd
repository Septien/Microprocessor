library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
	port(
		addr : in std_logic_vector(8 downto 0);
		data : out std_logic_vector(16 downto 0)
		);
	end ROM;

architecture LUT of ROM is
begin
	process(addr)
	begin
		case addr is
			when "000000000" => data <= "11111100101010101";
			when "000000001" => data <= "10111101000000000";
			when "000000010" => data <= "00001010000010010";
			when "000000011" => data <= "11111100111111000";
			when "000000100" => data <= "10001110000000000";
			when "000000101" => data <= "00001010000010011";
			when "000000110" => data <= "10101110000000000";
			when "000000111" => data <= "00001010000010011";
			when "000001000" => data <= "10101110000000000";
			when "000001001" => data <= "00001010000010011";
			when "000001010" => data <= "10101110000000000";
			when "000001011" => data <= "00001010000010011";
			when "000001100" => data <= "10110010000000000";
			when "000001101" => data <= "00001010000010011";
			when "000001110" => data <= "00001010000010010";
			when "000001111" => data <= "10111101000000000";
			when "000010000" => data <= "00001010000010011";
			when "000010001" => data <= "00010010000000000";
			when "000010010" => data <= "00101010000001111";
			when "000010011" => data <= "10000001000010000";
			when "000010100" => data <= "00010010000010011";
			when "000010101" => data <= "10000001000010001";
			when "000010110" => data <= "00010010000010011";
			when "000010111" => data <= "10000001000010010";
			when "000011000" => data <= "00010010000010011";
			when "000011001" => data <= "00110000000000000";
			when others => data <= "00000000000000000";
		end case;
	end process;
end LUT;
