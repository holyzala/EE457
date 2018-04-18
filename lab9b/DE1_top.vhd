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

	component seven_segment_cntrl IS
		PORT (input : IN STD_LOGIC_VECTOR (3 downto 0);
				seg_a : OUT STD_LOGIC_VECTOR(6 downto 0));
	END component seven_segment_cntrl;

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

	signal data_input : STD_LOGIC_VECTOR(3 downto 0);
	signal a1 : STD_LOGIC_VECTOR(4 downto 0);
	signal d1 : STD_LOGIC_VECTOR(3 downto 0);
	signal second_up : STD_LOGIC;
	signal read_address : STD_LOGIC_VECTOR(4 downto 0);
	signal key0_n : STD_LOGIC;
	
begin
	a1 <= SW(8 downto 4);
	d1 <= SW(3 downto 0);
	key0_n <= not KEY(0);
	
-- processes, component instantiations, general logic.
	one_second : gen_counter
		-- 26 bits wide and 50,000,000 max for 1 second
		generic map (wide => 26, max => 50000000)
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
		
	read_count : gen_counter
		-- 26 bits wide and 50,000,000 max for 1 second
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
		
	u1 : ram32x4
	port map (
				rdaddress => read_address,
				wraddress => a1,
				data => d1,
				wren => SW(9),
				clock => clock_50,
				q => data_input);
				
	s0 : seven_segment_cntrl
	port map(
			seg_a => HEX0,
			input => data_input
	);
	
	s5 : seven_segment_cntrl
	port map(
			seg_a => HEX5,
			input => "000" & a1(4)
	);
	
	s4 : seven_segment_cntrl
	port map(
			seg_a => HEX4,
			input => a1(3 downto 0)
	);
	
	s1 : seven_segment_cntrl
	port map(
			seg_a => HEX1,
			input => d1
	);
	
	s2 : seven_segment_cntrl
	port map(
			seg_a => HEX2,
			input => read_address(3 downto 0)
	);

	s3 : seven_segment_cntrl
	port map(
			seg_a => HEX3,
			input => "000" & read_address(4)
	);
	end;








