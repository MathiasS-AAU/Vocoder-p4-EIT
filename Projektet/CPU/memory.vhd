----------------------------------------------------------------------------------
-- Company:				AAU
-- Engineer: 			EIT4-415
-- Create Date:    	15/04/2020 
-- Design Name: 	 	Memoryblock
-- Module Name:    	MEMORY - memory - memory_arch
-- Description:		Control of inside memory blocks and I/O: 
--							Data Memory (Read/write), Program Memory (Read), 
--							output (Write) and input (Read)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

entity memory is -- Portdefinition of memoryblock (Module)
	port (CLK			: in  std_logic; -- Clock signal
			RST			: in  std_logic; -- Reset signal
			WE				: in  std_logic; -- Write enable
			data_in		: in  std_logic_vector (15 downto 0); -- Input data, 16 bit
			ADDR			: in  std_logic_vector (15 downto 0); -- Address bus, 16 bit
			data_out	 	: out std_logic_vector (15 downto 0); -- Output data, 16 bit
			-- 16x16bit input ports:
			port_in_00  : in  std_logic_vector (15 downto 0); 
         port_in_01  : in  std_logic_vector (15 downto 0);
         port_in_02  : in  std_logic_vector (15 downto 0);
         port_in_03  : in  std_logic_vector (15 downto 0);
         port_in_04  : in  std_logic_vector (15 downto 0);
         port_in_05  : in  std_logic_vector (15 downto 0);
         port_in_06  : in  std_logic_vector (15 downto 0);               
         port_in_07  : in  std_logic_vector (15 downto 0);
         port_in_08  : in  std_logic_vector (15 downto 0);
         port_in_09  : in  std_logic_vector (15 downto 0);
         port_in_10  : in  std_logic_vector (15 downto 0);
         port_in_11  : in  std_logic_vector (15 downto 0);
         port_in_12  : in  std_logic_vector (15 downto 0);
         port_in_13  : in  std_logic_vector (15 downto 0);
         port_in_14  : in  std_logic_vector (15 downto 0);
         port_in_15	: in  std_logic_vector (15 downto 0);
			-- 16x16bit output ports:
         port_out_00 : out std_logic_vector (15 downto 0);
         port_out_01 : out std_logic_vector (15 downto 0);
         port_out_02 : out std_logic_vector (15 downto 0);
         port_out_03 : out std_logic_vector (15 downto 0);
         port_out_04 : out std_logic_vector (15 downto 0);
         port_out_05 : out std_logic_vector (15 downto 0);
         port_out_06 : out std_logic_vector (15 downto 0);
         port_out_07 : out std_logic_vector (15 downto 0);
         port_out_08 : out std_logic_vector (15 downto 0);
         port_out_09 : out std_logic_vector (15 downto 0);
         port_out_10 : out std_logic_vector (15 downto 0);
         port_out_11 : out std_logic_vector (15 downto 0);
         port_out_12 : out std_logic_vector (15 downto 0);
         port_out_13 : out std_logic_vector (15 downto 0);
         port_out_14 : out std_logic_vector (15 downto 0);
         port_out_15 : out std_logic_vector (15 downto 0);
			port_out_16 : out std_logic_vector (15 downto 0)
			);
end entity;

architecture memory_arch of memory is

	component ram_32733x16_sync is -- Portdefinition of Data Memoryblock for Read/write (Submodule)
		port (CLK		: in  std_logic; -- Clock
		      WE			: in  std_logic; -- Write enable
		      ADDR		: in  std_logic_vector(15 downto 0);  -- Adress, 16 bit
		      data_in	: in  std_logic_vector(15 downto 0);  -- Input data, 16 bit
		      data_out : out std_logic_vector(15 downto 0)); -- Output data, 16 bit
	end component;

	component rom_32767x16_sync is -- Portdefinition of Program Memoryblock for Read only (Submodule)
		port (CLK		: in  std_logic; -- Clock
		      ADDR		: in  std_logic_vector(15 downto 0);  -- Adress, 16 bit
		      data_out : out std_logic_vector(15 downto 0)); -- Output data, 16 bit
	end component;
	
	-- Signals to wire data from Program/Data Memory
	signal rom_data	: std_logic_vector (15 downto 0);
	signal ram_data	: std_logic_vector (15 downto 0);
	
