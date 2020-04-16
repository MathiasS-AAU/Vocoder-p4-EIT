----------------------------------------------------------------------------------
-- Company:				AAU
-- Engineer: 			EIT4-415
-- Create Date:    	15/04/2020 
-- Design Name: 	 	Program Memory
-- Module Name:    	ROM - rom_32733x16_sync - Behavioral 
-- Description:		Read Only Memory (Don't overwrite the program!)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

entity rom_32767x16_sync is
	port(CLK	 	  : in std_logic; 							-- Clock signal
		  ADDR	  : in std_logic_vector(15 downto 0);  -- Number of adresses
		  data_out : out std_logic_vector(15 downto 0) -- Output data, 16 bit
        );
end rom_32767x16_sync;

architecture rom_32767x16_sync_arch of rom_32767x16_sync is
	signal EN : std_logic; -- An internal enable that will prevent data_out assignments for addresses outside of this valid range.
	--Load and store Mnemonics
	constant LDA_IMM : std_logic_vector(15 downto 0) :=x"0001"; -- Load A using immediate addressing
	constant LDA_DIR : std_logic_vector(15 downto 0) :=x"0002";	-- Load A using direct addressing
	constant LDB_IMM : std_logic_vector(15 downto 0) :=x"0003"; -- Load B using immediate addressing
	constant LDB_DIR : std_logic_vector(15 downto 0) :=x"0004"; -- Load B using direct addressing
	constant STA_DIR : std_logic_vector(15 downto 0) :=x"0005"; -- Store A using direct addressing
	constant STB_DIR : std_logic_vector(15 downto 0) :=x"0006";	-- Store B using direct addressing
	
	--Data manipulation
	constant ADD_AB : std_logic_vector(15 downto 0) :=x"0007"; -- Add A and B and store the result in A
	constant SUB_AB : std_logic_vector(15 downto 0) :=x"0008"; -- Subtract A with B and store the result in A
	constant SUB_BA : std_logic_vector(15 downto 0) :=x"0009"; -- Subtract B with A and store the result in A
	constant MUL_AB : std_logic_vector(15 downto 0) :=x"000A"; -- Multiply A and B and store the result in A
	constant DIV_AB : std_logic_vector(15 downto 0) :=x"000B"; -- Divide A with B and store the result in A
	constant DIV_BA : std_logic_vector(15 downto 0) :=x"000C"; -- Divide B with A and store the result in A
	constant AND_AB : std_logic_vector(15 downto 0) :=x"000D"; -- AND operation with A and B and store the result in A
	constant OR_AB  : std_logic_vector(15 downto 0) :=x"000E"; -- OR operation with A and B and store the result in A
	constant NOT_A  : std_logic_vector(15 downto 0) :=x"000F"; -- Invert A and store the result in A
	
	--Branches
	constant BRA : std_logic_vector(15 downto 0) :=x"0010"; -- Branch always, unconditional jump 
	constant BNT : std_logic_vector(15 downto 0) :=x"0011"; -- Branch if N flag is high, conditional jump 
	constant BNF : std_logic_vector(15 downto 0) :=x"0012"; -- Branch if N flag is low, conditional jump 
	constant BZT : std_logic_vector(15 downto 0) :=x"0013"; -- Branch if Z flag is high, conditional jump 
	constant BZF : std_logic_vector(15 downto 0) :=x"0014"; -- Branch if Z flag is low, conditional jump 
	constant BVT : std_logic_vector(15 downto 0) :=x"0015"; -- Branch if V flag is high, conditional jump 
	constant BVF : std_logic_vector(15 downto 0) :=x"0016"; -- Branch if V flag is low, conditional jump 
	constant BCT : std_logic_vector(15 downto 0) :=x"0017"; -- Branch if C flag is high, conditional jump 
	constant BCF : std_logic_vector(15 downto 0) :=x"0018"; -- Branch if C flag is low, conditional jump 
	

	type rom_type is array (0 to 32767) of std_logic_vector(15 downto 0); -- Read only 16 x 16 bit memory. 32767 adresses of 16 bits.
	constant ROM : rom_type := ( --Write code to be executed here
	
	
											others => x"0000"); -- Unused ROM is set to value 0.
begin								
	-- Enable process. Verifies if given adress is within ROM size.
	ENABLE : process (ADDR)
				begin
					if (to_integer(unsigned(ADDR)) >=0 and(to_integer(unsigned(ADDR)) <=32767)) then
						EN <= '1';		-- If 0 <= ADDR <= 32767 then set EN to 1.
					else
						EN <='0';
					end if;
				end process;
				
	-- Memory access process. 
	MEMORY : process (CLK)															-- If there is a rising clock edge
				begin 																	-- and EN = 1, then take whatever is
					if (rising_edge (CLK)) then									-- on adress ADDR and put in into data_out
						if (EN = '1') then
							data_out <= ROM(to_integer(unsigned(ADDR)));
						end if;
					end if;
				end process;

end architecture;