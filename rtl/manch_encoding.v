module manch_encoding #(
  parameter BAUDRATE = 115200 * 2,
  parameter CLK_FREQ = 18_750_000

) (
  input  wire clk,
  input  wire tx_data,
  output wire tx_manch

);

  localparam FULLBAUD =  CLK_FREQ / BAUDRATE;
  localparam bit_width = $clog2(FULLBAUD);

  reg [bit_width - 1 :0] clk_counter; 
  reg CLK_TX;

  always @(posedge clk) begin
    clk_counter <= clk_counter + 1;
      if (clk_counter == FULLBAUD-1) begin
        CLK_TX <= ~ CLK_TX;
        clk_counter <= 0;
      end
  end

  assign tx_manch = CLK_TX ^ tx_data;
  
endmodule