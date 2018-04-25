library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_sink is
port(
  clk       :in std_logic;
  rst       :in std_logic;
  stall     :in std_logic;
  empty     :in std_logic;
  available :in std_logic_vector( 8 downto 0 );
  data_rd   :out std_logic);
end entity;

architecture rtl of data_sink is

constant burst_size :unsigned (8 downto 0) := "001000000"; -- burst size of 64
constant fifo_size  :unsigned (8 downto 0) := "100000000"; -- fifo size 256
constant low_water  :unsigned (8 downto 0) := burst_size; -- value that means there is data for a burst

constant pend :std_logic := '0';
constant pull :std_logic := '1';

signal i_available :unsigned (8 downto 0);
signal dstate 	    :std_logic;
signal dnext	    :std_logic;

begin

i_available <= unsigned(available);

state_reg: process ( clk, rst ) begin
 if (rst = '1') then
   dstate <= pend;
 elsif rising_edge (clk) then
   if stall /='1' then -- i.e. not stalled
     dstate <= dnext;
	else
     dstate <= pend;
	end if;
 end if;
end process;
	
ns: process (dstate, empty, i_available) begin
 case (dstate) is
   when pend =>
     if (i_available >= low_water) then
	    dnext <= pull;
     else
       dnext <= pend;
     end if;
   when pull =>
     if (empty = '1') then
       dnext <= pend;
     else
       dnext <= pull;
     end if;
   when others =>
     dnext <= pend;
 end case;
end process;

-- generate the read request when we are reading.
wr: process (dstate) begin
 if (dstate = pull) then 
   data_rd <= '1';
 else
   data_rd <= '0';
 end if;
end process;

end architecture;				