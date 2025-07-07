`timescale 1ns/1ns
module decoder_manch #(
  parameter BAUDRATE = 115200 * 2,
  parameter CLK_FREQ = 18_750_000

) (
  input  wire clk, 
  input  wire rx_data,
  output reg  data_tx

);
  initial begin
    $dumpfile("dump1.vcd");
    $dumpvars(1, decoder_manch);
  end

  localparam FULLBAUD =  CLK_FREQ / BAUDRATE;
  localparam bit_width = $clog2(FULLBAUD);

  reg [bit_width - 1 :0] clk_counter; 
  reg CLK_TX;

  always @(posedge clk) begin
    clk_counter  <= clk_counter + 1;
  end

  always @(posedge rx_data) begin
    if ( clk_counter >= FULLBAUD - 1) begin
      data_tx <= 1'b1;
      clk_counter <= 0;  
    end
  end

  always @(negedge rx_data) begin
    if ( clk_counter >= FULLBAUD - 1) begin
      data_tx <= 1'b0;
      clk_counter <= 0;  
    end
  end

endmodule