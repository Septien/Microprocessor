library ieee;
use ieee.std_logic_1164.all;

entity Registro_P_n is
	generic(
          n : integer := 8
	);	
	port(  
          RST, CLK : in std_logic;
          DIN : in std_logic_vector( n - 1 downto 0 );
          OPC : in std_logic_vector( 1 downto 0 );
          Do  : out std_logic_vector( n - 1 downto 0 )
	);
end entity;

architecture acum of Registro_P_n is
signal Qp, Qn : std_logic_vector( n - 1 downto 0 ) := ( others => '0' );
begin
	combinacional: process (Qp,OPC,DIN)
	begin
		case OPC is
			when "00" => Qn <= Qp;                          -- HOLD
			when "01" => Qn <= DIN;                         -- WRITE
			when others => Qn <= ( others => '0' );         -- CLEAR
		end case;
	end process;
	Do <= Qp;
	secuencial: process(RST,CLK)
	begin
		if(RST='0') then
			Qp <= ( others => '0' );
		elsif( CLK'event and CLK='1' ) then
			Qp <= Qn;
		end if;
		end Process;
	end secuencial;
end acum;
