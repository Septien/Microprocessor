library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity Registro_P_n is
	generic(
          n : integer := 8
	);	
	port(  
          RST, CLK : in std_logic;
          DIN : in std_logic_vector( n - 1 downto 0 );
          OPC : in std_logic_vector( 2 downto 0 );
          SEL : in std_logic_vector( 2 downto 0 );                    -- Bit
          DBIT : out std_logic;
          Do  : out std_logic_vector( n - 1 downto 0 )
	);
end entity;

architecture acum of Registro_P_n is
  signal Qp, Qn : std_logic_vector( n - 1 downto 0 ) := ( others => '0' );
  signal bp, bn : std_logic := '0';                        -- Hold a bit
begin
	combinacional: process (Qp,OPC,DIN)
	begin
          case OPC is
            when "000" =>                                               -- Clear
              Qn <= ( others => '0' );
              bn <= '0';
            when "001" =>                                               -- Hold
              Qn <= Qp;
              bn <= bp;
            when "010" =>                                               -- Write
              Qn <= DIN;
              bn <= DIN(conv_integer(unsigned(SEL)));
            -- Operations on bits
            when "011" =>                                               -- Clear
              Qn <= DIN;
              bn <= '0';
            when "100" =>                                               -- Set
              Qn <= DIN;
              bn <= '1';
            when others =>                                               -- Toggle
              Qn <= DIN;
              bn <= not DIN(conv_integer(unsigned(SEL)));
            end case;
	end process;
	Do <= Qp;
        DBIT <= bp;
	secuencial: process(RST,CLK)
	begin
		if(RST='0') then
			Qp <= ( others => '0' );
		elsif( CLK'event and CLK='1' ) then
                  bp <= bn;
                  case SEL is
                    when "000" =>
                      Qp <= Qn( n - 1 downto 1 ) & bp;
                    when "001" =>
                      Qp <= Qn( n - 1 downto 2 ) & bp & Qn( 0 );
                    when "010" =>
                      Qp <= Qn( n - 1 downto 3 ) & bp & Qn( 1 downto 0 );
                    when "011" =>
                      Qp <= Qn( n - 1 downto 4 ) & bp & Qn( 2 downto 0 );
                    when "100" =>
                      Qp <= Qn( n - 1 downto 5 ) & bp & Qn( 3 downto 0 );
                    when "101" =>
                      Qp <= Qn( n - 1 downto 6 ) & bp & Qn( 4 downto 0 );
                    when "110" =>
                      Qp <= Qn ( n - 1 ) & bp & Qn ( 5 downto 0 );
                    when others =>
                      Qp <= bp & Qn( 6 downto 0 );
                    end case;
		end if;
        end process;
end acum;
