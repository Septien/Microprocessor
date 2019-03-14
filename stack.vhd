library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity stack is
	generic(
		m : integer := 9;	  -- Number of bits
		n : integer := 16;	  -- Maximum number of words
		k : integer  := 4	  -- Number of words
		);
	port(
		clk, rst : in std_logic;
		oprMode  : in std_logic_vector(1 downto 0);	    -- Operation Mode
		addrIn   : in std_logic_vector(m-1 downto 0);
		addrOut  : out std_logic_vector(m-1 downto 0);
		emptyStack : out std_logic;
		fullStack  : out std_logic
		);
end stack;

architecture sArray of stack is 
subtype registerWidth is std_logic_vector(m-1 downto 0);
type Memory is array(natural range <>) of registerWidth;
signal stackMem : Memory(0 to k-1);
signal currLoc, topBottom : std_logic_vector(n-1 downto 0) := (others => '0');
signal isFull, isEmpty : std_logic;
begin 
	
	Output: process(currLoc, isFull, isEmpty, stackMem)
	begin
		addrOut <= stackMem(to_integer(unsigned(currLoc)));
		fullStack <= isFull;
		emptyStack <= isEmpty;
	end process Output;
	
	Control: process(rst, clk)
	begin
		if ( rst = '0' ) then
			currLoc <= (others => '1');
			topBottom <= (others => '0');
			isEmpty <= '1';
			isFull <= '0';

		elsif ( clk'event and clk = '1' ) then
			case oprMode is
				when "01" => -- Read only
					if (isEmpty = '0') then
						if(currLoc = topBottom) then	-- The pointer is at the bottom of the stack	
							isEmpty <= '1';
						end if;
						currLoc <= currLoc - 1;
					end if;
					isEmpty <= '0';
				
				when "10" => -- Write only
					if (isFull = '0') then
						stackMem(to_integer(unsigned(currLoc + 1))) <= addrIn;
						if((currLoc + 1) = NOT(topBottom)) then	-- The pointer is at the top of the stack
							isFull <= '1'; --Memoria llena
						end if;
						currLoc <= currLoc + 1;
					end if;
					isEmpty <= '0'; --Memoria no esta vacia
				
				when others => -- Nop !
					null;
			end case;
		end if;
	end process Control;
	
end sArray;