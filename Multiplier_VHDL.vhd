library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Multiplier_VHDL is
  generic (bn: integer:= 8;
           doble: integer:= 16);
  port
  (
    Nibble1, Nibble2 :  in std_logic_vector(bn-1 downto 0);
    Result :            inout std_logic_vector(doble-1 downto 0);
    rl, rh :	        out std_logic_vector(bn-1 downto 0)
  );
end entity Multiplier_VHDL;

architecture Behavioral of Multiplier_VHDL is
begin

   Result <= std_logic_vector(unsigned(Nibble1) * unsigned(Nibble2));
   rl <= Result(bn-1 downto 0);
   rh <= Result(doble-1 downto bn);

end architecture Behavioral;
