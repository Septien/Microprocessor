library ieee;
use ieee.std_logic_1164.all;

entity mux is
  port(
    sel : in std_logic;
    input1, input2 : in std_logic_vector(8 downto 0);
    output : out std_logic_vector(8 downto 0)
  );
end mux;

architecture sel of mux is
begin
  process(sel, input1, input2)
  begin
    if (sel = '0') then
      output <= input1;
    else
      output <= input2;
    end if;
  end process;
end sel;
