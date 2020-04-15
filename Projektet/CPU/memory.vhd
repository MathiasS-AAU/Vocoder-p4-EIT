----------------------------------------------------------------------------------
-- Company:				AAU
-- Engineer: 			EIT4-415
-- Create Date:    	15/04/2020 
-- Design Name: 	 	Memoryblock
-- Module Name:    	MEMORY - memory - memory_arch
-- Description:		Control of inside memory blocks and I/O: 
--							Data Memory (Read/write), Program Memory (Read), 
--							output (Write) and input (Read)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity memory is -- Portdefinition of memoryblock (Module)
	port (CLK			: in  std_logic; -- Clock signal
			RST			: in  std_logic; -- Reset signal
			WE				: in  std_logic; -- Write enable
			data_in		: in  std_logic_vector (15 downto 0); -- Input data, 16 bit
			ADDR			: in  std_logic_vector (15 downto 0); -- Address bus, 16 bit
			data_out	 	: out std_logic_vector (15 downto 0); -- Output data, 16 bit
			-- 16x16bit input ports:
			port_in_00  : in  std_logic_vector (15 downto 0); 
         port_in_01  : in  std_logic_vector (15 downto 0);
         port_in_02  : in  std_logic_vector (15 downto 0);
         port_in_03  : in  std_logic_vector (15 downto 0);
         port_in_04  : in  std_logic_vector (15 downto 0);
         port_in_05  : in  std_logic_vector (15 downto 0);
         port_in_06  : in  std_logic_vector (15 downto 0);               
         port_in_07  : in  std_logic_vector (15 downto 0);
         port_in_08  : in  std_logic_vector (15 downto 0);
         port_in_09  : in  std_logic_vector (15 downto 0);
         port_in_10  : in  std_logic_vector (15 downto 0);
         port_in_11  : in  std_logic_vector (15 downto 0);
         port_in_12  : in  std_logic_vector (15 downto 0);
         port_in_13  : in  std_logic_vector (15 downto 0);
         port_in_14  : in  std_logic_vector (15 downto 0);
         port_in_15	: in  std_logic_vector (15 downto 0);
			-- 16x16bit output ports:
         port_out_00 : out std_logic_vector (15 downto 0);
         port_out_01 : out std_logic_vector (15 downto 0);
         port_out_02 : out std_logic_vector (15 downto 0);
         port_out_03 : out std_logic_vector (15 downto 0);
         port_out_04 : out std_logic_vector (15 downto 0);
         port_out_05 : out std_logic_vector (15 downto 0);
         port_out_06 : out std_logic_vector (15 downto 0);
         port_out_07 : out std_logic_vector (15 downto 0);
         port_out_08 : out std_logic_vector (15 downto 0);
         port_out_09 : out std_logic_vector (15 downto 0);
         port_out_10 : out std_logic_vector (15 downto 0);
         port_out_11 : out std_logic_vector (15 downto 0);
         port_out_12 : out std_logic_vector (15 downto 0);
         port_out_13 : out std_logic_vector (15 downto 0);
         port_out_14 : out std_logic_vector (15 downto 0);
         port_out_15 : out std_logic_vector (15 downto 0));
end entity;

architecture memory_arch of memory is

	component ram_32767x16_sync is -- Portdefinition of Data Memoryblock for Read/write (Submodule)
		port (CLK		: in  std_logic; -- Clock
		      WE			: in  std_logic; -- Write enable
		      ADDR		: in  std_logic_vector(15 downto 0);  -- Adress, 16 bit
		      data_in	: in  std_logic_vector(15 downto 0);  -- Input data, 16 bit
		      data_out : out std_logic_vector(15 downto 0)); -- Output data, 16 bit
	end component;

	component rom_32733x16_sync is -- Portdefinition of Program Memoryblock for Read only (Submodule)
		port (CLK		: in  std_logic; -- Clock
		      ADDR		: in  std_logic_vector(15 downto 0);  -- Adress, 16 bit
		      data_out : out std_logic_vector(15 downto 0)); -- Output data, 16 bit
	end component;
	
	-- Signals to wire data from Program/Data Memory
	signal rom_data	: std_logic_vector (15 downto 0);
	signal ram_data	: std_logic_vector (15 downto 0);
	
begin

	-- Portmap definition of submodules for outputlogic
	ROM : rom_32733x16_sync 	port map (CLK, ADDR, rom_data);
	RAM  : ram_32767x16_sync	port map (CLK, WE, ADDR, data_in, ram_data);

	-- TODO: Outputports
	-- TODO: MUX (Process) for data out

end architecture;

