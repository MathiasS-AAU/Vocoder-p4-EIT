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

begin

end architecture;

