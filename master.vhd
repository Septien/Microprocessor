library ieee;
use ieee.std_logic_1164.all;

entity master is
  port(
    clk, rst : in std_logic;
    DP1, DP2, DP3, DP4 : out std_logic_vector(6 downto 0);
    leds : out std_logic_vector(7 downto 0)
  );
end master;

architecture micro of master is
  -- Signals
  -- Input signals to fsm
  signal flags : std_logic_vector(5 downto 0);
  signal bitOpR : std_logic;
  signal instruction : std_logic_vector(16 downto 0);
  -- To mux/demux
  signal addrSel, memSel : std_logic;
  signal mulS, selA : std_logic;
  signal inSel : std_logic_vector(1 downto 0);
	signal pSel : std_logic;
  -- To programm counter
  signal load, inc, inc2 : std_logic;
  -- To RAM
  signal read, write : std_logic;
  -- Arithmetic/logic signals
  signal Fn : std_logic_vector(3 downto 0);
	signal bitOp, selBit : std_logic_vector(2 downto 0);
	signal selBy : std_logic_vector(1 downto 0);
  -- To stack
  signal opMode : std_logic_vector(1 downto 0);
  signal muxA, C : std_logic_vector(8 downto 0);    -- Input to ALU
  signal B : std_logic_vector(7 downto 0);
  signal addrIn, addrOut : std_logic_vector(8 downto 0);  -- to the stack
  signal addrL : std_logic_vector(8 downto 0);      -- Address to load on PC
  signal outMul : std_logic_vector(7 downto 0);
  signal addrMul : std_logic_vector(8 downto 0);
  signal outputRAM : std_logic_vector(7 downto 0);
  signal outputRAMA : std_logic_vector(8 downto 0);
  signal inputRAM : std_logic_vector(7 downto 0);
  signal PCAddr : std_logic_vector(8 downto 0);
  signal result : std_logic_vector(7 downto 0);
  signal memLocSel : std_logic_vector(8 downto 0);
  -- To leds/7seg
  signal DP1A, DP2A, DP3A, DP4A, ledsA : std_logic_vector(7 downto 0);
  signal D1 : std_logic_vector(8 downto 0);
  signal literalV, addr : std_logic_vector(8 downto 0);
  
  -- Components
  component WorkingRegister is
	port(  
        rst, clk : in std_logic;
        dataIn 	 : in std_logic_vector( 7 downto 0 );
        opt 	 : in std_logic_vector( 2 downto 0 );
        sel 	 : in std_logic_vector( 2 downto 0 );                    	-- Bit to work with
        opResult : out std_logic;										-- Result of the selected operation
        dataOut  : out std_logic_vector( 7 downto 0 )
	);
  end component;

  component stack is
	port(
		clk, rst : in std_logic;
		oprMode  : in std_logic_vector(1 downto 0);	    -- Operation Mode
		addrIn   : in std_logic_vector(8 downto 0);
		addrOut  : out std_logic_vector(8 downto 0);
		emptyStack : out std_logic;
		fullStack  : out std_logic
		);
  end component;
  
  component RAM is
  generic(
	 m : integer := 8; 						-- Number of bits
	 n : integer := 2;						-- Maximum number of words
	 k : integer := 4						-- Number of words
	);
	port(
	 clk 	     : in std_logic;
	 storeAddr : in std_logic_vector(n - 1 downto 0);
	 write     : in std_logic;
	 read 	    : in std_logic;
	 dataIn 	  : in std_logic_vector(m - 1 downto 0);
	 dataOut   : out std_logic_vector(m - 1 downto 0);
	 DP1, DP2, DP3, DP4 : out std_logic_vector(m - 1 downto 0);
	 leds1 : out std_logic_vector(m - 1 downto 0)
	);
  end component;
  
  component PC is
  port(
	 clk, rst : in std_logic;
	 address : in std_logic_vector(8 downto 0);
	 inc, inc2, load : std_logic;
	 pAddress : out std_logic_vector(8 downto 0)
	);
  end component;
  
  component Multiplier_VHDL is
  port
  (
    byte1, byte2 :  in std_logic_vector(7 downto 0);
    sel 		 : in std_logic_vector( 1 downto 0 );                    -- Which byte?
    result 		 : out std_logic_vector(7 downto 0 );
	  address		 : out std_logic_vector(8 downto 0)
	);
  end component;
  
  component ALU1 is
  port (
	 -- A -> From memory / literal, B -> From working register
	 A, B : in std_logic_vector( 7 downto 0 );
	 Fn : in std_logic_vector( 3 downto 0 );
	 result : out std_logic_vector( 7 downto 0 );
	 --[ >, <, =, NEG, V, ZERO ]
	 flags : out std_logic_vector( 5 downto 0 )
	);
  end component;
  
  component mux is
  port(
    sel : in std_logic;
    input1, input2 : in std_logic_vector(8 downto 0);
    output : out std_logic_vector(8 downto 0)
  );
  end component;
  
  component mux4a1 is
  port(
    sel : in std_logic_vector(1 downto 0);
    input1, input2, input3 : in std_logic_vector(7 downto 0);
    output : out std_logic_vector(7 downto 0)
  );
  end component;
  
  component DemuxAddr is
  port(
    D1       :  in std_logic_vector(8 downto 0);
    addrSel  :  in std_logic;
    literalV :  out std_logic_vector(8 downto 0);
    addr     :  out std_logic_vector(8 downto 0)
  );
  end component;
  
  component FSM is
  port(
    clk, rst : in std_logic;
    -- Input signals
    flags : in std_logic_vector(5 downto 0);
    bitOpR : in std_logic;
    instruction : in std_logic_vector(16 downto 0);
    
    -- Output signals
    -- To mux/demux
    addrSel, memSel : out std_logic;
    mulS, selA : out std_logic;
    inSel : out std_logic_vector(1 downto 0);
	  pSel : out std_logic;
    -- To programm counter
    load, inc, inc2 : out std_logic;
    -- To RAM
    read, write : out std_logic;
    -- Arithmetic/logic signals
    Fn : out std_logic_vector(3 downto 0);
	  bitOp, selBit : out std_logic_vector(2 downto 0);
	  selBy : out std_logic_vector(1 downto 0);
    -- To stack
    opMode : out std_logic_vector(1 downto 0)
  );
  end component;
  
