module i2c_s (
inout s_SDA,
input  s_SCL    
);
parameter [6:0]address = 7'd11 ;

reg [7:0]addr;
reg [7:0]MEM=8'd150;
reg [7:0]WMEM;

reg SDA;
//assign s_SDA=SDA;

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

initial SDA_WRITE=0;

assign s_SDA=(SDA_WRITE==1)?SDA:'bz;

//THIS WILL START THE PROCESS WHEN THE SDA IS PULLED DOWN ONLY WHEN SCL IS HIGH 
initial
begin
@(negedge s_SDA)
begin
if(s_SCL==1)
begin
state=IDLE;
end
end
end


always @(s_SCL)
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
        @(posedge s_SCL)addr[i]=s_SDA;
    end
    //assign SDA=s_SDA;
    SDA_WRITE=1;
    SDA=(addr[7:1]==address)?0:1;
    state=ACKNOWLEDGE;
end
ACKNOWLEDGE:
begin
    
    
    SDA_WRITE=(addr[0]==0)?1:0;
    state=(addr[0]==0)?WRITE:READ;
end
WRITE:
begin
    //SDA_WRITE=1;
    for(i=0;i<=7;i=i+1)
    begin
        @(negedge s_SCL)SDA=MEM[i];///write onto the master
    end
    state=STOP;
end
READ:
begin
    //SDA_WRITE=0;
    for(i=0;i<=7;i=i+1)
    begin
        @(posedge s_SCL)WMEM[i]=s_SDA;///write onto the master
    end
    state=STOP;
end
STOP:
begin
//SDA_WRITE=0;

end
endcase

end

endmodule //i2c_slave_adv