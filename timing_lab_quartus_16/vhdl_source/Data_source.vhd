library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity data_source is
port(
  clk		   :in std_logic;
  rst		   :in std_logic;
  halt      :in std_logic;
  full	   :in std_logic;
  filled	   :in std_logic_vector( 8 downto 0 );
  pkt_avail :out std_logic;
  data_out  :out std_logic_vector( 7 downto 0 );
  data_wr   :out std_logic);
end entity;

architecture rtl of data_source is

constant burst_size : unsigned(8 downto 0) := "001000000"; -- burst size of 64
constant fifo_size  : unsigned(8 downto 0) := "100000000"; -- fifo size 256
constant high_water : unsigned(8 downto 0) := burst_size; -- value that means there is room for a burst

constant pend : std_logic := '0';
constant fill : std_logic := '1';

signal i_count  : unsigned(7 downto 0);
signal i_filled : unsigned(8 downto 0);

signal dstate : std_logic;
signal dnext  : std_logic;

begin

i_filled <= unsigned(filled);
data_out <= std_logic_vector( i_count );

state_reg: process (clk, rst) begin
 if (rst = '1') then
   dstate <= pend;
 elsif rising_edge (clk) then
   if (halt /= '1') then -- i.e. not halted
	  dstate <= dnext;
	else
	  dstate <= pend;
   end if;
 end if;
end process;
	
ns: process (dstate, full, i_filled) begin
 case (dstate) is
   when pend =>
     if (i_filled = 0) then
       dnext <= fill;
     else
       dnext <= pend;
     end if;
	when fill =>
     if (i_filled >= high_water) then
       dnext <= pend;
     else
       dnext <= fill;
     end if;
   when others =>
      dnext <= pend;
 end case;
end process;


-- increment i_count when filling, allow to wrap.	
count_reg: process (clk, rst) begin
 if (rst = '1') then
   i_count <= ( others => '0' );
 elsif (rising_edge(clk)) then
   if (halt /= '1') then -- i.e. we are not halted
     if dstate = fill then
       i_count <= i_count + 1;
     end if;
   end if;
 end if;
end process;

-- generate the write request when we are filling.
wr: process (dstate) begin
 if (dstate = fill) then
   data_wr   <= '1';
   pkt_avail <= '0';
 else
   data_wr   <= '0';
	if halt = '1' then
     pkt_avail <= '1';
	else
	  pkt_avail <= '1';
	end if;
 end if;
end process;

end architecture;				