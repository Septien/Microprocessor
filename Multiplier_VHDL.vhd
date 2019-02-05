library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Multiplier_VHDL is
  generic (bn: integer:= 8;
           doble: integer:= 16);
  port
  (
    Nibble1, Nibble2 :  in std_logic_vector(bn-1 downto 0);
    sel : in std_logic_vector( 1 downto 0 );                    -- Which nibble?
    AD1, R1 : in std_logic_vector(1 downto 0 );
  );
end entity Multiplier_VHDL;

architecture Behavioral of Multiplier_VHDL is
  signal Result : std_logic_vector( doble - 1 downto 0 );
begin
  Result <= std_logic_vector(unsigned(Nibble1) * unsigned(Nibble2));
  process(Result, sel)
  begin
    case sel is
      when "00" =>
        R1 <= ( others 'Z' );
        AD1 <= ( others 'Z' );
      when "01" =>
        R1 <= Result( bn - 1 downto 0 );
        AD1 <= "00000000";              -- Store result on address zero of RAM
      when others =>
        R1 <= Result( doble - 1 downto bn );
        AD1 <= "00000001";              -- Store result on address one of RAM
    end case;
  end process;
end Behavioral;
