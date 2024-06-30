module I2C_MASTER_MOD (
    input  clk,
    output reg [7:0] o_SDA,
    input [7:0] i_SDA,
    output wire o_SCL,
    input [6:0] i_Slave_Add,
    input i_RW,
    output reg [7:0] o_Add_RD,
    input [7:0] i_DATA,
    input i_ACK
);

parameter [3:0] IDLE = 4'd0;
parameter [3:0] SCAN=4'd1;
parameter [3:0] DATA=4'd2;
parameter [3:0] READ=4'd3;
parameter [3:0] WRITE=4'd4;

reg [7:0] RWMEM;

reg [7:0] REDMEM ;
reg [3:0]state;

assign o_SCL=clk;

initial
begin

    state<=IDLE;
end

//start the process
always @(posedge clk) 
begin

        case(state)
        IDLE:
        begin
            //set the address of slave and rw signal together
            o_Add_RD = {i_Slave_Add,i_RW};
            state=SCAN;                                  
        end
        SCAN:        
        begin
            o_SDA<=o_Add_RD;            
            state=(i_ACK==0)?DATA:SCAN;                                              
        end
        DATA:
        begin
        RWMEM =(i_RW==0) ? i_SDA:i_DATA;
        state =(i_RW==0) ? READ:WRITE;    
        end                  
        READ:
        begin
            REDMEM=RWMEM;
            state=IDLE;        
        end                   
        WRITE:
        begin
            o_SDA=RWMEM;
            state=IDLE;       
        end
        
        endcase        

end

endmodule