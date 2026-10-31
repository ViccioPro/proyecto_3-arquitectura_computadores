// ARCHIVO GENERADO AUTOMATICAMENTE por assembler_v2.py
// a partir del programa en ensamblador. No editar a mano.
// Programa: 100 palabras de 32 bits.

module pochoco_rom (
  input  wire [29:0] addr_i,   // direccion de palabra
  output reg  [31:0] data_o
);

  always @(*) begin
    case (addr_i)
      30'd0: data_o = 32'h80000137;
      30'd1: data_o = 32'h00000193;
      30'd2: data_o = 32'h00000213;
      30'd3: data_o = 32'h00012223;
      30'd4: data_o = 32'h00012023;
      30'd5: data_o = 32'h00812083;
      30'd6: data_o = 32'h00f0f093;
      30'd7: data_o = 32'hfe008ce3;
      30'd8: data_o = 32'h00c12703;
      30'd9: data_o = 32'h00812083;
      30'd10: data_o = 32'h00f0f093;
      30'd11: data_o = 32'hfe009ce3;
      30'd12: data_o = 32'h00812083;
      30'd13: data_o = 32'h00f0f093;
      30'd14: data_o = 32'hfe009ce3;
      30'd15: data_o = 32'h00f00093;
      30'd16: data_o = 32'h00112223;
      30'd17: data_o = 32'h01012303;
      30'd18: data_o = 32'h01e00613;
      30'd19: data_o = 32'h01012383;
      30'd20: data_o = 32'h406383b3;
      30'd21: data_o = 32'hfec3ece3;
      30'd22: data_o = 32'h00812083;
      30'd23: data_o = 32'h00f0f093;
      30'd24: data_o = 32'hfe009ce3;
      30'd25: data_o = 32'h00c12403;
      30'd26: data_o = 32'h00874733;
      30'd27: data_o = 32'h00474733;
      30'd28: data_o = 32'h00374733;
      30'd29: data_o = 32'h5a574713;
      30'd30: data_o = 32'h00377413;
      30'd31: data_o = 32'h00040e63;
      30'd32: data_o = 32'h00100093;
      30'd33: data_o = 32'h00140e63;
      30'd34: data_o = 32'h00200093;
      30'd35: data_o = 32'h00140e63;
      30'd36: data_o = 32'h00800293;
      30'd37: data_o = 32'h0180006f;
      30'd38: data_o = 32'h00100293;
      30'd39: data_o = 32'h0100006f;
      30'd40: data_o = 32'h00200293;
      30'd41: data_o = 32'h0080006f;
      30'd42: data_o = 32'h00400293;
      30'd43: data_o = 32'h00512223;
      30'd44: data_o = 32'h01012303;
      30'd45: data_o = 32'h00812083;
      30'd46: data_o = 32'h00f0f093;
      30'd47: data_o = 32'hfe008ce3;
      30'd48: data_o = 32'h01012383;
      30'd49: data_o = 32'h04509c63;
      30'd50: data_o = 32'h406384b3;
      30'd51: data_o = 32'h00920233;
      30'd52: data_o = 32'h00118193;
      30'd53: data_o = 32'h0644a693;
      30'd54: data_o = 32'h00069463;
      30'd55: data_o = 32'h06300493;
      30'd56: data_o = 32'h00000513;
      30'd57: data_o = 32'h00a4a693;
      30'd58: data_o = 32'h00069863;
      30'd59: data_o = 32'hff648493;
      30'd60: data_o = 32'h00150513;
      30'd61: data_o = 32'hff1ff06f;
      30'd62: data_o = 32'h00a505b3;
      30'd63: data_o = 32'h00b585b3;
      30'd64: data_o = 32'h00b585b3;
      30'd65: data_o = 32'h00b585b3;
      30'd66: data_o = 32'h009585b3;
      30'd67: data_o = 32'h00b12023;
      30'd68: data_o = 32'h00a00093;
      30'd69: data_o = 32'h00118c63;
      30'd70: data_o = 32'hf19ff06f;
      30'd71: data_o = 32'h0ee00093;
      30'd72: data_o = 32'h00112023;
      30'd73: data_o = 32'h00012223;
      30'd74: data_o = 32'hf09ff06f;
      30'd75: data_o = 32'h00012223;
      30'd76: data_o = 32'h000205b3;
      30'd77: data_o = 32'h00558593;
      30'd78: data_o = 32'h00000493;
      30'd79: data_o = 32'h00a5a693;
      30'd80: data_o = 32'h00069863;
      30'd81: data_o = 32'hff658593;
      30'd82: data_o = 32'h00148493;
      30'd83: data_o = 32'hff1ff06f;
      30'd84: data_o = 32'h0644a693;
      30'd85: data_o = 32'h00069463;
      30'd86: data_o = 32'h06300493;
      30'd87: data_o = 32'h00000513;
      30'd88: data_o = 32'h00a4a693;
      30'd89: data_o = 32'h00069863;
      30'd90: data_o = 32'hff648493;
      30'd91: data_o = 32'h00150513;
      30'd92: data_o = 32'hff1ff06f;
      30'd93: data_o = 32'h00a505b3;
      30'd94: data_o = 32'h00b585b3;
      30'd95: data_o = 32'h00b585b3;
      30'd96: data_o = 32'h00b585b3;
      30'd97: data_o = 32'h009585b3;
      30'd98: data_o = 32'h00b12023;
      30'd99: data_o = 32'h0000006f;
      default: data_o = 32'h00000013;  // nop (addi x0, x0, 0)
    endcase
  end

endmodule
