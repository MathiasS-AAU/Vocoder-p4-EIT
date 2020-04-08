LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY PC IS PORT(
    d   : IN STD_LOGIC_VECTOR(31 downto 0); -- input 32 bit værdi
    ld  : IN STD_LOGIC; -- load/enable: eller write enable
    clr : IN STD_LOGIC; -- async. clear: wiper på risingedge når der loades på falling (dvs instant)
    clk : IN STD_LOGIC; -- clock.
	 inc : IN STD_LOGIC; -- increment
    q   : INOUT STD_LOGIC_VECTOR(31 downto 0) -- output 32 bit værdi
);
END PC;

ARCHITECTURE description OF PC IS

BEGIN
    process(clk, clr) -- Der er clk og clr der bestemmer hvornår der skal ske noget
    begin
        if clr = '1' then -- Hvis clr = 1 skal registeret wipes (Står først som højeste prioritet)
            q <= x"00000000"; -- 32-bit binær værdi i hex (x)
        elsif rising_edge(clk) then
            if ld = '1' then -- Ellers skal der ved hvert clk tjekkes om der skal writes til outputpin/gemmes
                q <= d;
            end if;
				if inc = '1' then
					q <= q + 4;
				end if;
        end if;
    end process;
END description;
