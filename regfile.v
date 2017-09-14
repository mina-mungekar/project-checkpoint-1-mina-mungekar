module dffe(d, clk, clrn, prn, ena, q);   
	input d, clk, ena, clrn, prn;	
	wire clr;   
	wire pr;   
	output q;   
	reg q;     
	assign pr = ~prn; 
	assign clr = ~clrn;
	initial
		 begin       
	q = 1'b0;   
	end   
	always @(posedge clk or posedge clr) begin       
	if (q == 1'bx) begin           
	q = 1'b0;       
	end else if (clr) begin           
	q <= 1'b0;       
	end else if (ena) begin            
	q <= d;       
	end
	end
endmodule


module register(D,clock,ctrl_reset,ctrl_writeEnable, out_enable1, out_enable2, Q1, Q2);
	input [31:0] D;
	input clock, ctrl_reset,ctrl_writeEnable,out_enable1, out_enable2;
	
	output[31:0] Q1, Q2;
	wire [31:0] qout;
	wire clrn;
	
	not n1(clrn,ctrl_reset);
	//and a1(clockenable,clock,ctrl_writeEnable)

genvar i;
   generate for (i = 0; i<32; i=i+1) begin:bitlabels
          dffe newdffe(.d(D[i]), .clk(clock),
		.clrn(clrn), .prn(1'b1), .ena(ctrl_writeEnable),
		.q(qout[i]));
   end
   endgenerate
		
	assign Q1 = out_enable1 ? qout : 32'bz;
	assign Q2 = out_enable2 ? qout : 32'bz;
	
endmodule

module decoder32(out, select);
	input [4:0] select;
	output [31:0] out;
	wire not0,not1,not2,not3;
	not n0(not0,select[0]);
	not n1(not1,select[1]);
	not n2(not2,select[2]);
	not n3(not3,select[3]);
	not n4(not4,select[4]);
	and a0(out[0],not4,not3,not2,not1,not0);
	and a1(out[1],not4,not3,not2,not1,select[0]);
	and a2(out[2],not4,not3,not2,select[1],not0);
	and a3(out[3],not4,not3,not2,select[1],select[0]);
	and a4(out[4],not4,not3,select[2],not1,not0);
	and a5(out[5],not4,not3,select[2],not1,select[0]);
	and a6(out[6],not4,not3,select[2],select[1],not0);
	and a7(out[7],not4,not3,select[2],select[1],select[0]);
	and a8(out[8],not4,select[3],not2,not1,not0);
	and a9(out[9],not4,select[3],not2,not1,select[0]);
	and a10(out[10],not4,select[3],not2,select[1],not0);
	and a11(out[11],not4,select[3],not2,select[1],select[0]);
	and a12(out[12],not4,select[3],select[2],not1,not0);
	and a13(out[13],not4,select[3],select[2],not1,select[0]);
	and a14(out[14],not4,select[3],select[2],select[1],not0);
	and a15(out[15],not4,select[3],select[2],select[1],select[0]);
	and a16(out[16],select[4],not3,not2,not1,not0);
	and a17(out[17],select[4],not3,not2,not1,select[0]);
	and a18(out[18],select[4],not3,not2,select[1],not0);
	and a19(out[19],select[4],not3,not2,select[1],select[0]);
	and a20(out[20],select[4],not3,select[2],not1,not0);
	and a21(out[21],select[4],not3,select[2],not1,select[0]);
	and a22(out[22],select[4],not3,select[2],select[1],not0);
	and a23(out[23],select[4],not3,select[2],select[1],select[0]);
	and a24(out[24],select[4],select[3],not2,not1,not0);
	and a25(out[25],select[4],select[3],not2,not1,select[0]);
	and a26(out[26],select[4],select[3],not2,select[1],not0);
	and a27(out[27],select[4],select[3],not2,select[1],select[0]);
	and a28(out[28],select[4],select[3],select[2],not1,not0);
	and a29(out[29],select[4],select[3],select[2],not1,select[0]);
	and a30(out[30],select[4],select[3],select[2],select[1],not0);
	and a31(out[31],select[4],select[3],select[2],select[1],select[0]);

endmodule

module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB,writeRegEnable
);

   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg;

   output [31:0] data_readRegA, data_readRegB, writeRegEnable;

	wire [31:0] decoderoutput1, decoderoutput2,decoderoutput3, writeRegEnable;

	decoder32 rd1(decoderoutput1,ctrl_readRegA);
	decoder32 rd2(decoderoutput2,ctrl_readRegB);
	decoder32 wt1(decoderoutput3,ctrl_writeReg);
	
	genvar k;
   generate for (k = 0; k<32; k=k+1) begin:writeRegEnablelabels
         and a1(writeRegEnable[k],decoderoutput3[k],ctrl_writeEnable);
	end
   endgenerate
	
	
genvar j;
   generate for (j = 0; j<32; j=j+1) begin:reglabels
          register newReg(data_writeReg,clock,ctrl_reset,writeRegEnable[j],decoderoutput1[j],decoderoutput2[j],data_readRegA, data_readRegB);  
   end
   endgenerate

//	register myFile[31:0] (data_writeReg,clock,ctrl_reset,writeRegEnable,decoderoutput1,decoderoutput2,data_readRegA, data_readRegB);  


endmodule
