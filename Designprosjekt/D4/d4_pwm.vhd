library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity d4_pwm is
  generic (
    CLK_PWM_PER : natural := 60;  -- ns
    CLK_SYS_PER : natural := 20;  -- ns (f_clk = 50 MHz)
    BITS        : natural := 3);
  port (
    clk     : in  std_logic;
    rstn    : in  std_logic;
    duty    : in  std_logic_vector(BITS-1 downto 0);
    pwm_out : out std_logic
  );
end entity d4_pwm;


architecture rtl of d4_pwm is
  constant PRESC_CNT_PER : natural := CLK_PWM_PER / CLK_SYS_PER;
  constant max_count     : natural := 2**BITS - 2;

  signal pre_cnt : integer range 0 to PRESC_CNT_PER-1 := 0;
  signal count   : integer range 0 to max_count := 0;
  signal ena     : std_logic;
begin

  -- Prescaler: teller 0 til PRESC_CNT_PER-1 på clk
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

  -- Enable puls pwm_clk.
  ena <= '1' when pre_cnt = PRESC_CNT_PER - 1 else '0';

  -- PWM-teller og utgangsregister, alt på clk, styrt av ena
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