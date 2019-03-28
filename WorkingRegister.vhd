 library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity WorkingRegister is
	generic(
		n : integer := 8
	);	
	port(  
        rst, clk : in std_logic;
        dataIn 	 : in std_logic_vector( n - 1 downto 0 );
        opt 	 : in std_logic_vector( 2 downto 0 );
        sel 	 : in std_logic_vector( 2 downto 0 );                    	-- Bit to work with
        opResult : out std_logic;										-- Result of the selected operation
        dataOut  : out std_logic_vector( n - 1 downto 0 )
	);
end entity;

architecture acum of WorkingRegister is
  signal Qp, Qn : std_logic_vector( n - 1 downto 0 ) := ( others => '0' );
  signal bp, bn : std_logic := '0';                        -- Hold a bit
begin
	combinacional: process (Qp, opt, dataIn)
	begin
          case opt is
            when "000" =>                                               -- Clear register
              Qn <= ( others => '0' );
              bn <= '0';
            when "001" =>                                               -- Hold value
              Qn <= Qp;
              bn <= bp;
            when "010" =>                                               -- Write to register
              Qn <= dataIn;
              bn <= dataIn(conv_integer(unsigned(sel)));
            
			-- Operations on bits
            when "011" =>                                               -- Clear bit
              Qn <= dataIn;
              bn <= '0';
            when "100" =>                                               -- Set bit
              Qn <= dataIn;
              bn <= '1';
            when others =>                                              -- Toggle bit
              Qn <= dataIn;
              bn <= not dataIn(conv_integer(unsigned(sel)));
			end case;
	end process;
	
	dataOut <= Qp;
  opResult <= bp;

	secuencial: process(RST,CLK)
	begin
		if(rst = '0') then
			Qp <= ( others => '0' );
		elsif( clk'event and clk = '1' ) then
			bp <= bn;
            case sel is
            when "000" =>
              Qp <= Qn( n - 1 downto 1 ) & bn;
            when "001" =>
              Qp <= Qn( n - 1 downto 2 ) & bn & Qn( 0 );
            when "010" =>
              Qp <= Qn( n - 1 downto 3 ) & bn & Qn( 1 downto 0 );
            when "011" =>
              Qp <= Qn( n - 1 downto 4 ) & bn & Qn( 2 downto 0 );
            when "100" =>
              Qp <= Qn( n - 1 downto 5 ) & bn & Qn( 3 downto 0 );
            when "101" =>
              Qp <= Qn( n - 1 downto 6 ) & bn & Qn( 4 downto 0 );
            when "110" =>
              Qp <= Qn ( n - 1 ) & bn & Qn ( 5 downto 0 );
            when others =>
              Qp <= bp & Qn( 6 downto 0 );
            end case;
		end if;
	end process;
end acum;
