library ieee;
use ieee.std_logic_1164.all;


entity Clk_rst_gen is
  port (
    END_SIM : in  std_logic;
    CLK     : out std_logic;
    RST_n   : out std_logic);
end Clk_rst_gen;

architecture Behavior of Clk_rst_gen is

  constant Ts : time := 10 ns;    -- clock period

  signal CLK_i : std_logic;

begin

  process
  begin
    if (CLK_i = 'U') then
      CLK_i <= '0';
    else
      CLK_i <= not(CLK_i);
    end if;
    wait for Ts/2;
  end process;

  CLK <= CLK_i and not(END_SIM);  -- clock is frozen after end of simulation

  process   -- initial reset condition
  begin
    RST_n <= '0';
    wait for 3*Ts/2;
    RST_n <= '1';
    wait;
  end process;

end Behavior;