begin

	-- Portmap definition of submodules for outputlogic
	ROM : rom_32767x16_sync 	port map (CLK, ADDR, rom_data);
	RAM  : ram_32733x16_sync	port map (CLK, WE, ADDR, data_in, ram_data);


	---------------------------------- 16 OUTPUT PORTS ------------------------------------------------------

	PORT0 : process(CLK, RST) -- Output port 0, sensitive to clock and reset
	begin
		if (RST = '0') then 							-- If reset is 0 then reset.
			port_out_00 <= x"0000";		
		elsif (rising_edge(CLK)) then 				-- If there is a rising edge in clock and
			if (ADDR = x"FFE0" and WE='1') then  -- if adress is port 0 = x"FFDE" and if
				port_out_00<=data_in;					-- write enable = 1, then write to port 0.
			end if;
		end if;
	end process;

	PORT1 : process(CLK, RST) -- Output port 1, sensitive to clock and reset
	begin
		if (RST = '0') then 							-- If reset is 0 then reset.
			port_out_01 <= x"0000";		
		elsif (rising_edge(CLK)) then 				-- If there is a rising edge in clock and
			if (ADDR = x"FFE1" and WE='1') then  -- if adress is port 1 = x"FFDF" and if
				port_out_01<=data_in;					-- write enable = 1, then write to port 1.
			end if;
		end if;
	end process;
	
	PORT2 : process(CLK, RST) -- Output port 2, sensitive to clock and reset
	begin
		if (RST = '0') then 							-- If reset is 0 then reset.
			port_out_02 <= x"0000";		
		elsif (rising_edge(CLK)) then 				-- If there is a rising edge in clock and
			if (ADDR = x"FFE2" and WE='1') then  -- if adress is port 2 = x"FFE0" and if
				port_out_00<=data_in;					-- write enable = 1, then write to port 2.
			end if;
		end if;
	end process;
	
	PORT3 : process(CLK, RST) -- Output port 3, sensitive to clock and reset
	begin
		if (RST = '0') then 							-- If reset is 0 then reset.
			port_out_03 <= x"0000";		
		elsif (rising_edge(CLK)) then 				-- If there is a rising edge in clock and
			if (ADDR = x"FFE3" and WE='1') then  -- if adress is port 3 = x"FFE1" and if
				port_out_03<=data_in;					-- write enable = 1, then write to port 3.
			end if;
		end if;
	end process;

	PORT4 : process(CLK, RST) -- Output port 4, sensitive to clock and reset
	begin
		if (RST = '0') then 							-- If reset is 0 then reset.
			port_out_04 <= x"0000";		
		elsif (rising_edge(CLK)) then 				-- If there is a rising edge in clock and
			if (ADDR = x"FFE4" and WE='1') then  -- if adress is port 4 = x"FFE2" and if
				port_out_04<=data_in;					-- write enable = 1, then write to port 4.
			end if;
		end if;
	end process;
	
	
	PORT5 : process(CLK, RST) -- Output port 5, sensitive to clock and reset
	begin
		if (RST = '0') then 							-- If reset is 0 then reset.
			port_out_05 <= x"0000";		
		elsif (rising_edge(CLK)) then 				-- If there is a rising edge in clock and
			if (ADDR = x"FFE5" and WE='1') then  -- if adress is port 5 = x"FFE3" and if
				port_out_05<=data_in;					-- write enable = 1, then write to port 5.
			end if;
		end if;
	end process;
	
	
	PORT6 : process(CLK, RST) -- Output port 6, sensitive to clock and reset
	begin
		if (RST = '0') then 							-- If reset is 0 then reset.
			port_out_06 <= x"0000";		
		elsif (rising_edge(CLK)) then 				-- If there is a rising edge in clock and
			if (ADDR = x"FFE6" and WE='1') then  -- if adress is port 6 = x"FFE4" and if
				port_out_06<=data_in;					-- write enable = 1, then write to port 6.
			end if;
		end if;
	end process;

	PORT7 : process(CLK, RST) -- Output port 7, sensitive to clock and reset
	begin
		if (RST = '0') then 							-- If reset is 0 then reset.
			port_out_07 <= x"0000";		
		elsif (rising_edge(CLK)) then 				-- If there is a rising edge in clock and
			if (ADDR = x"FFE7" and WE='1') then  -- if adress is port 7 = x"FFE5" and if
				port_out_07<=data_in;					-- write enable = 1, then write to port 7.
			end if;
		end if;
	end process;

	PORT8 : process(CLK, RST) -- Output port 8, sensitive to clock and reset
	begin
		if (RST = '0') then 							-- If reset is 0 then reset.
			port_out_08 <= x"0000";		
		elsif (rising_edge(CLK)) then 				-- If there is a rising edge in clock and
			if (ADDR = x"FFE8" and WE='1') then  -- if adress is port 6 = x"FFE6" and if
				port_out_08<=data_in;					-- write enable = 1, then write to port 8.
			end if;
		end if;
	end process;

	PORT9 : process(CLK, RST) -- Output port 9, sensitive to clock and reset
	begin
		if (RST = '0') then 							-- If reset is 0 then reset.
			port_out_09 <= x"0000";		
		elsif (rising_edge(CLK)) then 				-- If there is a rising edge in clock and
			if (ADDR = x"FFE9" and WE='1') then  -- if adress is port 9 = x"FFE7" and if
				port_out_09<=data_in;					-- write enable = 1, then write to port 9.
			end if;
		end if;
	end process;

	PORT10 : process(CLK, RST) -- Output port 10, sensitive to clock and reset
	begin
		if (RST = '0') then 							-- If reset is 0 then reset.
			port_out_10 <= x"0000";		
		elsif (rising_edge(CLK)) then 				-- If there is a rising edge in clock and
			if (ADDR = x"FFEA" and WE='1') then  -- if adress is port 10 = x"FFE8" and if
				port_out_10<=data_in;					-- write enable = 1, then write to port 10.
			end if;
		end if;
	end process;
	
	PORT11 : process(CLK, RST) -- Output port 11, sensitive to clock and reset
	begin
		if (RST = '0') then 							-- If reset is 0 then reset.
			port_out_11 <= x"0000";		
		elsif (rising_edge(CLK)) then 				-- If there is a rising edge in clock and
			if (ADDR = x"FFEB" and WE='1') then  -- if adress is port 11 = x"FFE9" and if
				port_out_11<=data_in;					-- write enable = 1, then write to port 11.
			end if;
		end if;
	end process;
	
	
	PORT12 : process(CLK, RST) -- Output port 12, sensitive to clock and reset
	begin
		if (RST = '0') then 							-- If reset is 0 then reset.
			port_out_12 <= x"0000";		
		elsif (rising_edge(CLK)) then 				-- If there is a rising edge in clock and
			if (ADDR = x"FFEC" and WE='1') then  -- if adress is port 11 = x"FFEA" and if
				port_out_12<=data_in;					-- write enable = 1, then write to port 12.
			end if;
		end if;
	end process;
		
	PORT13 : process(CLK, RST) -- Output port 13, sensitive to clock and reset
	begin
		if (RST = '0') then 							-- If reset is 0 then reset.
			port_out_13 <= x"0000";		
		elsif (rising_edge(CLK)) then 				-- If there is a rising edge in clock and
			if (ADDR = x"FFED" and WE='1') then  -- if adress is port 13 = x"FFED" and if
				port_out_13<=data_in;					-- write enable = 1, then write to port 13.
			end if;
		end if;
	end process;
		
	PORT14 : process(CLK, RST) -- Output port 14, sensitive to clock and reset
	begin
		if (RST = '0') then 							-- If reset is 0 then reset.
			port_out_14 <= x"0000";		
		elsif (rising_edge(CLK)) then 				-- If there is a rising edge in clock and
			if (ADDR = x"FFEE" and WE='1') then  -- if adress is port 14 = x"FFEB" and if
				port_out_14<=data_in;					-- write enable = 1, then write to port 14.
			end if;
		end if;
	end process;
		
	PORT15 : process(CLK, RST) -- Output port 15, sensitive to clock and reset
	begin
		if (RST = '0') then 							-- If reset is 0 then reset.
			port_out_15 <= x"0000";		
		elsif (rising_edge(CLK)) then 				-- If there is a rising edge in clock and
			if (ADDR = x"FFEF" and WE='1') then  -- if adress is port 15 = x"FFEF" and if
				port_out_15<=data_in;					-- write enable = 1, then write to port 15.
			end if;
		end if;
	end process;
	
	
	
