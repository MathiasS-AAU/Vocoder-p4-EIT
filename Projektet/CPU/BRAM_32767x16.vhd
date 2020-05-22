----------------------------------------------------------------------------------
-- Company:				AAU
-- Engineer: 			EIT4-415
-- Create Date:    	15/04/2020 
-- Design Name: 	 	Data Memory
-- Module Name:    	RAM - ram_32767x16_sync - Behavioral 
-- Description:		Random Access Memory for Read/Write
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;  
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;
Library UNISIM;
use UNISIM.vcomponents.all;
Library UNIMACRO;
use UNIMACRO.vcomponents.all;


entity BRAM_32733x16_sync is
	port(CLK	 	  : in std_logic; 							-- Clock signal
		  WE		  : in std_logic;								-- Write enable
		  ADDR	  : in std_logic_vector(15 downto 0);  -- Number of adresses
		  data_in : in std_logic_vector(15 downto 0);  -- Input data, 16 bit
		  data_out : out std_logic_vector(15 downto 0) -- Output data, 16 bit
        );
end BRAM_32733x16_sync;

--BRAM_SINGLE_MACRO : In order to incorporate this function into the design,
--     VHDL      : the following instance declaration needs to be placed
--   instance    : in the architecture body of the design code.  The
--  declaration  : (BRAM_SINGLE_MACRO_inst) and/or the port declarations
--     code      : after the "=>" assignment maybe changed to properly
--               : reference and connect this function to the design.
--               : All inputs and outputs must be connected.

--    Library    : In addition to adding the instance declaration, a use
--  declaration  : statement for the UNISIM.vcomponents library needs to be
--      for      : added before the entity declaration.  This library
--    Xilinx     : contains the component declarations for all Xilinx
--   primitives  : primitives and points to the models that will be used
--               : for simulation.

--  Copy the following four statements and paste them before the
--  Entity declaration, unless they already exist.


architecture BRAM_32733x16_sync_arch of BRAM_32733x16_sync is
	signal EN : std_ulogic; -- An internal enable that will prevent data_out assignments for addresses outside of this valid range.
	signal Sub_ADDR	   : std_logic_vector(9 downto 0);
	signal Sub_WE_0		: std_logic_vector(1 downto 0);

begin	

Sub_ADDR <= ADDR(9 downto 0);
sub_WE_0 <= WE&WE;
--  <-----Cut code below this line and paste into the architecture body---->

   -- BRAM_SINGLE_MACRO: Single Port RAM
   --                    Spartan-6
   -- Xilinx HDL Language Template, version 14.7

   -- Note -  This Unimacro model assumes the port directions to be "downto". 
   --         Simulation of this model with "to" in the port directions could lead to erroneous results.
  
   ---------------------------------------------------------------------
   --  READ_WIDTH | BRAM_SIZE | READ Depth  | ADDR Width |            --
   -- WRITE_WIDTH |           | WRITE Depth |            |  WE Width  --
   -- ============|===========|=============|============|============--
   --    19-36    |  "18Kb"   |      512    |    9-bit   |    4-bit   --
   --    10-18    |  "18Kb"   |     1024    |   10-bit   |    2-bit   --
   --    10-18    |   "9Kb"   |      512    |    9-bit   |    2-bit   --
   --     5-9     |  "18Kb"   |     2048    |   11-bit   |    1-bit   --
   --     5-9     |   "9Kb"   |     1024    |   10-bit   |    1-bit   --
   --     3-4     |  "18Kb"   |     4096    |   12-bit   |    1-bit   --
   --     3-4     |   "9Kb"   |     2048    |   11-bit   |    1-bit   --
   --       2     |  "18Kb"   |     8192    |   13-bit   |    1-bit   --
   --       2     |   "9Kb"   |     4096    |   12-bit   |    1-bit   --
   --       1     |  "18Kb"   |    16384    |   14-bit   |    1-bit   --
   --       1     |   "9Kb"   |     8192    |   13-bit   |    1-bit   --
   ---------------------------------------------------------------------

 --Med en 10 bit bred adressebus er der 1024 adresser per modul.
   BRAM_SINGLE_MACRO_inst : BRAM_SINGLE_MACRO
   generic map (
      BRAM_SIZE => "18Kb", -- Target BRAM, "9Kb" or "18Kb" 
      DEVICE => "SPARTAN6", -- Target Device: "VIRTEX5", "VIRTEX6", "SPARTAN6" 
      DO_REG => 0, -- Optional output register (0 or 1)
      INIT => X"000000000",   --  Initial values on output port
      INIT_FILE => "NONE",
      WRITE_WIDTH => 16,   -- Valid values are 1-36 (19-36 only valid when BRAM_SIZE="18Kb")
      READ_WIDTH => 16,   -- Valid values are 1-36 (19-36 only valid when BRAM_SIZE="18Kb")
      SRVAL => X"000000000",   -- Set/Reset value for port output
      WRITE_MODE => "WRITE_FIRST" -- "WRITE_FIRST", "READ_FIRST" or "NO_CHANGE" 
      -- The following INIT_xx declarations specify the initial contents of the RAM
      )

    port map (
      DO => data_out,      -- Output data, width defined by READ_WIDTH parameter
      ADDR => sub_ADDR,  -- Input address, width defined by read/write port depth
      CLK => CLK,    -- 1-bit input clock
      DI => data_in,      -- Input data port, width defined by WRITE_WIDTH parameter
      EN => EN,      -- 1-bit input RAM enable
      REGCE => '1', -- 1-bit input output register enable
      RST => '0',    -- 1-bit input reset
      WE => sub_WE_0       -- Input write enable, width defined by write port depth
   );

	ENABLE : process (ADDR)
				begin
					if (to_integer(unsigned(ADDR)) >=32768 and (to_integer(unsigned(ADDR)) <=65503)) then
						EN <= '1';		-- If 32768 <= ADDR <= 65503 then set EN to 1.
					else
						EN <='0';
					end if;
				end process;

   -- End of BRAM_SINGLE_MACRO_inst instantiation
end architecture;
				