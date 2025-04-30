module debounce(input btn ,clk,output transmit);
wire slow_clk;
wire Q1,Q2,Q2_bar,Q0;
clock_div u1(clk,slow_clk);
dff d0(slow_clk, btn,Q0 );

dff d1(slow_clk, Q0,Q1 );
dff d2(slow_clk, Q1,Q2 );
assign Q2_bar = ~Q2;
assign transmit  = Q1 & Q2_bar;
endmodule
// Slow clock for debouncing 
module clock_div(input Clk_100M, output reg slow_clk

    );
    reg [26:0]counter=0;
    always @(posedge Clk_100M)
    begin
        counter <= (counter>=7811)?0:counter+1;
        slow_clk <= (counter < 3905)?1'b0:1'b1;
    end
endmodule

module dff(input DFF_CLOCK, D, output reg Q);

    always @ (posedge DFF_CLOCK) begin
        Q <= D;
    end

endmodule
