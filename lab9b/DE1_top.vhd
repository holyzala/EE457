LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


entity DE1_top is

Port(

	-- 50Mhz clock, i.e. 50 Million rising edges per second
   clock_50 :in  std_logic; 
   -- 7 Segment Display
	-- driving the the individual bit loicall low will
	-- light up the segment.
	HEX0		:out	std_logic_vector( 6 downto 0); -- right most
	HEX1		:out	std_logic_vector( 6 downto 0);	
	HEX2		:out	std_logic_vector( 6 downto 0);	
	HEX3		:out	std_logic_vector( 6 downto 0);	
	HEX4		:out	std_logic_vector( 6 downto 0);	
	HEX5		:out	std_logic_vector( 6 downto 0); -- left most
   
	-- Red LEDs above Slider switches
	-- driving the LEDR signal logically high will light up the Red LED
	-- driving the LEDR signal logicall low will turn off the Red LED 
   LEDR		:out	std_logic_vector( 9 downto 0);	

	-- Push Button
	-- the KEY input is normally high, pressing the KEY
	-- will drive the input low.
	
	KEY		:in   std_logic_vector( 3 downto 0);  
   -- Slider Switch
	-- when the Slider switch is pushed up, away from the board edge
	-- the input signal is logically high, when pushed towards the
	-- board edge, the signal is loically low.
	SW			:in	std_logic_vector( 9 downto 0 ) 
    
);

end DE1_top;

architecture struct of DE1_top is

	-- signal and component declartions
	-- you will need to create the component declaration for the 7 segment control.
	Component ram32x4 IS
		PORT
		(
			clock		: IN STD_LOGIC  := '1';
			data		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			rdaddress		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			wraddress		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			wren		: IN STD_LOGIC  := '0';
			q		: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
		);
	END component ram32x4;

	-- Convert a binary number and convert it to a hexadecimal display
	component seven_segment_cntrl IS
		PORT (input : IN STD_LOGIC_VECTOR (3 downto 0);
				seg_a : OUT STD_LOGIC_VECTOR(6 downto 0));
	END component seven_segment_cntrl;

	-- Generic counter
	COMPONENT gen_counter
		generic (
			wide : positive; -- how many bits is the counter
			max  : positive  -- what is the max value of the counter ( modulus )
			);

		PORT (
			clk	 :in  std_logic; -- system clock
			data	 :in  std_logic_vector( wide-1 downto 0 ); -- data in for parallel load, use unsigned(data) to cast to unsigned
			load	 :in  std_logic; -- signal to load data into i_count i_count <= unsigned(data);
			enable :in  std_logic; -- clock enable
			reset	 :in  std_logic; -- reset to zeros use i_count <= (others => '0' ) since size depends on generic
			count	 :out std_logic_vector( wide-1 downto 0 ); -- count out
			term	 :out std_logic -- maximum count is reached
		);
	END COMPONENT gen_counter;

	-- Double D Flip Flop to hide the switches behind to prevent metastability
	COMPONENT switch_double_dff IS
		PORT (
			input : IN STD_LOGIC_VECTOR (9 downto 0);
			clock : IN STD_LOGIC;
			reset : IN STD_LOGIC;
			output : OUT STD_LOGIC_VECTOR(9 downto 0)
		);
			
	END COMPONENT switch_double_dff;

	-- The q value from the ram megafunction
	signal ram_data : STD_LOGIC_VECTOR(3 downto 0);
	-- The write address controlled by switches
	signal a1 : STD_LOGIC_VECTOR(4 downto 0);
	-- The data to write, also controlled by switches
	signal d1 : STD_LOGIC_VECTOR(3 downto 0);
	-- Goes high when a second has passed
	signal second_up : STD_LOGIC;
	-- The address to read from the memory, cycles with a counter
	signal read_address : STD_LOGIC_VECTOR(4 downto 0);
	-- Inverse of the reset key
	signal key0_n : STD_LOGIC;
	-- The leftmost digit of the read address
	signal top_read : STD_LOGIC_VECTOR(3 downto 0);
	-- The leftmost digit of the write address
	signal top_write : STD_LOGIC_VECTOR(3 downto 0);
	-- Output of the switches after returning from D Flip Flops
	signal switches : STD_LOGIC_VECTOR(9 downto 0);
	
begin
	a1 <= switches(8 downto 4);
	d1 <= switches(3 downto 0);
	key0_n <= not KEY(0);
	top_read <= "000" & read_address(4);
	top_write <= "000" & a1(4);
	
-- processes, component instantiations, general logic.
	-- Double D Flip Flop for the 10 board switches
	sw_dff : switch_double_dff
		PORT MAP (
			input => SW,
			clock => clock_50,
			reset => KEY(0),
			output => switches
		);

	-- Counts to one second (50,000,000 max, much lower for simulation)
	one_second : gen_counter
		-- 26 bits wide and 50,000,000 max for 1 second
--		generic map (wide => 26, max => 50000000)
		generic map (wide => 26, max => 5)
		PORT MAP (
			clk => clock_50,
			-- We never load it
			load => '0',
			data => (others => '0'),
			-- reset is key0 notted
			reset => key0_n,
			-- Always enabled
			enable => '1',
			-- Once term (max) is hit we have a second
			term => second_up
		);
		
	-- Second counter that counts from 0 to 31 for the read addresses
	read_count : gen_counter
		generic map (wide => 5, max => 31)
		PORT MAP (
			clk => second_up,
			-- We never load it
			load => '0',
			data => (others => '0'),
			-- reset is key0 notted
			reset => key0_n,
			-- Always enabled
			enable => '1',
			count => read_address
		);
		
	-- The ram megafunction
	u1 : ram32x4
		port map (
			rdaddress => read_address,
			wraddress => a1,
			data => d1,
			wren => switches(9),
			clock => clock_50,
			q => ram_data
	);
	
	-- Rightmost display for the read data
	s0 : seven_segment_cntrl
		port map(
			seg_a => HEX0,
			input => ram_data
	);
	
	-- Data to be written
	s1 : seven_segment_cntrl
		port map(
			seg_a => HEX1,
			input => d1
	);
	
	-- Right digit of the read address
	s2 : seven_segment_cntrl
		port map(
			seg_a => HEX2,
			input => read_address(3 downto 0)
	);
	
	-- Left digit of the read address
	s3 : seven_segment_cntrl
		port map(
			seg_a => HEX3,
			input => top_read
	);
	
	-- Right digit of the write address
	s4 : seven_segment_cntrl
		port map(
			seg_a => HEX4,
			input => a1(3 downto 0)
	);

	-- Leftmost display for the left digit of the write address
	s5 : seven_segment_cntrl
		port map(
			seg_a => HEX5,
			input => top_write
	);
end;
