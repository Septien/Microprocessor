library ieee;
use ieee.std_logic_1164.all;

entity fsm_tb is
end;

architecture Bench of fsm_tb is
  signal clk, rst : std_logic := '0';
  signal flags : std_logic_vector(5 downto 0);
  signal bitOpR : std_logic;
  signal instruction : std_logic_vector(16 downto 0);

  signal addrSel, memSel : std_logic;
  signal mulS, selA : std_logic;
  signal inSel : std_logic_vector(1 downto 0);
	signal pSel : std_logic;
  signal load, inc, inc2 : std_logic;
  signal read, write : std_logic;
  signal Fn : std_logic_vector(3 downto 0);
	signal bitOp, selBit : std_logic_vector(2 downto 0);
	signal selBy : std_logic_vector(1 downto 0);
  signal opMode : std_logic_vector(1 downto 0);
    
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
  Control : FSM port map(clk, rst, flags, bitOpR, instruction, addrSel, memSel, mulS, selA, inSel, pSel, load, inc, inc2, read, write, Fn, bitOp, selBit, selBy, opMode);
  clk <= not clk after 10 ns;
  rst <= '0', '1' after 10 ns;
  instruction <= "00110000110101010";--"00011000000000000";--"01000101010101010";--"11001000010101010";--"10000001010101010";
  flags <= "000001";--, "100010" after 40 ns;
  bitOpR <= '0';
  
end Bench;