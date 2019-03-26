library ieee;
use ieee.std_logic_1164.all;

entity mux4a1 is
  port(
    sel : in std_logic_vector(1 downto 0);
    input1, input2, input3 : in std_logic_vector(7 downto 0);
    output : out std_logic_vector(7 downto 0)
  );
end mux4a1;

architecture simple of mux4a1 is
begin
  process(sel, input1, input2, input3)
  begin
    if (sel = "00") then
      output <= input1;
    elsif (sel = "01") then
      output <= input2;
    elsif (sel = "10") then
      output <= input3;
    else
      output <= (others => 'Z');
    end if;
  end process;
end simple;
