module I2C_MASTER_MOD (
    input  clk,
    output reg [7:0] o_SDA,
    input [7:0] i_SDA,
    output wire o_SCL,
    input [6:0] i_Slave_Add,
    input i_RW,/// this is to trigger if read or write read is low and write is high
    output reg [7:0] o_Add_RD,
    input [7:0] i_DATA,
    input i_ACK//// this  is supposed to be with the SDA but couldnt do it there but ACK=0 means yes and 1 means no DNF
);
//states for the fsmm
parameter [3:0] IDLE = 4'd0;
parameter [3:0] SCAN=4'd1;
parameter [3:0] DATA=4'd2;
parameter [3:0] READ=4'd3;
parameter [3:0] WRITE=4'd4;
parameter [3:0] WAIT=4'd5;


reg [7:0] RWMEM;//mem saved

reg [7:0] REDMEM ;//mem that is read from the slave this is the one to see
reg [3:0]state;

assign o_SCL=clk;

initial
begin

    state<=IDLE;////always set the state to IDLE initially or no FSM
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
                     
             ///after the ack signal then get the ack
             state=(i_ACK==0)?DATA:SCAN;                                            
        end
        DATA:
        begin
        RWMEM =(i_RW==0) ? i_SDA:i_DATA;///sending the data from the stored place RWMEM or if read then will save the data from the slave in RWMEM thats why RW READ/WRITE
        state =(i_RW==0) ? READ:WRITE;    
        end                  
        READ:
        begin
            REDMEM=RWMEM;///save the data from the slave (the RWMEM is changed to the slave memory data input)
            state=IDLE;        
        end                   
        WRITE:
        begin
            o_SDA=RWMEM;///if write then send the data to slave data from RWMEM is sent to slave
            state=IDLE;       
        end
        
        
        endcase        

end

endmodule