-- Register:
--		16 bits
--		8 words
--		Two outputs

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity reg16_8 is
Port ( I_clk : in  STD_LOGIC;									-- Clock
       I_en : in  STD_LOGIC;									-- Enable clock in system
       I_dataD : in  STD_LOGIC_VECTOR (15 downto 0);	-- Data input: 16 bit
       O_dataA : out  STD_LOGIC_VECTOR (15 downto 0); -- Data output, parameter A: 16 bit
       O_dataB : out  STD_LOGIC_VECTOR (15 downto 0); -- Data output, parameter B: 16 bit
       I_selA : in  STD_LOGIC_VECTOR (2 downto 0);		-- Parameter A register adress select to show on output: 3 bit
       I_selB : in  STD_LOGIC_VECTOR (2 downto 0);		-- Parameter B register adress select to show on output: 3 bit
       I_selD : in  STD_LOGIC_VECTOR (2 downto 0);		-- Write to this register if enable is high: 3 bit
       I_we : in  STD_LOGIC);									-- Write enable pin
end reg16_8;
 
architecture description of reg16_8 is
  type store_t is array (0 to 7) of std_logic_vector(15 downto 0);	-- Define array with 8 spots; every spot i 16 deep
  signal regs: store_t := (others => x"0000");								-- Set all array values to b0000 0000 0000 0000 = x0000 (16 bit: binary to hex)

begin
	process(I_clk, I_en)														-- Do something when clk and I_en changes
	begin
		if rising_edge(I_clk) and I_en='1' then						-- If clk and enable pin is high:
			O_dataA <= regs(to_integer(unsigned(I_selA)));				-- Show selected A value on output pin A
			O_dataB <= regs(to_integer(unsigned(I_selB)));				-- Show selected B value on output pin B
				if (I_we = '1') then												-- If write enable is high:
					regs(to_integer(unsigned(I_selD))) <= I_dataD;				-- Safe input data on selected register
				end if;
		end if;
	end process;
end description;