`timescale 1ns / 1ps
//Primera Entrega Digitales II
//Conjetura de Collatz
//Grupo: Los Cracks
//Codigos: 2190407 2190418 2190427
module collatz(
    input [15:0] co, //N�mero de entrada
    input st, //Start
    input clk, //Se�al de Reloj
    output [15:0] x, //�rbita 
    output bs //Se�al Busy/Ocupado
    );
    wire Mx, Rx, Ik, Pk, Sk; //Salidas de la m�quina de estados
    wire [19:0]k; //Valor actual de la sucesi�n
    
    C_DP Datapath ( //Conexi�n con el datapath
        .clk(clk),
        .co(co),
        .st(st),
        .x(x),
        .k(k),
        
        .Mx(Mx),
        .Rx(Rx),
        .Ik(Ik),
        .Pk(Pk),
        .Sk(Sk)

    );
    
    C_FSMR FSM ( //Finite state machine
        .clk(clk),
        .co(co),
        .st(st),
        .k(k),
        
        .Mx(Mx),
        .Rx(Rx),
        .Ik(Ik),
        .Pk(Pk),
        .Sk(Sk),
        .bs(bs)
    );
    
endmodule
