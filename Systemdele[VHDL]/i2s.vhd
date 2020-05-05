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
	SD_out : INOUT STD_LOGIC; -- Serial data
	--Databehandling
    data_in_L_buff   : INOUT STD_LOGIC_VECTOR(15 downto 0); -- input 16 bit signed værdi
	data_out_buff_L   : INOUT STD_LOGIC_VECTOR(15 downto 0); -- output 16 bit signed værdi.
	data_out_buff_R   : INOUT STD_LOGIC_VECTOR(15 downto 0); -- output 16 bit signed værdi. Gentagelse af data_out_buff_L
	Ch_counter_L : INOUT STD_LOGIC_VECTOR(4 downto 0); -- Channel counter left. Bruges til at håndtere overlap
	Ch_counter_R : INOUT STD_LOGIC_VECTOR(4 downto 0) -- Channel counter right. Bruges til at håndtere overlap
);
END i2s;

ARCHITECTURE description OF i2s IS

	-- Nedtællerværdiers betydning
	constant One_cycle_before_MSB : std_logic_vector(4 downto 0) :="10000";
	constant One_cycle_after_LSB : std_logic_vector(4 downto 0) :="11111";
	constant Two_cycles_after_LSB : std_logic_vector(4 downto 0) :="11110";
	-- Hvis bit position 4 er høj er protokollen ikke i gang med at sende værdien. MSB er på "01111", LSB er på "00000"
	
BEGIN
	process(Ch_counter_L) -- Der er ch_counter_L der bestemmer hvornår der skal ske noget -- Kontrolenhed til intern I/O
	begin
			if ch_counter_L = One_cycle_before_MSB then
			--Sæt dual mono output værdi
			data_out_L_buff <= data_out;
			data_out_R_buff <= data_out;
			else if ch_counter_L = One_cycle_after_LSB then
			data_in <= data_in_L_buff;
			end if;
	end process;
	
	-- Nedtæller til venstre shift registre. Anvendes af intern I/O.
	process(SCK, WS) -- Det er SCK og WS der bestemmer hvornår der skal ske noget
	begin
		if falling_edge(WS) then
			Ch_counter_L <= One_cycle_before_MSB; -- Start på 16 også kaldt One_cycle_before_MSB.
		
		else if ch_counter_L = Two_cycles_after_LSB then; -- Gør ingenting efter -1 også kaldt One_cycle_after_LSB.
		
		else if falling_edge(SCK) then
			Ch_counter_L <= Ch_counter_L - 1;
		end if;
	end process;
	
	-- nedtæller til højre shift registre.
	process(SCK, WS) -- Det er SCK og WS der bestemmer hvornår der skal ske noget 
	begin
		if rising_edge(WS) then
			Ch_counter_R <= One_cycle_before_MSB; -- Start på 16 også kaldt One_cycle_before_MSB.
		
		else if ch_counter_R = Two_cycles_after_LSB then; -- Gør ingenting efter -1 også kaldt One_cycle_after_LSB.
		
		else if falling_edge(SCK) then
			Ch_counter_R <= Ch_counter_R - 1;
		end if;
	end process;
	
	-- Indlæsning til skifteregister. venstre input
    process(SCK, Ch_counter_L) -- Det er SCK og Ch_counter_L der bestemmer hvornår der skal ske noget 
    begin
		if not Ch_counter_L(4) then -- Hvis Ch_counter_L er 15 til 0. D.v.s. hvis venstre kanal er aktiv
			wait until rising_edge(SCK);
			data_in_L_buff(0) := SD_in;
			for i in 15 downto 1 loop -- ryk skifteregister. MSB ender i data_in_L_buff(15)
				data_in_L_buff(i) := data_in_L_buff(i-1); --Læs en bit af gangen ind i buffer MSB først
			end loop;
		end if;
    end process;
	
	-- Output fra skifteregister. Venstre output
	process(SCK, Ch_counter_L) -- Det er SCK og Ch_counter_L der bestemmer hvornår der skal ske noget
    begin
		if not Ch_counter_L(4) then --Hvis Ch_counter_L er 15 til 0. D.v.s. hvis venstre kanal er aktiv
				--Output MSB først
				SD_out := data_out_L_buff(15);
			for i in 15 downto 1 loop --ryk skifteregister
				data_out_L_buff(i) := data_out_L_buff(i-1); --Læs en bit af gangen ind i buffer MSB først
			end loop;
			wait until falling_edge(SCK);
		end if;
    end process;
	
	-- Output fra shift register. Højre output
	process(SCK, Ch_counter_R) -- Det er SCK og Ch_counter_R der bestemmer hvornår der skal ske noget
    begin
		if not Ch_counter_R(4) then --Hvis Ch_counter_R er 15 til 0. D.v.s. hvis Højre kanal er aktiv
				SD_out := data_out_R_buff(15);
			for i in 15 downto 1 loop --ryk skifteregister
				data_out_R_buff(i) := data_out_R_buff(i-1); --Læs en bit af gangen ind i buffer MSB først
			end loop;
			wait until falling_edge(SCK);
		end if;
    end process;
	
	
END description;
