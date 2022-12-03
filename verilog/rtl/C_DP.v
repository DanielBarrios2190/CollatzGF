`timescale 1ns / 1ps

module C_DP(
    input clk, //Señal de reloj
    input [15:0] co, //Número de entrada    
    input st, //Start
    output [15:0] x, //Órbita
    output reg [19:0] k, //Valor actual de la sucesión
    input Mx, Rx, Ik, Pk, Sk //Salidas de la máquina de estados
    );
    
    reg [15:0] i; //Conteo de órbita
    wire [15:0] nexti; //Siguiente valor de conteo
    wire [19:0] nextk; //Siguiente valor de la sucesión
    
    //____Registro i___//
    
    always@(posedge clk) begin
        i <= nexti; 
    end
    
    //nexti = 0 al inicializar
    //nexti = i+1 al ejecutar la sucesión
    //nexti = i al mantener el número
    assign nexti = Rx ? 0:( Mx ? i+1:i ); 
    
    //x = i al mantener
    //x = 0 en cualquier otro caso
    assign x = (~Mx&&~Rx)==1 ? i:0; //Se iguala el conteo a la órbita
    
    //____Registro k___//
    
    //Variables intermedias
    wire [19:0] K2;
    wire [19:0] K3;
    always@(posedge clk) begin
        k <= nextk;
    end
    assign nextk = Sk ? co:K2; //Co al inicializar
    assign K2 = Pk ? (k>>1):K3; //Se hace k/2 al ser par
    assign K3 = Ik ? (3*k+1):k; //Se hace 3k+1 al ser impar
    
endmodule