----------------------------------------- DATA OUT MULTIPLEXER ------------------------------------------

 MUX : process (ADDR, rom_data, ram_data,
					port_in_00, port_in_01, port_in_02, port_in_03,
					port_in_04, port_in_05, port_in_06, port_in_07,
					port_in_08, port_in_09, port_in_10, port_in_11,
					port_in_12, port_in_13, port_in_14, port_in_15)
		begin
			if (to_integer(unsigned(ADDR)) >=0 and (to_integer(unsigned(ADDR)) <=32767)) then
					data_out <= rom_data;
			elsif (to_integer(unsigned(ADDR)) >=32768 and (to_integer(unsigned(ADDR)) <=65501)) then
					data_out <= rom_data;
			elsif (ADDR = x"FFF0") then data_out <= port_in_00;
			elsif (ADDR = x"FFF1") then data_out <= port_in_01;
			elsif (ADDR = x"FFF2") then data_out <= port_in_02;
			elsif (ADDR = x"FFF3") then data_out <= port_in_03;
			elsif (ADDR = x"FFF4") then data_out <= port_in_04;
			elsif (ADDR = x"FFF5") then data_out <= port_in_05;
			elsif (ADDR = x"FFF6") then data_out <= port_in_06;
			elsif (ADDR = x"FFF7") then data_out <= port_in_07;
			elsif (ADDR = x"FFF8") then data_out <= port_in_08;
			elsif (ADDR = x"FFF9") then data_out <= port_in_09;
			elsif (ADDR = x"FFFA") then data_out <= port_in_10;
			elsif (ADDR = x"FFFB") then data_out <= port_in_11;
			elsif (ADDR = x"FFFC") then data_out <= port_in_12;
			elsif (ADDR = x"FFFD") then data_out <= port_in_13;
			elsif (ADDR = x"FFFE") then data_out <= port_in_14;
			elsif (ADDR = x"FFFF") then data_out <= port_in_15;
			else data_out <= x"0000";
			end if;
		
		end process;

end architecture;