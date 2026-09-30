library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity d2_counter is
  generic (
    F_CNT    : natural := 5_000_000;     -- Antall klokkesykluser som gir periode 0.1 sekund
    NUM_BITS : natural := 10);           -- Number of bits in output
  port (
    clk, rst, ena, cnt_sel: in  std_logic;
    count: out std_logic_vector(NUM_BITS-1 downto 0)
    );
  end entity d2_counter;


architecture rtl of d2_counter is

  signal lfsr_reg  : std_logic_vector(9 downto 0) := (0 => '1', others => '0');
  signal bin_cnt   : unsigned(9 downto 0 )        := (others => '0');
  signal clk_cnt   : unsigned(22 downto 0)        := (others => '0');
  signal update_en : std_logic                    := '0';
  
begin
  -- Sekvensiell del
  p_cnt : process(clk, rst)
  begin

    if rst = '0' then -- Aktivt lav
      lfsr_reg  <= (0 => '1', others => '0');
      bin_cnt   <= (others => '0');
      clk_cnt   <= (others => '0');


    elsif rising_edge(clk) then

      if ena = '1' then                     -- Kjøres kun hvis systemet er på (ena = 1)
        
        if clk_cnt = F_CNT-1 then           -- Hvert 0.1 sekund

          clk_cnt <= (others => '0');       -- Reset prescaler-klokke

          bin_cnt <= bin_cnt + 1;           -- Inkrementer binærteller
          
          lfsr_reg <= lfsr_reg(8 downto 0) & (lfsr_reg(6) xor lfsr_reg(9)); -- Inkrementer LFSR-teller: x^10 + x^7 + 1

        else
         clk_cnt <= clk_cnt + 1;
        
        end if;

      end if;

    end if;

  end process;


  -- Kombinatorisk del
  p_mux : process(cnt_sel, bin_cnt, lfsr_reg) -- Velger mellom binærteller og LFSR basert på cnt_sel
  begin

    case cnt_sel is
      when '0' =>
        count <= std_logic_vector(bin_cnt);
        
      when '1' =>
        count <= lfsr_reg;

      when others =>
        count <= (others => '0');

    end case;

  end process;

end architecture rtl;