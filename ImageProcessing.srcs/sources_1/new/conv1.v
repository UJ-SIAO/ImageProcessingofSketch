`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/31 13:29:50
// Design Name: 
// Module Name: conv1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module conv1(
input        i_clk,
input [71:0] i_pixel_data,
input        i_pixel_data_valid,
output reg [7:0] o_convolved_data,
output reg   o_convolved_data_valid
    );
    
integer i; 
reg [8:0] i_pixel_data_light[8:0];
reg [7:0] kernel1 [8:0];
reg [7:0] kernel2 [8:0];
reg [7:0] multData1[8:0];
reg [7:0] multData2[8:0];
reg [7:0] sumDataInt1[8:0];
reg [7:0] sumDataInt2[8:0];
reg [7:0] compared_data[6:0];
wire [7:0] compared_data7;
reg [7:0] sumData1;
reg [7:0] sumData2;
reg multDataValid;
reg sumDataValid;
reg convolved_data_valid;
reg [7:0] convolved_data_int1;
reg [20:0] convolved_data_int2;
wire [21:0] convolved_data_int;
reg convolved_data_int_valid;

reg [7:0]testData;

initial
begin
    kernel1[0] =  0;
    kernel1[1] =  0;
    kernel1[2] =  0;
    kernel1[3] =  0;
    kernel1[4] =  1;
    kernel1[5] =  0;
    kernel1[6] =  0;
    kernel1[7] =  0;
    kernel1[8] =  0;
    
    kernel2[0] =  1;
    kernel2[1] =  1;
    kernel2[2] =  1;
    kernel2[3] =  1;
    kernel2[4] =  1;
    kernel2[5] =  1;
    kernel2[6] =  1;
    kernel2[7] =  1;
    kernel2[8] =  1;
end    
    
always @(*)
begin
	for(i=0;i<9;i=i+1)
	begin
		i_pixel_data_light[i] <= (($signed({1'b0,i_pixel_data[i*8+:8]}) * 15)/10 >= 255) ? 255 : ($signed({1'b0,i_pixel_data[i*8+:8]}) * 15)/10;
	end	
end	
	
	
always @(posedge i_clk)
begin
	for(i=0;i<9;i=i+1)
	begin
		/*multData1[i] <= ($signed({1'b0,i_pixel_data_light[i]}) < 10) ?  8'b0 : (($signed({1'b0,i_pixel_data_light[i]}) - 40) * 51 ) / 43;
		multData2[i] <= ($signed({1'b0,i_pixel_data_light[i]}) < 10) ?  8'b0 : (($signed({1'b0,i_pixel_data_light[i]}) - 40) * 51 ) / 43; */
		multData1[i] <= $signed(kernel1[i])*$signed({1'b0,i_pixel_data_light[i]});
		multData2[i] <= ($signed({1'b0,i_pixel_data_light[i]}) < 40) ?  8'b0 : (($signed({1'b0,i_pixel_data_light[i]}) - 40) * 51 ) / 43;
	end
	multDataValid <= i_pixel_data_valid;
end


always @(*)
begin
    for(i=0;i<9;i=i+1)
    begin
		sumDataInt1[i] = 0;
		sumDataInt2[i] = 0;
		sumDataInt1[4] = $signed(multData1[4]);
		sumDataInt2[i] = 255 - multData2[i];
    end
	//testData = multData1[0];
end

always @(posedge i_clk)
begin
	compared_data[0] <= (sumDataInt2[0] <= sumDataInt2[1]) ? sumDataInt2[0] : sumDataInt2[1];
	compared_data[1] <= (sumDataInt2[2] <= sumDataInt2[3]) ? sumDataInt2[2] : sumDataInt2[3];
	compared_data[2] <= (sumDataInt2[4] <= sumDataInt2[5]) ? sumDataInt2[4] : sumDataInt2[5];
	compared_data[3] <= (sumDataInt2[6] <= sumDataInt2[7]) ? sumDataInt2[6] : sumDataInt2[7];
	compared_data[4] <= sumDataInt2[8];

	for(i=0;i<9;i=i+1)
	begin
		sumData1 <= sumDataInt1[4];
	end
	//compared_data[0] = testData ;
	sumDataValid <= multDataValid;
end



always @(posedge i_clk)
begin
    compared_data[5] <= (compared_data[0] <= compared_data[1]) ? compared_data[0] : compared_data[1];
    compared_data[6] <= (compared_data[2] <= compared_data[3]) ? compared_data[2] : compared_data[3];
	
	
	//compared_data[5]<=compared_data[0];
    convolved_data_int1 <= $signed(sumData1);
    convolved_data_int_valid <= sumDataValid;
end

//assign convolved_data_int = convolved_data_int1;
assign compared_data7   = (compared_data[6] <= compared_data[4]) ? compared_data[6] : compared_data[4];
    
always @(posedge i_clk)
begin
	o_convolved_data <= (compared_data7 <= compared_data[5]) ? compared_data7 : compared_data[5];
	//o_convolved_data <= convolved_data_int1;
	//o_convolved_data <=compared_data[5];
    o_convolved_data_valid <= convolved_data_int_valid;
end
    
endmodule
