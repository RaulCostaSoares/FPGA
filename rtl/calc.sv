module caclc(
  input logic clock,
  input logic reset,
  input logic[3:0] cmd,

  output logic[1:0] status,
  output logic[7:0] data,
  output logic[7:0] pos
  );

  reg[31:0] val1, val2, out;
  reg[7:0] op;
  reg is_op_set;


  // logic[3:0] data = 0;
  // logic[3:0] pos = 0;

  ctrl controlador(
    .dig(data),
    .pos(pos),
    .clock(clock),
    .reset(reset)

  );


  always @(posedge clock, negedge reset) begin

    if(reset == 1) begin
      val1 <= 0;
      val2 <= 0;
      op <= 0;
      out <= 0;
      is_op_set <= 0;
      status <= 0;
    end else begin
      if (cmd >= 0 && cmd <= 9) begin
        if(!is_op_set) begin
          val1 = (val1*10) + cmd;
        end else begin
          val2 = (val2*10) + cmd;
        end
        end else begin
            op <= cmd;
            is_op_set <= 1;
        end
        case (op)
        
          4'b1001: out <= val1 + val2;
          4'b1010: out <= val1 - val2;
          4'b1011: out <= val1 * val2;
          4'b1100: data <= out[7:0];
          // 4'b0101: apagar

        endcase
      end
    end
endmodule