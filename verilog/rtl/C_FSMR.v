`timescale 1ns / 1ps

module C_FSMR(
    input clk, //Señal de Reloj
    input st, //Start
    input [15:0] co, //Número de entrada
    input [19:0] k, //Valor actual de la sucesión
    output reg Mx, Rx, Ik, Pk, Sk, //Salidas de la máquina de estados
    output reg bs //Señal Busy/Ocupado
    );
    
    parameter H = 2'b00; //Hold
    parameter I = 2'b01; //In
    parameter O = 2'b10; //Odd (Impar)
    parameter E = 2'b11; //Even (Par)
    
    reg [1:0] CS = H;     //Current State 
    reg [1:0] NS;         //Next State
    wire [19:0] ShiftK = k>>1; //Siguiente valor cuando k es par
       
    always@(posedge clk)
        CS<= NS;
        
    always@(CS,st,k,Pk,co)
        case(CS)
            H:
                if(st) //Con start inicia
                    NS<=I;
                else //Si no, se mantiene
                    NS<=H; 
            I:
                if(co==1) //Si co = 1 el proceso termina inmediatamente
                    NS<=H;
                else if(co[0]==1) //Si co es impar 
                    NS<=O;
                else //Si no, es par
                    NS<=E;
            O:
                //Como k es impar, 3k+1 es par
                    NS<=E;
            E:
                if(k==2) //Si k es 2, en la siguiente iteración termina
                    NS<=H;
                else if(ShiftK[0]==1) //Si el siguiente k es impar
                    NS<=O;
                else //Si no, es par
                    NS<=E;
        endcase
        
    //Asignaciones de la máquina de estados
    always@(CS,NS) begin
        case(CS)
            H: begin
                   Mx <= 0;
                   Rx <= 0;
                   Ik <= 0;
                   Pk <= 0;
                   Sk <= 0;
                   bs <= 0;
               end
            I:
               begin
                   Mx <= 0;
                   Rx <= 1;
                   Ik <= 1;
                   Pk <= 1;
                   Sk <= 1;
                   bs <= 1;
               end
            E:
               begin
                   Mx <= 1;
                   Rx <= 0;
                   Ik <= 0;
                   Pk <= 1;
                   Sk <= 0;
                   bs <= 1;
               end
            O:
               begin
                   Mx <= 1;
                   Rx <= 0;
                   Pk <= 0;
                   Sk <= 0;
                   Ik <= 1;
                   bs <= 1;
               end
        endcase           
    end                   
                          
endmodule                 
                          
