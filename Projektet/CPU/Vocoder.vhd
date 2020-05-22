----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:35:23 05/21/2020 
-- Design Name: 
-- Module Name:    Vocoder - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Vocoder is
    Port ( 
	 CLK_in           	: in   std_logic; -- Clock
	 RST_ext          	: in   std_logic; -- Reset
	 ADDA_CLK : out std_logic; --DAC/ADC system clock
	 Par_I : in  STD_LOGIC_VECTOR (15 downto 0);
    Par_O : out  STD_LOGIC_VECTOR (15 downto 0)
	 );
end Vocoder;

architecture Behavioral of Vocoder is

component computer is -- Portdefinition of Memory (Module)
		port (
			CLK           	: in   std_logic; -- Clock
			RST          	: in   std_logic; -- Reset
			-- 16x16bit input ports:
			port_in_00     : in  std_logic_vector (15 downto 0); 
         port_in_01     : in  std_logic_vector (15 downto 0);
         port_in_02     : in  std_logic_vector (15 downto 0);
         port_in_03     : in  std_logic_vector (15 downto 0);
         port_in_04     : in  std_logic_vector (15 downto 0);
         port_in_05     : in  std_logic_vector (15 downto 0);
         port_in_06     : in  std_logic_vector (15 downto 0);               
         port_in_07     : in  std_logic_vector (15 downto 0);
         port_in_08     : in  std_logic_vector (15 downto 0);
         port_in_09     : in  std_logic_vector (15 downto 0);
         port_in_10     : in  std_logic_vector (15 downto 0);
         port_in_11     : in  std_logic_vector (15 downto 0);
         port_in_12     : in  std_logic_vector (15 downto 0);
         port_in_13     : in  std_logic_vector (15 downto 0);
         port_in_14     : in  std_logic_vector (15 downto 0);
         port_in_15     : in  std_logic_vector (15 downto 0);                                                                   
         -- 16x16bit output ports:
			port_out_00    : out std_logic_vector (15 downto 0); 
         port_out_01    : out std_logic_vector (15 downto 0);
         port_out_02    : out std_logic_vector (15 downto 0);
         port_out_03    : out std_logic_vector (15 downto 0);
         port_out_04    : out std_logic_vector (15 downto 0);
         port_out_05    : out std_logic_vector (15 downto 0);
         port_out_06    : out std_logic_vector (15 downto 0);
         port_out_07    : out std_logic_vector (15 downto 0);
         port_out_08    : out std_logic_vector (15 downto 0);
         port_out_09    : out std_logic_vector (15 downto 0);
         port_out_10    : out std_logic_vector (15 downto 0);
         port_out_11    : out std_logic_vector (15 downto 0);
         port_out_12    : out std_logic_vector (15 downto 0);
         port_out_13    : out std_logic_vector (15 downto 0);
         port_out_14    : out std_logic_vector (15 downto 0);
         port_out_15    : out std_logic_vector (15 downto 0)
			);
	end component;

component BUFG
port(I: in STD_LOGIC; O: out STD_LOGIC );
end component;			                                                                
component BUFIO2FB
port(I: in STD_LOGIC; O: out STD_LOGIC );
end component;

			
			--PLL stuff
			signal CLK : std_logic;
			signal CLK_OUT : std_logic;
			signal CLK_FB_in : std_logic;
			signal CLK_FB_out : std_logic;
begin

clock: BUFG port map (I => CLK_OUT, O => CLK); -- Clock line

Feedback_Clock: BUFIO2FB port map (I => CLK_FB_out, O => CLK_FB_in); -- Feedback line

