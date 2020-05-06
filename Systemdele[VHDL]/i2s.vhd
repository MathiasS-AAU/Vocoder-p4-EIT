LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

--Mono i2s bus slave
ENTITY i2s IS PORT(
	--Intern I/O
	data_in   : INOUT STD_LOGIC_VECTOR(15 downto 0); -- input 16 bit signed værdi
	data_out   : INOUT STD_LOGIC_VECTOR(15 downto 0); -- output 16 bit signed værdi. dual mono output. Værdi bør indsættes når WS stiger.
	--i2s bus
   SCK  : INOUT STD_LOGIC; -- continuous serial clock
   WS : INOUT STD_LOGIC; -- word select (channel select) 0 = Left, 1 = Right
   SD_in : INOUT STD_LOGIC; -- Serial data
	SD_out : INOUT STD_LOGIC -- Serial data


);
END i2s;

ARCHITECTURE description OF i2s IS--

	--Skifteregistre
	signal 	data_in_L_buff   :  STD_LOGIC_VECTOR(15 downto 0); -- input 16 bit signed værdi
	signal	data_out_L_buff   :  STD_LOGIC_VECTOR(15 downto 0); -- output 16 bit signed værdi.
	signal	data_out_R_buff   :  STD_LOGIC_VECTOR(15 downto 0); -- output 16 bit signed værdi. Gentagelse af data_out_buff_L
	
	--Edge detector
	signal	Last_WS :  STD_LOGIC;
	signal	WS_state :  STD_LOGIC_VECTOR(1 downto 0);
	
	--Edge detector values
	constant low : std_logic_vector(1 downto 0) :="00";
	constant high : std_logic_vector(1 downto 0) :="11";
	constant Rising : std_logic_vector(1 downto 0) :="01";
	constant Falling : std_logic_vector(1 downto 0) :="10";
	
	-- Nedtællerværdiers betydning
	constant One_cycle_before_MSB : std_logic_vector(4 downto 0) :="10000";
	constant MSB_cycle : std_logic_vector(4 downto 0) :="10000";
	constant One_cycle_after_LSB : std_logic_vector(4 downto 0) :="11111";
	constant Two_cycles_after_LSB : std_logic_vector(4 downto 0) :="11110";
	-- Hvis bit position 4 er høj er protokollen ikke i gang med at sende værdien. MSB er på "01111", LSB er på "00000"
	
	--Nedtællere
	signal	Ch_counter :  STD_LOGIC_VECTOR(4 downto 0) :=Two_cycles_after_LSB; -- Channel counter left. Bruges til at håndtere overlap
	
BEGIN
	
	-- Viser de to sidste WS målinger. Bruges til at tjekke om WS er rising eller falling. MÅ KUN TJEKKES PÅ FALLING_EDGE(SCK)!
WS_state_P :  process (SCK, WS)
				begin
					if rising_edge(SCK) then
						WS_state(1) <= WS_state(0);
						WS_state(0) <= WS;
					end if;
				end process;
	
	-- Nedtæller til venstre skifteregister.
Counter :	process (SCK, WS_state) -- Det er SCK og WS der bestemmer hvornår der skal ske noget
				begin
					if falling_edge(SCK) then
						if WS_state = falling or WS_state = rising then
							Ch_counter <= MSB_cycle; -- Start på 15 også kaldt MSB_cycle.

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
					for i in 15 downto 1 loop -- ryk skifteregister. MSB ender i data_in_L_buff(15)
						data_in_L_buff(i) <= data_in_L_buff(i-1); --Læs en bit af gangen ind i buffer MSB først
					end loop;
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
					end if;
					if (WS_state = Falling or WS_state = Low) then --Hvis Ch_counter_L er 15 til 0. D.v.s. hvis venstre kanal er aktiv

						--Output MSB først
						SD_out <= data_out_L_buff(15);
						for i in 15 downto 1 loop --ryk skifteregister
							data_out_L_buff(i) <= data_out_L_buff(i-1); --Læs en bit af gangen ind i buffer MSB først
						end loop;
						data_out_L_buff(0) <= '0';
					
					elsif  (WS_state = Rising or WS_state = High) then --Hvis Ch_counter_R er 15 til 0. D.v.s. hvis Højre kanal er aktiv
						SD_out <= data_out_R_buff(15);
						for i in 15 downto 1 loop --ryk skifteregister
							data_out_R_buff(i) <= data_out_R_buff(i-1); --Læs en bit af gangen ind i buffer MSB først
						end loop;
						data_out_R_buff(0) <= '0';
					
					end if;
				 end if;
			  end process;

	
	
END description;
