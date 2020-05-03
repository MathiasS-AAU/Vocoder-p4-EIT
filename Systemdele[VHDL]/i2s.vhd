LIBRARY ieee;
USE ieee.std_logic_1164.all;
--USE ieee.std_logic_arith.ALL;
--USE ieee.std_logic_signed.ALL;

ENTITY i2s IS PORT(
    data_in_L_buff   : INOUT STD_LOGIC_VECTOR(15 downto 0); -- input 16 bit signed værdi
	data_in_L   : INOUT STD_LOGIC_VECTOR(15 downto 0); -- input 16 bit signed værdi
	--data_in_R   : INOUT STD_LOGIC_VECTOR(15 downto 0); -- input 16 bit signed værdi
	data_out   : INOUT STD_LOGIC_VECTOR(15 downto 0); -- output 16 bit signed værdi
    SCK  : INOUT STD_LOGIC; -- continuous serial clock
    WS : INOUT STD_LOGIC; -- word select (channel select) 0 = Left, 1 = Right
    SD_in : INOUT STD_LOGIC -- Serial data
	SD_out : INOUT STD_LOGIC -- Serial data
);
END i2s;

ARCHITECTURE description OF i2s IS

BEGIN
    process(SCK, WS) -- Der er SCK og WS der bestemmer hvornår der skal ske noget
    begin
        if (not WS) or falling_edge(WS)  then -- Hvis venstre kanal er aktiv
		for i in 15 downto 0 loop --MSB først
        data_in_L_buff(i) <= SD_in --Læs en bit af gangen ind i buffer MSB først
		wait until falling_edge(SCK) 											--Er dette kun til simulering?
		end loop
		else if rising_edge(WS) then
		data_in_L <= data_in_L_buff --Når venstre kanal er færdig. Vis værdi.
        end if;
    end process;
END description;
