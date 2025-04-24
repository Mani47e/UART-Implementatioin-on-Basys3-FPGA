`timescale 1ns / 1ps


module top(
input [7:0]sw,
input btn0,
input btn1,
input btn2,
input clk,
input RxD,
output TxD,
//output TxD_debug,
//output transmit_debug,
//output button_debug, 
//output clk_debug,
output wire [7:0] LED
); 

wire transmit;
//assign TxD_debug = TxD;
//assign transmit_debug = transmit;
//assign button_debug = btn1;
//assign clk_debug = clk;


debounce D2 (.clk(clk), .btn(btn1), .transmit(transmit));
transmitter T1 (.clk(clk), .reset(btn0),.transmit(transmit),.TxD(TxD),.data(sw));
receiver R1(.clk(clk), .reset(btn2), .RxD(RxD), .RxData(LED));

endmodule
