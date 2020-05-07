-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY tb_i2s IS
  END tb_i2s;

  ARCHITECTURE behavior OF tb_i2s IS 

  -- Component Declaration
          COMPONENT i2s
          PORT(
                  --Intern I/O
						data_in   : INOUT STD_LOGIC_VECTOR(15 downto 0); -- input 16 bit signed værdi
						data_out   : INOUT STD_LOGIC_VECTOR(15 downto 0); -- output 16 bit signed værdi. dual mono output. Værdi bør indsættes når WS stiger.
						--i2s bus
						SCK  : INOUT STD_LOGIC; -- continuous serial clock
						WS : INOUT STD_LOGIC; -- word select (channel select) 0 = Left, 1 = Right
						SD_in : INOUT STD_LOGIC; -- Serial data
						SD_out : INOUT STD_LOGIC -- Serial data
               );
          END COMPONENT;
			 
			 --Intern I/O

         SIGNAL data_in   : STD_LOGIC_VECTOR(15 downto 0) := x"0000"; -- input 16 bit signed værdi
			signal data_out  : STD_LOGIC_VECTOR(15 downto 0) := x"0000"; -- output 16 bit signed værdi.
			
			--i2s bus
			Signal SCK  : STD_LOGIC := '0'; -- continuous serial clock
			Signal WS : STD_LOGIC := '1'; -- word select (channel select) 0 = Left, 1 = Right
			Signal SD_in : STD_LOGIC := '0'; -- Serial data
			Signal SD_out : STD_LOGIC := '0'; -- Serial data
          
			constant SCK_period : time := 40 ns; --25 MHz
			
			--values
			constant value1 : std_logic_vector(15 downto 0) :=x"FAFA";
			constant value2 : std_logic_vector(15 downto 0) :=x"AFAF";
			constant value1_L : std_logic_vector(23 downto 0) :=x"FAFAAF";
			constant value2_L : std_logic_vector(23 downto 0) :=x"AFAFFA";
  BEGIN

  -- Component Instantiation
          uut: i2s PORT MAP(
                  data_in => data_in,
                  data_out => data_out,
						SCK => SCK,
						WS => WS,
						SD_in => SD_in,
						SD_out => SD_out
          );
			 
			 
	-- clock process
		serial_clock : PROCESS
		BEGIN
		SCK <= '0';
		wait for SCK_period/2;
		SCK <= '1';
		wait for SCK_period/2;
		END PrOcEsS;
  
		data_out <= data_in;
  --  Test Bench Statements
     tb : PROCESS
     BEGIN

        wait for SCK_period; -- wait until global set/reset completes
		  WS <= '0';
		  SD_in <= '0';
		  
		  for i in 0 to 23 loop
			wait for SCK_period;
			SD_in <= '1';
		  end loop;
		  --data_out <= Value1;
		  WS <= not WS;-- 1
		  SD_in <= '1';
		  
		  for i in 0 to 23 loop
			wait for SCK_period;
			SD_in <= '0';
		  end loop;
		  WS <= not WS; --0
		  for i in 0 to 23 loop
			wait for SCK_period;
			SD_in <= Value1_L(23-i);
		  end loop;
		  --data_out <= Value2;
		  WS <= not WS;--1
		  for i in 0 to 23 loop
			wait for SCK_period;
			SD_in <= '0';
		  end loop;
		  WS <= not WS;--0
		  for i in 0 to 23 loop
			wait for SCK_period;
			SD_in <= Value2_L(23-i);
		  end loop;
		  --data_out <= Value1;
		  WS <= not WS;--1
		  for i in 0 to 23 loop
			wait for SCK_period;
			SD_in <= '0';
		  end loop;
		  WS <= not WS;--0
		  for i in 0 to 23 loop
			wait for SCK_period;
			SD_in <= Value1_L(23-i);
		  end loop;
		  --data_out <= Value2;
		  WS <= not WS;--1
		  for i in 0 to 23 loop
			wait for SCK_period;
			SD_in <= '0';
		  end loop;
		  WS <= not WS;--0
		  for i in 0 to 23 loop
			wait for SCK_period;
			SD_in <= Value2_L(23-i);
		  end loop;
		  WS <= not WS;--1
		  for i in 0 to 23 loop
			wait for SCK_period;
			SD_in <= '0';
		  end loop;
		  WS <= not WS;--0
        -- Add user defined stimulus here

        wait; -- will wait forever
     END PROCESS;
  --  End Test Bench 

  END;
