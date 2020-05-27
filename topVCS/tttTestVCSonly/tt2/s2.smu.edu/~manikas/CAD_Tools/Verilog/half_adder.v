// half_adder.v  T. Manikas  9-20-19
// half-adder circuit
// inputs are bits a and b
// outputs are sum bit s and carry-out bit co


// half-adder

module half_adder(s,co,a,b);
	input a,b;
	output s;	// sum
	output co;	// carry-out
	xor(s,a,b);
	and(co,a,b);
endmodule

// testbench

module test_ha;
	reg a,b;
	wire s, co;
	half_adder ha(s,co,a,b);
	initial
	begin
		a=0; b=0;
		#2 a=0; b=1;
		#2 a=1; b=0;
		#2 a=1; b=1;
	end
	initial $monitor($time, " a=%b b=%b, sum=%b carry-out=%b",a,b,s,co);
	initial #10 $stop;
endmodule
