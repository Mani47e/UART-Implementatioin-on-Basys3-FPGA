`timescale 1ns / 1ps

module receiver (
    input clk, 
    input reset, 
    input [2:0] baudrate_set,
    input RxD, 
    output [7:0] RxData
);

    reg shift; 
    reg state, nextstate; 
    reg [3:0] bitcounter; 
    reg [1:0] samplecounter; 
    reg [20:0] counter; 
    reg [9:0] rxshiftreg; 
    reg clear_bitcounter, inc_bitcounter, inc_samplecounter, clear_samplecounter; 

    wire [19:0] baud;
    reg [19:0] baud_rate;
    reg [31:0] div_counter;

    // Baudrate selection module
    Baudrate_set b2 (
        .baudrate(baudrate_set),
        .k(baud)
    );

    parameter clk_freq = 100_000_000;  
    parameter div_sample = 4;
    parameter mid_sample = div_sample / 2;
    parameter div_bit = 10;

    assign RxData = rxshiftreg[8:1]; 

    
    always @(*) begin
        baud_rate = baud;
        div_counter = clk_freq / (baud_rate * div_sample);
    end

    // UART receiver logic
    always @ (posedge clk) begin 
        if (reset) begin
            state <= 0; 
            bitcounter <= 0; 
            counter <= 0; 
            samplecounter <= 0;
            rxshiftreg <= 0;
        end else begin
            counter <= counter + 1;
            if (counter >= div_counter - 1) begin
                counter <= 0; 
                state <= nextstate; 
                if (shift) rxshiftreg <= {RxD, rxshiftreg[9:1]};
                if (clear_samplecounter) samplecounter <= 0;
                if (inc_samplecounter) samplecounter <= samplecounter + 1;
                if (clear_bitcounter) bitcounter <= 0;
                if (inc_bitcounter) bitcounter <= bitcounter + 1;
            end
        end
    end

    // FSM: UART receiver state machine
    always @ (posedge clk) begin 
        shift <= 0; 
        clear_samplecounter <= 0; 
        inc_samplecounter <= 0; 
        clear_bitcounter <= 0; 
        inc_bitcounter <= 0; 
        nextstate <= 0;

        case (state)
            0: begin // Idle state
                if (!RxD) begin
                    nextstate <= 1; 
                    clear_bitcounter <= 1;
                    clear_samplecounter <= 1;
                end else begin
                    nextstate <= 0;
                end
            end
            1: begin // Receiving state
                nextstate <= 1;
                if (samplecounter == mid_sample - 1)
                    shift <= 1;
                if (samplecounter == div_sample - 1) begin
                    if (bitcounter == div_bit - 1) begin
                        nextstate <= 0;
                    end
                    inc_bitcounter <= 1;
                    clear_samplecounter <= 1;
                end else begin
                    inc_samplecounter <= 1;
                end
            end
            default: nextstate <= 0;
        endcase
    end

endmodule
