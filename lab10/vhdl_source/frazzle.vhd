LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity frazzle is
port (
  din  :in  std_logic_vector(7 downto 0);
  dout :out std_logic_vector(7 downto 0)
);
end entity;

architecture foo of frazzle is

signal stage1 : unsigned (7 downto 0);
signal stage2 : unsigned (7 downto 0);
signal stage3 : unsigned (7 downto 0);
signal stage4 : unsigned (7 downto 0);
signal stage5 : unsigned (7 downto 0);
signal stage6 : unsigned (7 downto 0);

begin

 stage1 <= unsigned(din) ror 3;
 stage2 <= stage1 ror 5;
 stage3 <= stage2 rol 2;
 stage4 <= stage3 + unsigned(din);
 stage5 <= stage4 rol 5;
 stage6 <= stage2 + stage5;
 dout <= std_logic_vector(stage6);

end architecture;

