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
reg [15:0] i_pixel_data_light[8:0];
reg [7:0] kernel1 [8:0];

reg [7:0] multData1[8:0];
reg [7:0] multData2[8:0];
reg [10:0] multData1_s2;
reg [7:0] sumDataInt2[8:0];
reg [7:0] compared_data[6:0];
wire [7:0] compared_data7;
reg [7:0] multData1_s3;
reg [7:0] multData1_s4;
reg [7:0] sumData2;

reg multDataValid;
reg sumDataValid;
reg convolved_data_valid;
reg convolved_data_int_valid;

reg [7:0]testData;
reg [7:0]testData3;
reg [7:0]testData2[8:0];

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
end    
    
always @(*)
begin
	for(i=0;i<9;i=i+1)
	begin
		i_pixel_data_light[i] <= (((i_pixel_data[i*8+:8] * 155)/100)  >= 255) ? 255 : (i_pixel_data[i*8+:8] * 155)/100;
		//i_pixel_data_light[i] <= ((i_pixel_data[i*8+:8] * 2)  >= 255) ? 255 : (i_pixel_data[i*8+:8] * 2);
	end	
end	
	
	
always @(posedge i_clk)
begin
	for(i=0;i<9;i=i+1)
	begin
		multData1[i] <= $signed(kernel1[i]) * $signed({1'b0,i_pixel_data_light[i]});
		//multData2[i] <= ($signed({1'b0,i_pixel_data_light[i]}) < 20) ?  8'b0 : (($signed({1'b0,i_pixel_data_light[i]}) - 20) * 51 ) / 47;
		//multData2[i] <= ($signed({1'b0,i_pixel_data_light[i]}) < 40) ?  8'b0 : (($signed({1'b0,i_pixel_data_light[i]}) - 40) * 51 ) / 43;
		//multData2[i] <= (i_pixel_data_light[i] < 70) ?  8'd70 : ((i_pixel_data_light[i] - 70) * 40 ) / 37;
		multData2[i] <= (i_pixel_data_light[i] < 40) ?  8'd0 : 
						((((i_pixel_data_light[i] * 51 ) / 43) -47) > 240) ? 240 : (((i_pixel_data_light[i] * 51 ) / 43) -47);
		/*multData2[i] <= (i_pixel_data_light[i] < 70) ?  8'd50 : 
						((((i_pixel_data_light[i] - 70) * 51 ) / 37) > 200) ? 200 : (((i_pixel_data_light[i] - 70) * 51 ) / 37);*/
		//multData2[i] <= (i_pixel_data_light[i] < 20) ?  8'd0 : (((i_pixel_data_light[i] * 51 ) / 47) -22);
		
	end
	multDataValid <= i_pixel_data_valid;
end


always @(*)
begin
	multData1_s2 = 0;

	for(i=0;i<9;i=i+1)
	begin
		sumDataInt2[i] = 0;
		multData1_s2 = multData1_s2 + $signed(multData1[i]);

		sumDataInt2[i] = 255 - multData2[i];
	end
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
		testData2[i] <= $signed(kernel1[i]) * $signed({1'b0,multData2[i]});
	end
	
	multData1_s3<=multData1_s2;
	
	
	sumDataValid <= multDataValid;
end

always @(*)
begin
	testData3=0;
	for(i=0;i<9;i=i+1)
	begin
		testData3 = testData3 + $signed(testData2[i]);
	end
end

always @(posedge i_clk)
begin
    compared_data[5] <= (compared_data[0] <= compared_data[1]) ? compared_data[0] : compared_data[1];
    compared_data[6] <= (compared_data[2] <= compared_data[3]) ? compared_data[2] : compared_data[3];
	
	sumData2<=testData3;
	multData1_s4<=multData1_s3;
    convolved_data_int_valid <= sumDataValid;
end


assign compared_data7   = (compared_data[6] <= compared_data[4]) ? compared_data[6] : compared_data[4];

always @(posedge i_clk)
begin
	//o_convolved_data <= (compared_data7 <= compared_data[5]) ? compared_data7 : compared_data[5];
	
	//o_convolved_data<=sumData2;
	
	o_convolved_data <= (multData1_s4 == 255 ) ? 8'd240 : 
						(240 > ((compared_data7 << 8) / (255 - multData1_s4))) ?  ((compared_data7 << 8) / (255 - multData1_s4)) : 8'd240;
	
	
	o_convolved_data_valid <= convolved_data_int_valid;
end
    
endmodule
