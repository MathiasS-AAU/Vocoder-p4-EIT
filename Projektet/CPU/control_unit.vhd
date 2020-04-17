----------------------------------------------------------------------------------
-- Company:				AAU
-- Engineer: 			EIT4-415
-- Create Date:    	15/04/2020 
-- Design Name: 	 	Control Unit
-- Module Name:    	CU - control_unit - Behavioral 
-- Description:		The Finite State Machine controlling the data path and
--							memory, based on hardcoded instructions
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;

entity control_unit is
	port (CLK		  : in  std_logic;
			RST		  : in  std_logic;
			IR			  : in  std_logic_vector (15 downto 0);
			CCR_Result : in  std_logic_vector (3 downto 0);
			WE			  : out std_logic;
			IR_Load	  : out std_logic;
			MAR_Load	  : out std_logic;
			PC_Load	  : out std_logic;
			PC_INC	  : out std_logic;
			A_Load	  : out std_logic;
			B_Load	  : out std_logic;
			CCR_Load	  : out std_logic;
			BUS2_Sel	  : out std_logic_vector (1 downto 0);
			BUS1_Sel	  : out std_logic_vector (1 downto 0);
			ALU_Sel	  : out std_logic_vector (4 downto 0));
end entity;

architecture control_unit_arch of control_unit is

type state_type is (
	-- LOAD/STORE:
	S_FETCH_0, S_FETCH_1, S_FETCH_2, S_DECODE_3,
	S_LDA_IMM_4, S_LDA_IMM_5, S_LDA_IMM_6,
	S_LDA_DIR_4, S_LDA_DIR_5, S_LDA_DIR_6, S_LDA_DIR_7, S_LDA_DIR_8,
	S_LDB_IMM_4, S_LDB_IMM_5, S_LDB_IMM_6,
	S_LDB_DIR_4, S_LDB_DIR_5, S_LDB_DIR_6, S_LDB_DIR_7, S_LDB_DIR_8,
	S_STA_DIR_4, S_STA_DIR_5, S_STA_DIR_6, S_STA_DIR_7,
	S_STB_DIR_4, S_STB_DIR_5, S_STB_DIR_6, S_STB_DIR_7,
	-- DATA MANIP:
	S_ADD_AB_4,
	S_ADD_AB_4,
	S_ADD_BA_4,
	S_MUL_AB_4,
	S_DIV_AB_4,
	S_DIV_BA_4,
	S_AND_AB_4,
	S_OR_AB_4,
	S_NOT_A_4,
	-- Branches/Jump
	S_BRA_4, S_BRA_5, S_BRA_6,
	S_BNT_4, S_BNT_5, S_BNT_6, S_BNT_7,
	S_BNF_4, S_BNF_5, S_BNF_6, S_BNF_7,
	S_BZT_4, S_BZT_5, S_BZT_6, S_BZT_7,
	S_BZF_4, S_BZF_5, S_BZF_6, S_BZF_7,
	S_BVT_4, S_BVT_5, S_BVT_6, S_BVT_7,
	S_BVF_4, S_BVF_5, S_BVF_6, S_BVF_7,
	S_BCT_4, S_BCT_5, S_BCT_6, S_BCT_7,
	S_BCF_4, S_BCF_5, S_BCF_6, S_BCF_7);

	--State logic
	signal current_state, next_state : state_type;

	--Load and store Mnemonics
	constant LDA_IMM : std_logic_vector(15 downto 0) :=x"0001"; -- Load A using immediate addressing
	constant LDA_DIR : std_logic_vector(15 downto 0) :=x"0002";	-- Load A using direct addressing
	constant LDB_IMM : std_logic_vector(15 downto 0) :=x"0003"; -- Load B using immediate addressing
	constant LDB_DIR : std_logic_vector(15 downto 0) :=x"0004"; -- Load B using direct addressing
	constant STA_DIR : std_logic_vector(15 downto 0) :=x"0005"; -- Store A using direct addressing
	constant STB_DIR : std_logic_vector(15 downto 0) :=x"0006";	-- Store B using direct addressing
	
	--Data manipulation
	constant ADD_AB : std_logic_vector(15 downto 0) :=x"0007"; -- Add A and B and store the result in A
	constant SUB_AB : std_logic_vector(15 downto 0) :=x"0008"; -- Subtract A with B and store the result in A
	constant SUB_BA : std_logic_vector(15 downto 0) :=x"0009"; -- Subtract B with A and store the result in A
	constant MUL_AB : std_logic_vector(15 downto 0) :=x"000A"; -- Multiply A and B and store the result in A
	constant DIV_AB : std_logic_vector(15 downto 0) :=x"000B"; -- Divide A with B and store the result in A
	constant DIV_BA : std_logic_vector(15 downto 0) :=x"000C"; -- Divide B with A and store the result in A
	constant AND_AB : std_logic_vector(15 downto 0) :=x"000D"; -- AND operation with A and B and store the result in A
	constant OR_AB  : std_logic_vector(15 downto 0) :=x"000E"; -- OR operation with A and B and store the result in A
	constant NOT_A  : std_logic_vector(15 downto 0) :=x"000F"; -- Invert A and store the result in A
	
	--Branches
	constant BRA : std_logic_vector(15 downto 0) :=x"0010"; -- Branch always, unconditional jump 
	constant BNT : std_logic_vector(15 downto 0) :=x"0011"; -- Branch if N flag is high, conditional jump 
	constant BNF : std_logic_vector(15 downto 0) :=x"0012"; -- Branch if N flag is low, conditional jump 
	constant BZT : std_logic_vector(15 downto 0) :=x"0013"; -- Branch if Z flag is high, conditional jump 
	constant BZF : std_logic_vector(15 downto 0) :=x"0014"; -- Branch if Z flag is low, conditional jump 
	constant BVT : std_logic_vector(15 downto 0) :=x"0015"; -- Branch if V flag is high, conditional jump 
	constant BVF : std_logic_vector(15 downto 0) :=x"0016"; -- Branch if V flag is low, conditional jump 
	constant BCT : std_logic_vector(15 downto 0) :=x"0017"; -- Branch if C flag is high, conditional jump 
	constant BCF : std_logic_vector(15 downto 0) :=x"0018"; -- Branch if C flag is low, conditional jump 

