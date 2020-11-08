LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Multiplier IS

	PORT( mpy1, mpy2: IN SIGNED(7 DOWNTO 0);
		  product: OUT SIGNED(7 DOWNTO 0));
		  
END Multiplier;

ARCHITECTURE Behavior OF Multiplier IS

	SIGNAL partial_product: SIGNED(15 DOWNTO 0);
	
	BEGIN
	
		partial_product <= mpy1 * mpy2;
		product <= partial_product(15 DOWNTO 8);
		
END Behavior;