// ARCHIVO GENERADO AUTOMATICAMENTE por assembler_v2.py
// a partir del programa en ensamblador. No editar a mano.
// Estrategia 2 (seccion 3.2): memoria unificada de flip-flops.
// 100 palabras = 100 de programa + 0 de datos.
// El programa se carga en los flip-flops durante el reset.

module pochoco_ram (
  input  wire        clk_i,
  input  wire        rst_ni,

  // Port A: instruction
  input  wire        a_req_i,
  input  wire [31:0] a_addr_i,
  output reg  [31:0] a_rdata_o,

  // Port B: data
  input  wire        b_req_i,
  input  wire        b_we_i,
  input  wire [3:0]  b_be_i,
  input  wire [31:0] b_addr_i,
  input  wire [31:0] b_wdata_i,
  output reg  [31:0] b_rdata_o
);

  localparam integer NumWords = 100;
  localparam integer AddrW    = 7;

  // Contenido de reset: palabra 0 en los bits menos significativos.
  localparam [32*NumWords-1:0] PROG = {
    32'h0000006f,  // palabra 99
    32'h00b12023,  // palabra 98
    32'h009585b3,  // palabra 97
    32'h00b585b3,  // palabra 96
    32'h00b585b3,  // palabra 95
    32'h00b585b3,  // palabra 94
    32'h00a505b3,  // palabra 93
    32'hff1ff06f,  // palabra 92
    32'h00150513,  // palabra 91
    32'hff648493,  // palabra 90
    32'h00069863,  // palabra 89
    32'h00a4a693,  // palabra 88
    32'h00000513,  // palabra 87
    32'h06300493,  // palabra 86
    32'h00069463,  // palabra 85
    32'h0644a693,  // palabra 84
    32'hff1ff06f,  // palabra 83
    32'h00148493,  // palabra 82
    32'hff658593,  // palabra 81
    32'h00069863,  // palabra 80
    32'h00a5a693,  // palabra 79
    32'h00000493,  // palabra 78
    32'h00558593,  // palabra 77
    32'h000205b3,  // palabra 76
    32'h00012223,  // palabra 75
    32'hf09ff06f,  // palabra 74
    32'h00012223,  // palabra 73
    32'h00112023,  // palabra 72
    32'h0ee00093,  // palabra 71
    32'hf19ff06f,  // palabra 70
    32'h00118c63,  // palabra 69
    32'h00a00093,  // palabra 68
    32'h00b12023,  // palabra 67
    32'h009585b3,  // palabra 66
    32'h00b585b3,  // palabra 65
    32'h00b585b3,  // palabra 64
    32'h00b585b3,  // palabra 63
    32'h00a505b3,  // palabra 62
    32'hff1ff06f,  // palabra 61
    32'h00150513,  // palabra 60
    32'hff648493,  // palabra 59
    32'h00069863,  // palabra 58
    32'h00a4a693,  // palabra 57
    32'h00000513,  // palabra 56
    32'h06300493,  // palabra 55
    32'h00069463,  // palabra 54
    32'h0644a693,  // palabra 53
    32'h00118193,  // palabra 52
    32'h00920233,  // palabra 51
    32'h406384b3,  // palabra 50
    32'h04509c63,  // palabra 49
    32'h01012383,  // palabra 48
    32'hfe008ce3,  // palabra 47
    32'h00f0f093,  // palabra 46
    32'h00812083,  // palabra 45
    32'h01012303,  // palabra 44
    32'h00512223,  // palabra 43
    32'h00400293,  // palabra 42
    32'h0080006f,  // palabra 41
    32'h00200293,  // palabra 40
    32'h0100006f,  // palabra 39
    32'h00100293,  // palabra 38
    32'h0180006f,  // palabra 37
    32'h00800293,  // palabra 36
    32'h00140e63,  // palabra 35
    32'h00200093,  // palabra 34
    32'h00140e63,  // palabra 33
    32'h00100093,  // palabra 32
    32'h00040e63,  // palabra 31
    32'h00377413,  // palabra 30
    32'h5a574713,  // palabra 29
    32'h00374733,  // palabra 28
    32'h00474733,  // palabra 27
    32'h00874733,  // palabra 26
    32'h00c12403,  // palabra 25
    32'hfe009ce3,  // palabra 24
    32'h00f0f093,  // palabra 23
    32'h00812083,  // palabra 22
    32'hfec3ece3,  // palabra 21
    32'h406383b3,  // palabra 20
    32'h01012383,  // palabra 19
    32'h01e00613,  // palabra 18
    32'h01012303,  // palabra 17
    32'h00112223,  // palabra 16
    32'h00f00093,  // palabra 15
    32'hfe009ce3,  // palabra 14
    32'h00f0f093,  // palabra 13
    32'h00812083,  // palabra 12
    32'hfe009ce3,  // palabra 11
    32'h00f0f093,  // palabra 10
    32'h00812083,  // palabra 9
    32'h00c12703,  // palabra 8
    32'hfe008ce3,  // palabra 7
    32'h00f0f093,  // palabra 6
    32'h00812083,  // palabra 5
    32'h00012023,  // palabra 4
    32'h00012223,  // palabra 3
    32'h00000213,  // palabra 2
    32'h00000193,  // palabra 1
    32'h80000137  // palabra 0
  };

  reg  [32*NumWords-1:0] mem;
  wire [AddrW-1:0] a_word = a_addr_i[AddrW+1:2];
  wire [AddrW-1:0] b_word = b_addr_i[AddrW+1:2];

  integer i;

  // Carga del programa en reset y escritura por bytes (puerto B)
  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      mem <= PROG;
    end else if (b_req_i && b_we_i) begin
      for (i = 0; i < NumWords; i = i + 1) begin
        if (b_word == i) begin
          if (b_be_i[0]) mem[32*i      +: 8] <= b_wdata_i[7:0];
          if (b_be_i[1]) mem[32*i + 8  +: 8] <= b_wdata_i[15:8];
          if (b_be_i[2]) mem[32*i + 16 +: 8] <= b_wdata_i[23:16];
          if (b_be_i[3]) mem[32*i + 24 +: 8] <= b_wdata_i[31:24];
        end
      end
    end
  end

  // Lectura sincronica (1 ciclo), igual que la memoria original
  always @(posedge clk_i) begin
    if (a_req_i)
      a_rdata_o <= (a_word < NumWords) ? mem[32*a_word +: 32] : 32'h00000013;
    b_rdata_o <= (b_word < NumWords) ? mem[32*b_word +: 32] : 32'h00000000;
  end

endmodule
