 //this class can be called as transaction 
 // it is used to initiate new transactions and also capture it at dut interface
 // we shall randomize the inputs only 

class Packet;

	//input signals 
	rand logic [3:0] 	a			;
	rand logic [3:0] 	b			;
	rand logic 		valid_in 		;
	rand logic 		cin			;
	randc logic [3:0] 	ctl			;
	
	//constraint c1 {valid_in==1;} 		//if we want to avoid negative testing
	constraint c2 {ctl inside {[0:13]};} 	//constraint operation within range to avoid negative scenarios  
	
	//output signals 
	logic [3:0] 		alu 			;
	logic 			valid_out 		;
	logic 			carry 			;
	logic 			zero 			;
	
	//packet index for debugging
	int            		pkt_num     		;


	//function to compare outputs 
	function int compare_outputs(Packet pkt_stim , Packet pkt_mon);
		if (pkt_mon.alu === pkt_stim.alu && pkt_mon.carry === pkt_stim.carry && pkt_mon.zero === pkt_stim.zero && pkt_stim.valid_out === pkt_mon.valid_out) 
				return 1		;
		else
				return 0		;
	endfunction     


endclass
