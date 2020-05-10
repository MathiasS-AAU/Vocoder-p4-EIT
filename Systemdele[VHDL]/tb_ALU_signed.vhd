library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
 
ENTITY tb_ALU IS
END tb_ALU;
 
ARCHITECTURE behavior OF tb_ALU IS 
    COMPONENT ALU
    PORT(
         A : IN  std_logic_vector(15 downto 0);
         B : IN  std_logic_vector(15 downto 0);
         ALU_Sel : IN  std_logic_vector(3 downto 0);
         NZVC : OUT  std_logic_vector(3 downto 0);
         Result : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    
   --Inputs
   signal A : std_logic_vector(15 downto 0) := (others => '0');
   signal B : std_logic_vector(15 downto 0) := (others => '0');
   signal ALU_Sel : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal NZVC : std_logic_vector(3 downto 0);
   signal Result : std_logic_vector(15 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU_signed PORT MAP (
          A => A,
          B => B,
          ALU_Sel => ALU_Sel,
          NZVC => NZVC,
          Result => Result
        );

  -- Stimulus process
   stim_proc: process
   begin		

		ALU_Sel <= "0000";
		for i in 0 to 5 loop		-- Loop through Arithmetic operations
			A <= x"000A";			-- Set input A = 10
			B <= x"0002";			-- Set input B = 2
			wait for 5 ns;
			B <= x"FFEC";			-- Set input B = -20
			wait for 5 ns;
			A <= x"FFD8";			-- Set input A = -40			
			wait for 5 ns;
			ALU_Sel <= ALU_Sel + "1";
		end loop;
		
		A <= x"0000";			-- Set input A = 0
		B <= x"0000";			-- Set input B = 0
		ALU_Sel <= "0000";
 
		wait;
   end process;
END;
