LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

--Mono i2s bus slave
ENTITY i2s IS PORT(
	--Intern I/O
	data_in   : INOUT STD_LOGIC_VECTOR(15 downto 0); -- input 16 bit signed v�rdi
	data_out   : INOUT STD_LOGIC_VECTOR(15 downto 0); -- output 16 bit signed v�rdi. dual mono output. V�rdi b�r inds�ttes n�r WS stiger.
	--i2s bus
    SCK  : INOUT STD_LOGIC; -- continuous serial clock
    WS : INOUT STD_LOGIC; -- word select (channel select) 0 = Left, 1 = Right
    SD_in : INOUT STD_LOGIC; -- Serial data
	SD_out : INOUT STD_LOGIC; -- Serial data
	--Databehandling
    data_in_L_buff   : INOUT STD_LOGIC_VECTOR(15 downto 0); -- input 16 bit signed v�rdi
	data_out_buff_L   : INOUT STD_LOGIC_VECTOR(15 downto 0); -- output 16 bit signed v�rdi.
	data_out_buff_R   : INOUT STD_LOGIC_VECTOR(15 downto 0); -- output 16 bit signed v�rdi. Gentagelse af data_out_buff_L
	Ch_counter_L : INOUT STD_LOGIC_VECTOR(4 downto 0); -- Channel counter left. Bruges til at h�ndtere overlap
	Ch_counter_R : INOUT STD_LOGIC_VECTOR(4 downto 0) -- Channel counter right. Bruges til at h�ndtere overlap
);
END i2s;

ARCHITECTURE description OF i2s IS

	-- Nedt�llerv�rdiers betydning
	constant One_cycle_before_MSB : std_logic_vector(4 downto 0) :="10000";
	constant One_cycle_after_LSB : std_logic_vector(4 downto 0) :="11111";
	constant Two_cycles_after_LSB : std_logic_vector(4 downto 0) :="11110";
	-- Hvis bit position 4 er h�j er protokollen ikke i gang med at sende v�rdien. MSB er p� "01111", LSB er p� "00000"
	
BEGIN
	process(Ch_counter_L) -- Der er ch_counter_L der bestemmer hvorn�r der skal ske noget -- Kontrolenhed til intern I/O
	begin
			if ch_counter_L = One_cycle_before_MSB then
			--S�t dual mono output v�rdi
			data_out_L_buff <= data_out;
			data_out_R_buff <= data_out;
			else if ch_counter_L = One_cycle_after_LSB then
			data_in <= data_in_L_buff;
			end if;
	end process;
	
	-- Nedt�ller til venstre shift registre. Anvendes af intern I/O.
	process(SCK, WS) -- Det er SCK og WS der bestemmer hvorn�r der skal ske noget
	begin
		if falling_edge(WS) then
			Ch_counter_L <= One_cycle_before_MSB; -- Start p� 16 ogs� kaldt One_cycle_before_MSB.
		
		else if ch_counter_L = Two_cycles_after_LSB then; -- G�r ingenting efter -1 ogs� kaldt One_cycle_after_LSB.
		
		else if falling_edge(SCK) then
			Ch_counter_L <= Ch_counter_L - 1;
		end if;
	end process;
	
	-- nedt�ller til h�jre shift registre.
	process(SCK, WS) -- Det er SCK og WS der bestemmer hvorn�r der skal ske noget 
	begin
		if rising_edge(WS) then
			Ch_counter_R <= One_cycle_before_MSB; -- Start p� 16 ogs� kaldt One_cycle_before_MSB.
		
		else if ch_counter_R = Two_cycles_after_LSB then; -- G�r ingenting efter -1 ogs� kaldt One_cycle_after_LSB.
		
		else if falling_edge(SCK) then
			Ch_counter_R <= Ch_counter_R - 1;
		end if;
	end process;
	
	-- Indl�sning til skifteregister. venstre input
    process(SCK, Ch_counter_L) -- Det er SCK og Ch_counter_L der bestemmer hvorn�r der skal ske noget 
    begin
		if not Ch_counter_L(4) then -- Hvis Ch_counter_L er 15 til 0. D.v.s. hvis venstre kanal er aktiv
			wait until rising_edge(SCK);
			data_in_L_buff(0) := SD_in;
			for i in 15 downto 1 loop -- ryk skifteregister. MSB ender i data_in_L_buff(15)
				data_in_L_buff(i) := data_in_L_buff(i-1); --L�s en bit af gangen ind i buffer MSB f�rst
			end loop;
		end if;
    end process;
	
	-- Output fra skifteregister. Venstre output
	process(SCK, Ch_counter_L) -- Det er SCK og Ch_counter_L der bestemmer hvorn�r der skal ske noget
    begin
		if not Ch_counter_L(4) then --Hvis Ch_counter_L er 15 til 0. D.v.s. hvis venstre kanal er aktiv
				--Output MSB f�rst
				SD_out := data_out_L_buff(15);
			for i in 15 downto 1 loop --ryk skifteregister
				data_out_L_buff(i) := data_out_L_buff(i-1); --L�s en bit af gangen ind i buffer MSB f�rst
			end loop;
			wait until falling_edge(SCK);
		end if;
    end process;
	
	-- Output fra shift register. H�jre output
	process(SCK, Ch_counter_R) -- Det er SCK og Ch_counter_R der bestemmer hvorn�r der skal ske noget
    begin
		if not Ch_counter_R(4) then --Hvis Ch_counter_R er 15 til 0. D.v.s. hvis H�jre kanal er aktiv
				SD_out := data_out_R_buff(15);
			for i in 15 downto 1 loop --ryk skifteregister
				data_out_R_buff(i) := data_out_R_buff(i-1); --L�s en bit af gangen ind i buffer MSB f�rst
			end loop;
			wait until falling_edge(SCK);
		end if;
    end process;
	
	
END description;
