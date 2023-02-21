//Samples the interface signals and converts the signal level activity to the transaction level.
//Send the sampled transaction to Scoreboard via Mailbox.

class Monitor;
	
	virtual alu_if vif	;
	mailbox log_mon		;
	Packet 	pkt			;

	function new(virtual alu_if vif , mailbox log_mon);
		this.vif 		= vif		;
		this.log_mon 	= log_mon	;
	endfunction
	
	
	task input_monitor_task;
		forever begin
			pkt = new()							;
			
			@(posedge vif.clk)
			@(negedge vif.clk)
			begin
				wait (vif.valid_in == 1)		;
				@(negedge vif.clk)
				pkt.a 			= vif.a			;
				pkt.b 			= vif.b			;
				pkt.valid_in 	= vif.valid_in	;
				pkt.cin 		= vif.cin		;
				pkt.ctl 		= vif.ctl		;	
			end
		end
	endtask
	
	
	
	task output_monitor_task;
		forever begin 
		
			@(posedge vif.clk)
			@(negedge vif.clk)
			begin
				wait (vif.valid_out == 1)			;
				@(negedge vif.clk)
				pkt.alu 		= vif.alu			;
				pkt.valid_out 	= vif.valid_out		;
				pkt.carry 		= vif.carry			;
				pkt.zero 		= vif.zero			;
			end 
				pkt.pkt_num     = vif.pkt_num		;
			
				//sending the output to scoreboard
				log_mon.put(pkt)					;
				$display("packet_monitor = %p",pkt)	;
			end 
	endtask
	
endclass
