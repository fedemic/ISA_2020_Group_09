LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY FF IS

	PORT( ff_in: IN STD_LOGIC;
		  clock, reset_n: IN STD_LOGIC;
		  ff_out: OUT STD_LOGIC);
		  
END FF;

ARCHITECTURE Behavior OF FF IS
	
	BEGIN
		PROCESS(clock, reset_n)
		
			BEGIN
				IF (reset_n = '0') THEN
				
					ff_out <= '0';
					
				ELSIF (clock' EVENT AND clock = '1') THEN
				
						ff_out <= ff_in;
				
				END IF;
				
		END PROCESS;
		
		
END Behavior;