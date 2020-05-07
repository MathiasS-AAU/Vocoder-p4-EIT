library IEEE;
use IEEE.STD_LOGIC_1164.ALL;		-- Logical units
use IEEE.STD_LOGIC_UNSIGNED.ALL;	-- Unsigned units
use ieee.NUMERIC_STD.all;			-- Addition incode and such

--Mono i2s bus slave
ENTITY i2s IS 
	generic ( 
		constant N: natural := 1;  -- Number of shifted or rotated bits
		data_width          :  INTEGER := 16
   );
PORT(
	--Intern I/O
	data_in   : OUT STD_LOGIC_VECTOR(15 downto 0):= (others => '0'); -- input 16 bit signed værdi
	data_out   : IN STD_LOGIC_VECTOR(15 downto 0):= x"1111"; -- output 16 bit signed værdi. dual mono output. Værdi bør indsættes når WS stiger.
	--i2s bus
   SCK  : IN STD_LOGIC; -- continuous serial clock
   WS : IN STD_LOGIC; -- word select (channel select) 0 = Left, 1 = Right
   SD_in : IN STD_LOGIC; -- Serial data
	SD_out : OUT STD_LOGIC -- Serial data


);
END i2s;

ARCHITECTURE description OF i2s IS--

	--Skifteregistre
	signal 	data_in_L_buff   :  STD_LOGIC_VECTOR(data_width-1 downto 0) := (others => '0'); -- input 16 bit signed værdi
	signal	data_out_L_buff   :  STD_LOGIC_VECTOR(data_width-1 downto 0) := (others => '0'); -- output 16 bit signed værdi.
	signal	data_out_R_buff   :  STD_LOGIC_VECTOR(data_width-1 downto 0) := (others => '0'); -- output 16 bit signed værdi. Gentagelse af data_out_buff_L
	
	--Edge detector
	signal	WS_state :  STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
	
	--Edge detector values
	constant low : std_logic_vector(1 downto 0) :="00";
	constant high : std_logic_vector(1 downto 0) :="11";
	constant Rising : std_logic_vector(1 downto 0) :="01";
	constant Falling : std_logic_vector(1 downto 0) :="10";
	
	-- Nedtællerværdiers betydning
	constant One_cycle_before_MSB : std_logic_vector(4 downto 0) :="10000";
	constant MSB_cycle : std_logic_vector(4 downto 0) :="01111";
	constant One_cycle_after_LSB : std_logic_vector(4 downto 0) :="11111";
	constant Two_cycles_after_LSB : std_logic_vector(4 downto 0) :="11110";
	-- Hvis bit position 4 er høj er protokollen ikke i gang med at sende værdien. MSB er på "01111", LSB er på "00000"
	
	--Nedtællere
	signal	Ch_counter :  STD_LOGIC_VECTOR(4 downto 0) :=Two_cycles_after_LSB; -- Channel counter left. Bruges til at håndtere overlap
	
BEGIN
	SD_out <= data_out_L_buff(data_width-1);
	-- Viser de to sidste WS målinger. Bruges til at tjekke om WS er rising eller falling. MÅ KUN TJEKKES PÅ FALLING_EDGE(SCK)!
WS_state_P :  process (SCK, WS)
				begin
					if rising_edge(SCK) then
						WS_state <= WS_state(0) & WS;
					end if;
				end process;
	
	-- Nedtæller til venstre skifteregister.
Counter :	process (SCK, WS_state) -- Det er SCK og WS der bestemmer hvornår der skal ske noget
				begin
					if falling_edge(SCK) then
						if WS_state = falling then
							Ch_counter <= MSB_cycle; -- Start på 15 også kaldt MSB_cycle.
						elsif WS_state = rising then
							Ch_counter <= Two_cycles_after_LSB;
						elsif Ch_counter /= Two_cycles_after_LSB then -- Gør ingenting efter -1 også kaldt One_cycle_after_LSB.
							Ch_counter <= Ch_counter - 1; --Tæl ned
						end if;
					end if;
				end process;

	
	-- Indlæsning til skifteregister. venstre input
Input : process(SCK, Ch_counter, WS_state) -- Det er SCK og Ch_counter_L der bestemmer hvornår der skal ske noget 
			 begin
				if rising_edge(SCK) then
					if Ch_counter(4)='0' then -- Hvis Ch_counter_L er 15 til 0. D.v.s. hvis venstre kanal er aktiv
						data_in_L_buff <= data_in_L_buff(data_width-2 downto 0)& sd_in; --Læs en bit af gangen ind i buffer MSB først
					data_in_L_buff(0) <= SD_in;
					end if;
				end if;
				if falling_edge(SCK) and WS_state = Rising then
					data_in <= data_in_L_buff;
				end if;
			 end process;
	
	-- Output fra skifteregister. Venstre og højre output
Output : process(SCK, WS_state) -- Det er SCK og Ch_counter_L der bestemmer hvornår der skal ske noget
			  begin
				if falling_edge(SCK) then
					if WS_state = Falling then
						--Sæt dual mono output værdi
						data_out_L_buff <= data_out;
						data_out_R_buff <= data_out;
					elsif WS_state = Rising then
					   data_out_L_buff <= data_out_R_buff;
					end if;
					if (WS_state = Falling) then --Hvis Ch_counter_L er 15 til 0. D.v.s. hvis venstre kanal er aktiv

						--Output MSB først
						--SD_out <= data_out_L_buff(data_width-1);
					elsif (WS_state = Low) or (WS_state = High) then --Hvis Ch_counter_L er 15 til 0. D.v.s. hvis venstre kanal er aktiv

						--Output MSB først
						--SD_out <= data_out_L_buff(data_width-1);
						data_out_L_buff <= data_out_L_buff(data_width-2 downto 0) & '0'; --Læs en bit af gangen ind i buffer MSB først
					
					--elsif  (WS_state = Rising) then --Hvis Ch_counter_R er 15 til 0. D.v.s. hvis Højre kanal er aktiv
						--SD_out <= data_out_R_buff(data_width-1);
					--elsif  (WS_state = High) then --Hvis Ch_counter_R er 15 til 0. D.v.s. hvis Højre kanal er aktiv
						--SD_out <= data_out_R_buff(data_width-1);
						--data_out_R_buff <= data_out_R_buff(data_width-2 downto 0) & '0'; --Læs en bit af gangen ind i buffer MSB først
					
					end if;
				 end if;
			  end process;

	
	
END description;
