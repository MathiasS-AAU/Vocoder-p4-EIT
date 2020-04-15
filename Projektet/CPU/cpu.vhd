library IEEE;
use IEEE.std_logic_1164.all;  
use IEEE.numeric_std.all;

entity cpu is
	port	(CLK		: in  std_logic;
		 RST		: in  std_logic;
		 WE		: out std_logic;
		 from_memory	: in  std_logic_vector (15 downto 0);
		 ADDR	: out std_logic_vector (15 downto 0);
		 to_memory	: out std_logic_vector (15 downto 0));
end entity;

architecture cpu_arch of cpu is

	component control_unit is
		port	(CLK		: in  std_logic;
			 RST		: in  std_logic;
			 IR		: in  std_logic_vector (15 downto 0);
			 CCR_Result	: in  std_logic_vector (3 downto 0);
			 WE		: out std_logic;
			 IR_Load	: out std_logic;
			 MAR_Load	: out std_logic;
			 PC_Load	: out std_logic;
	 		 PC_INC		: out std_logic;
			 A_Load		: out std_logic;
			 B_Load		: out std_logic;
			 CCR_Load	: out std_logic;
			 Bus2_SEL	: out std_logic_vector (1 downto 0);
			 Bus1_SEL	: out std_logic_vector (1 downto 0);
			 ALU_Sel	: out std_logic_vector (3 downto 0));
	end component;

	component data_path is
		port	(CLK		: in  std_logic;
		 	RST		: in  std_logic;
		 	IR_Load		: in  std_logic;
		 	MAR_Load	: in  std_logic;
		 	PC_Load		: in  std_logic;
 		 	PC_INC		: in  std_logic;
		 	A_Load		: in  std_logic;
		 	B_Load		: in  std_logic;
		 	CCR_Load	: in  std_logic;
		 	Bus2_SEL	: in  std_logic_vector (1 downto 0);
		 	Bus1_SEL	: in  std_logic_vector (1 downto 0);
		 	ALU_Sel		: in  std_logic_vector (3 downto 0);
		 	IR		: out std_logic_vector (15 downto 0);
		 	CCR_Result	: out std_logic_vector (3 downto 0);
		 	ADDR		: out std_logic_vector (15 downto 0);
		 	from_memory	: in  std_logic_vector (15 downto 0);
		 	to_memory	: out std_logic_vector (15 downto 0));   
	end component;
	
	signal IR_Load_sig	: std_logic;
	signal MAR_Load_sig	: std_logic;
	signal PC_Load_sig	: std_logic;
	signal PC_INC_sig	: std_logic;
	signal A_Load_sig	: std_logic;
	signal B_Load_sig	: std_logic;
	signal CCR_Load_sig	: std_logic;
	signal BUS2	: std_logic_vector (1 downto 0);
	signal BUS1	: std_logic_vector (1 downto 0);
	signal IR_sig	: std_logic_vector (15 downto 0);
	signal CCR_Result_sig	: std_logic_vector (3 downto 0);
	signal ALU_Sel_sig	: std_logic_vector (3 downto 0);

begin

	CU : control_unit	port map (CLK => CLK,
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
					  Bus2_SEL => BUS2,
					  Bus1_SEL => BUS1,
					  ALU_Sel => ALU_Sel_sig);

	DP : data_path		port map (CLK => CLK,
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
					  Bus2_SEL => BUS2,
					  Bus1_SEL => BUS1,
					  ALU_Sel => ALU_Sel_sig,
					  ADDR => ADDR,
					  from_memory => from_memory,
					  to_memory => to_memory);
end architecture;
