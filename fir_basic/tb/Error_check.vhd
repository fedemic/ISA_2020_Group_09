library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity Error_check is

  port (FIR_OUT : in signed(7 downto 0); -- output of the FIR
        CLK, VOUT, RST_n : in std_logic); -- VOUT of the FIR

end Error_check;

architecture Behavior of Error_check is

begin

  process (CLK, RST_n)

    file errors_fp : text open WRITE_MODE is "data_files/error_check.txt";
    file results_c_fp : text open READ_MODE is "data_files/results_c.txt";
    variable error_buf : line; -- to write the error file
    variable results_c_buf : line;
    variable y_c : integer; -- to store c result

  begin

    if RST_n = '0' then
      null;
    elsif CLK'event and CLK = '1' then  -- each output FIR sample is read and compared
      if (VOUT = '1') then
        if not endfile(results_c_fp) then
            readline(results_c_fp, results_c_buf);
            read(results_c_buf, y_c);

            if y_c = to_integer(FIR_OUT) then
              write(error_buf, String'("Correct result"));
            else
              write(error_buf, String'("Wrong result:   expected "));
              write(error_buf, y_c);
              write(error_buf, String'("   obtained "));
              write(error_buf, to_integer(FIR_OUT));

            end if;
            writeline(errors_fp, error_buf);
        end if;
      end if;
    end if;
  end process;

end Behavior;