COMPUTER_mAp : computer	port map (CLK => CLK, RST => RST_ext,
				  port_in_00 => Par_I,
				  port_in_01 => x"0000",
				  port_in_02 => x"0000",
				  port_in_03 => x"0000",
				  port_in_04 => x"0000",
				  port_in_05 => x"0000",
				  port_in_06 => x"0000",
				  port_in_07 => x"0000",
				  port_in_08 => x"0000",
				  port_in_09 => x"0000",
				  port_in_10 => x"0000",
				  port_in_11 => x"0000",
				  port_in_12 => x"0000",
				  port_in_13 => x"0000",
				  port_in_14 => x"0000",
				  port_in_15 => x"0000",
				  port_out_00 => Par_O,
				  port_out_01 => open,
				  port_out_02 => open,
				  port_out_03 => open,
				  port_out_04 => open,
				  port_out_05 => open,
				  port_out_06 => open,
				  port_out_07 => open,
				  port_out_08 => open,
				  port_out_09 => open,
				  port_out_10 => open,
				  port_out_11 => open,
				  port_out_12 => open,
				  port_out_13 => open,
				  port_out_14 => open,
				  port_out_15 => open);


--PLL

PLL_BASE_inst : PLL_BASE
   generic map (
      BANDWIDTH => "OPTIMIZED",             -- "HIGH", "LOW" or "OPTIMIZED" 
      CLKFBOUT_MULT => 24,                   -- Multiply value for all CLKOUT clock outputs (1-64) -- does not work at low frequencies that is the reason for 24 multiplier 
      CLKFBOUT_PHASE => 0.0,                -- Phase offset in degrees of the clock feedback output
                                            -- (0.0-360.0).
      CLKIN_PERIOD => 31.25,  --32MHz       -- Input clock period in ns to ps resolution (i.e. 33.333 is 30
                                            -- MHz).
      -- CLKOUT0_DIVIDE - CLKOUT5_DIVIDE: Divide amount for CLKOUT# clock output (1-128)
      CLKOUT0_DIVIDE => 48, --32 MHz * 24 / 48 = 16 MHz
      CLKOUT1_DIVIDE => 34, --32 MHz * 24 / 34 = 22,588 MHz -- 22,558 MHz / 512 = 44,118 kHz
      -- CLKOUT0_DUTY_CYCLE - CLKOUT5_DUTY_CYCLE: Duty cycle for CLKOUT# clock output (0.01-0.99).
      CLKOUT0_DUTY_CYCLE => 0.5,
      CLKOUT1_DUTY_CYCLE => 0.5,
      -- CLKOUT0_PHASE - CLKOUT5_PHASE: Output phase relationship for CLKOUT# clock output (-360.0-360.0).
      CLKOUT0_PHASE => 0.0,
      CLKOUT1_PHASE => 0.0,
      CLK_FEEDBACK => "CLKFBOUT",           -- Clock source to drive CLKFBIN ("CLKFBOUT" or "CLKOUT0")
      COMPENSATION => "SYSTEM_SYNCHRONOUS", -- "SYSTEM_SYNCHRONOUS", "SOURCE_SYNCHRONOUS", "EXTERNAL" 
      DIVCLK_DIVIDE => 1,                   -- Division value for all output clocks (1-52)
      REF_JITTER => 0.1,                    -- Reference Clock Jitter in UI (0.000-0.999).
      RESET_ON_LOSS_OF_LOCK => FALSE        -- Must be set to FALSE
   )
   port map (
      CLKFBOUT => CLK_FB_OUT, -- 1-bit output: PLL_BASE feedback output
      -- CLKOUT0 - CLKOUT5: 1-bit (each) output: Clock outputs
      CLKOUT0 => CLK_OUT, --CPU clock
      CLKOUT1 => ADDA_CLK, --DAC/ADC system clock
      CLKOUT2 => open,
      CLKOUT3 => open,
      CLKOUT4 => open,
      CLKOUT5 => open,
      LOCKED => open,     -- 1-bit output: PLL_BASE lock status output
		--clock input and feedback
      CLKFBIN => CLK_FB_in,   -- 1-bit input: Feedback clock input
      CLKIN => CLK_IN,       -- 1-bit input: Clock input
      RST => RST_ext            -- 1-bit input: Reset input
   );

end Behavioral;

