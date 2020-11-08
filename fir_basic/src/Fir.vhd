LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Fir IS

	PORT( DIN, B0, B1, B2, B3, B4, B5, B6, B7, B8: IN SIGNED(7 DOWNTO 0);
		  CLK, RST_N, VIN: IN STD_LOGIC;
		  DOUT: OUT SIGNED(7 DOWNTO 0);
		  VOUT: OUT STD_LOGIC);

END Fir;

ARCHITECTURE Behavior OF Fir IS

	COMPONENT FF IS
		PORT( ff_in: IN STD_LOGIC;
		  clock, reset_n: IN STD_LOGIC;
		  ff_out: OUT STD_LOGIC);
	END COMPONENT;

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

	SIGNAL ld_reg_in, ld_reg_0, ld_reg_1, ld_reg_2, ld_reg_3, ld_reg_4, ld_reg_5, ld_reg_6, ld_reg_7, ld_reg_8, ld_reg_out: STD_LOGIC;
	SIGNAL in_reg_in, in_reg_0, in_reg_1, in_reg_2, in_reg_3, in_reg_4, in_reg_5, in_reg_6, in_reg_7, in_reg_8, in_reg_out: SIGNED(7 DOWNTO 0);
	SIGNAL out_reg_in, out_reg_0, out_reg_1, out_reg_2, out_reg_3, out_reg_4, out_reg_5, out_reg_6, out_reg_7, out_reg_8, out_reg_out: SIGNED(7 DOWNTO 0);

	SIGNAL in1_add_1, in1_add_2, in1_add_3, in1_add_4, in1_add_5, in1_add_6, in1_add_7, in1_add_8: SIGNED(7 DOWNTO 0);
	SIGNAL in2_add_1, in2_add_2, in2_add_3, in2_add_4, in2_add_5, in2_add_6, in2_add_7, in2_add_8: SIGNED(7 DOWNTO 0);
	SIGNAL out_add_1, out_add_2, out_add_3, out_add_4, out_add_5, out_add_6, out_add_7, out_add_8: SIGNED(7 DOWNTO 0);

	SIGNAL in1_mpy_0, in1_mpy_1, in1_mpy_2, in1_mpy_3, in1_mpy_4, in1_mpy_5, in1_mpy_6, in1_mpy_7, in1_mpy_8: SIGNED(7 DOWNTO 0);
	SIGNAL in2_mpy_0, in2_mpy_1, in2_mpy_2, in2_mpy_3, in2_mpy_4, in2_mpy_5, in2_mpy_6, in2_mpy_7, in2_mpy_8: SIGNED(7 DOWNTO 0);
	SIGNAL out_mpy_0, out_mpy_1, out_mpy_2, out_mpy_3, out_mpy_4, out_mpy_5, out_mpy_6, out_mpy_7, out_mpy_8: SIGNED(7 DOWNTO 0);

	SIGNAL in_ff_in, in_ff_1, in_ff_2, out_ff_in, out_ff_1, out_ff_2: STD_LOGIC;

	BEGIN
	-- input interfacing FF, it drives internal regs load
	FF_IN: FF PORT MAP(clock => CLK,
	                 reset_n => RST_N,
	                 ff_in => in_ff_in,
	                 ff_out => out_ff_in);

	-- FF1 drives reg_out load
	FF1: FF PORT MAP(clock => CLK,
	                 reset_n => RST_N,
	                 ff_in => in_ff_1,
	                 ff_out => out_ff_1);

	-- output interfacing FF, it generates VOUT signal
	FF2: FF PORT MAP(clock => CLK,
	                 reset_n => RST_N,
	                 ff_in => in_ff_2,
	                 ff_out => out_ff_2);

  -- input interfacing register
	Reg_in: Reg PORT MAP(clock => CLK,
						 reset_n => RST_N,
						 load => ld_reg_in,
						 reg_in => in_reg_in,
						 reg_out => out_reg_in);

  -- FIR structure
	Reg_0: Reg PORT MAP(clock => CLK,
					 						 reset_n => RST_N,
					 						 load => ld_reg_0,
					 						 reg_in => in_reg_0,
					 						 reg_out => out_reg_0);

	Reg_1: Reg PORT MAP(clock => CLK,
						 reset_n => RST_N,
						 load => ld_reg_1,
						 reg_in => in_reg_1,
						 reg_out => out_reg_1);

	Reg_2: Reg PORT MAP(clock => CLK,
						 reset_n => RST_N,
						 load => ld_reg_2,
						 reg_in => in_reg_2,
						 reg_out => out_reg_2);

	Reg_3: Reg PORT MAP(clock => CLK,
						 reset_n => RST_N,
						 load => ld_reg_3,
						 reg_in => in_reg_3,
						 reg_out => out_reg_3);

	Reg_4: Reg PORT MAP(clock => CLK,
						 reset_n => RST_N,
						 load => ld_reg_4,
						 reg_in => in_reg_4,
						 reg_out => out_reg_4);

	Reg_5: Reg PORT MAP(clock => CLK,
						 reset_n => RST_N,
						 load => ld_reg_5,
						 reg_in => in_reg_5,
						 reg_out => out_reg_5);

	Reg_6: Reg PORT MAP(clock => CLK,
						 reset_n => RST_N,
						 load => ld_reg_6,
						 reg_in => in_reg_6,
						 reg_out => out_reg_6);

	Reg_7: Reg PORT MAP(clock => CLK,
						 reset_n => RST_N,
						 load => ld_reg_7,
						 reg_in => in_reg_7,
						 reg_out => out_reg_7);

	Reg_8: Reg PORT MAP(clock => CLK,
						 reset_n => RST_N,
						 load => ld_reg_8,
						 reg_in => in_reg_8,
						 reg_out => out_reg_8);

  -- output interfacing register
	Reg_out: Reg PORT MAP(clock => CLK,
						 reset_n => RST_N,
						 load => ld_reg_out,
						 reg_in => in_reg_out,
						 reg_out => out_reg_out);

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

	-- signals connections

	-- VIN to VOUT propagation
	in_ff_in <= VIN;
	in_ff_1 <= out_ff_in;
	in_ff_2 <= out_ff_1;
	VOUT <= out_ff_2;

	ld_reg_in <= '1';		-- interfacing register is always sampling
	ld_reg_0 <= out_ff_in;
	ld_reg_1 <= out_ff_in;
	ld_reg_2 <= out_ff_in;
	ld_reg_3 <= out_ff_in;
	ld_reg_4 <= out_ff_in;
	ld_reg_5 <= out_ff_in;
	ld_reg_6 <= out_ff_in;
	ld_reg_7 <= out_ff_in;
	ld_reg_8 <= out_ff_in;
	ld_reg_out <= out_ff_1;

	in_reg_in <= DIN;
	in_reg_0 <= out_reg_in;
	in_reg_1 <= out_reg_0;
	in_reg_2 <= out_reg_1;
	in_reg_3 <= out_reg_2;
	in_reg_4 <= out_reg_3;
	in_reg_5 <= out_reg_4;
	in_reg_6 <= out_reg_5;
	in_reg_7 <= out_reg_6;
	in_reg_8 <= out_reg_7;

	in1_mpy_0 <= B0;
	in1_mpy_1 <= B1;
	in1_mpy_2 <= B2;
	in1_mpy_3 <= B3;
	in1_mpy_4 <= B4;
	in1_mpy_5 <= B5;
	in1_mpy_6 <= B6;
	in1_mpy_7 <= B7;
	in1_mpy_8 <= B8;

	in2_mpy_0 <= out_reg_0;
	in2_mpy_1 <= out_reg_1;
	in2_mpy_2 <= out_reg_2;
	in2_mpy_3 <= out_reg_3;
	in2_mpy_4 <= out_reg_4;
	in2_mpy_5 <= out_reg_5;
	in2_mpy_6 <= out_reg_6;
	in2_mpy_7 <= out_reg_7;
	in2_mpy_8 <= out_reg_8;

	in1_add_1 <= out_mpy_1;
	in1_add_2 <= out_mpy_2;
	in1_add_3 <= out_mpy_3;
	in1_add_4 <= out_mpy_4;
	in1_add_5 <= out_mpy_5;
	in1_add_6 <= out_mpy_6;
	in1_add_7 <= out_mpy_7;
	in1_add_8 <= out_mpy_8;

	in2_add_1 <= out_mpy_0;
	in2_add_2 <= out_add_1; -- adder cascade
	in2_add_3 <= out_add_2;
	in2_add_4 <= out_add_3;
	in2_add_5 <= out_add_4;
	in2_add_6 <= out_add_5;
	in2_add_7 <= out_add_6;
	in2_add_8 <= out_add_7;

	in_reg_out <= out_add_8;
	DOUT <= out_reg_out;

END Behavior;
