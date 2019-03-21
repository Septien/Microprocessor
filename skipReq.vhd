library ieee;
use ieee.std_logic_1164.all;

entity skipReq is
	port(
	z, lt, gt, eq, b : in std_logic; 							-- Flags from the alu
	msbInstruction : in std_logic_vector(1 downto 0);
	instruction : in std_logic_vector(6 downto 0);
	skip : out std_logic
	);
end skipReq;

architecture lut of skipReq is
begin
	process(instruction, msbInstruction)
	begin
		if ( not msbInstruction = "00") then
			-- INCFSZ, DECFSZ
			if ((instruction = "0000010" or instruction = "0001010") and z = '1') then
				skip <= '1';
			-- INFSNZ, DCFSNZ
			elsif ((instruction = "0000001" or instruction = "0001001") and z = '0') then
				skip <= '1';
			-- CPSEQ
			elsif (instruction = "1000100" and eq = '1') then
				skip <= '1';
			-- CPSGT
			elsif (instruction = "1000010" and gt = '1') then
				skip <= '1';
			-- CPSLT
			elsif (instruction = "1000001" and lt = '1') then
				skip <= '1';
			-- TSTFSZ
			elsif (instruction = "1001---" and z = '1') then
				skip <= '1';
			-- BTFSC
			elsif (instruction = "0011---" and b = '0') then
				skip <= '1';
			-- BTFSS
			elsif (instruction = "0100---" and b = '1') then
				skip <= '1';
			else
				skip <= '0';
			end if;
		else
			skip <= '0';
		end if;
	end process;
end lut;

		