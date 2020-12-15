id = 24
v_id = 9
c_id = 3
v_conn_not_c = [22, 23, -1]
c_conn_not_v = [1, 7, 17, 20]

print("// v{}-c{}: {}".format(v_id, c_id, id))
print("// c{} -> v{}".format(c_id, v_id))
print("// messages going into c{} but not coming from v{}".format(c_id, v_id))
print("wire signed[31:0] c{}tov{}m[4];".format(c_id, v_id))
print("assign c{}tov{}m[0]=oldVtoCm[{}];".format(c_id, v_id, c_conn_not_v[0]))
print("assign c{}tov{}m[1]=oldVtoCm[{}];".format(c_id, v_id, c_conn_not_v[1]))
print("assign c{}tov{}m[2]=oldVtoCm[{}];".format(c_id, v_id, c_conn_not_v[2]))
print("assign c{}tov{}m[3]=oldVtoCm[{}];\n".format(
    c_id, v_id, c_conn_not_v[3]))

print("CheckToVar c{}tov{}(.neighbourVars(c{}tov{}m), .CheckToVarMessage(newCtoVm[{}]));\n".format(
    c_id, v_id, c_id, v_id, id))

print("// v{} -> c{}".format(v_id, c_id))
print("// channel evidence + messages going into v{} but not coming from c{}".format(v_id, c_id))
print("wire signed[31:0] v{}toc{}m[4];".format(v_id, c_id))
print("assign v{}toc{}m[0]=channelEvidence[{}];".format(v_id, c_id, v_id))

if v_conn_not_c[0] == -1:
    print("assign v{}toc{}m[1]=0;".format(v_id, c_id))
else:
    print("assign v{}toc{}m[1]=oldCtoVm[{}];".format(
        v_id, c_id, v_conn_not_c[0]))

if v_conn_not_c[1] == -1:
    print("assign v{}toc{}m[2]=0;".format(v_id, c_id))
else:
    print("assign v{}toc{}m[2]=oldCtoVm[{}];".format(
        v_id, c_id, v_conn_not_c[1]))

if v_conn_not_c[2] == -1:
    print("assign v{}toc{}m[3]=0;\n".format(v_id, c_id))
else:
    print("assign v{}toc{}m[3]=oldCtoVm[{}];\n".format(
        v_id, c_id, v_conn_not_c[2]))

print("VarToCheck v{}toc{}(.neighbourChecks(v{}toc{}m), .VarToCheckMessage(newVtoCm[{}]));".format(
    v_id, c_id, v_id, c_id, id))
