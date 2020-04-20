----------------------------------------------------------------------------------
-- Company:				AAU
-- Engineer: 			EIT4-415
-- Create Date:    	15/04/2020 
-- Design Name: 	 	Central Processing Unit
-- Module Name:    	CPU - cpu - cpu_arch
-- Description:		Contains Control Unit and Data path
--							Submodule Control unit will have a load of outputs for the
--							datapath, that will take theese as inputs (for most cases)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

entity cpu is -- Portdefinition of CPU (Module)
	port (CLK			: in  std_logic; -- Clock
			RST			: in  std_logic; -- Reset
			WE				: out std_logic; -- Write enable to memoryblock
			from_memory	: in  std_logic_vector (15 downto 0);  -- Data from memory, 16 bit
			ADDR			: out std_logic_vector (15 downto 0);  -- Address to memoryblock, 16 bit
			to_memory	: out std_logic_vector (15 downto 0)); -- Data to memory, 16 bit
end entity;

architecture cpu_arch of cpu is

	component control_unit is -- Portdefinition of Control Unit (Submodule)
		port (CLK		  : in  std_logic; -- Clock
				RST		  : in  std_logic; -- Reset
				IR			  : in  std_logic_vector (15 downto 0); -- Single insctruction register, 16 bit (From Data path)
				CCR_Result : in  std_logic_vector (3 downto 0); -- 4 bit: NZVC (Neg, zero, overflow, carry) error correction holder (From Data path)
				WE			  : out std_logic; -- Write enable (To Memoryblock)
				IR_Load	  : out std_logic; -- Write data to IR register from BUS2 (To Data path)
				MAR_Load	  : out std_logic; -- Write data to MAR register from BUS2 (To Data path)
				PC_Load	  : out std_logic; -- Write data to PC register from BUS2 (To Data path)
				PC_INC     : out std_logic; -- Increment Program Counter (To Data path)
				A_Load	  : out std_logic; -- Write data to A register from BUS2 (To Data path)
				B_Load	  : out std_logic; -- Write data from B register from BUS2 (To Data path)
				CCR_Load	  : out std_logic; -- Write NZVC data to CCR_Result register (To Data path)
				BUS2_Sel	  : out std_logic_vector (1 downto 0);  -- MUX2 address selection onto BUS2, 2 bit (To Data path)
				BUS1_Sel	  : out std_logic_vector (1 downto 0);  -- MUX1 address selection onto BUS1, 2 bit (To Data path)
				ALU_Sel	  : out std_logic_vector (3 downto 0)); -- ALU operation selection, 4 bit (To Data path)
	end component;

	component data_path is -- Portdefinition of Data Path (Submodule)
		port (CLK			: in  std_logic; -- Clock
				RST			: in  std_logic; -- Reset
				IR_Load		: in  std_logic; -- Write data to IR register from BUS2 (From Control Unit)
				MAR_Load		: in  std_logic; -- Write data to MAR register from BUS2 (From Control Unit)
				PC_Load		: in  std_logic; -- Write data to PC register from BUS2 (From Control Unit))
				PC_INC		: in  std_logic; -- Increment Program Counter (From Control Unit)
				A_Load		: in  std_logic; -- Write data to A register from BUS2 (From Control Unit)
				B_Load		: in  std_logic; -- Write data from B register from BUS2 (From Control Unit)
				CCR_Load		: in  std_logic; -- Write NZVC data to CCR_Result register (From Control Unit)
				BUS2_Sel		: in  std_logic_vector (1 downto 0); -- MUX2 address selection onto BUS2, 2 bit (From Control Unit)
				BUS1_Sel		: in  std_logic_vector (1 downto 0); -- MUX1 address selection onto BUS1, 2 bit (From Control Unit)
				ALU_Sel		: in  std_logic_vector (3 downto 0); -- ALU operation selection, 4 bit (From Control Unit)
				IR				: out std_logic_vector (15 downto 0); -- Single insctruction register, 16 bit (To Control Unit)
				CCR_Result	: out std_logic_vector (3 downto 0); -- 4 bit: NZVC (Neg, zero, overflow, carry) error correction holder (To Control Unit)
				ADDR			: out std_logic_vector (15 downto 0); -- Address to memoryblock, 16 bit
				from_memory	: in  std_logic_vector (15 downto 0); -- Data from memory, 16 bit
				to_memory	: out std_logic_vector (15 downto 0)); -- Data to memory, 16 bit
	end component;
	
	-- Signals to wire data between Control Unit and Data Path
	signal IR_Load_sig	 : std_logic;
	signal MAR_Load_sig	 : std_logic;
	signal PC_Load_sig	 : std_logic;
	signal PC_INC_sig		 : std_logic;
	signal A_Load_sig		 : std_logic;
	signal B_Load_sig		 : std_logic;
	signal CCR_Load_sig 	 : std_logic;
	signal BUS2_Sel_sig 	 : std_logic_vector (1 downto 0);
	signal BUS1_Sel_sig 	 : std_logic_vector (1 downto 0);
	signal IR_sig		    : std_logic_vector (15 downto 0);
	signal CCR_Result_sig : std_logic_vector (3 downto 0);
	signal ALU_Sel_sig	 : std_logic_vector (3 downto 0);

begin

	-- Portmap definition of submodules:
	CU : control_unit
		port map (CLK => CLK,
					 RST => RST,
					 IR => IR_Load_sig,
					 CCR_Result => CCR_Result_sig,
					 WE => WE,
					 IR_Load => IR_Load_sig,
					 MAR_Load => MAR_Load_sig,
					 PC_Load => PC_Load_sig,
					 A_Load => A_Load_sig,
					 B_Load => B_Load_sig,
					 CCR_Load => CCR_Load_sig,
					 PC_INC => PC_INC_sig,
					 BUS2_Sel => BUS2_Sel_sig,
					 BUS1_Sel => BUS1_Sel_sig,
					 ALU_Sel => ALU_Sel_sig);
	DP : data_path		
		port map (CLK => CLK,
					 RST => RST,
					 IR => IR_sig,
					 CCR_Result => CCR_Result_sig,
					 IR_Load => IR_Load_sig,
					 MAR_Load => MAR_Load_sig,
					 PC_Load => PC_Load_sig,
					 A_Load => A_Load_sig,
					 B_Load => B_Load_sig,
					 CCR_Load => CCR_Load_sig,
					 PC_INC => PC_INC_sig,
					 BUS2_Sel => BUS2_Sel_sig,
					 BUS1_Sel => BUS1_Sel_sig,
					 ALU_Sel => ALU_Sel_sig,
					 ADDR => ADDR,
					 from_memory => from_memory,
					 to_memory => to_memory);
end architecture;