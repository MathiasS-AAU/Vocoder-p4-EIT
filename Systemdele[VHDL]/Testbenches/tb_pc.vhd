--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:10:14 04/05/2020
-- Design Name:   
-- Module Name:   C:/Users/bjark/Documents/DesignLab/open/circuit/tb_pc.vhd
-- Project Name:  PSL_Papilio_Pro_LX9
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PC
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
 
ENTITY tb_pc IS
END tb_pc;
 
ARCHITECTURE behavior OF tb_pc IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PC
    PORT(
         d : IN  std_logic_vector(31 downto 0);
         ld : IN  std_logic;
         clr : IN  std_logic;
         clk : IN  std_logic;
         inc : IN  std_logic;
         q : INOUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal d : std_logic_vector(31 downto 0) := (others => '0');
   signal ld : std_logic := '0';
   signal clr : std_logic := '0';
   signal clk : std_logic := '0';
   signal inc : std_logic := '0';

	--BiDirs
   signal q : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PC PORT MAP (
          d => d,
          ld => ld,
          clr => clr,
          clk => clk,
          inc => inc,
          q => q
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin	
		
		-- Force all low:
		d <= x"00000064";
		ld <= '0';
		clr <= '1';
		inc <= '0';
		wait for clk_period;
		clr <= '0';

		-- Data counting up
		d <= d + 1;
		wait for clk_period; -- Load high:
		d <= d + 1;
		ld <= '1';
		wait for clk_period;
		d <= d + 1;
		ld <= '0';
		wait for clk_period; -- Increment high
		d <= d + 1;
		inc <= '1';
		wait for clk_period;
		d <= d + 1;
		inc <= '0';
		wait for clk_period; -- Clear high:
		d <= d + 1;
		clr <= '1';
		wait for clk_period;
		d <= d + 1;
		clr <= '0';
		wait for clk_period; -- Load+increment high:
		d <= d + 1;
		ld <= '1';
		inc <= '1';
		wait for clk_period;
		d <= d + 1;
		ld <= '0';
		inc <= '0';
		wait for clk_period; -- Load+clear high:
		d <= d + 1;
		ld <= '1';
		clr <= '1';
		wait for clk_period;
		d <= d + 1;
		ld <= '0';
		clr <= '0';
		wait for clk_period; -- Increment+clear high
		d <= d + 1;
		inc <= '1';
		clr <= '1';
		wait for clk_period;
		d <= d + 1;
		inc <= '0';
		clr <= '0';
		wait for clk_period; -- Load+increment+clear high:
		d <= d + 1;
		ld <= '1';
		inc <= '1';
		clr <= '1';
		wait for clk_period;
		d <= d + 1;
		ld <= '0';
		inc <= '0';
		clr <= '0';
		wait;
   end process;

END;
