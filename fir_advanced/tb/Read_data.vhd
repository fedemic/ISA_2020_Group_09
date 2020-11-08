library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity Read_data is

  port (
    CLK     : in  std_logic;
    RST_n   : in  std_logic;
    VOUT    : out std_logic;
    DOUT_3k, DOUT_3k1, DOUT_3k2: out signed(7 downto 0);
    B0, B1, B2, B3, B4, B5, B6, B7, B8 : out signed(7 downto 0);
    END_SIM : out std_logic);

end Read_data;

architecture Behavior of Read_data is

	constant tco : time := 1 ns;
	constant Ts : time := 10 ns;
	constant data_period : time := 20 ns;

	signal sEndSim : std_logic;
	signal data_clock, data_clock_i: std_logic;


	begin

		process (RST_n)
		  file fp_coeffs : text open READ_MODE is "data_files/coeff.txt";
		  variable line_buf : line;
		  variable coeff : integer;
		  variable i : integer;

		  begin
		      if(RST_n = '0') then
		        while not endfile(fp_coeffs) loop
		          for i in 0 to 8 loop
		            readline(fp_coeffs, line_buf);
		            read(line_buf, coeff);

		             if (i = 0) then
		                B0 <= to_signed(coeff,8);
		             elsif (i = 1) then
		                B1 <= to_signed(coeff,8);
				         elsif (i = 2) then
		                B2 <= to_signed(coeff,8);
				        elsif (i = 3) then
		                B3 <= to_signed(coeff,8);
				        elsif (i = 4) then
		                B4 <= to_signed(coeff,8);
				        elsif (i = 5) then
		                B5 <= to_signed(coeff,8);
				        elsif (i = 6) then
		                B6 <= to_signed(coeff,8);
				        elsif (i = 7) then
		                B7 <= to_signed(coeff,8);
				        elsif (i = 8) then
		                B8 <= to_signed(coeff,8);

		            end if;
		          end loop;
		         end loop;
		        end if;
		end process;

		process (data_clock, RST_n)
		  file fp_in : text open READ_MODE is "data_files/samples.txt";
		  variable line_buf_3k, line_buf_3k1, line_buf_3k2 : line;    -- 3 samples at time are read and provided at the input of the FIR
		  variable sample_3k, sample_3k1, sample_3k2 : integer;
		  begin
			     if RST_n = '0' then
			        DOUT_3k <= (others => '0') after tco;
              DOUT_3k1 <= (others => '0') after tco;
              DOUT_3k2 <= (others => '0') after tco;
      			  VOUT <= '0' after tco;
      			  sEndSim <= '0' after tco;
		      elsif data_clock'event and data_clock = '1' then
			  	  if not endfile(fp_in) then
      				readline(fp_in, line_buf_3k);
      				read(line_buf_3k, sample_3k);
      				DOUT_3k <= to_signed(sample_3k,8) after tco;
              readline(fp_in, line_buf_3k1);
      				read(line_buf_3k1, sample_3k1);
      				DOUT_3k1 <= to_signed(sample_3k1,8) after tco;
              readline(fp_in, line_buf_3k2);
      				read(line_buf_3k2, sample_3k2);
      				DOUT_3k2 <= to_signed(sample_3k2,8) after tco;
      				VOUT <= '1'after tco, '0' after Ts+tco;
      				sEndSim <= '0' after tco;
			  	  else
    				  VOUT <= '0' after tco;
    				  sEndSim <= '1' after tco + 5*Ts; -- longer latency due to the pipeline implementation
			      end if;
			    end if;
		end process;

	process
  		begin
         if (data_clock_i = 'U') then
            data_clock_i <= '0';
         else
           data_clock_i <= not(data_clock_i);
         end if;
         wait for data_period/2;
  end process;

  data_clock <= data_clock_i and not(sEndSim);

  END_SIM <= sEndSim;

end Behavior;
