`include "Testenv.svh"

module top;
	
	import 		env_pkg::*			;
	parameter 	clock_cycle = 100 	;
	logic 		SystemClock 		;
	logic 		SystemReset			;

	// External File Handle
	int 		fd					;


	alu_if top_if(SystemClock, SystemReset);

	//DUT instatiation
	alu DUT(
		 .clk(SystemClock) 				,	 
		 .reset(SystemReset)			,
		 .valid_in(top_if.valid_in)		,
		 .a(top_if.a)					,	 
		 .b(top_if.b)					, 
		 .cin(top_if.cin)				,	 
		 .ctl(top_if.ctl)				,
		 .valid_out(top_if.valid_out)	,	 
		 .alu(top_if.alu)				,
		 .carry(top_if.carry)			,	 
		 .zero(top_if.zero)
			);
			
			
	TestEnv t_env;

	//Clock generation	
	initial begin
		SystemClock = 0;
		forever #5 SystemClock = ~ SystemClock;
	end


	initial begin
		fd = $fopen ("./bugs.txt", "w");
		t_env = new(top_if, fd); 	// create test environment
		t_env.run (); 				// start things running
	end
	
endmodule
