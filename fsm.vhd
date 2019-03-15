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
    inSel, pSel : out std_logic;
    -- To programm counter
    load, inc, inc2 : out std_logic;
    -- To RAM
    read, write : out std_logic;
    -- Arithmetic/logic signals
    Fn, bitOp, selBit, selBy : out std_logic;
    -- To stack
    opMode : out std_logic
  );
end FSM;

architecture control of FSM is
  type state is (S0, S1, S2, S3, S4, S5, S6, S7, S8);
  signal Qp, Qn : state;
  signal Fnaux : std_logic(3 downto 0);

  component aluFnLUT is
  port(
    opcode : in std_logic_vector(6 downto 0);
    Fn     : out std_logic_vector(3 downto 0)
  );
  end component;

begin
  AFT : aluFnLUT port map(instruction(16 downto 10), Fnaux);
  combinational : process(flags, bitOpR, instruction, Fnaux)
  begin
    case Qp is
    when S0 =>
      -- Next state
      if (instruction(16 downto 15) = "10" or instruction(16 downto 15) = "11" ) then
        Qn <= S1;
      elsif (instruction(16 downto 15) = "01") then
        Qn <= S4;
      else
        if (instruction(14 downto 12) = "001") then
          Qn <= S6
        elsif (instruction(14 downto 12) = "011" or instruction(14 downto 12) = "010" or instruction(14 downto 12) = "100") then
          Qn <= S7;
        else
          Qn <= S8;
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
      Fn <= Fnaux;
      bitOp <= "001";
      selBit <= instruction(10 downto 8);
      selBy <= "000";
      opMode <= "00";
      
    when S1 => 
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
      read <= '0';
      write <= '1';
      Fn <= Fnaux;
      bitOp <= "001";
      selBit <= "000";
      selBy <= "000";
      opMode <= "00";
      
    when S2 =>
      if (instruction(14 downto 11) = "0010") then
        Qn <= S3;
      else
        Qn <= S0;
      end if;
      -- Signals
      addrSel <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      if (instruction(14 downto 11) == "0010") then
        memSel <= '1';
        write <= '0';
        inSel <= "00";
      else
        memSel <= '0';
        write <= '1';
        inSel <= "10";
      end if;
      mulS <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      selA <= instruction(16) and instruction(15);  -- A literal will be sent to the alu/multiplier when both msb are 1.
      pSel <= '1';
      load <= '0';
      inc <= '0';
      inc2 <= '0';
      read <= '0';
      Fn <= Fnaux;
      bitOp <= "001";
      selBit <= "000";
      selBy <= "000";
      opMode <= "00";
      
    when S3 =>
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
      write <= '0';
      Fn <= Fnaux;
      bitOp <= "001";
      selBit <= "000";
      selBy <= "000";
      opMode <= "00";
  end process combinational;

  Qp <= S0 when rst = '0' else Qn when rising_edge(clk);
end control;