library ieee;
use ieee.std_logic_1164.all;

entity selBitMux is
  port(
    instruction : in std_logic_vector(8 downto 0);
    selBit : out std_logic_vector(2 downto 0)
  );
end selBitMux;

architecture mux of selBitMux is
begin
  process(instruction)
  begin
    case instruction is
    when "010001---" | "010010---" | "010011---" | "010100---"  | "010101---" =>
      selBit <= instruction(2 downto 0);
    when others =>
      selBit <= (others => '0');
    end case;
  end process;
end mux;
