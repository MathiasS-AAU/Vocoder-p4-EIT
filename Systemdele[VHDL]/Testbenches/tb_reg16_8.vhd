--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:29:38 04/05/2020
-- Design Name:   
-- Module Name:   C:/Users/bjark/Documents/DesignLab/open/circuit/tb_reg16_8.vhd
-- Project Name:  PSL_Papilio_Pro_LX9
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: reg16_8
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_reg16_8 IS
END tb_reg16_8;
 
ARCHITECTURE behavior OF tb_reg16_8 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT reg16_8
    PORT(
         I_clk : IN  std_logic;
         I_en : IN  std_logic;
         I_dataD : IN  std_logic_vector(15 downto 0);
         O_dataA : OUT  std_logic_vector(15 downto 0);
         O_dataB : OUT  std_logic_vector(15 downto 0);
         I_selA : IN  std_logic_vector(2 downto 0);
         I_selB : IN  std_logic_vector(2 downto 0);
         I_selD : IN  std_logic_vector(2 downto 0);
         I_we : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal I_clk : std_logic := '0';
   signal I_en : std_logic := '0';
   signal I_dataD : std_logic_vector(15 downto 0) := (others => '0');
   signal I_selA : std_logic_vector(2 downto 0) := (others => '0');
   signal I_selB : std_logic_vector(2 downto 0) := (others => '0');
   signal I_selD : std_logic_vector(2 downto 0) := (others => '0');
   signal I_we : std_logic := '0';

 	--Outputs
   signal O_dataA : std_logic_vector(15 downto 0);
   signal O_dataB : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant I_clk_period : time := 31.25 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: reg16_8 PORT MAP (
          I_clk => I_clk,
          I_en => I_en,
          I_dataD => I_dataD,
          O_dataA => O_dataA,
          O_dataB => O_dataB,
          I_selA => I_selA,
          I_selB => I_selB,
          I_selD => I_selD,
          I_we => I_we
        );

   -- Clock process definitions
   I_clk_process :process
   begin
		I_clk <= '0';
		wait for I_clk_period/2;
		I_clk <= '1';
		wait for I_clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      --wait for 100 ns;	

      wait for I_clk_period*10;

      -- insert stimulus here 

		I_en <= '1';
		I_we <= '1';
		wait for I_clk_period;
		I_dataD <= x"000A";		-- Data input = 10
		I_selD <= "001";			-- Write data to r1
		I_selA <= "000";			-- Read r0 and expect output A = 0
		I_selB <= "000";			-- Read r0 and expect output B = 0
		wait for I_clk_period;
		I_dataD <= x"0014";		-- Data input = 20
		I_selD <= "010";			-- Write data to r2
		wait for I_clk_period;
		I_dataD <= x"001E";		-- Data input = 30
		I_selD <= "011";			-- Write data to r3
		wait for I_clk_period;		
		I_dataD <= x"0000";		-- Data input = 0
		I_we <= '0';				-- Stop writing
		I_selD <= "000";			-- Write data to r0 (disabled)
		wait for I_clk_period;
		I_selA <= "011";			-- Read r3 and expect output A = 30
		I_selB <= "001";			-- Read r1 and expect output B = 10
		wait for I_clk_period;
		I_selA <= "010";			-- Read r2 and expect output A = 20
		I_selB <= "010";			-- Read r2 and expect output B = 20
		wait for I_clk_period;
		I_selA <= "001";			-- Read r1 and expect output A = 10
		I_selB <= "011";			-- Read r3 and expect output B = 30
		wait for I_clk_period;
		I_selA <= "000";			-- Read r0 and expect output A = 0
		I_selB <= "000";			-- Read r0 and expect output B = 0
		I_selD <= "000";			-- Write data to r0
		I_we <= '1';				-- Write enable
		wait for I_clk_period;
		I_dataD <= x"0028";		-- Data input = 40
		I_en <= '0';				-- Disable memory
		wait for I_clk_period;
		I_selA <= "001";			-- Read r0 and expect output A = 0
		I_selB <= "001";			-- Read r0 and expect output B = 0
		I_selD <= "001";			-- Write data to r0
		wait for I_clk_period;
		I_en <= '1';				-- Enable memory
		wait for I_clk_period;
		I_dataD <= x"000A";		-- Data output = 10
		wait for I_clk_period*2;
		I_dataD <= x"0014";		-- Data output = 20
		I_selD <= "010";			-- Write data to r2
		I_selA <= "010";			-- Read r2 and expect output A = 20
		wait for I_clk_period;
		I_dataD <= x"001E";		-- Data output = 30
		I_selD <= "011";			-- Write data to r3
		I_selA <= "011";			-- Read r3 and expect output A = 30
		wait for I_clk_period;
		I_dataD <= x"0000";		-- Set everything to 0 to see end
		I_selD <= "000";
		I_selA <= "000";
		I_selB <= "000";
		wait for I_clk_period;
		I_en <= '0';
		I_we <= '0';			
		wait;
   end process;
 
END;