v_id = 9
v_conn = [22, 23, 24]

print("// belief of v{}".format(v_id))
print("// channel evidence + messages going into v{}".format(v_id))
print("wire signed[31:0] v{}m[4];".format(v_id))
print("assign v{}m[0]=channelEvidence[{}];".format(v_id, v_id))

if v_conn[0] == -1:
    print("assign v{}m[1]=0;".format(v_id))
else:
    print("assign v{}m[1]=oldCtoVm[{}];".format(
        v_id, v_conn[0]))

if v_conn[1] == -1:
    print("assign v{}m[2]=0;".format(v_id))
else:
    print("assign v{}m[2]=oldCtoVm[{}];".format(
        v_id, v_conn[1]))

if v_conn[2] == -1:
    print("assign v{}m[3]=0;\n".format(v_id))
else:
    print("assign v{}m[3]=oldCtoVm[{}];\n".format(
        v_id, v_conn[2]))

print("Belief v{}(.neighbourChecks(v{}m), .belief(channelBelief[{}]), .corrected_bit(corrected_seq[{}]));".format(
    v_id, v_id, v_id, v_id))
