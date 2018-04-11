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
		address		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
	);
END component ram32x4;

component seven_segment_cntrl IS
	PORT (input : IN STD_LOGIC_VECTOR (3 downto 0);
			seg_a : OUT STD_LOGIC_VECTOR(6 downto 0));
END component seven_segment_cntrl;

	signal s1 : STD_LOGIC_VECTOR(3 downto 0);
	signal a1 : STD_LOGIC_VECTOR(4 downto 0);
	signal d1 : STD_LOGIC_VECTOR(3 downto 0);
	
begin
	a1 <= SW(8 downto 4);
	d1 <= SW(3 downto 0);
	
-- processes, component instantiations, general logic.
	u1 : ram32x4
	port map (
				address => a1,
				data => d1,
				wren => SW(9),
				clock => KEY(0),
				q => s1);
				
	s0 : seven_segment_cntrl
	port map(
			seg_a => HEX0,
			input => s1
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
	
	s2 : seven_segment_cntrl
	port map(
			seg_a => HEX2,
			input => d1
	);
	
	HEX1 <= "1111111";
	HEX3 <= "1111111";	
end;








