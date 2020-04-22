----------------------------------------------------------------------------------
-- Company:				AAU
-- Engineer: 			EIT4-415
-- Create Date:    	15/04/2020 
-- Design Name: 	 	Data Memory
-- Module Name:    	RAM - ram_32767x16_sync - Behavioral 
-- Description:		Random Access Memory for Read/Write
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;  
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

entity ram_32733x16_sync is
	port(CLK	 	  : in std_logic; 							-- Clock signal
		  WE		  : in std_logic;								-- Write enable
		  ADDR	  : in std_logic_vector(15 downto 0);  -- Number of adresses
		  data_in : in std_logic_vector(15 downto 0);  -- Input data, 16 bit
		  data_out : out std_logic_vector(15 downto 0) -- Output data, 16 bit
        );
end ram_32733x16_sync;

architecture ram_32733x16_sync_arch of ram_32733x16_sync is
	signal EN : std_logic; -- An internal enable that will prevent data_out assignments for addresses outside of this valid range.

	type ram_type is array (32768 to 65501) of std_logic_vector(15 downto 0); -- Random access 16 x 16 bit memory. 32733 adresses of 16 bits.
	signal RAM : ram_type;


begin							
	-- Enable process. Verifies if given adress is within RAM size.
	ENABLE : process (ADDR)
				begin
					if (to_integer(unsigned(ADDR)) >=32768 and (to_integer(unsigned(ADDR)) <=65501)) then
						EN <= '1';		-- If 32768 <= ADDR <= 65501 then set EN to 1.
					else
						EN <='0';
					end if;
				end process;
				
	-- Memory access process. 
	MEMORY : process (CLK)															-- If there is a rising clock edge
				begin 																	-- and EN = 1, then take whatever is
					if (rising_edge(CLK)) then									-- on adress ADDR and put in into data_out
						if (EN = '1' and WE = '0') then
							data_out <= RAM(to_integer(unsigned(ADDR)));
						elsif(EN = '1' and WE = '1') then
							RAM(to_integer(unsigned(ADDR))) <= data_in;
						end if;
					end if;
				end process;

end architecture;