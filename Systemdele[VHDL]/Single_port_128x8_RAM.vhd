library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

-- 128x8 single-port RAM
entity Single_port_RAM_VHDL is
port(
 RAM_ADDR: in std_logic_vector(6 downto 0); 		-- Address to write/read RAM
 RAM_DATA_IN: in std_logic_vector(7 downto 0); 	-- Data to write into RAM
 RAM_WR: in std_logic; 									-- Write enable 
 RAM_CLOCK: in std_logic; 								-- clock input for RAM
 RAM_DATA_OUT: out std_logic_vector(7 downto 0) -- Data output of RAM
);
end Single_port_RAM_VHDL;

architecture Behavioral of Single_port_RAM_VHDL is
-- Vi definerer 128 x 8 RAM
type RAM_ARRAY is array (0 to 127 ) of std_logic_vector (7 downto 0);
--Startværdier i RAM
signal RAM: RAM_ARRAY :=(
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00", 
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00", 
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00", 
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00", 
   x"00",x"00",x"00",x"00", 
   x"00",x"00",x"00",x"00", 
   x"00",x"00",x"00",x"00", 
   x"00",x"00",x"00",x"00", 
   x"00",x"00",x"00",x"00", 
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00", 
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00"
   ); 
begin
process(RAM_CLOCK)
begin
 if(rising_edge(RAM_CLOCK)) then
	 if(RAM_WR='1') then -- Når write enable WR = 1... 
	 RAM(to_integer(unsigned(RAM_ADDR))) <= RAM_DATA_IN; --...så skriv input data ind i RAM på den angivne adresse 
	 -- The index of the RAM array type needs to be integer so
	 -- converts RAM_ADDR from std_logic_vector -> Unsigned -> Interger using numeric_std library
	 end if;
 end if;
end process;
 -- Data der læses på output
 RAM_DATA_OUT <= RAM(to_integer(unsigned(RAM_ADDR)));
end Behavioral;


			