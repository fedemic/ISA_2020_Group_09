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
    VOUT    : out std_logic;          -- VIN of the FIR
    DOUT    : out signed(7 downto 0); -- DIN of the FIR
    B0, B1, B2, B3, B4, B5, B6, B7, B8 : out signed(7 downto 0);
    END_SIM : out std_logic);

end Read_data;

architecture Behavior of Read_data is

	constant tco : time := 1 ns; -- propagation delay
	constant Ts : time := 10 ns; -- clock period
	constant data_period : time := 10 ns; -- input data periodicity

	signal sEndSim : std_logic;
	signal data_clock, data_clock_i: std_logic;


	begin

		process (RST_n) -- Reading coefficients during the reset phase
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

		process (data_clock, RST_n) -- Provides the input samples for the FIR
		  file fp_in : text open READ_MODE is "data_files/samples.txt";
		  variable line_buf : line;
		  variable sample : integer;
		  begin
			   if RST_n = '0' then
			      DOUT <= (others => '0') after tco;
			      VOUT <= '0' after tco;
			      sEndSim <= '0' after tco;
			    elsif data_clock'event and data_clock = '1' then
			  	    if not endfile(fp_in) then
				          readline(fp_in, line_buf);
				          read(line_buf, sample);
				          DOUT <= to_signed(sample,8) after tco;
				          VOUT <= '1'after tco, '0' after Ts+tco; -- VOUT stays high for only 1 clock period
				          sEndSim <= '0' after tco;
			  	     else
				           VOUT <= '0' after tco;
				           sEndSim <= '1' after tco + 3*Ts; -- when EOF is reached, wait the latency for the last sample before ending simulation
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

  data_clock <= data_clock_i and not(sEndSim); -- data clock frozen after the end of simulation



  END_SIM <= sEndSim;

end Behavior;
