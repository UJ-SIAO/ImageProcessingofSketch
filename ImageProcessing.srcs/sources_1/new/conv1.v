`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/07 20:21:24
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

reg [7:0] kernel1 [8:0];

reg [15:0]stage1_data[8:0];
reg [7:0] i_pixel_data_light_s1[8:0];
reg [7:0] curved_data[8:0];
reg [7:0] i_pixel_data_light_s2[8:0];
reg [7:0] multData1[8:0];
reg [7:0] multData2[8:0];
reg [7:0] multData1_s2;
reg [7:0] sumDataInt2[8:0];
reg [7:0] compared_data[8:0];
reg [7:0] lonely_data[7:0];
reg [7:0] reserved_data[7:0];
reg [7:0] multData1_s3;
reg [7:0] multData1_s4;
reg [7:0] multData1_s5;

reg stage1_Vaild;
reg lightDataValid;
reg curved_Vaild;
reg multDataValid;
reg sumDataValid;
reg convolved_data_valid;
reg convolved_data_int_valid;
reg compared_data_valid;
reg dodged_data_valid;

/*reg [7:0] sumData2;
reg [7:0]testData;
reg [7:0]testData3;
reg [7:0]testData2[8:0];*/

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

always @(posedge i_clk)
begin
	for(i=0;i<9;i=i+1)
	begin
		stage1_data[i]  <= ((i_pixel_data[i*8+:8] * 16)/10);
	end
	stage1_Vaild    <= i_pixel_data_valid;
end





always @(posedge i_clk)
begin
	for(i=0;i<9;i=i+1)
	begin
		i_pixel_data_light_s1[i] <= (stage1_data[i] >= 255) ? 255 : stage1_data[i];
	end	
	lightDataValid <= stage1_Vaild;
end

always @(posedge i_clk)
begin	
	for(i=0;i<9;i=i+1)
	begin
		curved_data[i]  <= ((i_pixel_data_light_s1[i] - 40) * 46 ) / 43;
		i_pixel_data_light_s2[i] <= i_pixel_data_light_s1[i];
	end
	curved_Vaild    <= lightDataValid;		
end

always @(posedge i_clk)
begin
	for(i=0;i<9;i=i+1)
	begin
		//multData2[i] <= (i_pixel_data_light[i] < 40) ?  8'b0  : ((i_pixel_data_light[i] - 40) * 42 ) / 43;	//(40,0)->(255,210)
		multData2[i] <= i_pixel_data_light_s1[i];//(i_pixel_data_light_s2[i] > 40) ?  curved_data[i]  : 8'b0;		//(40,0)->(255,230)
		//multData2[i] <= (i_pixel_data_light[i] < 40) ?  8'd40 : ((i_pixel_data_light[i] - 40) * 34 ) / 43;	//(40,40)->(255,210)
		//multData2[i] <= (i_pixel_data_light[i] < 40) ?  8'b0  : ((i_pixel_data_light[i] - 40) * 51 ) / 43;	//(40,0)->(255,255)
		//multData2[i] <= (i_pixel_data_light[i] < 40) ?  8'd40 : ((i_pixel_data_light[i] - 40) * 51 ) / 43;	//(40,40)->(255,255)
		//multData2[i] <= (i_pixel_data_light[i] < 70) ?  8'd0 : ((i_pixel_data_light[i] - 70) * 42 ) / 37;		//(70,0)->(255,210)
		//multData2[i] <= (i_pixel_data_light[i] < 70) ?  8'd0 : ((i_pixel_data_light[i] - 70) * 46 ) / 37;		//(70,0)->(255,230)
		
		//for test
		//multData2[i] <= i_pixel_data_light[i];
		
	end
	multDataValid <= curved_Vaild;
end


always @(*)
begin
	for(i=0;i<9;i=i+1)
	begin
		sumDataInt2[i] = 0;
		sumDataInt2[i] = multData2[i];
		//for test
		//sumDataInt2[i] = multData2[i];
	end
end

always @(posedge i_clk)
begin
	compared_data[0] <= (sumDataInt2[0] <= sumDataInt2[1]) ? sumDataInt2[0] : sumDataInt2[1];
	compared_data[1] <= (sumDataInt2[2] <= sumDataInt2[3]) ? sumDataInt2[2] : sumDataInt2[3];
	compared_data[2] <= (sumDataInt2[4] <= sumDataInt2[5]) ? sumDataInt2[4] : sumDataInt2[5];
	compared_data[3] <= (sumDataInt2[6] <= sumDataInt2[7]) ? sumDataInt2[6] : sumDataInt2[7];
	lonely_data[0]   <= sumDataInt2[8];
	/*for(i=0;i<9;i=i+1)
	begin
		//testData2[i] <= $signed(kernel1[i]) * $signed({1'b0,multData2[i]});
		//multData1[i] <= $signed(kernel1[i]) * $signed({1'b0,multData2[i]});
		//for test
		//multData1[i] <= $signed(kernel1[i]) * $signed({1'b0,sumDataInt2[i]});
	end*/
	multData1[4] <= sumDataInt2[4];
	sumDataValid <= multDataValid;
end

/*always @(posedge i_clk) //4.5.6.7 reserved
begin
	compared_data[0] <= (sumDataInt2[0] <= sumDataInt2[1]) ? sumDataInt2[0] : sumDataInt2[1];
	compared_data[1] <= (sumDataInt2[2] <= sumDataInt2[3]) ? sumDataInt2[2] : sumDataInt2[3];
	
	reserved_data[4] <= sumDataInt2[4];
	reserved_data[5] <= sumDataInt2[5];
	reserved_data[6] <= sumDataInt2[6];
	reserved_data[7] <= sumDataInt2[7];
	
	compared_data[4] <= sumDataInt2[8];
	for(i=0;i<9;i=i+1)
	begin
		//testData2[i] <= $signed(kernel1[i]) * $signed({1'b0,multData2[i]});
		//multData1[i] <= $signed(kernel1[i]) * $signed({1'b0,multData2[i]});
		//for test
		multData1[i] <= $signed(kernel1[i]) * $signed({1'b0,sumDataInt2[i]});
	end
	sumDataValid <= multDataValid;
end*/

/*always @(posedge i_clk) //0.1.2.3 reserved
begin
	reserved_data[0] <= compared_data[0];
	reserved_data[1] <= compared_data[1];
	compared_data[2] <= (reserved_data[4] <= reserved_data[5]) ? reserved_data[4] : reserved_data[5];
	compared_data[3] <= (reserved_data[6] <= reserved_data[7]) ? reserved_data[6] : reserved_data[7];
	reserved_data[2] <= compared_data[4];
	for(i=0;i<9;i=i+1)
	begin
		//testData2[i] <= $signed(kernel1[i]) * $signed({1'b0,multData2[i]});
		//multData1[i] <= $signed(kernel1[i]) * $signed({1'b0,multData2[i]});
		//for test
		multData1[i] <= $signed(kernel1[i]) * $signed({1'b0,sumDataInt2[i]});
	end
	sumDataValid <= multDataValid;
end*/

/*always @(*)
begin
	//testData3=0;
	multData1_s2 = 0;
	for(i=0;i<9;i=i+1)
	begin
		multData1_s2 = multData1_s2 + multData1[i];
		//testData3 = testData3 + $signed(testData2[i]);
	end
end*/

always @(posedge i_clk)
begin
	compared_data[5] <= (compared_data[0] <= compared_data[1]) ? compared_data[0] : compared_data[1];
	compared_data[6] <= (compared_data[2] <= compared_data[3]) ? compared_data[2] : compared_data[3];
	lonely_data[1]   <= lonely_data[0];
	//sumData2<=testData3;
	multData1_s3<=multData1[4];
    convolved_data_int_valid <= sumDataValid;
	//for test
	//reserved_data[3] <= reserved_data[2];
end

always @(posedge i_clk)
begin
	compared_data[7] <= (compared_data[6] <= compared_data[5]) ? compared_data[6] : compared_data[5];
	lonely_data[2]   <=  lonely_data[1];
	multData1_s4 <= multData1_s3;
	compared_data_valid <= convolved_data_int_valid;
end

always @(posedge i_clk)
begin
	compared_data[8] <= (lonely_data[2] <= compared_data[7]) ? lonely_data[2] : compared_data[7];
	multData1_s5 <= multData1_s4;
	dodged_data_valid <= compared_data_valid;
end

always @(posedge i_clk)
begin
	/*o_convolved_data <= (multData1_s5 >= 200 ) ? 8'd255 : 
						(255 < (picture1 / picture2)) ?  8'd255 : (picture1 / picture2);*/
	/*o_convolved_data <= (multData1_s5 == 255 ) ? 8'd255 : 
						(255 < ((compared_data[7] * 255) / (255 - multData1_s5))) ?  8'd255 : ((compared_data[7] * 255) / (255 - multData1_s5));*/
	o_convolved_data<=multData1_s5;
	o_convolved_data_valid <= dodged_data_valid;
end
    
endmodule
