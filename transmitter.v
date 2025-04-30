`timescale 1ns / 1ps


module transmitter(
input clk, 
input reset, 
input transmit, 
input[2:0] baudset,
input [7:0] data, 
output reg TxD 
    );

reg [3:0] bitcounter; 
reg [13:0] counter; //14 bits counter to count the baud rate, counter = clock / baud rate
reg state,nextstate; 
 
reg [9:0] rightshiftreg; 
reg shift; 
reg load; 
reg clear; 

reg [19:0]k;



    parameter b1=20'd10415;
    parameter b2= 20'd5207;
    parameter b3= 20'd867;
    always@(*)
    begin
  case(baudset)
   
  3'b001: k<=b1;
  3'b010: k<=b2;
  3'b100: k<=b3;
  default:  k<=b1;
  endcase
  end





always @ (posedge clk) 
begin 
    if (reset) 
	   begin
        state <=0; 
        counter <=0; 
        bitcounter <=0; 
       end
    else begin
         counter <= counter + 1; //counter for baud rate generator start counting 
            if (counter >= k) //if count to 10416 (from 0 to 10415 or 5201 or 867)
               begin 
                  state <= nextstate; 
                  counter <=0; 
            	  if (load) rightshiftreg <= {1'b1,data,1'b0}; 
		          if (clear) bitcounter <=0; 
                  if (shift) 
                     begin 
                        rightshiftreg <= rightshiftreg >> 1;  
                        bitcounter <= bitcounter + 1; 
                     end
               end
         end
end 


always @ (posedge clk) 
begin
    load <=0; 
    shift <=0; 
    clear <=0; 
    TxD <=1; 
    case (state)
        0: begin // idle state
             if (transmit) begin 
             nextstate <= 1; 
             load <=1; 
             shift <=0; 
             clear <=0; 
             end 
		else begin 
             nextstate <= 0; 
             TxD <= 1; 
             end
           end
        1: begin  
             if (bitcounter >=10) begin 
             nextstate <= 0; 
             clear <=1; // set clear to 1 to clear all counters
             end 
		else begin // if transmisssion is not complete 
             nextstate <= 1; 
             TxD <= rightshiftreg[0]; 
             shift <=1; 
             end
           end
         default: nextstate <= 0;                      
    endcase
end


endmodule

