library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity Write_results is
  port (
    CLK   : in std_logic;
    RST_n : in std_logic;
    VIN   : in std_logic;
    DIN_3k, DIN_3k1, DIN_3k2   : in signed(7 downto 0));
end Write_results;

architecture Behavior of Write_results is

begin

  process (CLK, RST_n)
    file results_fp : text open WRITE_MODE is "data_files/results_vhdl.txt";
    variable line_buf_3k, line_buf_3k1, line_buf_3k2 : line;    -- it reads from the output of the FIR 3 samples at time and store them in order in a file
  begin
    if RST_n = '0' then
      null;
    elsif CLK'event and CLK = '1' then
      if (VIN = '1') then
        write(line_buf_3k, to_integer(DIN_3k));
        writeline(results_fp, line_buf_3k);
        write(line_buf_3k1, to_integer(DIN_3k1));
        writeline(results_fp, line_buf_3k1);
        write(line_buf_3k2, to_integer(DIN_3k2));
        writeline(results_fp, line_buf_3k2);
      end if;
    end if;
  end process;

end Behavior;
