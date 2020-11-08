LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Fir IS

	PORT( DIN_3k, DIN_3k1, DIN_3k2, B0, B1, B2, B3, B4, B5, B6, B7, B8: IN SIGNED(7 DOWNTO 0);
		  CLK, RST_N, VIN: IN STD_LOGIC;
		  DOUT_3k, DOUT_3k1, DOUT_3k2: OUT SIGNED(7 DOWNTO 0);
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

	COMPONENT Fir_substructure IS
    PORT( DIN0, DIN1, DIN2, DIN3, DIN4, DIN5, DIN6, DIN7, DIN8, B0, B1, B2, B3, B4, B5, B6, B7, B8: IN SIGNED(7 DOWNTO 0);
        CLK, RST_N: IN STD_LOGIC;
        DOUT: OUT SIGNED(7 DOWNTO 0));
  END COMPONENT;

-- internal signals
-- example: in2_3k: input 2 of the substructure 3k
SIGNAL in0_3k, in1_3k, in2_3k, in3_3k, in4_3k, in5_3k, in6_3k, in7_3k, in8_3k, out_3k: SIGNED(7 DOWNTO 0);
SIGNAL in0_3k1, in1_3k1, in2_3k1, in3_3k1, in4_3k1, in5_3k1, in6_3k1, in7_3k1, in8_3k1, out_3k1: SIGNED(7 DOWNTO 0);
SIGNAL in0_3k2, in1_3k2, in2_3k2, in3_3k2, in4_3k2, in5_3k2, in6_3k2, in7_3k2, in8_3k2, out_3k2: SIGNED(7 DOWNTO 0);

-- example: ld_reg0_3k1: load of the first delay register related to samples of the group 3k+1
SIGNAL ld_regin_3k, ld_regin_3k1, ld_regin_3k2, ld_regout_3k, ld_regout_3k1, ld_regout_3k2, ld_reg0_3k, ld_reg1_3k, ld_reg2_3k, ld_reg0_3k1, ld_reg1_3k1, ld_reg2_3k1, ld_reg3_3k1, ld_reg0_3k2, ld_reg1_3k2, ld_reg2_3k2, ld_reg3_3k2: STD_LOGIC;
SIGNAL in_regin_3k, in_regin_3k1, in_regin_3k2, in_regout_3k, in_regout_3k1, in_regout_3k2, in_reg0_3k, in_reg1_3k, in_reg2_3k, in_reg0_3k1, in_reg1_3k1, in_reg2_3k1, in_reg3_3k1, in_reg0_3k2, in_reg1_3k2, in_reg2_3k2, in_reg3_3k2: SIGNED(7 DOWNTO 0);
SIGNAL out_regin_3k, out_regin_3k1, out_regin_3k2, out_regout_3k, out_regout_3k1, out_regout_3k2, out_reg0_3k, out_reg1_3k, out_reg2_3k, out_reg0_3k1, out_reg1_3k1, out_reg2_3k1, out_reg3_3k1, out_reg0_3k2, out_reg1_3k2, out_reg2_3k2, out_reg3_3k2: SIGNED(7 DOWNTO 0);

SIGNAL in_ff_in, in_ff_pipe_0, in_ff_pipe_1, in_ff_1, in_ff_out, out_ff_in, out_ff_pipe_0, out_ff_pipe_1, out_ff_1, out_ff_out: STD_LOGIC;

BEGIN

  -- Substructures

  Fir_sub_3k: Fir_substructure PORT MAP(CLK => CLK,
                                        RST_N => RST_N,
                                        B0 => B0,
                                        B1 => B1,
                                        B2 => B2,
                                        B3 => B3,
                                        B4 => B4,
                                        B5 => B5,
                                        B6 => B6,
                                        B7 => B7,
                                        B8 => B8,
                                        DIN0 => in0_3k,
                                        DIN1 => in1_3k,
                                        DIN2 => in2_3k,
                                        DIN3 => in3_3k,
                                        DIN4 => in4_3k,
                                        DIN5 => in5_3k,
                                        DIN6 => in6_3k,
                                        DIN7 => in7_3k,
                                        DIN8 => in8_3k,
                                        DOUT => out_3k);

  Fir_sub_3k1: Fir_substructure PORT MAP(CLK => CLK,
                                        RST_N => RST_N,
                                        B0 => B0,
                                        B1 => B1,
                                        B2 => B2,
                                        B3 => B3,
                                        B4 => B4,
                                        B5 => B5,
                                        B6 => B6,
                                        B7 => B7,
                                        B8 => B8,
                                        DIN0 => in0_3k1,
                                        DIN1 => in1_3k1,
                                        DIN2 => in2_3k1,
                                        DIN3 => in3_3k1,
                                        DIN4 => in4_3k1,
                                        DIN5 => in5_3k1,
                                        DIN6 => in6_3k1,
                                        DIN7 => in7_3k1,
                                        DIN8 => in8_3k1,
                                        DOUT => out_3k1);

  Fir_sub_3k2: Fir_substructure PORT MAP(CLK => CLK,
                                        RST_N => RST_N,
                                        B0 => B0,
                                        B1 => B1,
                                        B2 => B2,
                                        B3 => B3,
                                        B4 => B4,
                                        B5 => B5,
                                        B6 => B6,
                                        B7 => B7,
                                        B8 => B8,
                                        DIN0 => in0_3k2,
                                        DIN1 => in1_3k2,
                                        DIN2 => in2_3k2,
                                        DIN3 => in3_3k2,
                                        DIN4 => in4_3k2,
                                        DIN5 => in5_3k2,
                                        DIN6 => in6_3k2,
                                        DIN7 => in7_3k2,
                                        DIN8 => in8_3k2,
                                        DOUT => out_3k2);

    -- Flip Flops

		-- input interfacing FF
    FF_in: FF PORT MAP (clock => CLK,
                        reset_n => RST_N,
                        ff_in => in_ff_in,
                        ff_out => out_ff_in);

		-- first level of pipe delay FF
    FF_pipe_0: FF PORT MAP (clock => CLK,
                        reset_n => RST_N,
                        ff_in => in_ff_pipe_0,
                        ff_out => out_ff_pipe_0);

		-- second level of pipe delay FF
    FF_pipe_1: FF PORT MAP (clock => CLK,
                        reset_n => RST_N,
                        ff_in => in_ff_pipe_1,
                        ff_out => out_ff_pipe_1);

		-- FF for the load of regout generation
    FF_1: FF PORT MAP (clock => CLK,
                        reset_n => RST_N,
                        ff_in => in_ff_1,
                        ff_out => out_ff_1);

		-- output interfacing FF and VOUT generator
    FF_out: FF PORT MAP (clock => CLK,
                        reset_n => RST_N,
                        ff_in => in_ff_out,
                        ff_out => out_ff_out);

    -- Registers

		-- input interfacing registers
    Regin_3k: Reg PORT MAP (clock => CLK,
                            reset_n => RST_N,
                            load => ld_regin_3k,
                            reg_in => in_regin_3k,
                            reg_out => out_regin_3k);

    Regin_3k1: Reg PORT MAP (clock => CLK,
                            reset_n => RST_N,
                            load => ld_regin_3k1,
                            reg_in => in_regin_3k1,
                            reg_out => out_regin_3k1);

    Regin_3k2: Reg PORT MAP (clock => CLK,
                            reset_n => RST_N,
                            load => ld_regin_3k2,
                            reg_in => in_regin_3k2,
                            reg_out => out_regin_3k2);

		-- output interfacing registers
    Regout_3k: Reg PORT MAP (clock => CLK,
                            reset_n => RST_N,
                            load => ld_regout_3k,
                            reg_in => in_regout_3k,
                            reg_out => out_regout_3k);

    Regout_3k1: Reg PORT MAP (clock => CLK,
                            reset_n => RST_N,
                            load => ld_regout_3k1,
                            reg_in => in_regout_3k1,
                            reg_out => out_regout_3k1);

    Regout_3k2: Reg PORT MAP (clock => CLK,
                            reset_n => RST_N,
                            load => ld_regout_3k2,
                            reg_in => in_regout_3k2,
                            reg_out => out_regout_3k2);

		-- delay registers
    Reg0_3k: Reg PORT MAP (clock => CLK,
                            reset_n => RST_N,
                            load => ld_reg0_3k,
                            reg_in => in_reg0_3k,
                            reg_out => out_reg0_3k);

    Reg1_3k: Reg PORT MAP (clock => CLK,
                            reset_n => RST_N,
                            load => ld_reg1_3k,
                            reg_in => in_reg1_3k,
                            reg_out => out_reg1_3k);

		Reg2_3k: Reg PORT MAP (clock => CLK,
                            reset_n => RST_N,
                            load => ld_reg2_3k,
                            reg_in => in_reg2_3k,
                            reg_out => out_reg2_3k);

    Reg0_3k1: Reg PORT MAP (clock => CLK,
                            reset_n => RST_N,
                            load => ld_reg0_3k1,
                            reg_in => in_reg0_3k1,
                            reg_out => out_reg0_3k1);

    Reg1_3k1: Reg PORT MAP (clock => CLK,
                            reset_n => RST_N,
                            load => ld_reg1_3k1,
                            reg_in => in_reg1_3k1,
                            reg_out => out_reg1_3k1);

    Reg2_3k1: Reg PORT MAP (clock => CLK,
                            reset_n => RST_N,
                            load => ld_reg2_3k1,
                            reg_in => in_reg2_3k1,
                            reg_out => out_reg2_3k1);

    Reg3_3k1: Reg PORT MAP (clock => CLK,
                            reset_n => RST_N,
                            load => ld_reg3_3k1,
                            reg_in => in_reg3_3k1,
                            reg_out => out_reg3_3k1);

    Reg0_3k2: Reg PORT MAP (clock => CLK,
                            reset_n => RST_N,
                            load => ld_reg0_3k2,
                            reg_in => in_reg0_3k2,
                            reg_out => out_reg0_3k2);

    Reg1_3k2: Reg PORT MAP (clock => CLK,
                            reset_n => RST_N,
                            load => ld_reg1_3k2,
                            reg_in => in_reg1_3k2,
                            reg_out => out_reg1_3k2);

    Reg2_3k2: Reg PORT MAP (clock => CLK,
                            reset_n => RST_N,
                            load => ld_reg2_3k2,
                            reg_in => in_reg2_3k2,
                            reg_out => out_reg2_3k2);

    Reg3_3k2: Reg PORT MAP (clock => CLK,
                            reset_n => RST_N,
                            load => ld_reg3_3k2,
                            reg_in => in_reg3_3k2,
                            reg_out => out_reg3_3k2);


    -- connections

    ld_regin_3k <= '1';
    ld_regin_3k1 <= '1';
    ld_regin_3k2 <= '1';

    ld_reg0_3k <= out_ff_in;
    ld_reg1_3k <= out_ff_in;
	  ld_reg2_3k <= out_ff_in;
    ld_reg0_3k1 <= out_ff_in;
    ld_reg1_3k1 <= out_ff_in;
    ld_reg2_3k1 <= out_ff_in;
	  ld_reg3_3k1 <= out_ff_in;
    ld_reg0_3k2 <= out_ff_in;
    ld_reg1_3k2 <= out_ff_in;
    ld_reg2_3k2 <= out_ff_in;
	  ld_reg3_3k2 <= out_ff_in;

    ld_regout_3k <= out_ff_1;
    ld_regout_3k1 <= out_ff_1;
    ld_regout_3k2 <= out_ff_1;

		-- VIN to VOUT propagation
    in_ff_in <= VIN;
    in_ff_pipe_0 <= out_ff_in;
    in_ff_pipe_1 <= out_ff_pipe_0;
    in_ff_1 <= out_ff_pipe_1;
    in_ff_out <= out_ff_1;
    VOUT <= out_ff_out;

	  in_regin_3k <= DIN_3k;
  	in_regin_3k1 <= DIN_3k1;
	  in_regin_3k2 <= DIN_3k2;

    in_reg0_3k <= out_regin_3k;
    in_reg1_3k <= out_reg0_3k;
	  in_reg2_3k <= out_reg1_3k;
    in_reg0_3k1 <= out_regin_3k1;
    in_reg1_3k1 <= out_reg0_3k1;
    in_reg2_3k1 <= out_reg1_3k1;
	  in_reg3_3k1 <= out_reg2_3k1;
    in_reg0_3k2 <= out_regin_3k2;
    in_reg1_3k2 <= out_reg0_3k2;
    in_reg2_3k2 <= out_reg1_3k2;
	  in_reg3_3k2 <= out_reg2_3k2;

    in_regout_3k <= out_3k;
    in_regout_3k1 <= out_3k1;
    in_regout_3k2 <= out_3k2;
    DOUT_3k <= out_regout_3k;
    DOUT_3k1 <= out_regout_3k1;
    DOUT_3k2 <= out_regout_3k2;

    -- Input Fir_substructure following the equations

    in0_3k <= out_reg0_3k;
    in1_3k <= out_reg1_3k2;
    in2_3k <= out_reg1_3k1;
    in3_3k <= out_reg1_3k;
    in4_3k <= out_reg2_3k2;
    in5_3k <= out_reg2_3k1;
    in6_3k <= out_reg2_3k;
    in7_3k <= out_reg3_3k2;
    in8_3k <= out_reg3_3k1;

    in0_3k1 <= out_reg0_3k1;
    in1_3k1 <= out_reg0_3k;
    in2_3k1 <= out_reg1_3k2;
    in3_3k1 <= out_reg1_3k1;
    in4_3k1 <= out_reg1_3k;
    in5_3k1 <= out_reg2_3k2;
    in6_3k1 <= out_reg2_3k1;
    in7_3k1 <= out_reg2_3k;
    in8_3k1 <= out_reg3_3k2;

    in0_3k2 <= out_reg0_3k2;
    in1_3k2 <= out_reg0_3k1;
    in2_3k2 <= out_reg0_3k;
    in3_3k2 <= out_reg1_3k2;
    in4_3k2 <= out_reg1_3k1;
    in5_3k2 <= out_reg1_3k;
    in6_3k2 <= out_reg2_3k2;
    in7_3k2 <= out_reg2_3k1;
    in8_3k2 <= out_reg2_3k;

END Behavior;
