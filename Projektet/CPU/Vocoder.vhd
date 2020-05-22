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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Vocoder is
    Port ( 
	 CLK           	: in   std_logic; -- Clock
	 RST_ext          	: in   std_logic; -- Reset
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
			

         signal S_port_in_01     :  std_logic_vector (15 downto 0);
         signal S_port_in_02     :  std_logic_vector (15 downto 0);
         signal S_port_in_03     :  std_logic_vector (15 downto 0);
         signal S_port_in_04     :  std_logic_vector (15 downto 0);
         signal S_port_in_05     :  std_logic_vector (15 downto 0);
         signal S_port_in_06     :  std_logic_vector (15 downto 0);               
         signal S_port_in_07     :  std_logic_vector (15 downto 0);
         signal S_port_in_08     :  std_logic_vector (15 downto 0);
         signal S_port_in_09     :  std_logic_vector (15 downto 0);
         signal S_port_in_10     :  std_logic_vector (15 downto 0);
         signal S_port_in_11     :  std_logic_vector (15 downto 0);
         signal S_port_in_12     :  std_logic_vector (15 downto 0);
         signal S_port_in_13     :  std_logic_vector (15 downto 0);
         signal S_port_in_14     :  std_logic_vector (15 downto 0);
         signal S_port_in_15     :  std_logic_vector (15 downto 0);                                                                   
         -- 16x16bit output ports:
         signal S_port_out_01    : std_logic_vector (15 downto 0);
         signal S_port_out_02    : std_logic_vector (15 downto 0);
         signal S_port_out_03    : std_logic_vector (15 downto 0);
         signal S_port_out_04    : std_logic_vector (15 downto 0);
         signal S_port_out_05    : std_logic_vector (15 downto 0);
         signal S_port_out_06    : std_logic_vector (15 downto 0);
         signal S_port_out_07    : std_logic_vector (15 downto 0);
         signal S_port_out_08    : std_logic_vector (15 downto 0);
         signal S_port_out_09    : std_logic_vector (15 downto 0);
         signal S_port_out_10    : std_logic_vector (15 downto 0);
         signal S_port_out_11    : std_logic_vector (15 downto 0);
         signal S_port_out_12    : std_logic_vector (15 downto 0);
         signal S_port_out_13    : std_logic_vector (15 downto 0);
         signal S_port_out_14    : std_logic_vector (15 downto 0);
         signal S_port_out_15    : std_logic_vector (15 downto 0);
begin

COMPUTER_mAp : computer	port map (CLK => CLK, RST => RST_ext,
				  port_in_00 => Par_I,
				  port_in_01 => S_port_in_01,
				  port_in_02 => S_port_in_02,
				  port_in_03 => S_port_in_03,
				  port_in_04 => S_port_in_04,
				  port_in_05 => S_port_in_05,
				  port_in_06 => S_port_in_06,
				  port_in_07 => S_port_in_07,
				  port_in_08 => S_port_in_08,
				  port_in_09 => S_port_in_09,
				  port_in_10 => S_port_in_10,
				  port_in_11 => S_port_in_11,
				  port_in_12 => S_port_in_12,
				  port_in_13 => S_port_in_13,
				  port_in_14 => S_port_in_14,
				  port_in_15 => S_port_in_15,
				  port_out_00 => Par_O,
				  port_out_01 => S_port_out_01,
				  port_out_02 => S_port_out_02,
				  port_out_03 => S_port_out_03,
				  port_out_04 => S_port_out_04,
				  port_out_05 => S_port_out_05,
				  port_out_06 => S_port_out_06,
				  port_out_07 => S_port_out_07,
				  port_out_08 => S_port_out_08,
				  port_out_09 => S_port_out_09,
				  port_out_10 => S_port_out_10,
				  port_out_11 => S_port_out_11,
				  port_out_12 => S_port_out_12,
				  port_out_13 => S_port_out_13,
				  port_out_14 => S_port_out_14,
				  port_out_15 => S_port_out_15);

end Behavioral;