begin

----------------------------------------------------------------------------------
-- State Memory
----------------------------------------------------------------------------------
	STATE_MEMORY : process (CLK, RST)
		begin
			if (Reset = '0') then
				current_state <= S_FETCH_0;
			elsif (rising_edge (clock)) then
				current_state <= next_state;
			end if;
		end process;

----------------------------------------------------------------------------------
-- Next state logic
----------------------------------------------------------------------------------
	NEXT_STATE_LOGIC : process (current_state, IR, CCR_Result)
	begin
		if (current_state = S_FETCH_0) then
			next_state <= S_FETCH_1;
		elsif (current_state = S_FETCH_1) then
			next_state <= S_FETCH_2;
		elsif (current_state = S_FETCH_2) then
			next_state <= S_DECODE_3;
		
		elsif (current_state = S_DECODE_3) then
		
			-- LOAD/STORE
			if (IR = LDA_IMM) then
				next_state <= S_LDA_IMM_4;
			elsif (IR = LDA_DIR) then
				next_state <= S_LDA_DIR_4;
			elsif (IR = LDB_IMM) then
				next_state <= S_LDB_IMM_4;
			elsif (IR = LDB_DIR) then
				next_state <= S_LDB_DIR_4;
			elsif (IR = STA_DIR) then
				next_state <= S_STA_DIR_4;
			elsif (IR = STB_DIR) then
				next_state <= S_STB_DIR_4;
			-- DATA MANIP.
			elsif (IR = ADD_AB) then
				next_state <= S_ADD_AB_4;
			elsif (IR = SUB_AB) then
				next_state <= S_SUB_AB_4;
			elsif (IR = SUB_BA) then
				next_state <= S_SUB_BA_4;
			elsif (IR = MUL_AB) then
				next_state <= S_MUL_AB_4;
			elsif (IR = DIV_AB) then
				next_state <= S_DIV_AB_4;
			elsif (IR = DIV_BA) then
				next_state <= S_DIV_BA_4;
			elsif (IR = AND_AB) then
				next_state <= S_AND_AB_4;
			elsif (IR = OR_AB) then
				next_state <= S_OR_AB_4;
			elsif (IR = NOT_A) then
				next_state <= S_NOT_A_4;
			-- BRANCHES/JUMP
			elsif (IR = BRA) then
				next_state <= S_BRA_AB_4; 
				
			elsif (IR = BNT and CCR_Result(3) = '1') then
				next_state <= S_BNT_4;
			elsif (IR = BNT and CCR_Result(3) = '0') then
				next_state <= S_BNT_7;
				
			elsif (IR = BNF and CCR_Result(3) = '0') then
				next_state <= S_BNF_4;
			elsif (IR = BNF and CCR_Result(3) = '1') then
				next_state <= S_BNF_7;
				
			elsif (IR = BZT and CCR_Result(2) = '1') then
				next_state <= S_BZT_4;
			elsif (IR = BZT and CCR_Result(2) = '0') then
				next_state <= S_BZT_7;
				
			elsif (IR = BZF and CCR_Result(2) = '0') then
				next_state <= S_BZF_4;
			elsif (IR = BZF and CCR_Result(2) = '1') then
				next_state <= S_BZF_7;
				
			elsif (IR = BVT and CCR_Result(1) = '1') then
				next_state <= S_BVT_4;
			elsif (IR = BVT and CCR_Result(1) = '0') then
				next_state <= S_BVT_7;
				
			elsif (IR = BVF and CCR_Result(1) = '0') then
				next_state <= S_BVF_4;
			elsif (IR = BVF and CCR_Result(1) = '1') then
				next_state <= S_BVF_7;
				
			elsif (IR = BCT and CCR_Result(0) = '1') then
				next_state <= S_BCT_4;
			elsif (IR = BCT and CCR_Result(0) = '0') then
				next_state <= S_BCT_7;
				
			elsif (IR = BCF and CCR_Result(0) = '0') then
				next_state <= S_BCF_4;
			elsif (IR = BCF and CCR_Result(0) = '1') then
				next_state <= S_BCF_7;
				
			else
				next_state <= S_FETCH_0;
			end if;
			
	-- LOAD/STORE
		-- LDA_IMM
		elsif (current_state = S_LDA_IMM_4) then
			next_state <= S_LDA_IMM_5;
		elsif (current_state = S_LDA_IMM_5) then
			next_state <= S_LDA_IMM_6;
		elsif (current_state = S_LDA_IMM_6) then
			next_state <= S_FETCH_0;
		
		-- LDA_DIR
		elsif (current_state = S_LDA_DIR_4) then
			next_state <= S_LDA_DIR_5;
		elsif (current_state = S_LDA_DIR_5) then
			next_state <= S_LDA_DIR_6;
		elsif (current_state = S_LDA_DIR_6) then
			next_state <= S_LDA_DIR_7;
		elsif (current_state = S_LDA_DIR_7) then
			next_state <= S_LDA_DIR_8;
		elsif (current_state = S_LDA_DIR_8) then
			next_state <= S_FETCH_0;
			
		-- LDB_IMM
		elsif (current_state = S_LDB_IMM_4) then
			next_state <= S_LDB_IMM_5;
		elsif (current_state = S_LDB_IMM_5) then
			next_state <= S_LDB_IMM_6;
		elsif (current_state = S_LDB_IMM_6) then
			next_state <= S_FETCH_0;
		
		-- LDB_DIR
		elsif (current_state = S_LDB_DIR_4) then
			next_state <= S_LDB_DIR_5;
		elsif (current_state = S_LDB_DIR_5) then
			next_state <= S_LDB_DIR_6;
		elsif (current_state = S_LDB_DIR_6) then
			next_state <= S_LDB_DIR_7;
		elsif (current_state = S_LDB_DIR_7) then
			next_state <= S_LDB_DIR_8;
		elsif (current_state = S_LDB_DIR_8) then
			next_state <= S_FETCH_0;
		
		-- STA_DIR
		elsif (current_state = S_STA_DIR_4) then
			next_state <= S_STA_DIR_5;
		elsif (current_state = S_STA_DIR_5) then
			next_state <= S_STA_DIR_6;
		elsif (current_state = S_STA_DIR_6) then
			next_state <= S_STA_DIR_7;
		elsif (current_state = S_STA_DIR_7) then
			next_state <= S_FETCH_0;
		
		-- STB_DIR
		elsif (current_state = S_STB_DIR_4) then
			next_state <= S_STB_DIR_5;
		elsif (current_state = S_STB_DIR_5) then
			next_state <= S_STB_DIR_6;
		elsif (current_state = S_STB_DIR_6) then
			next_state <= S_STB_DIR_7;
		elsif (current_state = S_STB_DIR_7) then
			next_state <= S_FETCH_0;
			
	-- DATA MANIP
		elsif (current_state = S_ADD_AB_4) then
			next_state <= S_FETCH_0;
		elsif (current_state = S_SUB_AB_4) then
			next_state <= S_FETCH_0;
		elsif (current_state = S_SUB_BA_4) then
			next_state <= S_FETCH_0;
		elsif (current_state = S_MUL_AB_4) then
			next_state <= S_FETCH_0;
		elsif (current_state = S_DIV_AB_4) then
			next_state <= S_FETCH_0;
		elsif (current_state = S_DIV_BA_4) then
			next_state <= S_FETCH_0;
		elsif (current_state = S_AND_AB_4) then
			next_state <= S_FETCH_0;
		elsif (current_state = S_OR_AB_4) then
			next_state <= S_FETCH_0;
		elsif (current_state = S_NOT_A_4) then
			next_state <= S_FETCH_0;				

	-- BRANCHES/JUMP
		-- BRA
		elsif (current_state = S_BRA_4) then
			next_state <= S_BRA_5;
		elsif (current_state = S_BRA_5) then
			next_state <= S_BRA_6;
		elsif (current_state = S_BRA_6) then
			next_state <= S_FETCH_0;
			
		-- BNT
		elsif (current_state = S_BNT_4) then
			next_state <= S_BNT_5;
		elsif (current_state = S_BNT_5) then
			next_state <= S_BNT_6;
		elsif (current_state = S_BNT_6) then
			next_state <= S_FETCH_0;
		elsif (current_state = S_BNT_7) then
			next_state <= S_FETCH_0;
			
		-- BNF
		elsif (current_state = S_BNF_4) then
			next_state <= S_BNF_5;
		elsif (current_state = S_BNF_5) then
			next_state <= S_BNF_6;
		elsif (current_state = S_BNF_6) then
			next_state <= S_FETCH_0;
		elsif (current_state = S_BNF_7) then
			next_state <= S_FETCH_0;

		-- BZT
		elsif (current_state = S_BZT_4) then
			next_state <= S_BZT_5;
		elsif (current_state = S_BZT_5) then
			next_state <= S_BZT_6;
		elsif (current_state = S_BZT_6) then
			next_state <= S_FETCH_0;
		elsif (current_state = S_BZT_7) then
			next_state <= S_FETCH_0;
			
		-- BZF
		elsif (current_state = S_BZF_4) then
			next_state <= S_BZF_5;
		elsif (current_state = S_BZF_5) then
			next_state <= S_BZF_6;
		elsif (current_state = S_BZF_6) then
			next_state <= S_FETCH_0;
		elsif (current_state = S_BZF_7) then
			next_state <= S_FETCH_0;
			
		-- BVT
		elsif (current_state = S_BVT_4) then
			next_state <= S_BVT_5;
		elsif (current_state = S_BVT_5) then
			next_state <= S_BVT_6;
		elsif (current_state = S_BVT_6) then
			next_state <= S_FETCH_0;
		elsif (current_state = S_BVT_7) then
			next_state <= S_FETCH_0;		
		
		-- BVF
		elsif (current_state = S_BVF_4) then
			next_state <= S_BVF_5;
		elsif (current_state = S_BVF_5) then
			next_state <= S_BVF_6;
		elsif (current_state = S_BVF_6) then
			next_state <= S_FETCH_0;
		elsif (current_state = S_BVF_7) then
			next_state <= S_FETCH_0;
		
		-- BCT
		elsif (current_state = S_BCT_4) then
			next_state <= S_BCT_5;
		elsif (current_state = S_BCT_5) then
			next_state <= S_BCT_6;
		elsif (current_state = S_BCT_6) then
			next_state <= S_FETCH_0;
		elsif (current_state = S_BCT_7) then
			next_state <= S_FETCH_0;	
		
		-- BCF
		elsif (current_state = S_BCF_4) then
			next_state <= S_BCF_5;
		elsif (current_state = S_BCF_5) then
			next_state <= S_BCF_6;
		elsif (current_state = S_BCF_6) then
			next_state <= S_FETCH_0;
		elsif (current_state = S_BCF_7) then
			next_state <= S_FETCH_0;
		end if;
	end process;
		
