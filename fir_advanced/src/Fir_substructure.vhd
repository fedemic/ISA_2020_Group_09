LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Fir_substructure IS

	PORT( DIN0, DIN1, DIN2, DIN3, DIN4, DIN5, DIN6, DIN7, DIN8, B0, B1, B2, B3, B4, B5, B6, B7, B8: IN SIGNED(7 DOWNTO 0);  -- inputs of multipliers
		  CLK, RST_N: IN STD_LOGIC;
		  DOUT: OUT SIGNED(7 DOWNTO 0));

END Fir_substructure;

ARCHITECTURE Behavior OF Fir_substructure IS

	COMPONENT Reg IS
		PORT( reg_in: IN SIGNED(7 DOWNTO 0);
		  clock, reset_n, load: IN STD_LOGIC;
		  reg_out: OUT SIGNED(7 DOWNTO 0));
	END COMPONENT;

	COMPONENT Adder IS
		PORT( add1, add2: IN SIGNED(7 DOWNTO 0);
		  sum: OUT SIGNED(7 DOWNTO 0));
	END COMPONENT;

	COMPONENT Multiplier IS
		PORT( mpy1, mpy2: IN SIGNED(7 DOWNTO 0);
		  product: OUT SIGNED(7 DOWNTO 0));
	END COMPONENT;

	-- internal signals

	SIGNAL in1_add_1, in1_add_2, in1_add_3, in1_add_4, in1_add_5, in1_add_6, in1_add_7, in1_add_8: SIGNED(7 DOWNTO 0);
	SIGNAL in2_add_1, in2_add_2, in2_add_3, in2_add_4, in2_add_5, in2_add_6, in2_add_7, in2_add_8: SIGNED(7 DOWNTO 0);
	SIGNAL out_add_1, out_add_2, out_add_3, out_add_4, out_add_5, out_add_6, out_add_7, out_add_8: SIGNED(7 DOWNTO 0);

	SIGNAL in1_mpy_0, in1_mpy_1, in1_mpy_2, in1_mpy_3, in1_mpy_4, in1_mpy_5, in1_mpy_6, in1_mpy_7, in1_mpy_8: SIGNED(7 DOWNTO 0);
	SIGNAL in2_mpy_0, in2_mpy_1, in2_mpy_2, in2_mpy_3, in2_mpy_4, in2_mpy_5, in2_mpy_6, in2_mpy_7, in2_mpy_8: SIGNED(7 DOWNTO 0);
	SIGNAL out_mpy_0, out_mpy_1, out_mpy_2, out_mpy_3, out_mpy_4, out_mpy_5, out_mpy_6, out_mpy_7, out_mpy_8: SIGNED(7 DOWNTO 0);

	-- pipeline internal signals
	-- first pipe level
	SIGNAL ld_pipe_mpy_0, ld_pipe_mpy_1, ld_pipe_mpy_2, ld_pipe_mpy_3, ld_pipe_mpy_4, ld_pipe_mpy_5, ld_pipe_mpy_6, ld_pipe_mpy_7, ld_pipe_mpy_8: STD_LOGIC;
	SIGNAL in_pipe_mpy_0, in_pipe_mpy_1, in_pipe_mpy_2, in_pipe_mpy_3, in_pipe_mpy_4, in_pipe_mpy_5, in_pipe_mpy_6, in_pipe_mpy_7, in_pipe_mpy_8: SIGNED(7 DOWNTO 0);
	SIGNAL out_pipe_mpy_0, out_pipe_mpy_1, out_pipe_mpy_2, out_pipe_mpy_3, out_pipe_mpy_4, out_pipe_mpy_5, out_pipe_mpy_6, out_pipe_mpy_7, out_pipe_mpy_8: SIGNED(7 DOWNTO 0);

	-- second pipe level
	SIGNAL ld_pipe2_mpy_5, ld_pipe2_mpy_6, ld_pipe2_mpy_7, ld_pipe2_mpy_8, ld_pipe_add: STD_LOGIC;
	SIGNAL in_pipe2_mpy_5, in_pipe2_mpy_6, in_pipe2_mpy_7, in_pipe2_mpy_8, in_pipe_add: SIGNED(7 DOWNTO 0);
	SIGNAL out_pipe2_mpy_5, out_pipe2_mpy_6, out_pipe2_mpy_7, out_pipe2_mpy_8, out_pipe_add: SIGNED(7 DOWNTO 0);

	BEGIN

	Add_1: Adder PORT MAP(add1 => in1_add_1,
						  add2 => in2_add_1,
						  sum => out_add_1);

	Add_2: Adder PORT MAP(add1 => in1_add_2,
						  add2 => in2_add_2,
						  sum => out_add_2);

	Add_3: Adder PORT MAP(add1 => in1_add_3,
						  add2 => in2_add_3,
						  sum => out_add_3);

	Add_4: Adder PORT MAP(add1 => in1_add_4,
						  add2 => in2_add_4,
						  sum => out_add_4);

	Add_5: Adder PORT MAP(add1 => in1_add_5,
						  add2 => in2_add_5,
						  sum => out_add_5);

	Add_6: Adder PORT MAP(add1 => in1_add_6,
						  add2 => in2_add_6,
						  sum => out_add_6);

	Add_7: Adder PORT MAP(add1 => in1_add_7,
						  add2 => in2_add_7,
						  sum => out_add_7);

	Add_8: Adder PORT MAP(add1 => in1_add_8,
						  add2 => in2_add_8,
						  sum => out_add_8);

	Mpy_0: Multiplier PORT MAP(mpy1 => in1_mpy_0,
							   mpy2 => in2_mpy_0,
							   product => out_mpy_0);

	Mpy_1: Multiplier PORT MAP(mpy1 => in1_mpy_1,
							   mpy2 => in2_mpy_1,
							   product => out_mpy_1);

	Mpy_2: Multiplier PORT MAP(mpy1 => in1_mpy_2,
							   mpy2 => in2_mpy_2,
							   product => out_mpy_2);

	Mpy_3: Multiplier PORT MAP(mpy1 => in1_mpy_3,
							   mpy2 => in2_mpy_3,
							   product => out_mpy_3);

	Mpy_4: Multiplier PORT MAP(mpy1 => in1_mpy_4,
							   mpy2 => in2_mpy_4,
							   product => out_mpy_4);

	Mpy_5: Multiplier PORT MAP(mpy1 => in1_mpy_5,
							   mpy2 => in2_mpy_5,
							   product => out_mpy_5);

	Mpy_6: Multiplier PORT MAP(mpy1 => in1_mpy_6,
							   mpy2 => in2_mpy_6,
							   product => out_mpy_6);

	Mpy_7: Multiplier PORT MAP(mpy1 => in1_mpy_7,
							   mpy2 => in2_mpy_7,
							   product => out_mpy_7);

	Mpy_8: Multiplier PORT MAP(mpy1 => in1_mpy_8,
							   mpy2 => in2_mpy_8,
							   product => out_mpy_8);

	-- pipeline components
	-- first pipe level
	Pipe_mpy_0: Reg PORT MAP(clock => CLK,
					 						 reset_n => RST_N,
					 						 load => ld_pipe_mpy_0,
					 						 reg_in => in_pipe_mpy_0,
					 						 reg_out => out_pipe_mpy_0);

	Pipe_mpy_1: Reg PORT MAP(clock => CLK,
						 reset_n => RST_N,
						 load => ld_pipe_mpy_1,
						 reg_in => in_pipe_mpy_1,
						 reg_out => out_pipe_mpy_1);

	Pipe_mpy_2: Reg PORT MAP(clock => CLK,
						 reset_n => RST_N,
						 load => ld_pipe_mpy_2,
						 reg_in => in_pipe_mpy_2,
						 reg_out => out_pipe_mpy_2);

	Pipe_mpy_3: Reg PORT MAP(clock => CLK,
						 reset_n => RST_N,
						 load => ld_pipe_mpy_3,
						 reg_in => in_pipe_mpy_3,
						 reg_out => out_pipe_mpy_3);

	Pipe_mpy_4: Reg PORT MAP(clock => CLK,
						 reset_n => RST_N,
						 load => ld_pipe_mpy_4,
						 reg_in => in_pipe_mpy_4,
						 reg_out => out_pipe_mpy_4);

	Pipe_mpy_5: Reg PORT MAP(clock => CLK,
												reset_n => RST_N,
												load => ld_pipe_mpy_5,
												reg_in => in_pipe_mpy_5,
												reg_out => out_pipe_mpy_5);

  Pipe_mpy_6: Reg PORT MAP(clock => CLK,
												reset_n => RST_N,
												load => ld_pipe_mpy_6,
												reg_in => in_pipe_mpy_6,
												reg_out => out_pipe_mpy_6);

	Pipe_mpy_7: Reg PORT MAP(clock => CLK,
												reset_n => RST_N,
												load => ld_pipe_mpy_7,
												reg_in => in_pipe_mpy_7,
												reg_out => out_pipe_mpy_7);

	Pipe_mpy_8: Reg PORT MAP(clock => CLK,
												reset_n => RST_N,
												load => ld_pipe_mpy_8,
												reg_in => in_pipe_mpy_8,
												reg_out => out_pipe_mpy_8);

	-- second pipe level
	Pipe_add: Reg PORT MAP(clock => CLK,
												reset_n => RST_N,
												load => ld_pipe_add,
												reg_in => in_pipe_add,
												reg_out => out_pipe_add);

	Pipe2_mpy_5: Reg PORT MAP(clock => CLK,
												reset_n => RST_N,
												load => ld_pipe2_mpy_5,
												reg_in => in_pipe2_mpy_5,
												reg_out => out_pipe2_mpy_5);

  Pipe2_mpy_6: Reg PORT MAP(clock => CLK,
												reset_n => RST_N,
												load => ld_pipe2_mpy_6,
												reg_in => in_pipe2_mpy_6,
												reg_out => out_pipe2_mpy_6);

	Pipe2_mpy_7: Reg PORT MAP(clock => CLK,
												reset_n => RST_N,
												load => ld_pipe2_mpy_7,
												reg_in => in_pipe2_mpy_7,
												reg_out => out_pipe2_mpy_7);

	Pipe2_mpy_8: Reg PORT MAP(clock => CLK,
												reset_n => RST_N,
												load => ld_pipe2_mpy_8,
												reg_in => in_pipe2_mpy_8,
												reg_out => out_pipe2_mpy_8);

	-- connections

	ld_pipe_mpy_0 <= '1';
	ld_pipe_mpy_1 <= '1';
	ld_pipe_mpy_2 <= '1';
	ld_pipe_mpy_3 <= '1';
	ld_pipe_mpy_4 <= '1';
	ld_pipe_mpy_5 <= '1';
	ld_pipe_mpy_6 <= '1';
	ld_pipe_mpy_7 <= '1';
	ld_pipe_mpy_8 <= '1';

	ld_pipe_add <= '1';
	ld_pipe2_mpy_5 <= '1';
	ld_pipe2_mpy_6 <= '1';
	ld_pipe2_mpy_7 <= '1';
	ld_pipe2_mpy_8 <= '1';

	in1_mpy_0 <= B0;
	in1_mpy_1 <= B1;
	in1_mpy_2 <= B2;
	in1_mpy_3 <= B3;
	in1_mpy_4 <= B4;
	in1_mpy_5 <= B5;
	in1_mpy_6 <= B6;
	in1_mpy_7 <= B7;
	in1_mpy_8 <= B8;

	in2_mpy_0 <= DIN0;
	in2_mpy_1 <= DIN1;
	in2_mpy_2 <= DIN2;
	in2_mpy_3 <= DIN3;
	in2_mpy_4 <= DIN4;
	in2_mpy_5 <= DIN5;
	in2_mpy_6 <= DIN6;
	in2_mpy_7 <= DIN7;
	in2_mpy_8 <= DIN8;

	in_pipe_mpy_0 <= out_mpy_0;
	in_pipe_mpy_1 <= out_mpy_1;
	in_pipe_mpy_2 <= out_mpy_2;
	in_pipe_mpy_3 <= out_mpy_3;
	in_pipe_mpy_4 <= out_mpy_4;
	in_pipe_mpy_5 <= out_mpy_5;
	in_pipe_mpy_6 <= out_mpy_6;
	in_pipe_mpy_7 <= out_mpy_7;
	in_pipe_mpy_8 <= out_mpy_8;

	in1_add_1 <= out_pipe_mpy_1;
	in1_add_2 <= out_pipe_mpy_2;
	in1_add_3 <= out_pipe_mpy_3;
	in1_add_4 <= out_pipe_mpy_4;
	in_pipe2_mpy_5 <= out_pipe_mpy_5; -- second pipe level
	in_pipe2_mpy_6 <= out_pipe_mpy_6;
	in_pipe2_mpy_7 <= out_pipe_mpy_7;
	in_pipe2_mpy_8 <= out_pipe_mpy_8;
	in1_add_5 <= out_pipe2_mpy_5;
	in1_add_6 <= out_pipe2_mpy_6;
	in1_add_7 <= out_pipe2_mpy_7;
	in1_add_8 <= out_pipe2_mpy_8;

	in2_add_1 <= out_pipe_mpy_0;
	in2_add_2 <= out_add_1;
	in2_add_3 <= out_add_2;
	in2_add_4 <= out_add_3;
	in_pipe_add <= out_add_4; -- second pipe level
	in2_add_5 <= out_pipe_add;
	in2_add_6 <= out_add_5;
	in2_add_7 <= out_add_6;
	in2_add_8 <= out_add_7;

	DOUT <= out_add_8;

END Behavior;
