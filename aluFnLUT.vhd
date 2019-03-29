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
    case opcode(6 downto 3) is
    when "0000" =>
      if (opcode(2 downto 0) = "101" or opcode(2 downto 0) = "110" or opcode(2 downto 0) = "111") then
        Fn <= "0110";                               -- Inc
      else
        Fn <= "0000";                               -- ADD
      end if;
      
    when "0001" =>
      if (opcode(2 downto 0) = "101" or opcode(2 downto 0) = "110" or opcode(2 downto 0) = "111") then
        Fn <= "0101";                               -- DEC
      else
        Fn <= "0110";                               -- SUB
      end if;
    when "0011" =>                                  -- AND
      Fn <= "0001";
    when "0100" =>                                  -- IOR
      Fn <= "0111";
    when "0101" =>                                  -- XOR
      Fn <= "1111";
    when "0110" =>                                  -- NEG (2's complement)
      Fn <= "1001";
    when "0111" =>                                  -- COM (1's complement)
      Fn <= "0011";
    when "1000" =>                                  -- Comparison
      Fn <= "0100";
    when "1001" =>                                  -- TSTFSZ
      Fn <= "1000";
    when "1010" =>                                  -- Left rotate
      Fn <= "1010";
    when "1011" =>                                  -- Right rotate
      Fn <= "1011";
    when "1100" =>                                  -- Clear f
      Fn <= "0010";
    when "1101" =>                                  -- Set f
      Fn <= "1100";
    when "1110" =>                                  -- Swap f
      Fn <= "1110";
    when "1111" =>                                  -- MOV
      Fn <= "1000";
    when others =>
      Fn <= "----";
    end case;
  end process mux;
end LUT;
