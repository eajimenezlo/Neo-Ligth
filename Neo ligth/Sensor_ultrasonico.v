module Sensor_ultrasonico(clk,trigger,eco, interferencia);

input clk;
output reg trigger;
output reg interferencia;
input eco;

reg [1:0] status=2'b0;
reg [7:0] counter;
reg clkus;
reg trig;
reg sen;
reg env;
reg reset;
reg [3:0]tem;
reg [15:0]eco_tem;

parameter TRIGGER=2'b00, ESPERANDO=2'b01, SENSANDO=2'b10, ENVIANDO=2'b11;






always@(posedge clk)begin //reloj en us
	if(counter<50)begin
		counter=counter+1;
		if(counter<25) clkus=1;
		else clkus=0;
	end
	else begin 
		counter=0;
	end
end

always@(posedge clkus)begin //maquina de estados
	case(status)
		TRIGGER: begin 
			trig=1'b1;
			sen=1'b0;
			env=1'b0;
			reset=1'b1;
			if(tem==10) status=ESPERANDO;
		end
		ESPERANDO:begin
			reset=1'b0;
			trig=1'b0;
			sen=1'b0;
			env=1'b0;
			if(eco) status=SENSANDO;
		end
		SENSANDO:begin
			reset=1'b0;
			trig=1'b0;
			sen=1'b1;
			env=1'b0;
			if(!eco) status=ENVIANDO;
		end
		ENVIANDO:begin
			reset=1'b0;
			trig=1'b0;
			sen=1'b0;
			env=1'b1;
			status=TRIGGER;
		end
			
	endcase
end

always@(posedge clkus)begin //estado TRIGGER 
	
	if(trig)begin
		trigger=1'b1;
		tem=tem+1;
	end
	else begin 
		tem=0;
		trigger=1'b0;
	end	
end

always@(posedge clkus)begin// estado SENSANDO
	if(reset)begin
		eco_tem=0;
	end
	if(sen)begin
		eco_tem=eco_tem+1;
		
	end
	
end

always@(posedge clkus)begin //estado ENVIANDO
	
	if(env)begin
		if(eco_tem<2500 && eco_tem>0)begin
			interferencia=1'b1;
		
		end
		else interferencia=1'b0;
	end
	
	
end
endmodule 