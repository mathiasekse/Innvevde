library ieee;
use ieee.std_logic_1164.all
use ieee.numeric_std.all

entity d2_counter is
  generic (
    -- F_CNT    : natural := 5;     -- Simulate a count update every 100 ns 
    NUM_BITS : natural := 10);      -- Number of bits in output
  port (
    clk, rst, ena, cnt_sel: in  std_logic;
    count: out std_logic_vector(NUM_BITS-1 downto 0)
    );
  end entity d2_counter;


architecture rtl of d2_counter is

  signal lfsr_reg  : std_logic_vector(9 downto 0) := (0 => '1', others => '0');
  signal bin_cnt   : std_logic_vector(9 downto 0) := (others => '0');
  signal clk_cnt   : unsigned(22 downto 0)        := (others => '0');
  signal update_en : std_logic                    := '0';
  constant MAX_VAL : std_logic_vector(9 downto 0) := (others => '1');
  

begin
  -- Sekvensiell del
  process(clk, rst)
  begin

    if rst = '0' then -- Aktivt lav
      lfsr_reg  <= (0 => '1', others => '0');
      bin_cnt   <= (others => '0');
      clk_cnt   <= (others => '0');


    elsif rising_edge(clk) then

      if ena = '1' then                       -- Kjøres kun hvis systemet er på (ena = 1)
        
        if clk_cnt = 4_999_999 then           -- Hvert 0.1 sekund

          clk_cnt <= (others => '0');

          if bin_cnt = (others => '1') then   -- Reset binærtelleren ved max verdi
            bin_cnt <= (others => '0');
          else
            bin_cnt <= std_logic_vector(unsigned(bin_cnt) + 1); -- Inkrementer binærteller med 1
          end if;
          
          lfsr_reg <= lfsr_reg(8 downto 0) & (lfsr_reg(6) xor lfsr_reg(9)); -- Inkrementer LFSR-teller (Venstreskift + xor på tappene)

        else
         clk_cnt <= clk_cnt + 1;
        
        end if;

      end if;

    end if;

  end process;


  -- Kombinatorisk del
  process(cnt_sel, bin_cnt, lfsr_reg)
  begin

    case cnt_sel is
      when '0' =>
        count <= bin_cnt;
        
      when '1' =>
        count <= lfsr_reg;

      when others =>
        count <= (others => '0');

    end case;

  end process;

end architecture rtl;