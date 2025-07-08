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
  localparam HALFBAUD = FULLBAUD / 2;


  // детектирование фронтов и спадов принимаемого сигнала 
  reg prev_data;
  wire rising_edge  = (prev_data == 1'b0) && (rx_data == 1'b1);
  wire falling_edge = (prev_data == 1'b1) && (rx_data == 1'b0);


  reg [16 - 1 :0] clk_counter;
  reg CLK_TX;


  always @(posedge clk) begin
    clk_counter <= clk_counter + 1;
    prev_data <= rx_data;
    if ( rising_edge == 1'b1) begin
      if ( clk_counter >= FULLBAUD + HALFBAUD  && clk_counter <= FULLBAUD + FULLBAUD + FULLBAUD) begin
        data_tx     <= 1'b1;
        clk_counter <= 0;  
      end  
    end else if (falling_edge == 1'b1) begin
      if ( clk_counter >= FULLBAUD + HALFBAUD  && clk_counter <= FULLBAUD + FULLBAUD + FULLBAUD) begin
        data_tx     <= 1'b0;
        clk_counter <= 0;  
      end       
    end
  end


endmodule