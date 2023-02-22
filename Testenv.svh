//includes all environment components:
//Driver, Stimulus, Monitor, Scoreboard,.
//The objects creation and running for all components starts from here

`include "alu_if.sv"
import env_pkg::*;

class TestEnv;
	// create handles
	mailbox  	s2d_mb				;
	mailbox  	log_mon, log_stim		;

	// dynamic array of handles
	Driver 		alu_drv 			;
	Monitor 	alu_mon 			;

	// Scoreboard & Stimulus Generator objects
	Scoreboard 	sb 				;
	Stimulus 	s 				;



	// virtual interface 
	virtual alu_if vif 				;	 

	function new(virtual alu_if vif, int fd)	;

		// create scoreboard & configure feeding mailbox handles
		this.vif 	= vif 							;
		
		s2d_mb 		= new()							;
		log_mon 	= new()							;
		log_stim 	= new()							;

		// create the monitor, driver and stimulus objects
		s 		= new (s2d_mb,log_stim)					;	 
		alu_drv	 	= new (vif,s2d_mb)					;
		alu_mon 	= new (vif,log_mon)					;
		sb 		= new (log_mon,log_stim,fd)				;
		
	endfunction


	task run();
		// start everything
		fork
			s.stim_task(100) 						; // number of trans
			alu_drv.driver_task()						;
			alu_mon.input_monitor_task()					;
			alu_mon.output_monitor_task()					;
			sb.sb_task()							;
		join 
			$finish;
	endtask
	
endclass : TestEnv

