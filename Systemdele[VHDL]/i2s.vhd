LIBRARY ieee;
USE ieee.std_logic_1164.all;
--USE ieee.std_logic_arith.ALL;
--USE ieee.std_logic_signed.ALL;

ENTITY i2s IS PORT(
    data_in_L_buff   : INOUT STD_LOGIC_VECTOR(15 downto 0); -- input 16 bit signed v�rdi
	data_in_L   : INOUT STD_LOGIC_VECTOR(15 downto 0); -- input 16 bit signed v�rdi
	--data_in_R   : INOUT STD_LOGIC_VECTOR(15 downto 0); -- input 16 bit signed v�rdi
	data_out   : INOUT STD_LOGIC_VECTOR(15 downto 0); -- output 16 bit signed v�rdi
    SCK  : INOUT STD_LOGIC; -- continuous serial clock
    WS : INOUT STD_LOGIC; -- word select (channel select) 0 = Left, 1 = Right
    SD_in : INOUT STD_LOGIC -- Serial data
	SD_out : INOUT STD_LOGIC -- Serial data
);
END i2s;

ARCHITECTURE description OF i2s IS

BEGIN
    process(SCK, WS) -- Der er SCK og WS der bestemmer hvorn�r der skal ske noget
    begin
        if (not WS) or falling_edge(WS)  then -- Hvis venstre kanal er aktiv
		for i in 15 downto 0 loop --MSB f�rst
        data_in_L_buff(i) <= SD_in --L�s en bit af gangen ind i buffer MSB f�rst
		wait until falling_edge(SCK) 											--Er dette kun til simulering?
		end loop
		else if rising_edge(WS) then
		data_in_L <= data_in_L_buff --N�r venstre kanal er f�rdig. Vis v�rdi.
        end if;
    end process;
END description;