----------------------------------------------------------------------------------
-- Output logic
----------------------------------------------------------------------------------
	OUTPUT_LOGIC : process(current_state)
	begin
		case (current_state) is
			when S_FETCH_0 =>
				IR_Load 	<= '0';
				MAR_Load <= '1';
				PC_Load 	<= '0';
				PC_INC 	<= '0';
				A_Load 	<= '0';
				B_Load 	<= '0';
				ALU_Sel 	<= "0000";
				CCR_Load <= '0';
				BUS1_Sel <= "00";
				BUS2_Sel <= "01";
				WE 		<= '0';
			when S_FETCH_1 =>
				IR_Load 	<= '0';
				MAR_Load <= '0';
				PC_Load 	<= '0';
				PC_INC 	<= '1';
				A_Load 	<= '0';
				B_Load 	<= '0';
				ALU_Sel 	<= "0000";
				CCR_Load <= '0';
				BUS1_Sel <= "00";
				BUS2_Sel <= "00";
				WE 		<= '0';
			when S_FETCH_2 =>
				IR_Load 	<= '1';
				MAR_Load <= '0';
				PC_Load 	<= '0';
				PC_INC 	<= '0';
				A_Load 	<= '0';
				B_Load 	<= '0';
				ALU_Sel 	<= "0000";
				CCR_Load <= '0';
				BUS1_Sel <= "00";
				BUS2_Sel <= "10";
				WE 		<= '0';
			when S_DECODE_3 =>
				IR_Load 	<= '0';
				MAR_Load <= '0';
				PC_Load 	<= '0';
				PC_INC 	<= '0';
				A_Load 	<= '0';
				B_Load 	<= '0';
				ALU_Sel 	<= "0000";
				CCR_Load <= '0';
				BUS1_Sel <= "00";
				BUS2_Sel <= "00";
				WE 		<= '0';
			end case;
	end process;
end architecture;

