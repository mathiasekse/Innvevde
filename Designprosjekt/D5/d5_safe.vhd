library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity d5_safe is
port(
  clk : in std_logic;
  rst_n : in std_logic;
  incr_key : in std_logic;
  sw0      : in std_logic;
  seg_sel  : in std_logic_vector(1 downto 0);
  sw9      : in std_logic;
  open_led : out std_logic;
  hex0     : out std_logic_vector(7 downto 0);
  hex1     : out std_logic_vector(7 downto 0);
  hex2     : out std_logic_vector(7 downto 0);
  hex3     : out std_logic_vector(7 downto 0));
end entity d5_safe;

architecture rtl of d5_safe is
  -- Array hvor indeksen velger hvilket 7-seg display, og tallet er hvilket tall som skal vises
  type digit_array is array (0 to 3) of integer range 0 to 9;
  signal digits : digit_array;
  constant secret : digit_array := (1, 2, 3, 4);
  -- For beregning av synkende flanke p� knappetrykk
  signal incr_prev : std_logic;

  -- 7 Segment Display coding
  constant SEG7_0 : std_logic_vector(7 downto 0) := "11000000";
  constant SEG7_1 : std_logic_vector(7 downto 0) := "11111001";
  constant SEG7_2 : std_logic_vector(7 downto 0) := "10100100";
  constant SEG7_3 : std_logic_vector(7 downto 0) := "10110000";
  constant SEG7_4 : std_logic_vector(7 downto 0) := "10011001";
  constant SEG7_5 : std_logic_vector(7 downto 0) := "10010010";
  constant SEG7_6 : std_logic_vector(7 downto 0) := "10000010";
  constant SEG7_7 : std_logic_vector(7 downto 0) := "11111000";
  constant SEG7_8 : std_logic_vector(7 downto 0) := "10000000";
  constant SEG7_9 : std_logic_vector(7 downto 0) := "10010000";


  -- Tilegner tallet "d" til riktig 7-segment kode
  function to_seven_seg(d : integer range 0 to 9) return std_logic_vector is
  begin
    case d is
      when 0      => return SEG7_0;
      when 1      => return SEG7_1;
      when 2      => return SEG7_2;
      when 3      => return SEG7_3;
      when 4      => return SEG7_4;
      when 5      => return SEG7_5;
      when 6      => return SEG7_6;
      when 7      => return SEG7_7;
      when 8      => return SEG7_8;
      when 9      => return SEG7_9;
      when others => return SEG7_0;
    end case;
  end function;


begin

  p_main : process(clk, rst_n)
    -- Variabel som holder styr p� valgt 7-seg display fra arrayet
    variable sel : integer range 0 to 3;
  begin
    if rst_n = '0' then
      digits <= (others => 0); -- Resetter alle display til tallet 0
      incr_prev <= '1';
    elsif rising_edge(clk) then
      incr_prev <= incr_key;
      sel := to_integer(unsigned(seg_sel));

      -- Ved trykk: overgang fra 1 til 0 (aktiv lav)
      if incr_prev = '1' and incr_key = '0' then
        if digits(sel) = 9 then
          digits(sel) <= 0;     -- Begynner p� nytt ved overflyt
        else
          digits(sel) <= digits(sel) + 1; -- �ker tallet p� gjeldende display
        end if;
      end if;
    end if;
  end process p_main;
  hex0 <= to_seven_seg(digits(0)) when sw9 = '0' else to_seven_seg(secret(0));
  hex1 <= to_seven_seg(digits(1)) when sw9 = '0' else to_seven_seg(secret(1));
  hex2 <= to_seven_seg(digits(2)) when sw9 = '0' else to_seven_seg(secret(2));
  hex3 <= to_seven_seg(digits(3)) when sw9 = '0' else to_seven_seg(secret(3));
  open_led <= '1' when digits(0) = 1 and digits(1) = 2 and digits(2) = 3 and digits(3) = 4 and sw0 = '1' else '0';
end architecture rtl;