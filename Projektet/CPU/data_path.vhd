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

entity data_path is
-- Port
end data_path;

architecture Behavioral of data_path is

-- component alu
	-- port
	
	-- signal

begin

	-- Portmap definition of subsubmodule:
	ALU : alu 	port map(B_out, BUS1, ALU_Sel, NZVC_sig, Result_sig); 

----------------------------------------------------------------------------------
-- Bus Lines
----------------------------------------------------------------------------------
--MUX_BUS1
--MUX_BUS2

----------------------------------------------------------------------------------
-- Registers
----------------------------------------------------------------------------------
-- IR
-- MAR
-- A
-- B
-- CCR

----------------------------------------------------------------------------------
-- PC
----------------------------------------------------------------------------------


end Behavioral;

