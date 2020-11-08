library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity Error_check is

  port (FIR_OUT_3k, FIR_OUT_3k1, FIR_OUT_3k2  : in signed(7 downto 0);
        CLK, VOUT, RST_n : in std_logic);

end Error_check;

architecture Behavior of Error_check is

begin

  process (CLK, RST_n)

    file errors_fp : text open WRITE_MODE is "data_files/error_check.txt";
    file results_c_fp : text open READ_MODE is "data_files/results_c.txt";
    variable error_buf_3k, error_buf_3k1, error_buf_3k2  : line;
    variable results_c_buf_3k, results_c_buf_3k1, results_c_buf_3k2  : line; -- it reads and compare 3 samples at time between the output of the filter and the results file
    variable y_c_3k, y_c_3k1, y_c_3k2  : integer;

    begin

      if RST_n = '0' then
        null;
      elsif CLK'event and CLK = '1' then
        if (VOUT = '1') then
          if not endfile(results_c_fp) then
		        -- 3k
            readline(results_c_fp, results_c_buf_3k);
            read(results_c_buf_3k, y_c_3k);
            if y_c_3k = to_integer(FIR_OUT_3k) then
                write(error_buf_3k, String'("Correct result"));
            else
                write(error_buf_3k, String'("Wrong result:   expected "));
                write(error_buf_3k, y_c_3k);
                write(error_buf_3k, String'("   obtained "));
                write(error_buf_3k, to_integer(FIR_OUT_3k));
		        end if;

	         	-- 3k1
			      readline(results_c_fp, results_c_buf_3k1);
		        read(results_c_buf_3k1, y_c_3k1);
		        if y_c_3k1 = to_integer(FIR_OUT_3k1) then
		          write(error_buf_3k1, String'("Correct result"));
		        else
      		    write(error_buf_3k1, String'("Wrong result:   expected "));
      		    write(error_buf_3k1, y_c_3k1);
      		    write(error_buf_3k1, String'("   obtained "));
      		    write(error_buf_3k1, to_integer(FIR_OUT_3k1));
			      end if;

		         -- 3k2
      		   readline(results_c_fp, results_c_buf_3k2);
		         read(results_c_buf_3k2, y_c_3k2);
		         if y_c_3k2 = to_integer(FIR_OUT_3k2) then
		          write(error_buf_3k2, String'("Correct result"));
		         else
		          write(error_buf_3k2, String'("Wrong result:   expected "));
		          write(error_buf_3k2, y_c_3k2);
		          write(error_buf_3k2, String'("   obtained "));
		          write(error_buf_3k2, to_integer(FIR_OUT_3k2));
    		     end if;

            writeline(errors_fp, error_buf_3k);
		        writeline(errors_fp, error_buf_3k1);
		        writeline(errors_fp, error_buf_3k2);
        end if;
      end if;
    end if;
  end process;

end Behavior;