begin
  CTRL : FSM port map(clk, rst, flags, bitOpR, instruction, addrSel, memSel, mulS, selA, inSel, pSel, load, inc, inc2, read, write, Fn, bitOp, selBit, selBy, opMode);
  ALU  : ALU1 port map(muxA(7 downto 0), B, Fn, result, flags);
  PC1  : PC port map(clk, rst, PCAddr, inc, inc2, load);
  LIFO : stack port map(clk, rst, opMode, addrIn, addrOut, open, open);
  MRAM : RAM generic map(8, 9, 256) port map(clk, memLocSel(7 downto 0), write, read, inputRAM, outputRAM, DP1A, DP2A, DP3A, DP4A, ledsA);
  W    : WorkingRegister port map(rst, clk, outputRAM, bitOp, selBit, bitOpR, B);
  MUL  : Multiplier_VHDL port map(C(7 downto 0), B, selBy, outMul, addrMul);
  DMX  : DemuxAddr port map(D1, addrSel, literalV, addr);
  AMUX : mux port map(selA, outputRAMA, literalV, muxA);
  MMUX : mux port map(mulS, literalV, outputRAMA, C);
  MPC  : mux port map(pSel, addr, addrOut, addrL);
  MLMX : mux port map(memSel, addr, addrMul, memLocSel);
  MXIN  : mux4a1 port map(inSel, outMul, B, result, inputRAM);
   
  outputRAMA <= '0' & outputRAM; 
  -- To 7seg/leds
  DP1 <= DP1A(6 downto 0);
  DP2 <= DP2A(6 downto 0);
  DP3 <= DP3A(6 downto 0);
  DP4 <= DP4A(6 downto 0);
  leds <= ledsA;
end micro;
