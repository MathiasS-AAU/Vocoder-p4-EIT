-- ALU (Arithmetic Logic Unit):
--		8 bit
--		Two inputs
--		Selection
--		One output
--		Carryout flag output
--		Based on a change in inputs, that already is based on clk.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;		-- Logical units
use IEEE.STD_LOGIC_UNSIGNED.ALL;	-- Unsigned units
use ieee.NUMERIC_STD.all;			-- Addition incode and such

entity ALU is
	generic ( 
		constant N: natural := 1  -- Number of shifted or rotated bits
   );
  
   Port (
		A, B     : in  STD_LOGIC_VECTOR(7 downto 0);  	-- 2 inputs 8-bit
		ALU_Sel  : in  STD_LOGIC_VECTOR(3 downto 0);  	-- 1 input 4-bit for selecting function
		ALU_Out   : out  STD_LOGIC_VECTOR(7 downto 0); 	-- 1 output 8-bit 
		Carryout : out std_logic        						-- Carryout flag
   );
end ALU; 

architecture Behavioral of ALU is
	signal ALU_Result : std_logic_vector (7 downto 0); -- Used to save calculation after caseselection. 
	signal tmp: std_logic_vector (8 downto 0);			-- if MSB is high (8): overflow

begin
	process(A,B,ALU_Sel)
	begin
		case(ALU_Sel) is	-- Switch case, with adresses for operations
			when "0000" => -- 0: Arithmetic addition
				ALU_Result <= A + B ; 
			when "0001" => -- 1: Arithmetic subtraction
				ALU_Result <= A - B ;
			when "0010" => -- 2: Arithmetic multiplication
				ALU_Result <= std_logic_vector(to_unsigned((to_integer(unsigned(A)) * to_integer(unsigned(B))),8)) ;
			when "0011" => -- 3: Arithmetic division
				ALU_Result <= std_logic_vector(to_unsigned(to_integer(unsigned(A)) / to_integer(unsigned(B)),8)) ;
			when "0100" => -- 4: Logical shift left
				ALU_Result <= std_logic_vector(unsigned(A) sll N);
			when "0101" => -- 5: Logical shift right
				ALU_Result <= std_logic_vector(unsigned(A) srl N);
			when "0110" => -- 6: Rotate left
				ALU_Result <= std_logic_vector(unsigned(A) rol N);
			when "0111" => -- 7: Rotate right
				ALU_Result <= std_logic_vector(unsigned(A) ror N);
			when "1000" => -- 8: Logical and 
				ALU_Result <= A and B;
			when "1001" => -- 9: Logical or
				ALU_Result <= A or B;
			when "1010" => -- 10: Logical xor 
				ALU_Result <= A xor B;
			when "1011" => -- 11: Logical nor
				ALU_Result <= A nor B;
			when "1100" => -- 12: Logical nand 
				ALU_Result <= A nand B;
			when "1101" => -- 13: Logical xnor
				ALU_Result <= A xnor B;
			when "1110" => -- 14: Greater comparison
				if(A>B) then
					ALU_Result <= x"01" ;
				else
					ALU_Result <= x"00" ;
				end if; 
			when "1111" => -- 15: Equal comparison   
				if(A=B) then
					ALU_Result <= x"01" ;
				else
					ALU_Result <= x"00" ;
				end if;
			when others => -- Make sure no other case is random
				ALU_Result <= A + B ;
		end case;
	end process;
	ALU_Out <= ALU_Result; 		 	-- ALU out
	tmp <= ('0' & A) + ('0' & B); -- Add an extra MSB (0) to A and B and add in tmp which is +1bit for carry
	Carryout <= tmp(8); 			 	-- If MSB in tmp is high, the carryout flag is high

end Behavioral;