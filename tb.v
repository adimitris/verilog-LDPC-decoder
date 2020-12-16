module tb;
    reg signed [31:0] tb_neighbourChecks[4], tb_VarToCheckMessage;
    reg signed [31:0] tb_neighbourVars[4], tb_CheckToVarMessage;
    reg signed [31:0] tb_channelEvidence[10];
    reg signed [31:0] tb_channelBelief[10];
    reg signed [31:0] tb_belief;
    reg [31:0] tb_bitErrorLogProb;
    reg clk = 0;
    reg tb_corrected_bit;
    reg tb_corrected_seq[10];
    reg tb_receivedPacket[10];

    // Testing for channel evidence
    ChEvidence ChEvidence1(.receivedPacket(tb_receivedPacket),
                           .bitErrorLogProb(tb_bitErrorLogProb),
                           .channelEvidence(tb_channelEvidence));

    // Testing for variable-to-check module
    VarToCheck VarToCheck12(.neighbourChecks(tb_neighbourChecks),
                            .VarToCheckMessage(tb_VarToCheckMessage));
    
    // Testing for check-to-variable module
    CheckToVar CheckToVar21(.neighbourVars(tb_neighbourVars),
                            .CheckToVarMessage(tb_CheckToVarMessage));
    
    // Testing for belief module
    Belief belief1(.neighbourChecks(tb_neighbourChecks),
                    .belief(tb_belief),
                    .corrected_bit(tb_corrected_bit));

    // Testing for decoder
    Decoder decoder1(.receivedPacket(tb_receivedPacket),
                    .bitErrorLogProb(tb_bitErrorLogProb),
                    .clk(clk),
                    .channelBelief(tb_channelBelief),
                    .corrected_seq(tb_corrected_seq));



    initial begin
        // Check values for decoder
        tb_bitErrorLogProb = 13;
        tb_receivedPacket[0] = 1;
        tb_receivedPacket[1] = 1;
        tb_receivedPacket[2] = 0;
        tb_receivedPacket[3] = 0;
        tb_receivedPacket[4] = 1;
        tb_receivedPacket[5] = 0;
        tb_receivedPacket[6] = 0;
        tb_receivedPacket[7] = 1;
        tb_receivedPacket[8] = 0;
        tb_receivedPacket[9] = 1;

        // Test values for VarToCheck and Belief
        tb_neighbourChecks[0] <= 2.1;
        tb_neighbourChecks[1] <= 2.5;
        tb_neighbourChecks[2] <= 2.7;
        tb_neighbourChecks[3] <= 2;

        // Test values for CheckToVar
        tb_neighbourVars[0] <= -3;
        tb_neighbourVars[1] <= 100;
        tb_neighbourVars[2] <= 55;
        tb_neighbourVars[3] <= 100;

        // 28 clock switches for decoder testing
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
    end

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars;
    end
endmodule