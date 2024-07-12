
module i2c_m_tb;
  //Ports
  wire SDA;
  wire  m_SCL;
  reg [7:0] in_DATA;
  reg [6:0] address;
  reg  i_RW;
  reg  trig_ss;
  //reg  s_SCL;
  i2c_m  i2c_m_inst (
    .m_SDA(SDA),
    .m_SCL(m_SCL),
    .in_DATA(in_DATA),
    .address(address),
    .i_RW(i_RW),
    .trig_ss(trig_ss)
  );

  i2c_s  i2c_s_inst (////the inout can only be assigned to one reg at a time either slave or master
    .s_SDA(SDA),
    .s_SCL(m_SCL)
  );

initial
begin
//s_SCL=m_SCL;
address=7'd11;
in_DATA=8'b10011001;
i_RW=1;//READ MEANS '0' AND WRITE IS '1'
end

initial
begin
#15 trig_ss=1;
end

always #300 $finish();
endmodule