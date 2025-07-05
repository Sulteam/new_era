module filter_sinc3 #(
  parameter WIDTH    = 16,
  parameter dec_rate = 256                           //   dec_rate - decimation rate  
  
) (
  input                       mclkin,                // тактовая частота для модулятора
  input                       mdata1,                // входной поток данных от модулятора
  input                       word_clk,              // тактовая частота после децимации
  output reg [WIDTH - 1: 0]   DATA                   // отфильтрованные данные 

  
);

  localparam REG_BIT_WIDTH = 1 + 3 * $clog2(dec_rate);     // reg_bit_width = x(n) + (M * log2(DR))  DR - decimation rate 
  // Внутренние провода
  
  reg [REG_BIT_WIDTH - 1:0] ip_data1;
  reg [REG_BIT_WIDTH - 1:0] acc1;
  reg [REG_BIT_WIDTH - 1:0] acc2;
  reg [REG_BIT_WIDTH - 1:0] acc3;
  reg [REG_BIT_WIDTH - 1:0] acc3_d2;
  reg [REG_BIT_WIDTH - 1:0] diff1;
  reg [REG_BIT_WIDTH - 1:0] diff2;
  reg [REG_BIT_WIDTH - 1:0] diff3;
  reg [REG_BIT_WIDTH - 1:0] diff1_d;
  reg [REG_BIT_WIDTH - 1:0] diff2_d;
    

  // Входные данные 
  always @(mdata1) begin
    if (mdata1 == 0) begin
	   ip_data1 <= 37'd0;
	 end else begin
	   ip_data1 <= 37'd1;
    end
  end
  
  // Блок интеграторов 
  always @(negedge mclkin) begin
   acc1 <= acc1 + ip_data1;
   acc2 <= acc2 + acc1;
   acc3 <= acc3 + acc2;
  end
	
  // Блок дифференциаторов
  always @(posedge word_clk) begin
   diff1 <= acc3 - acc3_d2;
	 diff2 <= diff1 - diff1_d;
	 diff3 <= diff2 - diff2_d;
	 acc3_d2 <= acc3; 
	 diff1_d <= diff1;
	 diff2_d <= diff2;
  end
  
  
  always @ ( posedge word_clk ) begin
    case ( dec_rate )
      16'd32:   DATA <= (diff3[15:0]  == 16'h8000)   ? 16'hFFFF : {diff3[14:0], 1'b0};
      16'd64:   DATA <= (diff3[18:2]  == 17'h10000)  ? 16'hFFFF : diff3[17:2];
      16'd128:  DATA <= (diff3[21:5]  == 17'h10000)  ? 16'hFFFF : diff3[20:5];
      16'd256:  DATA <= (diff3[24:8]  == 17'h10000)  ? 16'hFFFF : diff3[23:8];
      16'd512:  DATA <= (diff3[27:11] == 17'h10000)  ? 16'hFFFF : diff3[26:11];
      16'd1024: DATA <= (diff3[30:14] == 17'h10000)  ? 16'hFFFF : diff3[29:14];
      16'd2048: DATA <= (diff3[33:17] == 17'h10000)  ? 16'hFFFF : diff3[32:17];
      16'd4096: DATA <= (diff3[36:20] == 17'h10000)  ? 16'hFFFF : diff3[35:20];
      default:  DATA <= (diff3[24:8]  == 17'h10000)  ? 16'hFFFF : diff3[23:8];
    endcase
  end
  
endmodule