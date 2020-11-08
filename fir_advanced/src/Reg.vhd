LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Reg IS

	PORT( reg_in: IN SIGNED(7 DOWNTO 0);
		  clock, reset_n, load: IN STD_LOGIC;
		  reg_out: OUT SIGNED(7 DOWNTO 0));
		  
END Reg;

ARCHITECTURE Behavior OF Reg IS
	
	BEGIN
		PROCESS(clock, reset_n)
		
			BEGIN
				IF (reset_n = '0') THEN
				
					reg_out <= (OTHERS => '0');
					
				ELSIF (clock' EVENT AND clock = '1') THEN
				
					IF (load = '1') THEN
					
						reg_out <= reg_in;
						
					END IF;
				
				END IF;
				
		END PROCESS;
		
		
END Behavior;