library ieee;
use ieee.std_logic_1164.all;

entity skipReq is
	port(
	z, lt, gt, eq, b : in std_logic; 							-- Flags from the alu
	msbInstruction : in std_logic_vector(1 downto 0);
	instruction : in std_logic_vector(6 downto 0);
	inc, inc2 : out std_logic
	);
end skipReq;

architecture lut of skipReq is
begin
	process(instruction, msbInstruction, z, eq, gt, lt, b)
	begin
	  -- Arithmetic/logic
	  if (msbInstruction = "10" or msbInstruction = "11") then
		  -- First cycle of multiplication
		  if (instruction(6 downto 3) = "0010") then
			  inc <= '0';
			  inc2 <= '0';
			-- INCFSZ, DECFSZ
			elsif ((instruction = "0000010" or instruction = "0001010") and z = '1') then
			  inc <= '0';
				inc2 <= '1';
			-- INFSNZ, DCFSNZ
			elsif ((instruction = "0000001" or instruction = "0001001") and z = '0') then
				inc <= '0';
				inc2 <= '1';
			-- CPSEQ
			elsif (instruction = "1000100" and eq = '1') then
			  inc <= '0';
				inc2 <= '1';
			-- CPSGT
			elsif (instruction = "1000010" and gt = '1') then
				inc <= '0';
				inc2 <= '1';
			-- CPSLT
			elsif (instruction = "1000001" and lt = '1') then
				inc <= '0';
				inc2 <= '1';
			else
			  inc <= '1';
				inc2 <= '0';
			end if;
		elsif (msbInstruction = "01") then
			-- TSTFSZ
			if (instruction(6 downto 3) = "1001" and z = '1') then
				inc <= '0';
				inc2 <= '1';
			-- BTFSC
			elsif (instruction(6 downto 3) = "0011" and b = '0') then
				inc <= '0';
				inc2 <= '1';
			-- BTFSS
			elsif (instruction(6 downto 3) = "0100" and b = '1') then
				inc <= '0';
				inc2 <= '1';
			else
				inc <= '1';
				inc2 <= '0';
			end if;
		else
			inc <= '1';
			inc2 <= '0';
		end if;
	end process;
end lut;

		