-- This component maps the input opcode to a alu function
library ieee;
use ieee.std_logic_1164.all;

entity aluFnLUT is
  port(
    opcode : in std_logic_vector(6 downto 0);
    Fn     : out std_logic_vector(3 downto 0)
  );
end aluFnLUT;

architecture LUT of aluFnLUT is
begin
  mux : process(opcode)
  begin
    case opcode is
    when "0000000" =>                               -- ADD
      Fn <= "0000";
    when "0000100" | "0000010" | "0000001" =>       -- Inc
      Fn <= "0110";
    when "0001000" =>                               -- SUB
      Fn <= "1101";
    when "0001100" | "0001010" | "0001001" =>       -- Dec
      Fn <= "0101";
    when "0011000" =>                               -- AND
      Fn <= "0001";
    when "0100000" =>                               -- IOR
      Fn <= "0111";
    when "0101000" =>                               -- XOR
      Fn <= "1111";
    when "0110000" =>                               -- NEG (2's complement)
      Fn <= "1001";
    when "0111000" =>                               -- COM (1's complement)
      Fn <= "0011";
    when "1000000" =>                               -- Comparison
      Fn <= "0100";
    when "1001000" =>                               -- TSTFSZ
      Fn <= "1000";
    when "1010000" =>                               -- Left rotate
      Fn <= "1010";
    when "1011000" =>                               -- Right rotate
      Fn <= "1011";
    when "1100000" =>                               -- Clear f
      Fn <= "0010";
    when "1101000" =>                               -- Set f
      Fn <= "1100";
    when "1110000" =>                               -- Swap f
      Fn <= "1110";
    when "1111011" | "1111010" | "1111001" =>       -- MOV
      Fn <= "1000";
    when others =>
      Fn <= "----";
    end case;
  end process mux;
end LUT;
