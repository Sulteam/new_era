module manch_encoding #(
  parameter WIDTH = 16
  
) (
  input wire clk,
  input wire tx_valid,
  input wire [WIDTH - 1:0] tx_data,
  output reg tx

);
  
  wire [WIDTH * 2 - 1: 0] data_manchester;  // удвоенный данные для передачи по манчестерскому кодированию. (один бит - это переход из "0" в "1" или из "1" в "0")


  //преобразование «защелкнутых» входных данных в выходную посылку
  //преобразуем поле данных в манчестерский вид
  genvar i;
  generate for (i = 0; i < 16; i = i + 1)
  begin : gen_manchester
     assign data_manchester[2*i] = ~tx_data[i];
     assign data_manchester[2*i + 1] = tx_data[i];
  end
  endgenerate
  
endmodule