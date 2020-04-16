----------------------------------------------------------------------------------
-- Company:				AAU
-- Engineer: 			EIT4-415
-- Create Date:    	15/04/2020 
-- Design Name: 	 	Computer
-- Module Name:    	computer - computer_arch
-- Description:		Contains CPU and Memory, wirering everything together and 
--							portmapping modules
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

entity computer is -- Portdefinition of computer (Overmodule)
	port (CLK           	: in   std_logic; -- Clock
			RST          	: in   std_logic; -- Reset
			-- 16x16bit input ports:
			port_in_00     : in  std_logic_vector (15 downto 0); 
         port_in_01     : in  std_logic_vector (15 downto 0);
         port_in_02     : in  std_logic_vector (15 downto 0);
         port_in_03     : in  std_logic_vector (15 downto 0);
         port_in_04     : in  std_logic_vector (15 downto 0);
         port_in_05     : in  std_logic_vector (15 downto 0);
         port_in_06     : in  std_logic_vector (15 downto 0);               
         port_in_07     : in  std_logic_vector (15 downto 0);
         port_in_08     : in  std_logic_vector (15 downto 0);
         port_in_09     : in  std_logic_vector (15 downto 0);
         port_in_10     : in  std_logic_vector (15 downto 0);
         port_in_11     : in  std_logic_vector (15 downto 0);
         port_in_12     : in  std_logic_vector (15 downto 0);
         port_in_13     : in  std_logic_vector (15 downto 0);
         port_in_14     : in  std_logic_vector (15 downto 0);
         port_in_15     : in  std_logic_vector (15 downto 0);                                                                   
         -- 16x16bit output ports:
			port_out_00    : out std_logic_vector (15 downto 0); 
         port_out_01    : out std_logic_vector (15 downto 0);
         port_out_02    : out std_logic_vector (15 downto 0);
         port_out_03    : out std_logic_vector (15 downto 0);
         port_out_04    : out std_logic_vector (15 downto 0);
         port_out_05    : out std_logic_vector (15 downto 0);
         port_out_06    : out std_logic_vector (15 downto 0);
         port_out_07    : out std_logic_vector (15 downto 0);
         port_out_08    : out std_logic_vector (15 downto 0);
         port_out_09    : out std_logic_vector (15 downto 0);
         port_out_10    : out std_logic_vector (15 downto 0);
         port_out_11    : out std_logic_vector (15 downto 0);
         port_out_12    : out std_logic_vector (15 downto 0);
         port_out_13    : out std_logic_vector (15 downto 0);
         port_out_14    : out std_logic_vector (15 downto 0);
         port_out_15    : out std_logic_vector (15 downto 0));
end entity;

