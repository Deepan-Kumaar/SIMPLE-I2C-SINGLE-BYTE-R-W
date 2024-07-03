
module I2C_MASTER_MOD_tb;

  //Ports
  reg  clk;
  wire [7:0] o_SDA;
  //reg [7:0] i_SDA;
  wire  o_SCL;
  reg [6:0] i_Slave_Add;
  reg  i_RW;
  wire [7:0] o_Add_RD;
  reg [7:0] i_DATA;
  //reg  i_ACK;
  //Ports
  //reg  s_SCL;
  reg [7:0] si_SDA;
  wire [7:0] so_SDA;
  wire  s_ACK;  
  reg si_SCL;


  I2C_MASTER_MOD  I2C_MASTER_MOD_inst (
    .clk(clk),
    .o_SDA(o_SDA),
    .i_SDA(so_SDA),
    .o_SCL(o_SCL),
    .i_Slave_Add(i_Slave_Add),
    .i_RW(i_RW),
    .o_Add_RD(o_Add_RD),
    .i_DATA(i_DATA),
    .i_ACK(s_ACK)
  );



I2C_SLAVE_MOD  I2C_SLAVE_MOD_inst (
  .s_SCL(si_SCL),
  .si_SDA(o_SDA),
  .so_SDA(so_SDA),
  .s_ACK(s_ACK)
);

initial
begin
  clk<=0;
end
always@(*)
begin
si_SCL<=o_SCL;
end
always #10  clk = ! clk ;

initial 
begin 
  i_Slave_Add=7'b1010101;///address
  i_DATA=8'b00000111;///data to be sent to the slave
  i_RW=0;  ///change to 0 or 1 (read or write)
end
always #200 $finish;



endmodule

