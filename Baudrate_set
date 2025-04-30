module Baudrate_set(
input[2:0] baudrate,output reg [20:0] k    );
    
    parameter b1=9600;
    parameter b2=19200;
    parameter b3=115200;
    always@(*)
    begin
  case(baudrate)
   
  3'b001: k<=b1;
  3'b010: k<=b2;
  3'b100: k<=b3;
  default : k<=b1;
  endcase
  end
  endmodule
