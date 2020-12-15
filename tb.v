module CtoVtb;
    reg signed [31:0] tb_neighbourChecks[4], tb_VarToCheckMessage;
    reg signed [31:0] tb_neighbourVars[4], tb_CheckToVarMessage;
    reg signed [31:0] tb_channelEvidence[10];
    reg clk = 0;
    reg signed [31:0] tb_channelBelief[10];
    reg tb_corrected_seq[10];


    // VarToCheck VarToCheck12(.neighbourChecks(tb_neighbourChecks),
    //                         .VarToCheckMessage(tb_VarToCheckMessage));
    // CheckToVar CheckToVar21(.neighbourVars(tb_neighbourVars),
    //                         .CheckToVarMessage(tb_CheckToVarMessage));
    decoder decoder1(.channelEvidence(tb_channelEvidence),
                    .clk(clk),
                    .channelBelief(tb_channelBelief),
                    .corrected_seq(tb_corrected_seq));



    initial begin
        // tb_neighbourChecks[0] <= 2.1;
        // tb_neighbourChecks[1] <= 2.5;
        // tb_neighbourChecks[2] <= 2.7;
        // tb_neighbourChecks[3] <= 2;

        // tb_neighbourVars[0] <= -3;
        // tb_neighbourVars[1] <= 100;
        // tb_neighbourVars[2] <= 55;
        // tb_neighbourVars[3] <= 100;

        tb_channelEvidence[0] = -13;
        tb_channelEvidence[1] = 13;
        tb_channelEvidence[2] = 13;
        tb_channelEvidence[3] = 13;
        tb_channelEvidence[4] = -13;
        tb_channelEvidence[5] = 13;
        tb_channelEvidence[6] = 13;
        tb_channelEvidence[7] = -13;
        tb_channelEvidence[8] = 13;
        tb_channelEvidence[9] = -13;

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