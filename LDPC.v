`define	kFofE_HFOSC_CLOCK_DIVIDER_FOR_1Hz	24000000

// Implements the variable-to-check message
module VarToCheck(
  input wire signed [31:0] neighbourChecks[4],
  output reg signed [31:0] VarToCheckMessage
  );
  integer i;

  always @* // combinational logic independent of clock
  begin
    VarToCheckMessage = 0;
    for(i = 0; i < 4; i=i+1)
      VarToCheckMessage = VarToCheckMessage + neighbourChecks[i];
  end
endmodule

// Implements the check-to-variable message
module CheckToVar(
  input wire signed [31:0] neighbourVars[4],
  output reg signed [31:0] CheckToVarMessage
  );

  integer j;
  reg sign;

  always @*
  begin
    sign = 0;

    if (neighbourVars[0]>0)
      CheckToVarMessage = neighbourVars[0];
    else
      CheckToVarMessage = -neighbourVars[0];

    for(j = 0; j < 4; j=j+1) begin
      sign = sign + neighbourVars[j][31];

      if (neighbourVars[j]<CheckToVarMessage && neighbourVars[j]>0)
        CheckToVarMessage = neighbourVars[j];
      if (-neighbourVars[j]<CheckToVarMessage && neighbourVars[j]<0)
        CheckToVarMessage = -neighbourVars[j];
    end

    if (sign==1)
      CheckToVarMessage = -CheckToVarMessage;

  end
endmodule

// Calculates the belief of a variable
module Belief(
  input wire signed [31:0] neighbourChecks[4],
  output reg signed [31:0] belief,
  output reg corrected_bit
  );
  integer i;

  always @* // combinational logic, independent of clock
  begin
    belief = 0;
    for(i = 0; i < 4; i=i+1)
      belief = belief + neighbourChecks[i];

    if (belief>0)
      corrected_bit = 0;
    else
      corrected_bit = 1;
  end
endmodule

// Decoder of 10-bit codeword with 5 low-density parity-check equations
module Decoder(
  input wire signed [31:0] channelEvidence[10],
  input wire clk,
  output reg signed [31:0] channelBelief[10],
  output reg corrected_seq[10]
);
  reg signed [31:0] oldVtoCm[25]; // previous variable-to-check messages
  reg signed [31:0] oldCtoVm[25]; // previous check-to-variable messages
  reg signed [31:0] newVtoCm[25]; // current variable-to-check messages
  reg signed [31:0] newCtoVm[25]; // current check-to-variable messages

  // Combinational Logic
  
  // v0-c0: message array index 0
  //c0->v0
  wire signed [31:0] c0tov0m [4];
  assign c0tov0m[0] = oldVtoCm[4];
  assign c0tov0m[1] = oldVtoCm[8];
  assign c0tov0m[2] = oldVtoCm[10];
  assign c0tov0m[3] = oldVtoCm[16];

  CheckToVar c0tov0 (.neighbourVars(c0tov0m), .CheckToVarMessage(newCtoVm[0]));

  //v0->c0
  wire signed [31:0] v0toc0m [4];
  assign v0toc0m[0] = channelEvidence[0];
  assign v0toc0m[1] = oldCtoVm[1];
  assign v0toc0m[2] = 0;
  assign v0toc0m[3] = 0;

  VarToCheck v0toc0 (.neighbourChecks(v0toc0m), .VarToCheckMessage(newVtoCm[0]));

// v0-c3: message array index 1
  //c3->v0
  wire signed [31:0] c3tov0m [4];
  assign c3tov0m[0] = oldVtoCm[7];
  assign c3tov0m[1] = oldVtoCm[17];
  assign c3tov0m[2] = oldVtoCm[20];
  assign c3tov0m[3] = oldVtoCm[24];

  CheckToVar c3tov0 (.neighbourVars(c3tov0m), .CheckToVarMessage(newCtoVm[1]));

  //v0->c3
  wire signed [31:0] v0toc3m [4];
  assign v0toc3m[0] = channelEvidence[0];
  assign v0toc3m[1] = oldCtoVm[0];
  assign v0toc3m[2] = 0;
  assign v0toc3m[3] = 0;

  VarToCheck v0toc3 (.neighbourChecks(v0toc3m), .VarToCheckMessage(newVtoCm[1]));

  // v1-c1: message array index 2
  //c1->v1
  // messages going into c1 but not coming from v1
  wire signed [31:0] c1tov1m [4];
  assign c1tov1m[0] = oldVtoCm[6];
  assign c1tov1m[1] = oldVtoCm[13];
  assign c1tov1m[2] = oldVtoCm[19];
  assign c1tov1m[3] = oldVtoCm[22];

  CheckToVar c1tov1 (.neighbourVars(c1tov1m), .CheckToVarMessage(newCtoVm[2]));

  //v1->c1
  // channel evidence + messages going into v1 but not coming from c1
  wire signed [31:0] v1toc1m [4];
  assign v1toc1m[0] = channelEvidence[1];
  assign v1toc1m[1] = oldCtoVm[3];
  assign v1toc1m[2] = 0;
  assign v1toc1m[3] = 0;

  VarToCheck v1toc1 (.neighbourChecks(v1toc1m), .VarToCheckMessage(newVtoCm[2]));

  // v1-c4: message array index 3
  //c4->v1
  // messages going into c4 but not coming from v1
  wire signed [31:0] c4tov1m [4];
  assign c4tov1m[0] = oldVtoCm[12];
  assign c4tov1m[1] = oldVtoCm[15];
  assign c4tov1m[2] = oldVtoCm[18];
  assign c4tov1m[3] = oldVtoCm[21];

  CheckToVar c4tov1 (.neighbourVars(c4tov1m), .CheckToVarMessage(newCtoVm[3]));

  //v1->c4
  // channel evidence + messages going into v1 but not coming from c4
  wire signed [31:0] v1toc4m [4];
  assign v1toc4m[0] = channelEvidence[1];
  assign v1toc4m[1] = oldCtoVm[2];
  assign v1toc4m[2] = 0;
  assign v1toc4m[3] = 0;

  VarToCheck v1toc4 (.neighbourChecks(v1toc4m), .VarToCheckMessage(newVtoCm[3]));

  // v2-c0: message array index 4
  //c0->v2
  // messages going into c0 but not coming from v2
  wire signed [31:0] c0tov2m [4];
  assign c0tov2m[0] = oldVtoCm[0];
  assign c0tov2m[1] = oldVtoCm[8];
  assign c0tov2m[2] = oldVtoCm[10];
  assign c0tov2m[3] = oldVtoCm[16];

  CheckToVar c0tov2 (.neighbourVars(c0tov2m), .CheckToVarMessage(newCtoVm[4]));

  //v2->c0
  // channel evidence + messages going into v2 but not coming from c0
  wire signed [31:0] v2toc0m [4];
  assign v2toc0m[0] = channelEvidence[2];
  assign v2toc0m[1] = oldCtoVm[5];
  assign v2toc0m[2] = 0;
  assign v2toc0m[3] = 0;

  VarToCheck v2toc0 (.neighbourChecks(v2toc0m), .VarToCheckMessage(newVtoCm[4]));

  // v2-c2: message array index 5
  // c2 -> v2
  // messages going into c2 but not coming from v2
  wire signed[31:0] c2tov2m[4];
  assign c2tov2m[0]=oldVtoCm[9];
  assign c2tov2m[1]=oldVtoCm[11];
  assign c2tov2m[2]=oldVtoCm[14];
  assign c2tov2m[3]=oldVtoCm[23];

  CheckToVar c2tov2(.neighbourVars(c2tov2m), .CheckToVarMessage(newCtoVm[5]));

  // v2 -> c2
  // channel evidence + messages going into v2 but not coming from c2
  wire signed[31:0] v2toc2m[4];
  assign v2toc2m[0]=channelEvidence[2];
  assign v2toc2m[1]=oldCtoVm[4];
  assign v2toc2m[2]=0;
  assign v2toc2m[3]=0;

  VarToCheck v2toc2(.neighbourChecks(v2toc2m), .VarToCheckMessage(newVtoCm[5]));

  // v3-c1: message array index 6
  // c1 -> v3
  // messages going into c1 but not coming from v3
  wire signed[31:0] c1tov3m[4];
  assign c1tov3m[0]=oldVtoCm[2];
  assign c1tov3m[1]=oldVtoCm[13];
  assign c1tov3m[2]=oldVtoCm[19];
  assign c1tov3m[3]=oldVtoCm[22];

  CheckToVar c1tov3(.neighbourVars(c1tov3m), .CheckToVarMessage(newCtoVm[6]));

  // v3 -> c1
  // channel evidence + messages going into v3 but not coming from c1
  wire signed[31:0] v3toc1m[4];
  assign v3toc1m[0]=channelEvidence[3];
  assign v3toc1m[1]=oldCtoVm[7];
  assign v3toc1m[2]=0;
  assign v3toc1m[3]=0;

  VarToCheck v3toc1(.neighbourChecks(v3toc1m), .VarToCheckMessage(newVtoCm[6]));

  // v3-c3: message array index 7
  // c3 -> v3
  // messages going into c3 but not coming from v3
  wire signed[31:0] c3tov3m[4];
  assign c3tov3m[0]=oldVtoCm[1];
  assign c3tov3m[1]=oldVtoCm[17];
  assign c3tov3m[2]=oldVtoCm[20];
  assign c3tov3m[3]=oldVtoCm[24];

  CheckToVar c3tov3(.neighbourVars(c3tov3m), .CheckToVarMessage(newCtoVm[7]));

  // v3 -> c3
  // channel evidence + messages going into v3 but not coming from c3
  wire signed[31:0] v3toc3m[4];
  assign v3toc3m[0]=channelEvidence[3];
  assign v3toc3m[1]=oldCtoVm[6];
  assign v3toc3m[2]=0;
  assign v3toc3m[3]=0;

  VarToCheck v3toc3(.neighbourChecks(v3toc3m), .VarToCheckMessage(newVtoCm[7]));

  // v4-c0: message array index 8
  // c0 -> v4
  // messages going into c0 but not coming from v4
  wire signed[31:0] c0tov4m[4];
  assign c0tov4m[0]=oldVtoCm[0];
  assign c0tov4m[1]=oldVtoCm[4];
  assign c0tov4m[2]=oldVtoCm[10];
  assign c0tov4m[3]=oldVtoCm[16];

  CheckToVar c0tov4(.neighbourVars(c0tov4m), .CheckToVarMessage(newCtoVm[8]));

  // v4 -> c0
  // channel evidence + messages going into v4 but not coming from c0
  wire signed[31:0] v4toc0m[4];
  assign v4toc0m[0]=channelEvidence[4];
  assign v4toc0m[1]=oldCtoVm[9];
  assign v4toc0m[2]=0;
  assign v4toc0m[3]=0;

  VarToCheck v4toc0(.neighbourChecks(v4toc0m), .VarToCheckMessage(newVtoCm[8]));

  // v4-c2: message array index 9
  // c2 -> v4
  // messages going into c2 but not coming from v4
  wire signed[31:0] c2tov4m[4];
  assign c2tov4m[0]=oldVtoCm[5];
  assign c2tov4m[1]=oldVtoCm[11];
  assign c2tov4m[2]=oldVtoCm[14];
  assign c2tov4m[3]=oldVtoCm[23];

  CheckToVar c2tov4(.neighbourVars(c2tov4m), .CheckToVarMessage(newCtoVm[9]));

  // v4 -> c2
  // channel evidence + messages going into v4 but not coming from c2
  wire signed[31:0] v4toc2m[4];
  assign v4toc2m[0]=channelEvidence[4];
  assign v4toc2m[1]=oldCtoVm[8];
  assign v4toc2m[2]=0;
  assign v4toc2m[3]=0;

  VarToCheck v4toc2(.neighbourChecks(v4toc2m), .VarToCheckMessage(newVtoCm[9]));

  // v5-c0: message array index 10
  // c0 -> v5
  // messages going into c0 but not coming from v5
  wire signed[31:0] c0tov5m[4];
  assign c0tov5m[0]=oldVtoCm[0];
  assign c0tov5m[1]=oldVtoCm[4];
  assign c0tov5m[2]=oldVtoCm[8];
  assign c0tov5m[3]=oldVtoCm[16];

  CheckToVar c0tov5(.neighbourVars(c0tov5m), .CheckToVarMessage(newCtoVm[10]));

  // v5 -> c0
  // channel evidence + messages going into v5 but not coming from c0
  wire signed[31:0] v5toc0m[4];
  assign v5toc0m[0]=channelEvidence[5];
  assign v5toc0m[1]=oldCtoVm[11];
  assign v5toc0m[2]=oldCtoVm[12];
  assign v5toc0m[3]=0;

  VarToCheck v5toc0(.neighbourChecks(v5toc0m), .VarToCheckMessage(newVtoCm[10]));

  // v5-c2: message array index 11
  // c2 -> v5
  // messages going into c2 but not coming from v5
  wire signed[31:0] c2tov5m[4];
  assign c2tov5m[0]=oldVtoCm[5];
  assign c2tov5m[1]=oldVtoCm[9];
  assign c2tov5m[2]=oldVtoCm[14];
  assign c2tov5m[3]=oldVtoCm[23];

  CheckToVar c2tov5(.neighbourVars(c2tov5m), .CheckToVarMessage(newCtoVm[11]));

  // v5 -> c2
  // channel evidence + messages going into v5 but not coming from c2
  wire signed[31:0] v5toc2m[4];
  assign v5toc2m[0]=channelEvidence[5];
  assign v5toc2m[1]=oldCtoVm[10];
  assign v5toc2m[2]=oldCtoVm[12];
  assign v5toc2m[3]=0;

  VarToCheck v5toc2(.neighbourChecks(v5toc2m), .VarToCheckMessage(newVtoCm[11]));

  // v5-c4: message array index 12
  // c4 -> v5
  // messages going into c4 but not coming from v5
  wire signed[31:0] c4tov5m[4];
  assign c4tov5m[0]=oldVtoCm[3];
  assign c4tov5m[1]=oldVtoCm[15];
  assign c4tov5m[2]=oldVtoCm[18];
  assign c4tov5m[3]=oldVtoCm[21];

  CheckToVar c4tov5(.neighbourVars(c4tov5m), .CheckToVarMessage(newCtoVm[12]));

  // v5 -> c4
  // channel evidence + messages going into v5 but not coming from c4
  wire signed[31:0] v5toc4m[4];
  assign v5toc4m[0]=channelEvidence[5];
  assign v5toc4m[1]=oldCtoVm[10];
  assign v5toc4m[2]=oldCtoVm[11];
  assign v5toc4m[3]=0;

  VarToCheck v5toc4(.neighbourChecks(v5toc4m), .VarToCheckMessage(newVtoCm[12]));

  // v6-c1: message array index 13
  // c1 -> v6
  // messages going into c1 but not coming from v6
  wire signed[31:0] c1tov6m[4];
  assign c1tov6m[0]=oldVtoCm[2];
  assign c1tov6m[1]=oldVtoCm[6];
  assign c1tov6m[2]=oldVtoCm[19];
  assign c1tov6m[3]=oldVtoCm[22];

  CheckToVar c1tov6(.neighbourVars(c1tov6m), .CheckToVarMessage(newCtoVm[13]));

  // v6 -> c1
  // channel evidence + messages going into v6 but not coming from c1
  wire signed[31:0] v6toc1m[4];
  assign v6toc1m[0]=channelEvidence[6];
  assign v6toc1m[1]=oldCtoVm[14];
  assign v6toc1m[2]=oldCtoVm[15];
  assign v6toc1m[3]=0;

  VarToCheck v6toc1(.neighbourChecks(v6toc1m), .VarToCheckMessage(newVtoCm[13]));

  // v6-c2: message array index 14
  // c2 -> v6
  // messages going into c2 but not coming from v6
  wire signed[31:0] c2tov6m[4];
  assign c2tov6m[0]=oldVtoCm[5];
  assign c2tov6m[1]=oldVtoCm[9];
  assign c2tov6m[2]=oldVtoCm[11];
  assign c2tov6m[3]=oldVtoCm[23];

  CheckToVar c2tov6(.neighbourVars(c2tov6m), .CheckToVarMessage(newCtoVm[14]));

  // v6 -> c2
  // channel evidence + messages going into v6 but not coming from c2
  wire signed[31:0] v6toc2m[4];
  assign v6toc2m[0]=channelEvidence[6];
  assign v6toc2m[1]=oldCtoVm[13];
  assign v6toc2m[2]=oldCtoVm[15];
  assign v6toc2m[3]=0;

  VarToCheck v6toc2(.neighbourChecks(v6toc2m), .VarToCheckMessage(newVtoCm[14]));

  // v6-c4: message array index 15
  // c4 -> v6
  // messages going into c4 but not coming from v6
  wire signed[31:0] c4tov6m[4];
  assign c4tov6m[0]=oldVtoCm[3];
  assign c4tov6m[1]=oldVtoCm[12];
  assign c4tov6m[2]=oldVtoCm[18];
  assign c4tov6m[3]=oldVtoCm[21];

  CheckToVar c4tov6(.neighbourVars(c4tov6m), .CheckToVarMessage(newCtoVm[15]));

  // v6 -> c4
  // channel evidence + messages going into v6 but not coming from c4
  wire signed[31:0] v6toc4m[4];
  assign v6toc4m[0]=channelEvidence[6];
  assign v6toc4m[1]=oldCtoVm[13];
  assign v6toc4m[2]=oldCtoVm[14];
  assign v6toc4m[3]=0;

  VarToCheck v6toc4(.neighbourChecks(v6toc4m), .VarToCheckMessage(newVtoCm[15]));

  // v7-c0: message array index 16
  // c0 -> v7
  // messages going into c0 but not coming from v7
  wire signed[31:0] c0tov7m[4];
  assign c0tov7m[0]=oldVtoCm[0];
  assign c0tov7m[1]=oldVtoCm[4];
  assign c0tov7m[2]=oldVtoCm[8];
  assign c0tov7m[3]=oldVtoCm[10];

  CheckToVar c0tov7(.neighbourVars(c0tov7m), .CheckToVarMessage(newCtoVm[16]));

  // v7 -> c0
  // channel evidence + messages going into v7 but not coming from c0
  wire signed[31:0] v7toc0m[4];
  assign v7toc0m[0]=channelEvidence[7];
  assign v7toc0m[1]=oldCtoVm[17];
  assign v7toc0m[2]=oldCtoVm[18];
  assign v7toc0m[3]=0;

  VarToCheck v7toc0(.neighbourChecks(v7toc0m), .VarToCheckMessage(newVtoCm[16]));

  // v7-c3: message array index 17
  // c3 -> v7
  // messages going into c3 but not coming from v7
  wire signed[31:0] c3tov7m[4];
  assign c3tov7m[0]=oldVtoCm[1];
  assign c3tov7m[1]=oldVtoCm[7];
  assign c3tov7m[2]=oldVtoCm[20];
  assign c3tov7m[3]=oldVtoCm[24];

  CheckToVar c3tov7(.neighbourVars(c3tov7m), .CheckToVarMessage(newCtoVm[17]));

  // v7 -> c3
  // channel evidence + messages going into v7 but not coming from c3
  wire signed[31:0] v7toc3m[4];
  assign v7toc3m[0]=channelEvidence[7];
  assign v7toc3m[1]=oldCtoVm[16];
  assign v7toc3m[2]=oldCtoVm[18];
  assign v7toc3m[3]=0;

  VarToCheck v7toc3(.neighbourChecks(v7toc3m), .VarToCheckMessage(newVtoCm[17]));

  // v7-c4: message array index 18
  // c4 -> v7
  // messages going into c4 but not coming from v7
  wire signed[31:0] c4tov7m[4];
  assign c4tov7m[0]=oldVtoCm[3];
  assign c4tov7m[1]=oldVtoCm[12];
  assign c4tov7m[2]=oldVtoCm[15];
  assign c4tov7m[3]=oldVtoCm[21];

  CheckToVar c4tov7(.neighbourVars(c4tov7m), .CheckToVarMessage(newCtoVm[18]));

  // v7 -> c4
  // channel evidence + messages going into v7 but not coming from c4
  wire signed[31:0] v7toc4m[4];
  assign v7toc4m[0]=channelEvidence[7];
  assign v7toc4m[1]=oldCtoVm[16];
  assign v7toc4m[2]=oldCtoVm[17];
  assign v7toc4m[3]=0;

  VarToCheck v7toc4(.neighbourChecks(v7toc4m), .VarToCheckMessage(newVtoCm[18]));

  // v8-c1: message array index 19
  // c1 -> v8
  // messages going into c1 but not coming from v8
  wire signed[31:0] c1tov8m[4];
  assign c1tov8m[0]=oldVtoCm[2];
  assign c1tov8m[1]=oldVtoCm[6];
  assign c1tov8m[2]=oldVtoCm[13];
  assign c1tov8m[3]=oldVtoCm[22];

  CheckToVar c1tov8(.neighbourVars(c1tov8m), .CheckToVarMessage(newCtoVm[19]));

  // v8 -> c1
  // channel evidence + messages going into v8 but not coming from c1
  wire signed[31:0] v8toc1m[4];
  assign v8toc1m[0]=channelEvidence[8];
  assign v8toc1m[1]=oldCtoVm[20];
  assign v8toc1m[2]=oldCtoVm[21];
  assign v8toc1m[3]=0;

  VarToCheck v8toc1(.neighbourChecks(v8toc1m), .VarToCheckMessage(newVtoCm[19]));

  // v8-c3: message array index 20
  // c3 -> v8
  // messages going into c3 but not coming from v8
  wire signed[31:0] c3tov8m[4];
  assign c3tov8m[0]=oldVtoCm[1];
  assign c3tov8m[1]=oldVtoCm[7];
  assign c3tov8m[2]=oldVtoCm[17];
  assign c3tov8m[3]=oldVtoCm[24];

  CheckToVar c3tov8(.neighbourVars(c3tov8m), .CheckToVarMessage(newCtoVm[20]));

  // v8 -> c3
  // channel evidence + messages going into v8 but not coming from c3
  wire signed[31:0] v8toc3m[4];
  assign v8toc3m[0]=channelEvidence[8];
  assign v8toc3m[1]=oldCtoVm[19];
  assign v8toc3m[2]=oldCtoVm[21];
  assign v8toc3m[3]=0;

  VarToCheck v8toc3(.neighbourChecks(v8toc3m), .VarToCheckMessage(newVtoCm[20]));

  // v8-c4: message array index 21
  // c4 -> v8
  // messages going into c4 but not coming from v8
  wire signed[31:0] c4tov8m[4];
  assign c4tov8m[0]=oldVtoCm[3];
  assign c4tov8m[1]=oldVtoCm[12];
  assign c4tov8m[2]=oldVtoCm[15];
  assign c4tov8m[3]=oldVtoCm[18];

  CheckToVar c4tov8(.neighbourVars(c4tov8m), .CheckToVarMessage(newCtoVm[21]));

  // v8 -> c4
  // channel evidence + messages going into v8 but not coming from c4
  wire signed[31:0] v8toc4m[4];
  assign v8toc4m[0]=channelEvidence[8];
  assign v8toc4m[1]=oldCtoVm[19];
  assign v8toc4m[2]=oldCtoVm[20];
  assign v8toc4m[3]=0;

  VarToCheck v8toc4(.neighbourChecks(v8toc4m), .VarToCheckMessage(newVtoCm[21]));

  // v9-c1: message array index 22
  // c1 -> v9
  // messages going into c1 but not coming from v9
  wire signed[31:0] c1tov9m[4];
  assign c1tov9m[0]=oldVtoCm[2];
  assign c1tov9m[1]=oldVtoCm[6];
  assign c1tov9m[2]=oldVtoCm[13];
  assign c1tov9m[3]=oldVtoCm[19];

  CheckToVar c1tov9(.neighbourVars(c1tov9m), .CheckToVarMessage(newCtoVm[22]));

  // v9 -> c1
  // channel evidence + messages going into v9 but not coming from c1
  wire signed[31:0] v9toc1m[4];
  assign v9toc1m[0]=channelEvidence[9];
  assign v9toc1m[1]=oldCtoVm[23];
  assign v9toc1m[2]=oldCtoVm[24];
  assign v9toc1m[3]=0;

  VarToCheck v9toc1(.neighbourChecks(v9toc1m), .VarToCheckMessage(newVtoCm[22]));

  // v9-c2: message array index 23
  // c2 -> v9
  // messages going into c2 but not coming from v9
  wire signed[31:0] c2tov9m[4];
  assign c2tov9m[0]=oldVtoCm[5];
  assign c2tov9m[1]=oldVtoCm[9];
  assign c2tov9m[2]=oldVtoCm[11];
  assign c2tov9m[3]=oldVtoCm[14];

  CheckToVar c2tov9(.neighbourVars(c2tov9m), .CheckToVarMessage(newCtoVm[23]));

  // v9 -> c2
  // channel evidence + messages going into v9 but not coming from c2
  wire signed[31:0] v9toc2m[4];
  assign v9toc2m[0]=channelEvidence[9];
  assign v9toc2m[1]=oldCtoVm[22];
  assign v9toc2m[2]=oldCtoVm[24];
  assign v9toc2m[3]=0;

  VarToCheck v9toc2(.neighbourChecks(v9toc2m), .VarToCheckMessage(newVtoCm[23]));

  // v9-c3: message array index 24
  // c3 -> v9
  // messages going into c3 but not coming from v9
  wire signed[31:0] c3tov9m[4];
  assign c3tov9m[0]=oldVtoCm[1];
  assign c3tov9m[1]=oldVtoCm[7];
  assign c3tov9m[2]=oldVtoCm[17];
  assign c3tov9m[3]=oldVtoCm[20];

  CheckToVar c3tov9(.neighbourVars(c3tov9m), .CheckToVarMessage(newCtoVm[24]));

  // v9 -> c3
  // channel evidence + messages going into v9 but not coming from c3
  wire signed[31:0] v9toc3m[4];
  assign v9toc3m[0]=channelEvidence[9];
  assign v9toc3m[1]=oldCtoVm[22];
  assign v9toc3m[2]=oldCtoVm[23];
  assign v9toc3m[3]=0;

  VarToCheck v9toc3(.neighbourChecks(v9toc3m), .VarToCheckMessage(newVtoCm[24]));

  // belief of v0
  // channel evidence + messages going into v0
  wire signed[31:0] v0m[4];
  assign v0m[0]=channelEvidence[0];
  assign v0m[1]=oldCtoVm[0];
  assign v0m[2]=oldCtoVm[1];
  assign v0m[3]=0;

  Belief v0(.neighbourChecks(v0m), .belief(channelBelief[0]), .corrected_bit(corrected_seq[0]));

  // belief of v1
  // channel evidence + messages going into v1
  wire signed[31:0] v1m[4];
  assign v1m[0]=channelEvidence[1];
  assign v1m[1]=oldCtoVm[2];
  assign v1m[2]=oldCtoVm[3];
  assign v1m[3]=0;

  Belief v1(.neighbourChecks(v1m), .belief(channelBelief[1]), .corrected_bit(corrected_seq[1]));

  // belief of v2
  // channel evidence + messages going into v2
  wire signed[31:0] v2m[4];
  assign v2m[0]=channelEvidence[2];
  assign v2m[1]=oldCtoVm[4];
  assign v2m[2]=oldCtoVm[5];
  assign v2m[3]=0;

  Belief v2(.neighbourChecks(v2m), .belief(channelBelief[2]), .corrected_bit(corrected_seq[2]));

  // belief of v3
  // channel evidence + messages going into v3
  wire signed[31:0] v3m[4];
  assign v3m[0]=channelEvidence[3];
  assign v3m[1]=oldCtoVm[6];
  assign v3m[2]=oldCtoVm[7];
  assign v3m[3]=0;

  Belief v3(.neighbourChecks(v3m), .belief(channelBelief[3]), .corrected_bit(corrected_seq[3]));

  // belief of v4
  // channel evidence + messages going into v4
  wire signed[31:0] v4m[4];
  assign v4m[0]=channelEvidence[4];
  assign v4m[1]=oldCtoVm[8];
  assign v4m[2]=oldCtoVm[9];
  assign v4m[3]=0;

  Belief v4(.neighbourChecks(v4m), .belief(channelBelief[4]), .corrected_bit(corrected_seq[4]));

  // belief of v5
  // channel evidence + messages going into v5
  wire signed[31:0] v5m[4];
  assign v5m[0]=channelEvidence[5];
  assign v5m[1]=oldCtoVm[10];
  assign v5m[2]=oldCtoVm[11];
  assign v5m[3]=oldCtoVm[12];

  Belief v5(.neighbourChecks(v5m), .belief(channelBelief[5]), .corrected_bit(corrected_seq[5]));

  // belief of v6
  // channel evidence + messages going into v6
  wire signed[31:0] v6m[4];
  assign v6m[0]=channelEvidence[6];
  assign v6m[1]=oldCtoVm[13];
  assign v6m[2]=oldCtoVm[14];
  assign v6m[3]=oldCtoVm[15];

  Belief v6(.neighbourChecks(v6m), .belief(channelBelief[6]), .corrected_bit(corrected_seq[6]));

  // belief of v7
  // channel evidence + messages going into v7
  wire signed[31:0] v7m[4];
  assign v7m[0]=channelEvidence[7];
  assign v7m[1]=oldCtoVm[16];
  assign v7m[2]=oldCtoVm[17];
  assign v7m[3]=oldCtoVm[18];

  Belief v7(.neighbourChecks(v7m), .belief(channelBelief[7]), .corrected_bit(corrected_seq[7]));

  // belief of v8
  // channel evidence + messages going into v8
  wire signed[31:0] v8m[4];
  assign v8m[0]=channelEvidence[8];
  assign v8m[1]=oldCtoVm[19];
  assign v8m[2]=oldCtoVm[20];
  assign v8m[3]=oldCtoVm[21];

  Belief v8(.neighbourChecks(v8m), .belief(channelBelief[8]), .corrected_bit(corrected_seq[8]));

  // belief of v9
  // channel evidence + messages going into v9
  wire signed[31:0] v9m[4];
  assign v9m[0]=channelEvidence[9];
  assign v9m[1]=oldCtoVm[22];
  assign v9m[2]=oldCtoVm[23];
  assign v9m[3]=oldCtoVm[24];

  Belief v9(.neighbourChecks(v9m), .belief(channelBelief[9]), .corrected_bit(corrected_seq[9]));

  integer k;
  
  // Sequential logic
  initial begin // start with all messages = 0
    for (k=0;k<25;k=k+1) begin
      oldVtoCm[k] = 0;
      oldCtoVm[k] = 0;
    end
  end

  always @(posedge clk) begin // iteratively update old messages using current messages
    for (k = 0;k<25;k=k+1) begin
      oldVtoCm[k] = newVtoCm[k];
      oldCtoVm[k] = newCtoVm[k];
    end
	end
endmodule