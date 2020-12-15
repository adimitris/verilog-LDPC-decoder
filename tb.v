module tb;
    reg signed [31:0] tb_neighbourChecks[4], tb_VarToCheckMessage;
    reg signed [31:0] tb_neighbourVars[4], tb_CheckToVarMessage;
    reg signed [31:0] tb_channelEvidence[10];
    reg clk = 0;
    reg signed [31:0] tb_channelBelief[10];
    reg tb_corrected_seq[10];
    reg signed [31:0] tb_belief;
    reg tb_corrected_bit;

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
    Decoder decoder1(.channelEvidence(tb_channelEvidence),
                    .clk(clk),
                    .channelBelief(tb_channelBelief),
                    .corrected_seq(tb_corrected_seq));



    initial begin
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

        // Check values for decoder
        tb_channelEvidence[0] = -13; // 1
        tb_channelEvidence[1] = 13;  // 0
        tb_channelEvidence[2] = 13; // 0
        tb_channelEvidence[3] = 13; // 0
        tb_channelEvidence[4] = -13; // 1
        tb_channelEvidence[5] = 13; // 0
        tb_channelEvidence[6] = 13; // 0
        tb_channelEvidence[7] = -13; // 1
        tb_channelEvidence[8] = 13; // 0
        tb_channelEvidence[9] = -13; // 1

        // 28 clock switches
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
        $dumpvars(0,decoder1);
    end
endmodule