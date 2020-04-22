----------------------------------------------------------------------------------
-- Company:				AAU
-- Engineer: 			EIT4-415
-- Create Date:    	15/04/2020 
-- Design Name: 	 	Arithmetic Logic Unit
-- Module Name:    	ALU - ALU - Behavioral
-- Description:		A signal from control unit will determine which operation
--							to execute
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;  
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

entity alu is
	port (B		  : in  std_logic_vector (15 downto 0);
			A		  : in  std_logic_vector (15 downto 0);
			ALU_Sel : in  std_logic_vector (3 downto 0);
			NZVC	  : out std_logic_vector (3 downto 0);
			Result  : out std_logic_vector (15 downto 0));
end entity;

architecture alu_arch of alu is

	

begin

	Operations : process (A)
		
		variable Sum_uns	:	unsigned(16 downto 0);
		
		begin
		
----------------------------------------------------------------------------------
-- Sum calculation
----------------------------------------------------------------------------------
		if(ALU_Sel = "0000") then
			Sum_uns := unsigned('0' & A) + unsigned('0' & B);
			Result  <= std_logic_vector(Sum_uns(16 downto 0));
			
			NZVC(3) <= Sum_uns(15);
			
			if(Sum_uns(15 downto 0) = x"0000") then
				NZVC(2) <= '1';
			else
				NZVC(2) <= '0';
			end if;
			
			if((A(15)='0' and B(15)='0' and Sum_uns(15)='1') or 
				(A(15)='1' and B(15)='1' and Sum_uns(15)='0')) then
				NZVC(1) <= '1';
			else
				NZVC(1) <= '0';
			end if;
			
			NZVC(0) <= Sum_uns(16);
		elsif(ALU_Sel = "0000") then -- ADD_AB
			Result <= A + B;
			NZVC <= x"0";
		elsif(ALU_Sel = "0001") then -- SUB_AB
			Result <= A - B;
			NZVC <= x"0";
		elsif(ALU_Sel = "0010") then -- SUB_BA
			Result <= B - A;
			NZVC <= x"0";
		elsif(ALU_Sel = "0011") then -- MUL_AB
			Result <= std_logic_vector(to_unsigned((to_integer(unsigned(A)) * to_integer(unsigned(B))),16)) ;
			NZVC <= x"0";
		elsif(ALU_Sel = "0100") then -- DIV_AB
			Result <= std_logic_vector(to_unsigned((to_integer(unsigned(A)) / to_integer(unsigned(B))),16)) ;
			NZVC <= x"0";
		elsif(ALU_Sel = "0101") then -- DIV_BA
			Result <= std_logic_vector(to_unsigned((to_integer(unsigned(B)) / to_integer(unsigned(A))),16)) ;
			NZVC <= x"0";
		elsif(ALU_Sel = "0110") then -- AND_AB
			Result <= A AND B;
			NZVC <= x"0";
		elsif(ALU_Sel = "0111") then -- OR_AB
			Result <= A OR B;
			NZVC <= x"0";
		elsif(ALU_Sel = "1000") then -- NOT_A
			Result <= NOT A;
			NZVC <= x"0";
		end if;
		
	end process;

end architecture;