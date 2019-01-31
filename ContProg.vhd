library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity ContProg is port (
	d   : in std_logic_vector (31 downto 0);
	ld	: in std_logic;  --Cargar/habilitar
	clr : in std_logic;  --clear
	clk : in std_logic;	 --señal de reloj
	inc : in std_logic;	 --incremento
	q   : inout std_logic_vector (31 downto 0));--salida
end ContProg;

architecture behavior of ContProg is
begin
	process(clk, clr)
	begin
		if clr = '1' then
			q <= x"00000000";
		elsif rising_edge(clk) then 
			if ld = '1' then
				q<= d;
			end if;
			if inc = '1' then
				q<= q + 1; 
			end if;
			
		end if;
		end process;  	
	end behavior;
	
			
										   