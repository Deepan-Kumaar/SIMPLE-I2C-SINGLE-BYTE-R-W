module i2c_m (
    inout m_SDA,
    output m_SCL,
    input [7:0]in_DATA,
    input  [6:0]address,
    input i_RW,
    input trig_ss
    //output [6:0]m_s_add
);
integer i;
//STATES
reg [2:0]state;

parameter [2:0]IDLE =3'd0 ;
parameter [2:0]START =3'd1 ;
parameter [2:0]ADDRESS =3'd2;
parameter [2:0]ACKNOWLEDGE =3'd3;
parameter [2:0]WRITE =3'd4;
parameter [2:0]READ =3'd5;
parameter [2:0]STOP =3'd6;
parameter [2:0]NULL =3'd7;


//SDA WRITE
reg SDA_WRITE;
initial SDA_WRITE=1;
reg ACK;

///MAKE A CLK AND SET IT TO SCL AS OUTPUT
reg clk=0;
always #10 clk=~clk;
assign m_SCL=clk;

///memory modules
reg [7:0] READMEM;
reg [7:0] WMEM;
always @(*) begin
    WMEM=in_DATA;
end
reg [7:0]s_addr;
initial #1 s_addr={address,i_RW};

//start condition is when SDA moves from high to low while SCL is HIGH and 
//stop condition is when SDA moves from LOW to HIGH while SCL is HIGH
reg SDA=1;
assign m_SDA=(SDA_WRITE==1)?SDA:'bz;

//start & stop

always @(*) 
begin
    SDA=(trig_ss)?0:1;
       
end
//THIS WILL START THE PROCESS WHEN THE SDA IS PULLED DOWN ONLY WHEN SCL IS HIGH 
initial
begin
@(negedge SDA)
begin
if(clk==1)
begin
state=IDLE;

end
end
end

//FSM
always @(m_SCL)
begin
case (state)
IDLE:
begin
    state=ADDRESS;
    
end
ADDRESS:
begin
    for(i=0;i<=8;i=i+1)
    begin
        @(negedge m_SCL)SDA=s_addr[i]; //Will send the adress bit by bit
    end
    SDA_WRITE=0;
    @(posedge m_SCL)state=ACKNOWLEDGE;
    
end
ACKNOWLEDGE:
begin    
    ACK=(m_SDA==0)?0:1;//wait for ack signal 0
    state=(ACK==0)?((i_RW==0)?READ:WRITE):ADDRESS;
    SDA_WRITE=(i_RW==0)?0:1;
    
end
WRITE:
begin
    //SDA_WRITE=1;
    for(i=0;i<=7;i=i+1)
    begin
        @(negedge clk)SDA=WMEM[i];//write
    end
    state=STOP;
    
end
READ:
begin
    //SDA_WRITE=0;
    for(i=0;i<=7;i=i+1)
    begin
        @(posedge clk)READMEM[i]=m_SDA;///read
    end
    state=STOP;
end
STOP:
begin
SDA_WRITE=1;
SDA=1;

end

endcase

end



endmodule //i2c_master_adv