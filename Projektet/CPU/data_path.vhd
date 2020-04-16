----------------------------------------------------------------------------------
-- Company:				AAU
-- Engineer: 			EIT4-415
-- Create Date:    	15/04/2020 
-- Design Name: 	 	Data Path
-- Module Name:    	DP - data_path - Behavioral 
-- Description:		Contains all the smaller registers used for instructions
--							and operations. Is being controlled by Control Unit
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

entity data_path is
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
end entity;

architecture data_path_arch of data_path is

	component alu is -- Portdefinition of Data Path (Submodule)
		port (A			: in  std_logic_vector	(15 downto 0);
				B			: in  std_logic_vector	(15 downto 0);
				RES		: out std_logic_vector	(15 downto 0);
				ALU_Sel	: in  std_logic_vector  (3 downto 0);
				NCVC		: out std_logic_vector	(3 downto 0));
	end component;
	
	
	signal A_out    : std_logic_vector	(15 downto 0);
	signal B_out    : std_logic_vector	(15 downto 0);
	signal PC_out   : std_logic_vector	(15 downto 0);
	signal PC_uns   : unsigned(15 downto 0);
	signal BUS1     : std_logic_vector	(15 downto 0);
	signal BUS2     : std_logic_vector	(15 downto 0);
	signal RES_Sig  : std_logic_vector	(15 downto 0);
	signal MAR_out  : std_logic_vector	(15 downto 0);
	signal NZVC_sig : std_logic_vector 	(3 downto 0);
	
begin

	-- Portmap definition of subsubmodule:
	ALU_MAP : alu 	port map(B_out, BUS1, ALU_Sel, NZVC_sig, RES_Sig); 

----------------------------------------------------------------------------------
-- Bus Lines
----------------------------------------------------------------------------------
	MUX_BUS1 : process(A_out, B_out, PC_out, BUS1_Sel)
	begin
		case (BUS1_Sel) is 
			when "00" 	=> BUS1 <= PC_out;
			when "01" 	=> BUS1 <= A_out;
			when "10" 	=> BUS1 <= B_out;
			when others => BUS1 <= x"0000";
		end case;
	end process;

	MUX_BUS2 : process(BUS2_Sel, RES_Sig, BUS1, from_memory)
	begin
		case (BUS2_Sel) is 
			when "00" 	=> BUS2 <= RES_Sig;
			when "01" 	=> BUS2 <= BUS1;
			when "10" 	=> BUS2 <= from_memory;
			when others => BUS2 <= x"0000";
		end case;
	end process;

	ADDR <= MAR_out;
	to_memory <= BUS1;
	
----------------------------------------------------------------------------------
-- Registers
----------------------------------------------------------------------------------
	Instruction_Register : process (CLK, RST)
	begin
		if (RST='0') then 
			IR <= x"0000";
		elsif (rising_edge(CLK)) then
			if (IR_Load='1') then 
				IR <= BUS2;
			end if;
		end if;
	end process;

	Memory_Address_Register : process (CLK, RST)
	begin
		if (RST='0') then 
			MAR_out <= x"0000";
		elsif (rising_edge(CLK)) then
			if (MAR_Load='1') then 
				MAR_out <= BUS2;
			end if;
		end if;
	end process;

	A_register : process (CLK, RST)
	begin
		if (RST='0') then 
			A_out <= x"0000";
		elsif (rising_edge(CLK)) then
			if (A_Load='1') then 
				A_out <= BUS2;
			end if;
		end if;
	end process;

	B_register : process (CLK, RST)
	begin
		if (RST='0') then 
			B_out <= x"0000";
		elsif (rising_edge(CLK)) then
			if (B_Load='1') then 
				B_out <= BUS2;
			end if;
		end if;
	end process;

	Condition_Code_Register : process (CLK, RST)
	begin
		if (RST='0') then 
			CCR_result <= x"0";
		elsif (rising_edge(CLK)) then
			if (CCR_Load='1') then 
				CCR_result <= NZVC_sig;
			end if;
		end if;
	end process;


----------------------------------------------------------------------------------
-- PC
----------------------------------------------------------------------------------
	Program_Counter : process(CLK, RST)
	begin
		if (RST='0') then 
			PC_uns <= x"0000";
		elsif (rising_edge(CLK)) then
			if (PC_Load='1') then
				PC_uns <= unsigned(BUS2);
			elsif (PC_INC='1') then
				PC_uns <= PC_uns + 1;
			end if;
		end if;
	end process;	

	PC_out <= std_logic_vector(PC_uns);

end architecture;

