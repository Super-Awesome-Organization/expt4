`timescale 1ns/1ns

module trojan_seq_tb ();

	reg 			clk = 1;
	reg 			rst;
	reg 	[55:0]	key;
	reg 	[31:0]	trigger;
	wire 	[55:0]	payload;
	
	trojan_seq U0 (
		.clk(clk),
		.rst(rst),
		.key(key),
		.trigger(trigger),
		.payload(payload)
	);


	`define DELAY(TIME_CLK) #(10*TIME_CLK); //delays one clk cycle, TIME_CLK = number of clk cycles to delay

	reg simState = 0;
	always begin 
		if (simState != 1) begin
			`DELAY(1/2)
			clk = ~clk;
		end
	end


	initial begin
		$display($time, "- Starting Sim");
		rst = 1'b1;
		key = 56'h000000000000000;
		trigger = 32'h00000000;		
		`DELAY(1)

		rst = 1'b0;
		key = 56'hFFFFFFFFFFFFFFF;
		trigger = 32'hAAAAAAA0;	
		`DELAY(1)

		trigger = 32'h55555550;
		`DELAY(1)

		trigger = 32'h55555552;
		`DELAY(1)

		trigger = 32'h55555551;
		`DELAY(1)

		trigger = 32'h55555550;
		`DELAY(1)

// TRIGGER CONDITION START ---------------------

		trigger = 32'h55555552;
		`DELAY(1)

		trigger = 32'h55555551;
		`DELAY(1)

		trigger = 32'h55555553;
		`DELAY(1)

// TRIGGER CONDITION END -----------------------

		trigger = 32'h55555555;
		`DELAY(1)

		trigger = 32'h55555556;
		`DELAY(1)

		trigger = 32'h55555552;
		`DELAY(20)

		$stop;
	end

endmodule : trojan_seq_tb