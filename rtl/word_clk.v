module word_clk (
  input         mclkin,
  output reg    word_clk = 0

);
  
  // 
  reg [16 :0] word_count = 0;

  always @(posedge mclkin) begin
    word_count <= word_count + 16'b1;

    if (word_count == 255) begin 
      word_count <= 16'b0;
      word_clk <= 1'b0;
    end else if (word_count == 127) begin 
      word_clk <= 1'b1;
    end
  end

endmodule