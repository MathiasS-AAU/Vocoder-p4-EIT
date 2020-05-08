----------------------------------------------------------------------------------
-- Company:				AAU
-- Engineer: 			EIT4-415
-- Create Date:    	29/04/2020 
-- Design Name: 	 	Arithmetic Logic Unit
-- Module Name:    	ALU_signed - Behavioral
-- Description:		A signal from control unit will determine which operation
--							to execute (SIGNED)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;		-- Logical units
use IEEE.STD_LOGIC_SIGNED.ALL;	-- Signed units
use ieee.NUMERIC_STD.all;			-- Addition incode and such

entity alu is
	port (B		  : in  std_logic_vector (15 downto 0);
			A		  : in  std_logic_vector (15 downto 0);
			ALU_Sel : in  std_logic_vector (3 downto 0);
			NZVC	  : out std_logic_vector (3 downto 0);
			Result  : out std_logic_vector (15 downto 0));
end entity;

architecture alu_arch of alu is
begin
	process(A,B,ALU_Sel)
	variable Sum_sign	:	signed(16 downto 0);
	begin
		case(ALU_Sel) is	-- Switch case, with adresses for operations
			when "0000" => -- ADD_AB
				Sum_sign := signed('0' & A) + signed('0' & B);
				Result   <= std_logic_vector(Sum_sign(15 downto 0));
			when "0001" => -- SUB_AB
				Sum_sign := signed('0' & A) - signed('0' & B);
				Result   <= std_logic_vector(Sum_sign(15 downto 0));
			when "0010" => -- SUB_BA
				Sum_sign := signed('0' & B) - signed('0' & A);
				Result   <= std_logic_vector(Sum_sign(15 downto 0));
			when "0011" => -- MUL_AB
				Sum_sign := to_signed((to_integer(signed(A)) * to_integer(signed(B))),17);
				Result   <= std_logic_vector(Sum_sign(15 downto 0));
			when "0100" => -- DIV_AB
				Sum_sign := to_signed((to_integer(signed(A)) / to_integer(signed(B))),17);
				Result   <= std_logic_vector(Sum_sign(15 downto 0));
			when "0101" => -- DIV_BA
				Sum_sign := to_signed((to_integer(signed(B)) / to_integer(signed(A))),17);
				Result   <= std_logic_vector(Sum_sign(15 downto 0));
			when "0110" => -- AND_AB
				Sum_sign := signed('0' & A) AND signed('0' & B);
				Result   <= std_logic_vector(Sum_sign(15 downto 0));
			when "0111" => -- OR_AB
				Sum_sign := signed('0' & A) OR signed('0' & B);
				Result   <= std_logic_vector(Sum_sign(15 downto 0));
			when "1000" => -- NOT_A
				Sum_sign := signed(NOT('0' & A));
				Result   <= std_logic_vector(Sum_sign(15 downto 0));
			when others => -- Make sure no other case is random
				Result   <= x"0000";
		end case;
	
		-- Negative flag
		NZVC(3) <= Sum_sign(15);
		
		-- Zero flag
		if(Sum_sign(15 downto 0) = x"0000") then
			NZVC(2) <= '1';
		else
			NZVC(2) <= '0';
		end if;
		
		-- Overflow flag
		if((A(15)='0' and B(15)='0' and Sum_sign(15)='1') or 
			(A(15)='1' and B(15)='1' and Sum_sign(15)='0')) then
			NZVC(1) <= '1';
		else
			NZVC(1) <= '0';
		end if;
		
		-- Carry flag
		NZVC(0) <= Sum_sign(16);

	end process;		
end architecture;