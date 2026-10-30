library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity d4_pwm is
  generic (
    CLK_PWM_PER : natural := 60;  -- T_clk_pwm [ns]
    CLK_SYS_PER : natural := 20;  -- T_clk (f_clk = 50 MHz) [ns]
    BITS        : natural := 3);
  port (
    clk     : in  std_logic;
    rstn    : in  std_logic;
    duty    : in  std_logic_vector(BITS-1 downto 0);
    pwm_out : out std_logic
  );
end entity d4_pwm;


architecture rtl of d4_pwm is
  -- Antall clk-perioder per pwm-klokkeperiode (60/20 = 3)
  constant PRESC_CNT_PER : natural := CLK_PWM_PER / CLK_SYS_PER;
  -- Høyeste telleverdi gir 2**BITS - 2 steg per PWM-periode (0..6 for BITS = 3)
  constant max_count     : natural := 2**BITS - 2;

  signal pre_cnt : integer range 0 to PRESC_CNT_PER-1 := 0;
  signal count   : integer range 0 to max_count := 0;
  signal ena     : std_logic;
begin

  -----------------------------------------------------------------------------
  -- Prescaler: teller 0 til PRESC_CNT_PER-1 på clk og starter deretter på 0.
  -----------------------------------------------------------------------------
  p_presc : process(clk, rstn)
  begin
    if rstn = '0' then
      pre_cnt <= 0;
    elsif rising_edge(clk) then
      if pre_cnt = PRESC_CNT_PER - 1 then
        pre_cnt <= 0;
      else
        pre_cnt <= pre_cnt + 1;
      end if;
    end if;
  end process p_presc;

  -----------------------------------------------------------------------------
  -- Enable-puls: høy i siste clk-periode av hver prescaler-runde, altså hvert
  -- CLK_PWM_PER ns. Brukes som pwm_clk puls.
  -----------------------------------------------------------------------------
  ena <= '1' when pre_cnt = PRESC_CNT_PER - 1 else '0';

  -----------------------------------------------------------------------------
  -- PWM-teller og utgangsregister: Oppdateres kun når ena = '1'. Utgangen er
  -- høy så lenge telleren er mindre enn duty.
  -----------------------------------------------------------------------------
  p_main : process(clk, rstn)
  begin
    if rstn = '0' then
      count   <= 0;
      pwm_out <= '0';
    elsif rising_edge(clk) then
      if ena = '1' then
        if count = max_count then
          count <= 0;
        else
          count <= count + 1;
        end if;

        if count < to_integer(unsigned(duty)) then
          pwm_out <= '1';
        else
          pwm_out <= '0';
        end if;
      end if;
    end if;
  end process p_main;

end architecture rtl;