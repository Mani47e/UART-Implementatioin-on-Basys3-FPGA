`timescale 1ns / 1ps


module top(
input [7:0]sw,
input [2:0]baudset,
input btn0,
input btn1,
input btn2,
input clk,
input RxD,
output TxD,

output wire [7:0] LED
); 

wire transmit;


debounce D2 (.clk(clk), .btn(btn1), .transmit(transmit));
transmitter T1 (.clk(clk), .reset(btn0),.transmit(transmit),.TxD(TxD),.data(sw),.baudset(baudset));
receiver R1(.clk(clk), .reset(btn2), .RxD(RxD), .RxData(LED),.baudrate_set(baudset));





endmodule