architecture computer_arch of computer is

	component cpu is -- Portdefinition of CPU (Module)
		port (CLK			: in  std_logic; -- Clock
				RST			: in  std_logic; -- Reset
				WE				: out std_logic; -- Write enable
				from_memory	: in  std_logic_vector (15 downto 0);  -- Data from memoryblock, 16 bit
				ADDR			: out std_logic_vector (15 downto 0);  -- Address for dataselection, 16 bit
				to_memory	: out std_logic_vector (15 downto 0)); -- Data to memoryblock, 16 bit
	end component;

	component memory is -- Portdefinition of Memory (Module)
		port	(CLK				 : in  std_logic;	-- Clock signal
			 RST				 : in  std_logic;	-- Reset signal
			 WE				 : in  std_logic; -- Write enable
			 data_in			 : in  std_logic_vector (15 downto 0); -- Input data, 16 bit
			 ADDR				 : in  std_logic_vector (15 downto 0); -- Address bus, 16 bit
			 data_out		 : out std_logic_vector (15 downto 0); -- Output data, 16 bit
			 -- 16x16bit input ports:
			 port_in_00     : in  std_logic_vector (15 downto 0);
          port_in_01     : in  std_logic_vector (15 downto 0);
          port_in_02     : in  std_logic_vector (15 downto 0);
          port_in_03     : in  std_logic_vector (15 downto 0);
          port_in_04     : in  std_logic_vector (15 downto 0);
          port_in_05     : in  std_logic_vector (15 downto 0);
          port_in_06     : in  std_logic_vector (15 downto 0);               
          port_in_07     : in  std_logic_vector (15 downto 0);
          port_in_08     : in  std_logic_vector (15 downto 0);
          port_in_09     : in  std_logic_vector (15 downto 0);
          port_in_10     : in  std_logic_vector (15 downto 0);
          port_in_11     : in  std_logic_vector (15 downto 0);
          port_in_12     : in  std_logic_vector (15 downto 0);
          port_in_13     : in  std_logic_vector (15 downto 0);
          port_in_14     : in  std_logic_vector (15 downto 0);
          port_in_15     : in  std_logic_vector (15 downto 0); 
			 -- 16x16bit output ports:
          port_out_00    : out std_logic_vector (15 downto 0); 
          port_out_01    : out std_logic_vector (15 downto 0);
          port_out_02    : out std_logic_vector (15 downto 0);
          port_out_03    : out std_logic_vector (15 downto 0);
          port_out_04    : out std_logic_vector (15 downto 0);
          port_out_05    : out std_logic_vector (15 downto 0);
          port_out_06    : out std_logic_vector (15 downto 0);
          port_out_07    : out std_logic_vector (15 downto 0);
          port_out_08    : out std_logic_vector (15 downto 0);
          port_out_09    : out std_logic_vector (15 downto 0);
          port_out_10    : out std_logic_vector (15 downto 0);
          port_out_11    : out std_logic_vector (15 downto 0);
          port_out_12    : out std_logic_vector (15 downto 0);
          port_out_13    : out std_logic_vector (15 downto 0);
          port_out_14    : out std_logic_vector (15 downto 0);
          port_out_15    : out std_logic_vector (15 downto 0));
	end component;
	
	-- Signals to wire data between CPU and memory
	signal ADDR_sig : std_logic_vector (15 downto 0);
	signal WE_sig	 : std_logic;
	signal in_sig	 : std_logic_vector (15 downto 0);
	signal out_sig	 : std_logic_vector (15 downto 0);

begin

	-- Portmap definition of modules:
	CPU : cpu	port map (CLK => CLK, RST => RST, ADDR => ADDR_sig, WE => WE_sig, to_memory => in_sig, from_memory => out_sig);
	MEMORY : memory	port map (CLK => CLK, RST => RST, ADDR => ADDR_sig, WE => WE_sig, data_in => in_sig, data_out => out_sig,
				  port_in_00 => port_in_00,
				  port_in_01 => port_in_01,
				  port_in_02 => port_in_02,
				  port_in_03 => port_in_03,
				  port_in_04 => port_in_04,
				  port_in_05 => port_in_05,
				  port_in_06 => port_in_06,
				  port_in_07 => port_in_07,
				  port_in_08 => port_in_08,
				  port_in_09 => port_in_09,
				  port_in_10 => port_in_10,
				  port_in_11 => port_in_11,
				  port_in_12 => port_in_12,
				  port_in_13 => port_in_13,
				  port_in_14 => port_in_14,
				  port_in_15 => port_in_15,
				  port_out_00 => port_out_00,
				  port_out_01 => port_out_01,
				  port_out_02 => port_out_02,
				  port_out_03 => port_out_03,
				  port_out_04 => port_out_04,
				  port_out_05 => port_out_05,
				  port_out_06 => port_out_06,
				  port_out_07 => port_out_07,
				  port_out_08 => port_out_08,
				  port_out_09 => port_out_09,
				  port_out_10 => port_out_10,
				  port_out_11 => port_out_11,
				  port_out_12 => port_out_12,
				  port_out_13 => port_out_13,
				  port_out_14 => port_out_14,
				  port_out_15 => port_out_15);

end architecture;