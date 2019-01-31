library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity LIFO is
	generic(
		m : integer := 8;	  --Numero de bits
		n : integer := 2;	  -- Lineas de direccion
		k : integer  := 4	  -- Numero de localidades
		);
	port(
		RST : in std_logic;  						--Reset de control
		CLK : in std_logic;						    --Reloj Maestro
		OPR : in std_logic_vector(1 downto 0);	    --Modo de operacion
		DE  : in std_logic_vector(m-1 downto 0);    --Dato de entrada
		DS  : out std_logic_vector(m-1 downto 0);   --Dato de salida
		E   : out std_logic;					    --Memoria vacia
		F   : out std_logic 					    --Memoria llena
		);
end LIFO;

architecture Arreglo of LIFO is 
subtype Ancho_del_registro is std_logic_vector(m-1 downto 0);
type Memoria is array(natural range <>) of Ancho_del_registro;
signal Stack : Memoria(0 to k-1);
signal AE, AS : std_logic_vector(n-1 downto 0) := (others => '0');
signal FP, EP : std_logic;
begin 
	
	Salida: process(AE,EP,FP,Stack)
	begin
		DS <= Stack(conv_integer(unsigned(AE)));
		F  <= FP;
		E  <= EP;
	end process Salida;
	
	Control: process(RST,CLK)
	begin
		if (RST='0') then
			AE <= (others => '1');
			AS <= (others => '0');
			EP <= '1'; --Memoria vacia
			FP <= '0'; --Memoria no llena
		elsif (CLK'event and CLK='1') then
			case OPR is
				when "01" => --Solo lectura
					if (EP = '0') then --Memoria no vacia
						if(AE = AS) then	
							EP <= '1'; --Memoria vacia
						end if;
						AE <= AE - 1;
					end if;
					FP <= '0'; --Memoria no esta llena
				when "10" => -- Solo escritura 
					if (FP = '0') then --Memoria no llena
						Stack(conv_integer(unsigned(AE+1))) <= DE;
						if((AE+1) = NOT(AS)) then
							FP <= '1'; --Memoria llena
						end if;
						AE <= AE+1;
					end if;
					EP <= '0'; --Memoria no esta vacia
				when others => null;
			end case;
		end if;
	end process Control;
	
end Arreglo;