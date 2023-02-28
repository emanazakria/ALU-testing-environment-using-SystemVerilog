 
//Driver class is responsible for,
//receive the stimulus generated from the generator and drive to DUT 
//by assigning transaction class values to interface signals.

class Driver;
	
	virtual alu_if vif	;
	mailbox s2d_mb		;
	Packet 	pkt			;
	 

	function new(virtual alu_if vif , mailbox s2d_mb );
		this.vif 	= vif		;
		this.s2d_mb = s2d_mb	;
	endfunction
	


	task driver_task();
		
		vif.reset_task();
		
		forever begin
		
		/*using peek first to take the time to put the input at the interface then get the packet to notify the monitor 
		that the driver is ready for the next transction*/
		s2d_mb.peek(pkt);
	
		@(posedge vif.clk);
		begin
			vif.a 				= pkt.a 			;
			vif.b 				= pkt.b 			;
			vif.valid_in 		= pkt.valid_in 		;
			vif.cin 			= pkt.cin 			;
			vif.ctl 			= pkt.ctl			;
			vif.pkt_num     	= pkt.pkt_num  		;
 		end

		//output (just to print the packet - not needed)
		@(posedge vif.clk)
		begin
			pkt.alu 			= vif.alu 			;
			pkt.valid_out 		= vif.valid_out 	;
			pkt.carry 			= vif.carry 		;
			pkt.zero 			= vif.zero 			;
		end


		s2d_mb.get(pkt)								;
		$display("packet_driver = %p",pkt)			;	
 
		end 
	endtask 
	
endclass
