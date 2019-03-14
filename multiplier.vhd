library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Multiplier_VHDL is
  generic (bn: integer:= 8;
           doble: integer:= 16);
  port
  (
    byte1, byte2 :  in std_logic_vector(bn-1 downto 0);
    sel 		 : in std_logic_vector( 1 downto 0 );                    -- Which byte?
    result 		 : out std_logic_vector(bn - 1 downto 0 );
	address		 : out std_logic_vector(bn downto 0)
	);
end entity Multiplier_VHDL;

architecture Behavioral of Multiplier_VHDL is
  signal MultResult : std_logic_vector( doble - 1 downto 0 );
begin
  MultResult  <= std_logic_vector(unsigned(byte1) * unsigned(byte2));
  process(MultResult, sel)
  begin
    case sel is
      when "01" =>
        result <= MultResult ( bn - 1 downto 0 );
        address <= "00000000";              -- Store result on address zero of RAM
      when "10" =>
        result <= MultResult ( doble - 1 downto bn );
        address <= "00000001";              -- Store result on address one of RAM
	  when others =>
        result <= ( others => 'Z' );
        address <= ( others => 'Z' );
    end case;
  end process;
end Behavioral;
