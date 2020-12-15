// Modified version of the original blink.v from:
// https://github.com/f-of-e/f-of-e-tools/tree/master/verilog/hardware/blink
`include "LDPC.v"
`define	kFofE_HFOSC_CLOCK_DIVIDER_FOR_1Hz	24000000

module blink(led);
	output		led;
	wire		clk;
	reg		LEDstatus = 1;
	reg [31:0]	count = 0;

	/*
	 *	Creates a 48MHz clock signal from
	 *	internal oscillator of the iCE40
	 */
	SB_HFOSC OSCInst0 (
		.CLKHFPU(1'b1),
		.CLKHFEN(1'b1),
		.CLKHF(clk)
	);

    reg signed [31:0] channelEvidence[10];
    reg signed [31:0] channelBelief[10];
    reg corrected_seq[10];

    decoder decoder1(.channelEvidence(channelEvidence),
                    .clk(clk),
                    .channelBelief(channelBelief),
                    .corrected_seq(corrected_seq));

    initial begin
        channelEvidence[0] = -13;
        channelEvidence[1] = 13;
        channelEvidence[2] = 13;
        channelEvidence[3] = 13;
        channelEvidence[4] = -13;
        channelEvidence[5] = 13;
        channelEvidence[6] = 13;
        channelEvidence[7] = -13;
        channelEvidence[8] = 13;
        channelEvidence[9] = -13;
    end

	/*
	 *	Blinks LED if corrected zeroth-bit is 1. The constant kFofE_CLOCK_DIVIDER_FOR_1Hz
	 *	(defined above) is calibrated to yield a blink rate of about 1Hz.
	 */
	always @(posedge clk) begin
		if (count > `kFofE_HFOSC_CLOCK_DIVIDER_FOR_1Hz) begin
			LEDstatus <= corrected_seq[0];
			count <= 0;
		end
		else begin
			count <= count + 1;
		end
	end

	/*
	 *	Assign output led to value in LEDstatus register
	 */
	assign	led = LEDstatus;
endmodule