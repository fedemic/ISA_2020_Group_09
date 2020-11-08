LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Adder IS

	PORT( add1, add2: IN SIGNED(7 DOWNTO 0);
		  sum: OUT SIGNED(7 DOWNTO 0));
		  
END Adder;

ARCHITECTURE Behavior OF Adder IS

	SIGNAL partial_sum: SIGNED(8 DOWNTO 0);
	
	BEGIN
	
		partial_sum <= ('0' & add1) + ('0' & add2);
		sum <= partial_sum(7 DOWNTO 0);
		
END Behavior;