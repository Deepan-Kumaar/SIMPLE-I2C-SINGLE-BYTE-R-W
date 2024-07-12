module I2C_SLAVE_MOD (
    input s_SCL,
    input [7:0]si_SDA,
    output reg [7:0]so_SDA,
    output reg s_ACK        
    );

//states for the fsm
parameter [6:0] ADDRESS=7'b1010101;
parameter  IDL = 0;
parameter  CHEC=1;
parameter [2:0] ACKNOWLEDG=3'b10;
parameter [2:0] READ=3'b011;
parameter [2:0] WRITE=3'b101;
parameter [2:0] DAT=3'b111;
reg [6:0]inreg;
reg [2:0]a;
reg rw;
reg [7:0] WMEM;///write mem data that will be saved in this will be from the master
reg [7:0] mem=8'b11000011;///mem to be sent//READ
//reg S_ACK;
initial
begin
s_ACK=1;
a=IDL;
end

always @(posedge s_SCL) 
begin     
    case(a)
    IDL:
    begin
        assign inreg=si_SDA[7:1];   
        s_ACK=1;     
        a=CHEC;        
    end
    CHEC:
    begin
        assign a=(inreg==ADDRESS) ? ACKNOWLEDG:IDL;////CHECKING IF THE ADDRESS IS ITS
    end
    ACKNOWLEDG:
    begin
        s_ACK=0;                
        //so_SDA=S_ACK;             
        /*rw=si_SDA[0];
        assign a=DAT;
        
    end
    DAT:
    begin*/
        assign a=(si_SDA[0]==0)?READ:WRITE; 
        
    end   
    READ:
    begin    
      so_SDA=mem; ///SEND
      s_ACK=0;
      assign a=IDL;
                
    end
    WRITE:
    begin
        WMEM=si_SDA;///SAVE
        s_ACK=0;
        a=IDL;    
    end
    
    endcase
end

    
endmodule
