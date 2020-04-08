LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_ALU IS
END tb_ALU;
 
ARCHITECTURE behavior OF tb_ALU IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         A : IN  std_logic_vector(7 downto 0);
         B : IN  std_logic_vector(7 downto 0);
         ALU_Sel : IN  std_logic_vector(3 downto 0);
         ALU_Out : OUT  std_logic_vector(7 downto 0);
         Carryout : OUT  std_logic
        );
    END COMPONENT;
       --Inputs
   signal A : std_logic_vector(7 downto 0) := (others => '0');
   signal B : std_logic_vector(7 downto 0) := (others => '0');
   signal ALU_Sel : std_logic_vector(3 downto 0) := (others => '0');

  --Outputs
   signal ALU_Out : std_logic_vector(7 downto 0);
   signal Carryout : std_logic;
 
	--signal i:integer;
BEGIN
 
 -- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          A => A,
          B => B,
          ALU_Sel => ALU_Sel,
          ALU_Out => ALU_Out,
          Carryout => Carryout
        );

 

   -- Stimulus process
   stim_proc: process
   begin  
		
		A <= x"0A";			-- Set input A = 10
		B <= x"02";			-- Set input B = 2
		ALU_Sel <= x"0";	-- Selection = 0 (Addition)
		wait for 5 ns;

		for i in 0 to 6 loop	-- Loop through arithmetic and rotate/shift
			ALU_Sel <= ALU_Sel + x"1";
			wait for 5 ns;
		end loop;
		
		for i in 7 to 14 loop -- Loop through logical functions
			A <= x"00";			 -- Scenario 1: low A and high B
			B <= x"01";
			ALU_Sel <= ALU_Sel + x"1";
			wait for 5 ns;
			A <= x"01";			 -- Scenario 2: high A and B
			wait for 5 ns;
			--A <= x"0A";		 -- Scenario 3: Two high values
			--B <= x"0A";
			--wait for 5 ns;
			--A <= x"64";		 -- Scenario 4: Two high values but A = 10*B
			--wait for 5 ns;
		end loop;
		
		A <= x"FF";			-- Set input A = 255
		B <= x"FF";			-- Set input B = 255
		ALU_Sel <= x"2";	-- Selection = 2 (Multiplication), expect carryout flag
		wait for 5 ns;
		
		wait;
   end process;

END;