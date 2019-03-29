library ieee;
use ieee.std_logic_1164.all;

entity FSM is
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
end FSM;

architecture control of FSM is
  type state is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9);
  signal Qp, Qn : state;
  signal Fnaux : std_logic_vector(3 downto 0);
  signal skipR : std_logic;
  signal bitOpAux : std_logic_vector(2 downto 0);
  signal incA, inc2A : std_logic; 
  signal selBitA : std_logic_vector(2 downto 0);

  component aluFnLUT is
  port(
    opcode : in std_logic_vector(6 downto 0);
    Fn     : out std_logic_vector(3 downto 0)
  );
  end component;
  
  component skipReq is
	port(
	z, lt, gt, eq, b : in std_logic; 							-- Flags from the alu
	msbInstruction : in std_logic_vector(1 downto 0);
	instruction : in std_logic_vector(6 downto 0);
	inc, inc2 : out std_logic
	);
  end component;
  
  component BitOpLUT is
	port(
	instruction : in std_logic_vector(3 downto 0);
	bitOp : out std_logic_vector(2 downto 0)
	);
  end component;
  
  component selBitMux is
  port(
    instruction : in std_logic_vector(8 downto 0);
    selBit : out std_logic_vector(2 downto 0)
  );
  end component;

begin
  AFT : aluFnLUT port map(instruction(14 downto 8), Fnaux);
  --[ >, <, =, NEG, V, ZERO ]
  SKR : skipReq port map(flags(0), flags(4), flags(5), flags(3), bitOpR, instruction(16 downto 15), instruction(14 downto 8), incA, inc2A);
  BOL : BitOpLUT port map(instruction(14 downto 11), bitOpAux);
  SBM : selBitMux port map(instruction(16 downto 8), selBitA);
  combinational : process(Qp, flags, bitOpR, instruction, Fnaux, bitOpAux, incA, inc2A, selBitA)
  begin
    case Qp is
    when S0 =>																				-- Initial state
      -- Next state
      if (instruction(16 downto 15) = "10" or instruction(16 downto 15) = "11" ) then
        Qn <= S1;																			-- Arithmetic/logic operation
      elsif (instruction(16 downto 15) = "01") then
        Qn <= S4;																			-- Bit operations (w register)
      else
        if (instruction(14 downto 12) = "001") then
          Qn <= S6;																			-- CALL
        elsif (instruction(14 downto 12) = "011" or instruction(14 downto 12) = "010" or instruction(14 downto 12) = "100") then
          Qn <= S7;																			-- GOTO, RESET, NOP
        else
          Qn <= S8;																			-- RETURN, RETLW
        end if;
      end if;
      -- Signals
      addrSel <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      memSel <= '0';
      mulS <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      selA <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      inSel <= "11";
      pSel <= '1';
      load <= '0';
      inc <= '0';
      inc2 <= '0';
      read <= instruction(16) xor instruction(15);
      write <= '0';
      Fn <= "----";
      bitOp <= "001";
      selBit <= selBitA;
      selBy <= "00";
      opMode <= "00";
      
    -- States 1 to 3: for ALU and multiplier operations
	when S1 =>												-- Load from memory and perform operation
      -- Unconditional state; load from memory
      Qn <= S2;
      -- Signals
      addrSel <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      memSel <= '0';
      mulS <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      selA <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      inSel <= "10";
      pSel <= '1';
      load <= '0';
      inc <= '0';
      inc2 <= '0';
      read <= instruction(16) xor instruction(15);
	    write <= '0';
	    bitOp <= "001";
      Fn <= Fnaux;
      selBit <= "000";
      selBy <= "00";
      opMode <= "00";
      
    when S2 =>				-- Store result back on memory/w register
      if (instruction(14 downto 11) = "0010") then		-- 0010 -> Multiplication
        Qn <= S3;
      else
        Qn <= S0;
      end if;
      -- Signals
      addrSel <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      if (instruction(14 downto 11) = "0010") then
        memSel <= '1';
        write <= '0';
        inSel <= "00";
		    bitOp <= "001";
		    selBy <= "01";
      else
		    selBy <= "00";
        memSel <= '0';
		    -- Check if d = 1
		    if (instruction(14 downto 8) = "1111111" or instruction(14 downto 8) = "1111011") then    --movf
		      write <= '1';
		      bitOp <= "010";
		      inSel <= "10";
		    elsif (instruction(14 downto 8) = "1111001") then  --movlw
		      write <= '0';
		      bitOp <= "010";
		      inSel <= "11";
		    elsif (instruction(14 downto 8) = "1111010") then   --movwf
		      write <= '1';
		      bitOp <= "001";
		      inSel <= "01";
		    elsif (instruction(10) = '0') then
		      write <= '0';
		      bitOp <= "010";
		      inSel <= "11";
		     else
		      write <= '1';
		  	   bitOp <= "001";
		  	   inSel <= "10";
		     end if;
      end if;
      inc <= incA;
		  inc2 <= inc2A;
      mulS <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      selA <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      pSel <= '1';
      load <= '0';
      read <= instruction(16) xor instruction(15);
      Fn <= Fnaux;
      selBit <= "000";
      opMode <= "00";
      
    when S3 =>						-- Is multiplication, store second byte
      Qn <= S0;
      addrSel <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      memSel <= '0';
      mulS <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      selA <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      inSel <= "10";
      pSel <= '1';
      load <= '0';
      inc <= '1';
      inc2 <= '0';
      read <= '0';
      write <= '1';
      Fn <= Fnaux;
      bitOp <= "001";
      selBit <= "000";
      selBy <= "10";
      opMode <= "00";
	
	-- Operations with bits (toggle, set, clear)
	when S4 =>														-- Load on w
	  Qn <= S5;
	  -- Signals
      addrSel <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      memSel <= '0';
      mulS <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      selA <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      inSel <= "11";
      pSel <= '1';
      load <= '0';
      inc <= '0';
      inc2 <= '0';
      read <= '1';
      write <= '0';
      Fn <= "----";
      bitOp <= bitOpAux;
      selBit <= instruction(10 downto 8);
      selBy <= "00";
      opMode <= "00";
	
	when S5 =>								-- Write result back
		Qn <= S0;
	  addrSel <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      memSel <= '0';
      mulS <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      selA <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      inSel <= "01";
      pSel <= '1';
      load <= '0';
  	   inc <= incA;
		  inc2 <= inc2A;
      read <= '0';
      write <= '1';
      Fn <= "----";
      bitOp <= bitOpAux;
      selBit <= instruction(10 downto 8);
      selBy <= "00";
      opMode <= "00";
	
	-- CALL command
	when S6 =>									-- Push on stack
	  Qn <= S7;
	  -- Signals
      addrSel <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      memSel <= '0';
      mulS <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      selA <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      inSel <= "11";
      pSel <= '0';
      load <= '0';
      inc <= '0';
      inc2 <= '0';
      read <= '0';
      write <= '0';
      Fn <= "----";
      bitOp <= "001";
      selBit <= "000";
      selBy <= "00";
      opMode <= "10";
	
	-- GOTO, RESET, NOP
	when S7 => 						-- Load address/increase
	  Qn <= S0;
     -- Signals
      addrSel <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      memSel <= '0';
      mulS <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      selA <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      inSel <= "11";
      pSel <= '0';
	  if (instruction(14 downto 11) = "0110") then -- NOP
		  load <= '0';
		  inc <= '1';
	  else
		  load <= '1';
      	inc <= '0';
	  end if;
      inc2 <= '0';
      read <= '0';
      write <= '0';
      Fn <= "0010";
      bitOp <= "001";
      selBit <= "000";
      selBy <= "00";
      opMode <= "00";
  
  -- RETURN, RETLW
  when S8 =>      -- Pop from stack  
    Qn <= S9;
	  -- Signals
	  if (instruction(14 downto 11) = "1010") then		-- RETLW
		  addrSel <= '1';
		  selA <= '1';
		  Fn <= "1000";
		  bitOp <= "010";
	  else
		  addrSel <= '0';
		  selA <= '0';
		  Fn <= "----";
		  bitOp <= "001";
	  end if;
      memSel <= '0';
      mulS <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      inSel <= "11";
      pSel <= '1';
      load <= '1';
      inc <= '0';
      inc2 <= '0';
      read <= '0';
      write <= '0';
      selBit <= "000";
      selBy <= "00";
      opMode <= "00";
    
	
	when S9 =>         -- increase pc
	  Qn <= S0;
	  -- Signals
      addrSel <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      memSel <= '0';
      mulS <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      selA <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      inSel <= "11";
      pSel <= '1';
      load <= '0';
      inc <= '1';
      inc2 <= '0';
      read <= '0';
      write <= '0';
      Fn <= "----";
      bitOp <= "001";
      selBit <= "000";
      selBy <= "00";
      opMode <= "01";

	end case;	  
  end process combinational;

  Qp <= S0 when rst = '0' else Qn when rising_edge(clk);
end control;