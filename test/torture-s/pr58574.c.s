	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58574.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	f64
	.result 	f64
	.local  	i32, f64
# BB#0:                                 # %entry
	f64.const	$2=, 0x1p0
	block   	
	i32.trunc_s/f64	$push1346=, $0
	tee_local	$push1345=, $1=, $pop1346
	i32.const	$push0=, 93
	i32.gt_u	$push1=, $pop1345, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %entry
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	br_table 	$1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 64, 64, 64, 27, 64, 64, 64, 64, 64, 64, 64, 64, 64, 28, 64, 64, 64, 64, 64, 64, 64, 64, 64, 29, 64, 64, 64, 64, 64, 64, 64, 64, 64, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 0 # 0: down to label64
                                        # 1: down to label63
                                        # 2: down to label62
                                        # 3: down to label61
                                        # 4: down to label60
                                        # 5: down to label59
                                        # 6: down to label58
                                        # 7: down to label57
                                        # 8: down to label56
                                        # 9: down to label55
                                        # 10: down to label54
                                        # 11: down to label53
                                        # 12: down to label52
                                        # 13: down to label51
                                        # 14: down to label50
                                        # 15: down to label49
                                        # 16: down to label48
                                        # 17: down to label47
                                        # 18: down to label46
                                        # 19: down to label45
                                        # 20: down to label44
                                        # 21: down to label43
                                        # 22: down to label42
                                        # 23: down to label41
                                        # 24: down to label40
                                        # 25: down to label39
                                        # 26: down to label38
                                        # 64: down to label0
                                        # 27: down to label37
                                        # 28: down to label36
                                        # 29: down to label35
                                        # 30: down to label34
                                        # 31: down to label33
                                        # 32: down to label32
                                        # 33: down to label31
                                        # 34: down to label30
                                        # 35: down to label29
                                        # 36: down to label28
                                        # 37: down to label27
                                        # 38: down to label26
                                        # 39: down to label25
                                        # 40: down to label24
                                        # 41: down to label23
                                        # 42: down to label22
                                        # 43: down to label21
                                        # 44: down to label20
                                        # 45: down to label19
                                        # 46: down to label18
                                        # 47: down to label17
                                        # 48: down to label16
                                        # 49: down to label15
                                        # 50: down to label14
                                        # 51: down to label13
                                        # 52: down to label12
                                        # 53: down to label11
                                        # 54: down to label10
                                        # 55: down to label9
                                        # 56: down to label8
                                        # 57: down to label7
                                        # 58: down to label6
                                        # 59: down to label5
                                        # 60: down to label4
                                        # 61: down to label3
                                        # 62: down to label2
                                        # 63: down to label1
.LBB0_2:                                # %sw.bb
	end_block                       # label64:
	f64.add 	$push1262=, $0, $0
	f64.const	$push1263=, -0x1p0
	f64.add 	$push1348=, $pop1262, $pop1263
	tee_local	$push1347=, $0=, $pop1348
	f64.const	$push1264=, 0x1.cac6baec528a3p-50
	f64.mul 	$push1265=, $0, $pop1264
	f64.const	$push1266=, 0x1.9f49c634d36c8p-42
	f64.add 	$push1267=, $pop1265, $pop1266
	f64.mul 	$push1268=, $0, $pop1267
	f64.const	$push1269=, 0x1.675d48090d1d6p-34
	f64.add 	$push1270=, $pop1268, $pop1269
	f64.mul 	$push1271=, $0, $pop1270
	f64.const	$push1272=, 0x1.2afb34142b11cp-26
	f64.add 	$push1273=, $pop1271, $pop1272
	f64.mul 	$push1274=, $0, $pop1273
	f64.const	$push1275=, 0x1.e037b539626b4p-19
	f64.add 	$push1276=, $pop1274, $pop1275
	f64.mul 	$push1277=, $0, $pop1276
	f64.const	$push1278=, 0x1.7578a807708cbp-11
	f64.add 	$push1279=, $pop1277, $pop1278
	f64.mul 	$push1280=, $pop1347, $pop1279
	f64.const	$push1281=, 0x1.739ad75c47d48p-11
	f64.add 	$push1344=, $pop1280, $pop1281
	return  	$pop1344
.LBB0_3:                                # %sw.bb12
	end_block                       # label63:
	f64.add 	$push1242=, $0, $0
	f64.const	$push1243=, -0x1.8p1
	f64.add 	$push1350=, $pop1242, $pop1243
	tee_local	$push1349=, $0=, $pop1350
	f64.const	$push1244=, 0x1.e62fdf221a945p-50
	f64.mul 	$push1245=, $0, $pop1244
	f64.const	$push1246=, 0x1.b56f4407b2b3fp-42
	f64.add 	$push1247=, $pop1245, $pop1246
	f64.mul 	$push1248=, $0, $pop1247
	f64.const	$push1249=, 0x1.7803f03d4db15p-34
	f64.add 	$push1250=, $pop1248, $pop1249
	f64.mul 	$push1251=, $0, $pop1250
	f64.const	$push1252=, 0x1.3675193770057p-26
	f64.add 	$push1253=, $pop1251, $pop1252
	f64.mul 	$push1254=, $0, $pop1253
	f64.const	$push1255=, 0x1.ee7f95858f80dp-19
	f64.add 	$push1256=, $pop1254, $pop1255
	f64.mul 	$push1257=, $0, $pop1256
	f64.const	$push1258=, 0x1.7d157f6e1f426p-11
	f64.add 	$push1259=, $pop1257, $pop1258
	f64.mul 	$push1260=, $pop1349, $pop1259
	f64.const	$push1261=, 0x1.1987908299a2dp-9
	f64.add 	$push1343=, $pop1260, $pop1261
	return  	$pop1343
.LBB0_4:                                # %sw.bb27
	end_block                       # label62:
	f64.add 	$push1222=, $0, $0
	f64.const	$push1223=, -0x1.4p2
	f64.add 	$push1352=, $pop1222, $pop1223
	tee_local	$push1351=, $0=, $pop1352
	f64.const	$push1224=, 0x1.01900ac1a16a7p-49
	f64.mul 	$push1225=, $0, $pop1224
	f64.const	$push1226=, 0x1.cce31abf0cfe7p-42
	f64.add 	$push1227=, $pop1225, $pop1226
	f64.mul 	$push1228=, $0, $pop1227
	f64.const	$push1229=, 0x1.898e06fac46dfp-34
	f64.add 	$push1230=, $pop1228, $pop1229
	f64.mul 	$push1231=, $0, $pop1230
	f64.const	$push1232=, 0x1.427bbb26be687p-26
	f64.add 	$push1233=, $pop1231, $pop1232
	f64.mul 	$push1234=, $0, $pop1233
	f64.const	$push1235=, 0x1.fd5455ccf9081p-19
	f64.add 	$push1236=, $pop1234, $pop1235
	f64.mul 	$push1237=, $0, $pop1236
	f64.const	$push1238=, 0x1.84ed651dbbfdap-11
	f64.add 	$push1239=, $pop1237, $pop1238
	f64.mul 	$push1240=, $pop1351, $pop1239
	f64.const	$push1241=, 0x1.da059a73b42ccp-9
	f64.add 	$push1342=, $pop1240, $pop1241
	return  	$pop1342
.LBB0_5:                                # %sw.bb42
	end_block                       # label61:
	f64.add 	$push1202=, $0, $0
	f64.const	$push1203=, -0x1.cp2
	f64.add 	$push1354=, $pop1202, $pop1203
	tee_local	$push1353=, $0=, $pop1354
	f64.const	$push1204=, 0x1.10f093c3894a7p-49
	f64.mul 	$push1205=, $0, $pop1204
	f64.const	$push1206=, 0x1.e5bf3b2ed15bap-42
	f64.add 	$push1207=, $pop1205, $pop1206
	f64.mul 	$push1208=, $0, $pop1207
	f64.const	$push1209=, 0x1.9c0a2f40226f1p-34
	f64.add 	$push1210=, $pop1208, $pop1209
	f64.mul 	$push1211=, $0, $pop1210
	f64.const	$push1212=, 0x1.4f137fc876864p-26
	f64.add 	$push1213=, $pop1211, $pop1212
	f64.mul 	$push1214=, $0, $pop1213
	f64.const	$push1215=, 0x1.065e6aa3cabb7p-18
	f64.add 	$push1216=, $pop1214, $pop1215
	f64.mul 	$push1217=, $0, $pop1216
	f64.const	$push1218=, 0x1.8d00591646be5p-11
	f64.add 	$push1219=, $pop1217, $pop1218
	f64.mul 	$push1220=, $pop1353, $pop1219
	f64.const	$push1221=, 0x1.4f3e2bb4b9b09p-8
	f64.add 	$push1341=, $pop1220, $pop1221
	return  	$pop1341
.LBB0_6:                                # %sw.bb57
	end_block                       # label60:
	f64.add 	$push1182=, $0, $0
	f64.const	$push1183=, -0x1.2p3
	f64.add 	$push1356=, $pop1182, $pop1183
	tee_local	$push1355=, $0=, $pop1356
	f64.const	$push1184=, 0x1.21535de6eaaa3p-49
	f64.mul 	$push1185=, $0, $pop1184
	f64.const	$push1186=, 0x1.000d5a2623093p-41
	f64.add 	$push1187=, $pop1185, $pop1186
	f64.mul 	$push1188=, $0, $pop1187
	f64.const	$push1189=, 0x1.af85ebd11ee25p-34
	f64.add 	$push1190=, $pop1188, $pop1189
	f64.mul 	$push1191=, $0, $pop1190
	f64.const	$push1192=, 0x1.5c40cd02f8aa5p-26
	f64.add 	$push1193=, $pop1191, $pop1192
	f64.mul 	$push1194=, $0, $pop1193
	f64.const	$push1195=, 0x1.0e5ff996ada1ap-18
	f64.add 	$push1196=, $pop1194, $pop1195
	f64.mul 	$push1197=, $0, $pop1196
	f64.const	$push1198=, 0x1.9553b9bb7810bp-11
	f64.add 	$push1199=, $pop1197, $pop1198
	f64.mul 	$push1200=, $pop1355, $pop1199
	f64.const	$push1201=, 0x1.b3885828b601bp-8
	f64.add 	$push1340=, $pop1200, $pop1201
	return  	$pop1340
.LBB0_7:                                # %sw.bb72
	end_block                       # label59:
	f64.add 	$push1162=, $0, $0
	f64.const	$push1163=, -0x1.6p3
	f64.add 	$push1358=, $pop1162, $pop1163
	tee_local	$push1357=, $0=, $pop1358
	f64.const	$push1164=, 0x1.32bfca1e19775p-49
	f64.mul 	$push1165=, $0, $pop1164
	f64.const	$push1166=, 0x1.0e04d99704505p-41
	f64.add 	$push1167=, $pop1165, $pop1166
	f64.mul 	$push1168=, $0, $pop1167
	f64.const	$push1169=, 0x1.c407fe0f955e6p-34
	f64.add 	$push1170=, $pop1168, $pop1169
	f64.mul 	$push1171=, $0, $pop1170
	f64.const	$push1172=, 0x1.6a0c6ea3056bap-26
	f64.add 	$push1173=, $pop1171, $pop1172
	f64.mul 	$push1174=, $0, $pop1173
	f64.const	$push1175=, 0x1.16b2475b20719p-18
	f64.add 	$push1176=, $pop1174, $pop1175
	f64.mul 	$push1177=, $0, $pop1176
	f64.const	$push1178=, 0x1.9de7870d4ff4bp-11
	f64.add 	$push1179=, $pop1177, $pop1178
	f64.mul 	$push1180=, $pop1357, $pop1179
	f64.const	$push1181=, 0x1.0cf75f478e341p-7
	f64.add 	$push1339=, $pop1180, $pop1181
	return  	$pop1339
.LBB0_8:                                # %sw.bb87
	end_block                       # label58:
	f64.add 	$push1142=, $0, $0
	f64.const	$push1143=, -0x1.ap3
	f64.add 	$push1360=, $pop1142, $pop1143
	tee_local	$push1359=, $0=, $pop1360
	f64.const	$push1144=, 0x1.454fabb93b71cp-49
	f64.mul 	$push1145=, $0, $pop1144
	f64.const	$push1146=, 0x1.1cd31454040b1p-41
	f64.add 	$push1147=, $pop1145, $pop1146
	f64.mul 	$push1148=, $0, $pop1147
	f64.const	$push1149=, 0x1.d9b6add0b78edp-34
	f64.add 	$push1150=, $pop1148, $pop1149
	f64.mul 	$push1151=, $0, $pop1150
	f64.const	$push1152=, 0x1.7883965bbdac9p-26
	f64.add 	$push1153=, $pop1151, $pop1152
	f64.mul 	$push1154=, $0, $pop1153
	f64.const	$push1155=, 0x1.1f5a7b5b1c03bp-18
	f64.add 	$push1156=, $pop1154, $pop1155
	f64.mul 	$push1157=, $0, $pop1156
	f64.const	$push1158=, 0x1.a6bfc7d698d37p-11
	f64.add 	$push1159=, $pop1157, $pop1158
	f64.mul 	$push1160=, $pop1359, $pop1159
	f64.const	$push1161=, 0x1.414112efc6ccep-7
	f64.add 	$push1338=, $pop1160, $pop1161
	return  	$pop1338
.LBB0_9:                                # %sw.bb102
	end_block                       # label57:
	f64.add 	$push1122=, $0, $0
	f64.const	$push1123=, -0x1.ep3
	f64.add 	$push1362=, $pop1122, $pop1123
	tee_local	$push1361=, $0=, $pop1362
	f64.const	$push1124=, 0x1.5911c49cf8751p-49
	f64.mul 	$push1125=, $0, $pop1124
	f64.const	$push1126=, 0x1.2c89559516ee9p-41
	f64.add 	$push1127=, $pop1125, $pop1126
	f64.mul 	$push1128=, $0, $pop1127
	f64.const	$push1129=, 0x1.f0955bc5733f2p-34
	f64.add 	$push1130=, $pop1128, $pop1129
	f64.mul 	$push1131=, $0, $pop1130
	f64.const	$push1132=, 0x1.87aaaa1381b8bp-26
	f64.add 	$push1133=, $pop1131, $pop1132
	f64.mul 	$push1134=, $0, $pop1133
	f64.const	$push1135=, 0x1.285a4d649df58p-18
	f64.add 	$push1136=, $pop1134, $pop1135
	f64.mul 	$push1137=, $0, $pop1136
	f64.const	$push1138=, 0x1.afddd3b040dp-11
	f64.add 	$push1139=, $pop1137, $pop1138
	f64.mul 	$push1140=, $pop1361, $pop1139
	f64.const	$push1141=, 0x1.76a2f48c2e771p-7
	f64.add 	$push1337=, $pop1140, $pop1141
	return  	$pop1337
.LBB0_10:                               # %sw.bb117
	end_block                       # label56:
	f64.add 	$push1102=, $0, $0
	f64.const	$push1103=, -0x1.1p4
	f64.add 	$push1364=, $pop1102, $pop1103
	tee_local	$push1363=, $0=, $pop1364
	f64.const	$push1104=, 0x1.6e18872722536p-49
	f64.mul 	$push1105=, $0, $pop1104
	f64.const	$push1106=, 0x1.3d3324d4e01e3p-41
	f64.add 	$push1107=, $pop1105, $pop1106
	f64.mul 	$push1108=, $0, $pop1107
	f64.const	$push1109=, 0x1.0457a51dc5dfep-33
	f64.add 	$push1110=, $pop1108, $pop1109
	f64.mul 	$push1111=, $0, $pop1110
	f64.const	$push1112=, 0x1.978edb7d72726p-26
	f64.add 	$push1113=, $pop1111, $pop1112
	f64.mul 	$push1114=, $0, $pop1113
	f64.const	$push1115=, 0x1.31b6e4e19f1f7p-18
	f64.add 	$push1116=, $pop1114, $pop1115
	f64.mul 	$push1117=, $0, $pop1116
	f64.const	$push1118=, 0x1.b94708fe00767p-11
	f64.add 	$push1119=, $pop1117, $pop1118
	f64.mul 	$push1120=, $pop1363, $pop1119
	f64.const	$push1121=, 0x1.ad3a604e1e71p-7
	f64.add 	$push1336=, $pop1120, $pop1121
	return  	$pop1336
.LBB0_11:                               # %sw.bb132
	end_block                       # label55:
	f64.add 	$push1082=, $0, $0
	f64.const	$push1083=, -0x1.3p4
	f64.add 	$push1366=, $pop1082, $pop1083
	tee_local	$push1365=, $0=, $pop1366
	f64.const	$push1084=, 0x1.847dc6a7decccp-49
	f64.mul 	$push1085=, $0, $pop1084
	f64.const	$push1086=, 0x1.4ee05c5bffeaap-41
	f64.add 	$push1087=, $pop1085, $pop1086
	f64.mul 	$push1088=, $0, $pop1087
	f64.const	$push1089=, 0x1.1113200e25815p-33
	f64.add 	$push1090=, $pop1088, $pop1089
	f64.mul 	$push1091=, $0, $pop1090
	f64.const	$push1092=, 0x1.a83d5c4cb0bc1p-26
	f64.add 	$push1093=, $pop1091, $pop1092
	f64.mul 	$push1094=, $0, $pop1093
	f64.const	$push1095=, 0x1.3b77210a15f77p-18
	f64.add 	$push1096=, $pop1094, $pop1095
	f64.mul 	$push1097=, $0, $pop1096
	f64.const	$push1098=, 0x1.c2fb67bfd7c6dp-11
	f64.add 	$push1099=, $pop1097, $pop1098
	f64.mul 	$push1100=, $pop1365, $pop1099
	f64.const	$push1101=, 0x1.e4f765fd8adacp-7
	f64.add 	$push1335=, $pop1100, $pop1101
	return  	$pop1335
.LBB0_12:                               # %sw.bb147
	end_block                       # label54:
	f64.add 	$push1062=, $0, $0
	f64.const	$push1063=, -0x1.5p4
	f64.add 	$push1368=, $pop1062, $pop1063
	tee_local	$push1367=, $0=, $pop1368
	f64.const	$push1064=, 0x1.9c57a5f629aa4p-49
	f64.mul 	$push1065=, $0, $pop1064
	f64.const	$push1066=, 0x1.61a5294113d1fp-41
	f64.add 	$push1067=, $pop1065, $pop1066
	f64.mul 	$push1068=, $0, $pop1067
	f64.const	$push1069=, 0x1.1e8861019bd46p-33
	f64.add 	$push1070=, $pop1068, $pop1069
	f64.mul 	$push1071=, $0, $pop1070
	f64.const	$push1072=, 0x1.b9b62c813c95dp-26
	f64.add 	$push1073=, $pop1071, $pop1072
	f64.mul 	$push1074=, $0, $pop1073
	f64.const	$push1075=, 0x1.459cb9ac001bp-18
	f64.add 	$push1076=, $pop1074, $pop1075
	f64.mul 	$push1077=, $0, $pop1076
	f64.const	$push1078=, 0x1.ccfef6c0912a3p-11
	f64.add 	$push1079=, $pop1077, $pop1078
	f64.mul 	$push1080=, $pop1367, $pop1079
	f64.const	$push1081=, 0x1.0efdc9c4da9p-6
	f64.add 	$push1334=, $pop1080, $pop1081
	return  	$pop1334
.LBB0_13:                               # %sw.bb162
	end_block                       # label53:
	f64.add 	$push1042=, $0, $0
	f64.const	$push1043=, -0x1.7p4
	f64.add 	$push1370=, $pop1042, $pop1043
	tee_local	$push1369=, $0=, $pop1370
	f64.const	$push1044=, 0x1.b5bff86228abep-49
	f64.mul 	$push1045=, $0, $pop1044
	f64.const	$push1046=, 0x1.758ff4dd67c05p-41
	f64.add 	$push1047=, $pop1045, $pop1046
	f64.mul 	$push1048=, $0, $pop1047
	f64.const	$push1049=, 0x1.2cb767f828d91p-33
	f64.add 	$push1050=, $pop1048, $pop1049
	f64.mul 	$push1051=, $0, $pop1050
	f64.const	$push1052=, 0x1.cc0f499af778fp-26
	f64.add 	$push1053=, $pop1051, $pop1052
	f64.mul 	$push1054=, $0, $pop1053
	f64.const	$push1055=, 0x1.502cd63156628p-18
	f64.add 	$push1056=, $pop1054, $pop1055
	f64.mul 	$push1057=, $0, $pop1056
	f64.const	$push1058=, 0x1.d755bccaf709bp-11
	f64.add 	$push1059=, $pop1057, $pop1058
	f64.mul 	$push1060=, $pop1369, $pop1059
	f64.const	$push1061=, 0x1.2c1f42bb6673p-6
	f64.add 	$push1333=, $pop1060, $pop1061
	return  	$pop1333
.LBB0_14:                               # %sw.bb177
	end_block                       # label52:
	f64.add 	$push1022=, $0, $0
	f64.const	$push1023=, -0x1.9p4
	f64.add 	$push1372=, $pop1022, $pop1023
	tee_local	$push1371=, $0=, $pop1372
	f64.const	$push1024=, 0x1.d0cce0c2d79abp-49
	f64.mul 	$push1025=, $0, $pop1024
	f64.const	$push1026=, 0x1.8ab4ec479933cp-41
	f64.add 	$push1027=, $pop1025, $pop1026
	f64.mul 	$push1028=, $0, $pop1027
	f64.const	$push1029=, 0x1.3bb6b98d5330ap-33
	f64.add 	$push1030=, $pop1028, $pop1029
	f64.mul 	$push1031=, $0, $pop1030
	f64.const	$push1032=, 0x1.df517f66a1fc6p-26
	f64.add 	$push1033=, $pop1031, $pop1032
	f64.mul 	$push1034=, $0, $pop1033
	f64.const	$push1035=, 0x1.5b2e55d20f44p-18
	f64.add 	$push1036=, $pop1034, $pop1035
	f64.mul 	$push1037=, $0, $pop1036
	f64.const	$push1038=, 0x1.e2026910e5ab7p-11
	f64.add 	$push1039=, $pop1037, $pop1038
	f64.mul 	$push1040=, $pop1371, $pop1039
	f64.const	$push1041=, 0x1.49e8815e39714p-6
	f64.add 	$push1332=, $pop1040, $pop1041
	return  	$pop1332
.LBB0_15:                               # %sw.bb192
	end_block                       # label51:
	f64.add 	$push1002=, $0, $0
	f64.const	$push1003=, -0x1.bp4
	f64.add 	$push1374=, $pop1002, $pop1003
	tee_local	$push1373=, $0=, $pop1374
	f64.const	$push1004=, 0x1.ed9be2e1862d9p-49
	f64.mul 	$push1005=, $0, $pop1004
	f64.const	$push1006=, 0x1.a129ad859a0ebp-41
	f64.add 	$push1007=, $pop1005, $pop1006
	f64.mul 	$push1008=, $0, $pop1007
	f64.const	$push1009=, 0x1.4b91980ede2b9p-33
	f64.add 	$push1010=, $pop1008, $pop1009
	f64.mul 	$push1011=, $0, $pop1010
	f64.const	$push1012=, 0x1.f38e657dbd4e3p-26
	f64.add 	$push1013=, $pop1011, $pop1012
	f64.mul 	$push1014=, $0, $pop1013
	f64.const	$push1015=, 0x1.66a65ff82397dp-18
	f64.add 	$push1016=, $pop1014, $pop1015
	f64.mul 	$push1017=, $0, $pop1016
	f64.const	$push1018=, 0x1.ed0a59f6159b7p-11
	f64.add 	$push1019=, $pop1017, $pop1018
	f64.mul 	$push1020=, $pop1373, $pop1019
	f64.const	$push1021=, 0x1.6861e92923e5cp-6
	f64.add 	$push1331=, $pop1020, $pop1021
	return  	$pop1331
.LBB0_16:                               # %sw.bb207
	end_block                       # label50:
	f64.add 	$push982=, $0, $0
	f64.const	$push983=, -0x1.dp4
	f64.add 	$push1376=, $pop982, $pop983
	tee_local	$push1375=, $0=, $pop1376
	f64.const	$push984=, 0x1.0627198057091p-48
	f64.mul 	$push985=, $0, $pop984
	f64.const	$push986=, 0x1.b903d69d5c337p-41
	f64.add 	$push987=, $pop985, $pop986
	f64.mul 	$push988=, $0, $pop987
	f64.const	$push989=, 0x1.5c5345ca8d1a8p-33
	f64.add 	$push990=, $pop988, $pop989
	f64.mul 	$push991=, $0, $pop990
	f64.const	$push992=, 0x1.046530e354dcep-25
	f64.add 	$push993=, $pop991, $pop992
	f64.mul 	$push994=, $0, $pop993
	f64.const	$push995=, 0x1.729bd3db89d4p-18
	f64.add 	$push996=, $pop994, $pop995
	f64.mul 	$push997=, $0, $pop996
	f64.const	$push998=, 0x1.f86ee71374fcdp-11
	f64.add 	$push999=, $pop997, $pop998
	f64.mul 	$push1000=, $pop1375, $pop999
	f64.const	$push1001=, 0x1.878b7a1c25d07p-6
	f64.add 	$push1330=, $pop1000, $pop1001
	return  	$pop1330
.LBB0_17:                               # %sw.bb222
	end_block                       # label49:
	f64.add 	$push962=, $0, $0
	f64.const	$push963=, -0x1.fp4
	f64.add 	$push1378=, $pop962, $pop963
	tee_local	$push1377=, $0=, $pop1378
	f64.const	$push964=, 0x1.167ed2383a844p-48
	f64.mul 	$push965=, $0, $pop964
	f64.const	$push966=, 0x1.d2590594d1848p-41
	f64.add 	$push967=, $pop965, $pop966
	f64.mul 	$push968=, $0, $pop967
	f64.const	$push969=, 0x1.6e0ca63504f66p-33
	f64.add 	$push970=, $pop968, $pop969
	f64.mul 	$push971=, $0, $pop970
	f64.const	$push972=, 0x1.0f8db8e0a45c3p-25
	f64.add 	$push973=, $pop971, $pop972
	f64.mul 	$push974=, $0, $pop973
	f64.const	$push975=, 0x1.7f1221183d337p-18
	f64.add 	$push976=, $pop974, $pop975
	f64.mul 	$push977=, $0, $pop976
	f64.const	$push978=, 0x1.021ab7665e2dep-10
	f64.add 	$push979=, $pop977, $pop978
	f64.mul 	$push980=, $pop1377, $pop979
	f64.const	$push981=, 0x1.a771c970f7b9ep-6
	f64.add 	$push1329=, $pop980, $pop981
	return  	$pop1329
.LBB0_18:                               # %sw.bb237
	end_block                       # label48:
	f64.add 	$push942=, $0, $0
	f64.const	$push943=, -0x1.08p5
	f64.add 	$push1380=, $pop942, $pop943
	tee_local	$push1379=, $0=, $pop1380
	f64.const	$push944=, 0x1.27e96632d455fp-48
	f64.mul 	$push945=, $0, $pop944
	f64.const	$push946=, 0x1.ed449c2f3d75fp-41
	f64.add 	$push947=, $pop945, $pop946
	f64.mul 	$push948=, $0, $pop947
	f64.const	$push949=, 0x1.80c8fb9c090fap-33
	f64.add 	$push950=, $pop948, $pop949
	f64.mul 	$push951=, $0, $pop950
	f64.const	$push952=, 0x1.1b4996838dbc1p-25
	f64.add 	$push953=, $pop951, $pop952
	f64.mul 	$push954=, $0, $pop953
	f64.const	$push955=, 0x1.8c1396822f672p-18
	f64.add 	$push956=, $pop954, $pop955
	f64.mul 	$push957=, $0, $pop956
	f64.const	$push958=, 0x1.08305029e3ff2p-10
	f64.add 	$push959=, $pop957, $pop958
	f64.mul 	$push960=, $pop1379, $pop959
	f64.const	$push961=, 0x1.c814d72799a2p-6
	f64.add 	$push1328=, $pop960, $pop961
	return  	$pop1328
.LBB0_19:                               # %sw.bb252
	end_block                       # label47:
	f64.add 	$push922=, $0, $0
	f64.const	$push923=, -0x1.18p5
	f64.add 	$push1382=, $pop922, $pop923
	tee_local	$push1381=, $0=, $pop1382
	f64.const	$push924=, 0x1.3a73bf18375e2p-48
	f64.mul 	$push925=, $0, $pop924
	f64.const	$push926=, 0x1.04ef8d289d598p-40
	f64.add 	$push927=, $pop925, $pop926
	f64.mul 	$push928=, $0, $pop927
	f64.const	$push929=, 0x1.949929743e5f4p-33
	f64.add 	$push930=, $pop928, $pop929
	f64.mul 	$push931=, $0, $pop930
	f64.const	$push932=, 0x1.279d2fb27147fp-25
	f64.add 	$push933=, $pop931, $pop932
	f64.mul 	$push934=, $0, $pop933
	f64.const	$push935=, 0x1.99a3a3b55ba9ep-18
	f64.add 	$push936=, $pop934, $pop935
	f64.mul 	$push937=, $0, $pop936
	f64.const	$push938=, 0x1.0e7aed0628383p-10
	f64.add 	$push939=, $pop937, $pop938
	f64.mul 	$push940=, $pop1381, $pop939
	f64.const	$push941=, 0x1.e9813879c4114p-6
	f64.add 	$push1327=, $pop940, $pop941
	return  	$pop1327
.LBB0_20:                               # %sw.bb267
	end_block                       # label46:
	f64.add 	$push902=, $0, $0
	f64.const	$push903=, -0x1.28p5
	f64.add 	$push1384=, $pop902, $pop903
	tee_local	$push1383=, $0=, $pop1384
	f64.const	$push904=, 0x1.4e35d7fbf4617p-48
	f64.mul 	$push905=, $0, $pop904
	f64.const	$push906=, 0x1.1421f0df0657fp-40
	f64.add 	$push907=, $pop905, $pop906
	f64.mul 	$push908=, $0, $pop907
	f64.const	$push909=, 0x1.a993b4592b866p-33
	f64.add 	$push910=, $pop908, $pop909
	f64.mul 	$push911=, $0, $pop910
	f64.const	$push912=, 0x1.3495b6206fe24p-25
	f64.add 	$push913=, $pop911, $pop912
	f64.mul 	$push914=, $0, $pop913
	f64.const	$push915=, 0x1.a7cc9785b3accp-18
	f64.add 	$push916=, $pop914, $pop915
	f64.mul 	$push917=, $0, $pop916
	f64.const	$push918=, 0x1.14fb39c7a1eaap-10
	f64.add 	$push919=, $pop917, $pop918
	f64.mul 	$push920=, $pop1383, $pop919
	f64.const	$push921=, 0x1.05db76b3bb83dp-5
	f64.add 	$push1326=, $pop920, $pop921
	return  	$pop1326
.LBB0_21:                               # %sw.bb282
	end_block                       # label45:
	f64.add 	$push882=, $0, $0
	f64.const	$push883=, -0x1.38p5
	f64.add 	$push1386=, $pop882, $pop883
	tee_local	$push1385=, $0=, $pop1386
	f64.const	$push884=, 0x1.633e72c2b33b3p-48
	f64.mul 	$push885=, $0, $pop884
	f64.const	$push886=, 0x1.24489b0bcfd4cp-40
	f64.add 	$push887=, $pop885, $pop886
	f64.mul 	$push888=, $0, $pop887
	f64.const	$push889=, 0x1.bfc3de9893d59p-33
	f64.add 	$push890=, $pop888, $pop889
	f64.mul 	$push891=, $0, $pop890
	f64.const	$push892=, 0x1.4239c2a719fc4p-25
	f64.add 	$push893=, $pop891, $pop892
	f64.mul 	$push894=, $0, $pop893
	f64.const	$push895=, 0x1.b695512b2de5ap-18
	f64.add 	$push896=, $pop894, $pop895
	f64.mul 	$push897=, $0, $pop896
	f64.const	$push898=, 0x1.1bb7ec6af7c5ap-10
	f64.add 	$push899=, $pop897, $pop898
	f64.mul 	$push900=, $pop1385, $pop899
	f64.const	$push901=, 0x1.176145953586dp-5
	f64.add 	$push1325=, $pop900, $pop901
	return  	$pop1325
.LBB0_22:                               # %sw.bb297
	end_block                       # label44:
	f64.add 	$push862=, $0, $0
	f64.const	$push863=, -0x1.48p5
	f64.add 	$push1388=, $pop862, $pop863
	tee_local	$push1387=, $0=, $pop1388
	f64.const	$push864=, 0x1.79a58a8004affp-48
	f64.mul 	$push865=, $0, $pop864
	f64.const	$push866=, 0x1.35741e6f4452cp-40
	f64.add 	$push867=, $pop865, $pop866
	f64.mul 	$push868=, $0, $pop867
	f64.const	$push869=, 0x1.d745cdf4df966p-33
	f64.add 	$push870=, $pop868, $pop869
	f64.mul 	$push871=, $0, $pop870
	f64.const	$push872=, 0x1.509686f990786p-25
	f64.add 	$push873=, $pop871, $pop872
	f64.mul 	$push874=, $0, $pop873
	f64.const	$push875=, 0x1.c604afddc0ca6p-18
	f64.add 	$push876=, $pop874, $pop875
	f64.mul 	$push877=, $0, $pop876
	f64.const	$push878=, 0x1.22b104f029c92p-10
	f64.add 	$push879=, $pop877, $pop878
	f64.mul 	$push880=, $pop1387, $pop879
	f64.const	$push881=, 0x1.295421c044285p-5
	f64.add 	$push1324=, $pop880, $pop881
	return  	$pop1324
.LBB0_23:                               # %sw.bb312
	end_block                       # label43:
	f64.add 	$push842=, $0, $0
	f64.const	$push843=, -0x1.58p5
	f64.add 	$push1390=, $pop842, $pop843
	tee_local	$push1389=, $0=, $pop1390
	f64.const	$push844=, 0x1.91831a4779845p-48
	f64.mul 	$push845=, $0, $pop844
	f64.const	$push846=, 0x1.47b173735b59fp-40
	f64.add 	$push847=, $pop845, $pop846
	f64.mul 	$push848=, $0, $pop847
	f64.const	$push849=, 0x1.f02a65e2b3c19p-33
	f64.add 	$push850=, $pop848, $pop849
	f64.mul 	$push851=, $0, $pop850
	f64.const	$push852=, 0x1.5fb29bf163c7cp-25
	f64.add 	$push853=, $pop851, $pop852
	f64.mul 	$push854=, $0, $pop853
	f64.const	$push855=, 0x1.d626ba3f5ba98p-18
	f64.add 	$push856=, $pop854, $pop855
	f64.mul 	$push857=, $0, $pop856
	f64.const	$push858=, 0x1.29e6835737f54p-10
	f64.add 	$push859=, $pop857, $pop858
	f64.mul 	$push860=, $pop1389, $pop859
	f64.const	$push861=, 0x1.3bb83cf2cf95dp-5
	f64.add 	$push1323=, $pop860, $pop861
	return  	$pop1323
.LBB0_24:                               # %sw.bb327
	end_block                       # label42:
	f64.add 	$push822=, $0, $0
	f64.const	$push823=, -0x1.68p5
	f64.add 	$push1392=, $pop822, $pop823
	tee_local	$push1391=, $0=, $pop1392
	f64.const	$push824=, 0x1.aae99476e38a8p-48
	f64.mul 	$push825=, $0, $pop824
	f64.const	$push826=, 0x1.5b1d6ccaacc2cp-40
	f64.add 	$push827=, $pop825, $pop826
	f64.mul 	$push828=, $0, $pop827
	f64.const	$push829=, 0x1.054144eb5aa81p-32
	f64.add 	$push830=, $pop828, $pop829
	f64.mul 	$push831=, $0, $pop830
	f64.const	$push832=, 0x1.6f9d6634e4f2bp-25
	f64.add 	$push833=, $pop831, $pop832
	f64.mul 	$push834=, $0, $pop833
	f64.const	$push835=, 0x1.e70097b9f75b6p-18
	f64.add 	$push836=, $pop834, $pop835
	f64.mul 	$push837=, $0, $pop836
	f64.const	$push838=, 0x1.3165d3996fa83p-10
	f64.add 	$push839=, $pop837, $pop838
	f64.mul 	$push840=, $pop1391, $pop839
	f64.const	$push841=, 0x1.4e93e1c9b413ap-5
	f64.add 	$push1322=, $pop840, $pop841
	return  	$pop1322
.LBB0_25:                               # %sw.bb342
	end_block                       # label41:
	f64.add 	$push802=, $0, $0
	f64.const	$push803=, -0x1.78p5
	f64.add 	$push1394=, $pop802, $pop803
	tee_local	$push1393=, $0=, $pop1394
	f64.const	$push804=, 0x1.c5f67cd792795p-48
	f64.mul 	$push805=, $0, $pop804
	f64.const	$push806=, 0x1.6fbf3f21de835p-40
	f64.add 	$push807=, $pop805, $pop806
	f64.mul 	$push808=, $0, $pop807
	f64.const	$push809=, 0x1.13352fc9a645bp-32
	f64.add 	$push810=, $pop808, $pop809
	f64.mul 	$push811=, $0, $pop810
	f64.const	$push812=, 0x1.805fb190d49p-25
	f64.add 	$push813=, $pop811, $pop812
	f64.mul 	$push814=, $0, $pop813
	f64.const	$push815=, 0x1.f8a006bd80cbep-18
	f64.add 	$push816=, $pop814, $pop815
	f64.mul 	$push817=, $0, $pop816
	f64.const	$push818=, 0x1.392189bd8383bp-10
	f64.add 	$push819=, $pop817, $pop818
	f64.mul 	$push820=, $pop1393, $pop819
	f64.const	$push821=, 0x1.61e71044f1a1ap-5
	f64.add 	$push1321=, $pop820, $pop821
	return  	$pop1321
.LBB0_26:                               # %sw.bb357
	end_block                       # label40:
	f64.add 	$push782=, $0, $0
	f64.const	$push783=, -0x1.88p5
	f64.add 	$push1396=, $pop782, $pop783
	tee_local	$push1395=, $0=, $pop1396
	f64.const	$push784=, 0x1.e2c1ce7d17156p-48
	f64.mul 	$push785=, $0, $pop784
	f64.const	$push786=, 0x1.85b3bd2b88744p-40
	f64.add 	$push787=, $pop785, $pop786
	f64.mul 	$push788=, $0, $pop787
	f64.const	$push789=, 0x1.21ff066d70de7p-32
	f64.add 	$push790=, $pop788, $pop789
	f64.mul 	$push791=, $0, $pop790
	f64.const	$push792=, 0x1.9208e2ab83a8p-25
	f64.add 	$push793=, $pop791, $pop792
	f64.mul 	$push794=, $0, $pop793
	f64.const	$push795=, 0x1.0586cf27f6074p-17
	f64.add 	$push796=, $pop794, $pop795
	f64.mul 	$push797=, $0, $pop796
	f64.const	$push798=, 0x1.412711bcc0e61p-10
	f64.add 	$push799=, $pop797, $pop798
	f64.mul 	$push800=, $pop1395, $pop799
	f64.const	$push801=, 0x1.75ba2be0589adp-5
	f64.add 	$push1320=, $pop800, $pop801
	return  	$pop1320
.LBB0_27:                               # %sw.bb372
	end_block                       # label39:
	f64.add 	$push762=, $0, $0
	f64.const	$push763=, -0x1.98p5
	f64.add 	$push1398=, $pop762, $pop763
	tee_local	$push1397=, $0=, $pop1398
	f64.const	$push764=, 0x1.00b39a7a160dp-47
	f64.mul 	$push765=, $0, $pop764
	f64.const	$push766=, 0x1.9d095040f681cp-40
	f64.add 	$push767=, $pop765, $pop766
	f64.mul 	$push768=, $0, $pop767
	f64.const	$push769=, 0x1.31acdbb7ee971p-32
	f64.add 	$push770=, $pop768, $pop769
	f64.mul 	$push771=, $0, $pop770
	f64.const	$push772=, 0x1.a4a3f844e2f75p-25
	f64.add 	$push773=, $pop771, $pop772
	f64.mul 	$push774=, $0, $pop773
	f64.const	$push775=, 0x1.0f2ab2899438cp-17
	f64.add 	$push776=, $pop774, $pop775
	f64.mul 	$push777=, $0, $pop776
	f64.const	$push778=, 0x1.497d2193ce7e8p-10
	f64.add 	$push779=, $pop777, $pop778
	f64.mul 	$push780=, $pop1397, $pop779
	f64.const	$push781=, 0x1.8a0f4d7add15fp-5
	f64.add 	$push1319=, $pop780, $pop781
	return  	$pop1319
.LBB0_28:                               # %sw.bb387
	end_block                       # label38:
	f64.add 	$push742=, $0, $0
	f64.const	$push743=, -0x1.d8p5
	f64.add 	$push1400=, $pop742, $pop743
	tee_local	$push1399=, $0=, $pop1400
	f64.const	$push744=, 0x1.4870426dcdb0ep-47
	f64.mul 	$push745=, $0, $pop744
	f64.const	$push746=, 0x1.05189fcd8287bp-39
	f64.add 	$push747=, $pop745, $pop746
	f64.mul 	$push748=, $0, $pop747
	f64.const	$push749=, 0x1.7a62cc6986c28p-32
	f64.add 	$push750=, $pop748, $pop749
	f64.mul 	$push751=, $0, $pop750
	f64.const	$push752=, 0x1.f9cae3284854ep-25
	f64.add 	$push753=, $pop751, $pop752
	f64.mul 	$push754=, $0, $pop753
	f64.const	$push755=, 0x1.3a73b6897e136p-17
	f64.add 	$push756=, $pop754, $pop755
	f64.mul 	$push757=, $0, $pop756
	f64.const	$push758=, 0x1.6e01655acdabfp-10
	f64.add 	$push759=, $pop757, $pop758
	f64.mul 	$push760=, $pop1399, $pop759
	f64.const	$push761=, 0x1.e0e30446b69dbp-5
	f64.add 	$push1318=, $pop760, $pop761
	return  	$pop1318
.LBB0_29:                               # %sw.bb402
	end_block                       # label37:
	f64.add 	$push722=, $0, $0
	f64.const	$push723=, -0x1.3cp6
	f64.add 	$push1402=, $pop722, $pop723
	tee_local	$push1401=, $0=, $pop1402
	f64.const	$push724=, 0x1.2ee9801a347abp-46
	f64.mul 	$push725=, $0, $pop724
	f64.const	$push726=, 0x1.d9aa84ed5f7f8p-39
	f64.add 	$push727=, $pop725, $pop726
	f64.mul 	$push728=, $0, $pop727
	f64.const	$push729=, 0x1.487d76cb7622ap-31
	f64.add 	$push730=, $pop728, $pop729
	f64.mul 	$push731=, $0, $pop730
	f64.const	$push732=, 0x1.9a613c8cbadfcp-24
	f64.add 	$push733=, $pop731, $pop732
	f64.mul 	$push734=, $0, $pop733
	f64.const	$push735=, 0x1.d281dc526a9fdp-17
	f64.add 	$push736=, $pop734, $pop735
	f64.mul 	$push737=, $0, $pop736
	f64.const	$push738=, 0x1.e61ead6a30f64p-10
	f64.add 	$push739=, $pop737, $pop738
	f64.mul 	$push740=, $pop1401, $pop739
	f64.const	$push741=, 0x1.745bf26f1dc51p-4
	f64.add 	$push1317=, $pop740, $pop741
	return  	$pop1317
.LBB0_30:                               # %sw.bb417
	end_block                       # label36:
	f64.add 	$push702=, $0, $0
	f64.const	$push703=, -0x1.8cp6
	f64.add 	$push1404=, $pop702, $pop703
	tee_local	$push1403=, $0=, $pop1404
	f64.const	$push704=, 0x1.11ed4c2f43d7ep-45
	f64.mul 	$push705=, $0, $pop704
	f64.const	$push706=, 0x1.af109a3630d2ep-38
	f64.add 	$push707=, $pop705, $pop706
	f64.mul 	$push708=, $0, $pop707
	f64.const	$push709=, 0x1.22f550d281614p-30
	f64.add 	$push710=, $pop708, $pop709
	f64.mul 	$push711=, $0, $pop710
	f64.const	$push712=, 0x1.5782f0a3274a4p-23
	f64.add 	$push713=, $pop711, $pop712
	f64.mul 	$push714=, $0, $pop713
	f64.const	$push715=, 0x1.66c7e028f516cp-16
	f64.add 	$push716=, $pop714, $pop715
	f64.mul 	$push717=, $0, $pop716
	f64.const	$push718=, 0x1.4de48f6131734p-9
	f64.add 	$push719=, $pop717, $pop718
	f64.mul 	$push720=, $pop1403, $pop719
	f64.const	$push721=, 0x1.1350092ccf6bep-3
	f64.add 	$push1316=, $pop720, $pop721
	return  	$pop1316
.LBB0_31:                               # %sw.bb432
	end_block                       # label35:
	f64.add 	$push682=, $0, $0
	f64.const	$push683=, -0x1.dcp6
	f64.add 	$push1406=, $pop682, $pop683
	tee_local	$push1405=, $0=, $pop1406
	f64.const	$push684=, 0x1.dcc29389c0b3bp-45
	f64.mul 	$push685=, $0, $pop684
	f64.const	$push686=, 0x1.83c457cdf69a8p-37
	f64.add 	$push687=, $pop685, $pop686
	f64.mul 	$push688=, $0, $pop687
	f64.const	$push689=, 0x1.043a1711a52c6p-29
	f64.add 	$push690=, $pop688, $pop689
	f64.mul 	$push691=, $0, $pop690
	f64.const	$push692=, 0x1.270db3366ba97p-22
	f64.add 	$push693=, $pop691, $pop692
	f64.mul 	$push694=, $0, $pop693
	f64.const	$push695=, 0x1.1e049a3af6987p-15
	f64.add 	$push696=, $pop694, $pop695
	f64.mul 	$push697=, $0, $pop696
	f64.const	$push698=, 0x1.dc57844b53bb7p-9
	f64.add 	$push699=, $pop697, $pop698
	f64.mul 	$push700=, $pop1405, $pop699
	f64.const	$push701=, 0x1.902de00d1b717p-3
	f64.add 	$push1315=, $pop700, $pop701
	return  	$pop1315
.LBB0_32:                               # %sw.bb447
	end_block                       # label34:
	f64.add 	$push662=, $0, $0
	f64.const	$push663=, -0x1.e4p6
	f64.add 	$push1408=, $pop662, $pop663
	tee_local	$push1407=, $0=, $pop1408
	f64.const	$push664=, 0x1.f682fb42899afp-45
	f64.mul 	$push665=, $0, $pop664
	f64.const	$push666=, 0x1.9ab5097251322p-37
	f64.add 	$push667=, $pop665, $pop666
	f64.mul 	$push668=, $0, $pop667
	f64.const	$push669=, 0x1.13cfff76e3d9cp-29
	f64.add 	$push670=, $pop668, $pop669
	f64.mul 	$push671=, $0, $pop670
	f64.const	$push672=, 0x1.37cb0bef2ef1ep-22
	f64.add 	$push673=, $pop671, $pop672
	f64.mul 	$push674=, $0, $pop673
	f64.const	$push675=, 0x1.2c3c9655b9bd4p-15
	f64.add 	$push676=, $pop674, $pop675
	f64.mul 	$push677=, $0, $pop676
	f64.const	$push678=, 0x1.eea7122820b08p-9
	f64.add 	$push679=, $pop677, $pop678
	f64.mul 	$push680=, $pop1407, $pop679
	f64.const	$push681=, 0x1.9f5ad96a6a012p-3
	f64.add 	$push1314=, $pop680, $pop681
	return  	$pop1314
.LBB0_33:                               # %sw.bb462
	end_block                       # label33:
	f64.add 	$push642=, $0, $0
	f64.const	$push643=, -0x1.ecp6
	f64.add 	$push1410=, $pop642, $pop643
	tee_local	$push1409=, $0=, $pop1410
	f64.const	$push644=, 0x1.08ad32632c073p-44
	f64.mul 	$push645=, $0, $pop644
	f64.const	$push646=, 0x1.b2e9fd6fd80ddp-37
	f64.add 	$push647=, $pop645, $pop646
	f64.mul 	$push648=, $0, $pop647
	f64.const	$push649=, 0x1.245528d098f79p-29
	f64.add 	$push650=, $pop648, $pop649
	f64.mul 	$push651=, $0, $pop650
	f64.const	$push652=, 0x1.498ac7468b8cbp-22
	f64.add 	$push653=, $pop651, $pop652
	f64.mul 	$push654=, $0, $pop653
	f64.const	$push655=, 0x1.3b42baff5eb43p-15
	f64.add 	$push656=, $pop654, $pop655
	f64.mul 	$push657=, $0, $pop656
	f64.const	$push658=, 0x1.00f0c0c7dbcc4p-8
	f64.add 	$push659=, $pop657, $pop658
	f64.mul 	$push660=, $pop1409, $pop659
	f64.const	$push661=, 0x1.af1a9fbe76c8bp-3
	f64.add 	$push1313=, $pop660, $pop661
	return  	$pop1313
.LBB0_34:                               # %sw.bb477
	end_block                       # label32:
	f64.add 	$push622=, $0, $0
	f64.const	$push623=, -0x1.f4p6
	f64.add 	$push1412=, $pop622, $pop623
	tee_local	$push1411=, $0=, $pop1412
	f64.const	$push624=, 0x1.16a6b65650415p-44
	f64.mul 	$push625=, $0, $pop624
	f64.const	$push626=, 0x1.cc5a31eebbb9ep-37
	f64.add 	$push627=, $pop625, $pop626
	f64.mul 	$push628=, $0, $pop627
	f64.const	$push629=, 0x1.35d09c8f5e982p-29
	f64.add 	$push630=, $pop628, $pop629
	f64.mul 	$push631=, $0, $pop630
	f64.const	$push632=, 0x1.5c5aa3ac6e65cp-22
	f64.add 	$push633=, $pop631, $pop632
	f64.mul 	$push634=, $0, $pop633
	f64.const	$push635=, 0x1.4b261082509f2p-15
	f64.add 	$push636=, $pop634, $pop635
	f64.mul 	$push637=, $0, $pop636
	f64.const	$push638=, 0x1.0b0a1f3db2e8fp-8
	f64.add 	$push639=, $pop637, $pop638
	f64.mul 	$push640=, $pop1411, $pop639
	f64.const	$push641=, 0x1.bf77af640639dp-3
	f64.add 	$push1312=, $pop640, $pop641
	return  	$pop1312
.LBB0_35:                               # %sw.bb492
	end_block                       # label31:
	f64.add 	$push602=, $0, $0
	f64.const	$push603=, -0x1.fcp6
	f64.add 	$push1414=, $pop602, $pop603
	tee_local	$push1413=, $0=, $pop1414
	f64.const	$push604=, 0x1.252f30a08e99p-44
	f64.mul 	$push605=, $0, $pop604
	f64.const	$push606=, 0x1.e729ae4e3a05p-37
	f64.add 	$push607=, $pop605, $pop606
	f64.mul 	$push608=, $0, $pop607
	f64.const	$push609=, 0x1.48506d9468e04p-29
	f64.add 	$push610=, $pop608, $pop609
	f64.mul 	$push611=, $0, $pop610
	f64.const	$push612=, 0x1.704b1f40c0981p-22
	f64.add 	$push613=, $pop611, $pop612
	f64.mul 	$push614=, $0, $pop613
	f64.const	$push615=, 0x1.5bef2de483919p-15
	f64.add 	$push616=, $pop614, $pop615
	f64.mul 	$push617=, $0, $pop616
	f64.const	$push618=, 0x1.15a65a723c5d8p-8
	f64.add 	$push619=, $pop617, $pop618
	f64.mul 	$push620=, $pop1413, $pop619
	f64.const	$push621=, 0x1.d07c84b5dcc64p-3
	f64.add 	$push1311=, $pop620, $pop621
	return  	$pop1311
.LBB0_36:                               # %sw.bb507
	end_block                       # label30:
	f64.add 	$push582=, $0, $0
	f64.const	$push583=, -0x1.02p7
	f64.add 	$push1416=, $pop582, $pop583
	tee_local	$push1415=, $0=, $pop1416
	f64.const	$push584=, 0x1.3448ef8da1489p-44
	f64.mul 	$push585=, $0, $pop584
	f64.const	$push586=, 0x1.01ac394729779p-36
	f64.add 	$push587=, $pop585, $pop586
	f64.mul 	$push588=, $0, $pop587
	f64.const	$push589=, 0x1.5be2aec0ebf4bp-29
	f64.add 	$push590=, $pop588, $pop589
	f64.mul 	$push591=, $0, $pop590
	f64.const	$push592=, 0x1.856cb8236b3ecp-22
	f64.add 	$push593=, $pop591, $pop592
	f64.mul 	$push594=, $0, $pop593
	f64.const	$push595=, 0x1.6db166f35cb72p-15
	f64.add 	$push596=, $pop594, $pop595
	f64.mul 	$push597=, $0, $pop596
	f64.const	$push598=, 0x1.20cc28621ed91p-8
	f64.add 	$push599=, $pop597, $pop598
	f64.mul 	$push600=, $pop1415, $pop599
	f64.const	$push601=, 0x1.e2339c0ebedfap-3
	f64.add 	$push1310=, $pop600, $pop601
	return  	$pop1310
.LBB0_37:                               # %sw.bb522
	end_block                       # label29:
	f64.add 	$push562=, $0, $0
	f64.const	$push563=, -0x1.06p7
	f64.add 	$push1418=, $pop562, $pop563
	tee_local	$push1417=, $0=, $pop1418
	f64.const	$push564=, 0x1.43f51a43656d1p-44
	f64.mul 	$push565=, $0, $pop564
	f64.const	$push566=, 0x1.107c412f52afep-36
	f64.add 	$push567=, $pop565, $pop566
	f64.mul 	$push568=, $0, $pop567
	f64.const	$push569=, 0x1.7098f7ae69034p-29
	f64.add 	$push570=, $pop568, $pop569
	f64.mul 	$push571=, $0, $pop570
	f64.const	$push572=, 0x1.9bcd2cc45b459p-22
	f64.add 	$push573=, $pop571, $pop572
	f64.mul 	$push574=, $0, $pop573
	f64.const	$push575=, 0x1.807778764d281p-15
	f64.add 	$push576=, $pop574, $pop575
	f64.mul 	$push577=, $0, $pop576
	f64.const	$push578=, 0x1.2c83ec892ab69p-8
	f64.add 	$push579=, $pop577, $pop578
	f64.mul 	$push580=, $pop1417, $pop579
	f64.const	$push581=, 0x1.f49cf56eac86p-3
	f64.add 	$push1309=, $pop580, $pop581
	return  	$pop1309
.LBB0_38:                               # %sw.bb537
	end_block                       # label28:
	f64.add 	$push542=, $0, $0
	f64.const	$push543=, -0x1.0ap7
	f64.add 	$push1420=, $pop542, $pop543
	tee_local	$push1419=, $0=, $pop1420
	f64.const	$push544=, 0x1.5434d7e7b823ap-44
	f64.mul 	$push545=, $0, $pop544
	f64.const	$push546=, 0x1.200df0b7681fp-36
	f64.add 	$push547=, $pop545, $pop546
	f64.mul 	$push548=, $0, $pop547
	f64.const	$push549=, 0x1.867a51cd7a1e6p-29
	f64.add 	$push550=, $pop548, $pop549
	f64.mul 	$push551=, $0, $pop550
	f64.const	$push552=, 0x1.b3853a536e553p-22
	f64.add 	$push553=, $pop551, $pop552
	f64.mul 	$push554=, $0, $pop553
	f64.const	$push555=, 0x1.945290793d0b5p-15
	f64.add 	$push556=, $pop554, $pop555
	f64.mul 	$push557=, $0, $pop556
	f64.const	$push558=, 0x1.38d60a633051p-8
	f64.add 	$push559=, $pop557, $pop558
	f64.mul 	$push560=, $pop1419, $pop559
	f64.const	$push561=, 0x1.03e1869835159p-2
	f64.add 	$push1308=, $pop560, $pop561
	return  	$pop1308
.LBB0_39:                               # %sw.bb552
	end_block                       # label27:
	f64.add 	$push522=, $0, $0
	f64.const	$push523=, -0x1.0ep7
	f64.add 	$push1422=, $pop522, $pop523
	tee_local	$push1421=, $0=, $pop1422
	f64.const	$push524=, 0x1.65094fa076898p-44
	f64.mul 	$push525=, $0, $pop524
	f64.const	$push526=, 0x1.3065c8cb517eep-36
	f64.add 	$push527=, $pop525, $pop526
	f64.mul 	$push528=, $0, $pop527
	f64.const	$push529=, 0x1.9d9f5e283a865p-29
	f64.add 	$push530=, $pop528, $pop529
	f64.mul 	$push531=, $0, $pop530
	f64.const	$push532=, 0x1.cca55ef08d88ap-22
	f64.add 	$push533=, $pop531, $pop532
	f64.mul 	$push534=, $0, $pop533
	f64.const	$push535=, 0x1.a951b7469782dp-15
	f64.add 	$push536=, $pop534, $pop535
	f64.mul 	$push537=, $0, $pop536
	f64.const	$push538=, 0x1.45cc92eb29af2p-8
	f64.add 	$push539=, $pop537, $pop538
	f64.mul 	$push540=, $pop1421, $pop539
	f64.const	$push541=, 0x1.0ddd6e04c0592p-2
	f64.add 	$push1307=, $pop540, $pop541
	return  	$pop1307
.LBB0_40:                               # %sw.bb567
	end_block                       # label26:
	f64.add 	$push502=, $0, $0
	f64.const	$push503=, -0x1.12p7
	f64.add 	$push1424=, $pop502, $pop503
	tee_local	$push1423=, $0=, $pop1424
	f64.const	$push504=, 0x1.7672816da09eap-44
	f64.mul 	$push505=, $0, $pop504
	f64.const	$push506=, 0x1.41884a56f6894p-36
	f64.add 	$push507=, $pop505, $pop506
	f64.mul 	$push508=, $0, $pop507
	f64.const	$push509=, 0x1.b612aae79156ap-29
	f64.add 	$push510=, $pop508, $pop509
	f64.mul 	$push511=, $0, $pop510
	f64.const	$push512=, 0x1.e740d86b9e2a1p-22
	f64.add 	$push513=, $pop511, $pop512
	f64.mul 	$push514=, $0, $pop513
	f64.const	$push515=, 0x1.bf8840abc1ba5p-15
	f64.add 	$push516=, $pop514, $pop515
	f64.mul 	$push517=, $0, $pop516
	f64.const	$push518=, 0x1.536e3c1dbd803p-8
	f64.add 	$push519=, $pop517, $pop518
	f64.mul 	$push520=, $pop1423, $pop519
	f64.const	$push521=, 0x1.184230fcf80dcp-2
	f64.add 	$push1306=, $pop520, $pop521
	return  	$pop1306
.LBB0_41:                               # %sw.bb582
	end_block                       # label25:
	f64.add 	$push482=, $0, $0
	f64.const	$push483=, -0x1.16p7
	f64.add 	$push1426=, $pop482, $pop483
	tee_local	$push1425=, $0=, $pop1426
	f64.const	$push484=, 0x1.88706d4f3663p-44
	f64.mul 	$push485=, $0, $pop484
	f64.const	$push486=, 0x1.5382f81e0e6bap-36
	f64.add 	$push487=, $pop485, $pop486
	f64.mul 	$push488=, $0, $pop487
	f64.const	$push489=, 0x1.cfe24aecb2b41p-29
	f64.add 	$push490=, $pop488, $pop489
	f64.mul 	$push491=, $0, $pop490
	f64.const	$push492=, 0x1.01b6d22240d98p-21
	f64.add 	$push493=, $pop491, $pop492
	f64.mul 	$push494=, $0, $pop493
	f64.const	$push495=, 0x1.d70534f326d3bp-15
	f64.add 	$push496=, $pop494, $pop495
	f64.mul 	$push497=, $0, $pop496
	f64.const	$push498=, 0x1.61c871f439226p-8
	f64.add 	$push499=, $pop497, $pop498
	f64.mul 	$push500=, $pop1425, $pop499
	f64.const	$push501=, 0x1.23150dae3e6c5p-2
	f64.add 	$push1305=, $pop500, $pop501
	return  	$pop1305
.LBB0_42:                               # %sw.bb597
	end_block                       # label24:
	f64.add 	$push462=, $0, $0
	f64.const	$push463=, -0x1.1ap7
	f64.add 	$push1428=, $pop462, $pop463
	tee_local	$push1427=, $0=, $pop1428
	f64.const	$push464=, 0x1.9b01ec1f5ab98p-44
	f64.mul 	$push465=, $0, $pop464
	f64.const	$push466=, 0x1.6655d22099262p-36
	f64.add 	$push467=, $pop465, $pop466
	f64.mul 	$push468=, $0, $pop467
	f64.const	$push469=, 0x1.eb235a896cd5bp-29
	f64.add 	$push470=, $pop468, $pop469
	f64.mul 	$push471=, $0, $pop470
	f64.const	$push472=, 0x1.10a23fd58ae5ep-21
	f64.add 	$push473=, $pop471, $pop472
	f64.mul 	$push474=, $0, $pop473
	f64.const	$push475=, 0x1.efe0336d26046p-15
	f64.add 	$push476=, $pop474, $pop475
	f64.mul 	$push477=, $0, $pop476
	f64.const	$push478=, 0x1.70e397ea6cf0cp-8
	f64.add 	$push479=, $pop477, $pop478
	f64.mul 	$push480=, $pop1427, $pop479
	f64.const	$push481=, 0x1.2e60807357e67p-2
	f64.add 	$push1304=, $pop480, $pop481
	return  	$pop1304
.LBB0_43:                               # %sw.bb612
	end_block                       # label23:
	f64.add 	$push442=, $0, $0
	f64.const	$push443=, -0x1.1ep7
	f64.add 	$push1430=, $pop442, $pop443
	tee_local	$push1429=, $0=, $pop1430
	f64.const	$push444=, 0x1.ae26fdde0da22p-44
	f64.mul 	$push445=, $0, $pop444
	f64.const	$push446=, 0x1.7a0e5b224de62p-36
	f64.add 	$push447=, $pop445, $pop446
	f64.mul 	$push448=, $0, $pop447
	f64.const	$push449=, 0x1.03f1f64f79f02p-28
	f64.add 	$push450=, $pop448, $pop449
	f64.mul 	$push451=, $0, $pop450
	f64.const	$push452=, 0x1.206db40f9df7p-21
	f64.add 	$push453=, $pop451, $pop452
	f64.mul 	$push454=, $0, $pop453
	f64.const	$push455=, 0x1.051647f3923c1p-14
	f64.add 	$push456=, $pop454, $pop455
	f64.mul 	$push457=, $0, $pop456
	f64.const	$push458=, 0x1.80c9befb52f21p-8
	f64.add 	$push459=, $pop457, $pop458
	f64.mul 	$push460=, $pop1429, $pop459
	f64.const	$push461=, 0x1.3a272862f598ap-2
	f64.add 	$push1303=, $pop460, $pop461
	return  	$pop1303
.LBB0_44:                               # %sw.bb627
	end_block                       # label22:
	f64.add 	$push422=, $0, $0
	f64.const	$push423=, -0x1.22p7
	f64.add 	$push1432=, $pop422, $pop423
	tee_local	$push1431=, $0=, $pop1432
	f64.const	$push424=, 0x1.c1de7b6571ffbp-44
	f64.mul 	$push425=, $0, $pop424
	f64.const	$push426=, 0x1.8eac93232cabap-36
	f64.add 	$push427=, $pop425, $pop426
	f64.mul 	$push428=, $0, $pop427
	f64.const	$push429=, 0x1.131e511bb18ap-28
	f64.add 	$push430=, $pop428, $pop429
	f64.mul 	$push431=, $0, $pop430
	f64.const	$push432=, 0x1.31242d906ac99p-21
	f64.add 	$push433=, $pop431, $pop432
	f64.mul 	$push434=, $0, $pop433
	f64.const	$push435=, 0x1.12fecf1743ad4p-14
	f64.add 	$push436=, $pop434, $pop435
	f64.mul 	$push437=, $0, $pop436
	f64.const	$push438=, 0x1.918a009f62307p-8
	f64.add 	$push439=, $pop437, $pop438
	f64.mul 	$push440=, $pop1431, $pop439
	f64.const	$push441=, 0x1.466e43aa79bbbp-2
	f64.add 	$push1302=, $pop440, $pop441
	return  	$pop1302
.LBB0_45:                               # %sw.bb642
	end_block                       # label21:
	f64.add 	$push402=, $0, $0
	f64.const	$push403=, -0x1.26p7
	f64.add 	$push1434=, $pop402, $pop403
	tee_local	$push1433=, $0=, $pop1434
	f64.const	$push404=, 0x1.d62179d259236p-44
	f64.mul 	$push405=, $0, $pop404
	f64.const	$push406=, 0x1.a43dfce6eca43p-36
	f64.add 	$push407=, $pop405, $pop406
	f64.mul 	$push408=, $0, $pop407
	f64.const	$push409=, 0x1.231c04bdd0c64p-28
	f64.add 	$push410=, $pop408, $pop409
	f64.mul 	$push411=, $0, $pop410
	f64.const	$push412=, 0x1.42d62a77da788p-21
	f64.add 	$push413=, $pop411, $pop412
	f64.mul 	$push414=, $0, $pop413
	f64.const	$push415=, 0x1.21b57ec9d6f09p-14
	f64.add 	$push416=, $pop414, $pop415
	f64.mul 	$push417=, $0, $pop416
	f64.const	$push418=, 0x1.a32e6dd194b2bp-8
	f64.add 	$push419=, $pop417, $pop418
	f64.mul 	$push420=, $pop1433, $pop419
	f64.const	$push421=, 0x1.53404ea4a8c15p-2
	f64.add 	$push1301=, $pop420, $pop421
	return  	$pop1301
.LBB0_46:                               # %sw.bb657
	end_block                       # label20:
	f64.add 	$push382=, $0, $0
	f64.const	$push383=, -0x1.2ap7
	f64.add 	$push1436=, $pop382, $pop383
	tee_local	$push1435=, $0=, $pop1436
	f64.const	$push384=, 0x1.eaeff924c30d3p-44
	f64.mul 	$push385=, $0, $pop384
	f64.const	$push386=, 0x1.bac2986d8dcfdp-36
	f64.add 	$push387=, $pop385, $pop386
	f64.mul 	$push388=, $0, $pop387
	f64.const	$push389=, 0x1.33f59f5ebec07p-28
	f64.add 	$push390=, $pop388, $pop389
	f64.mul 	$push391=, $0, $pop390
	f64.const	$push392=, 0x1.558d49addfa8fp-21
	f64.add 	$push393=, $pop391, $pop392
	f64.mul 	$push394=, $0, $pop393
	f64.const	$push395=, 0x1.314626b37ba09p-14
	f64.add 	$push396=, $pop394, $pop395
	f64.mul 	$push397=, $0, $pop396
	f64.const	$push398=, 0x1.b5c4728b37d7p-8
	f64.add 	$push399=, $pop397, $pop398
	f64.mul 	$push400=, $pop1435, $pop399
	f64.const	$push401=, 0x1.60a5269595feep-2
	f64.add 	$push1300=, $pop400, $pop401
	return  	$pop1300
.LBB0_47:                               # %sw.bb672
	end_block                       # label19:
	f64.add 	$push362=, $0, $0
	f64.const	$push363=, -0x1.2ep7
	f64.add 	$push1438=, $pop362, $pop363
	tee_local	$push1437=, $0=, $pop1438
	f64.const	$push364=, 0x1.002a2cd8bae1cp-43
	f64.mul 	$push365=, $0, $pop364
	f64.const	$push366=, 0x1.d247e87ac75bfp-36
	f64.add 	$push367=, $pop365, $pop366
	f64.mul 	$push368=, $0, $pop367
	f64.const	$push369=, 0x1.45b5af2762942p-28
	f64.add 	$push370=, $pop368, $pop369
	f64.mul 	$push371=, $0, $pop370
	f64.const	$push372=, 0x1.6958a97a655e7p-21
	f64.add 	$push373=, $pop371, $pop372
	f64.mul 	$push374=, $0, $pop373
	f64.const	$push375=, 0x1.41bebc3dde5cfp-14
	f64.add 	$push376=, $pop374, $pop375
	f64.mul 	$push377=, $0, $pop376
	f64.const	$push378=, 0x1.c95b2844c2a7bp-8
	f64.add 	$push379=, $pop377, $pop378
	f64.mul 	$push380=, $pop1437, $pop379
	f64.const	$push381=, 0x1.6e9f6a93f290bp-2
	f64.add 	$push1299=, $pop380, $pop381
	return  	$pop1299
.LBB0_48:                               # %sw.bb687
	end_block                       # label18:
	f64.add 	$push342=, $0, $0
	f64.const	$push343=, -0x1.32p7
	f64.add 	$push1440=, $pop342, $pop343
	tee_local	$push1439=, $0=, $pop1440
	f64.const	$push344=, 0x1.0b1bc641957fap-43
	f64.mul 	$push345=, $0, $pop344
	f64.const	$push346=, 0x1.eacded0e9948ap-36
	f64.add 	$push347=, $pop345, $pop346
	f64.mul 	$push348=, $0, $pop347
	f64.const	$push349=, 0x1.5866c240a35cdp-28
	f64.add 	$push350=, $pop348, $pop349
	f64.mul 	$push351=, $0, $pop350
	f64.const	$push352=, 0x1.7e48c7fd54b3fp-21
	f64.add 	$push353=, $pop351, $pop352
	f64.mul 	$push354=, $0, $pop353
	f64.const	$push355=, 0x1.532b0f112ec05p-14
	f64.add 	$push356=, $pop354, $pop355
	f64.mul 	$push357=, $0, $pop356
	f64.const	$push358=, 0x1.de01a876ac2ecp-8
	f64.add 	$push359=, $pop357, $pop358
	f64.mul 	$push360=, $pop1439, $pop359
	f64.const	$push361=, 0x1.7d3c36113404fp-2
	f64.add 	$push1298=, $pop360, $pop361
	return  	$pop1298
.LBB0_49:                               # %sw.bb702
	end_block                       # label17:
	f64.add 	$push322=, $0, $0
	f64.const	$push323=, -0x1.36p7
	f64.add 	$push1442=, $pop322, $pop323
	tee_local	$push1441=, $0=, $pop1442
	f64.const	$push324=, 0x1.16528c8a42f2p-43
	f64.mul 	$push325=, $0, $pop324
	f64.const	$push326=, 0x1.022ed4006984cp-35
	f64.add 	$push327=, $pop325, $pop326
	f64.mul 	$push328=, $0, $pop327
	f64.const	$push329=, 0x1.6c11a47741b18p-28
	f64.add 	$push330=, $pop328, $pop329
	f64.mul 	$push331=, $0, $pop330
	f64.const	$push332=, 0x1.946b63a69a956p-21
	f64.add 	$push333=, $pop331, $pop332
	f64.mul 	$push334=, $0, $pop333
	f64.const	$push335=, 0x1.659a2777d7ecbp-14
	f64.add 	$push336=, $pop334, $pop335
	f64.mul 	$push337=, $0, $pop336
	f64.const	$push338=, 0x1.f3c70c996b767p-8
	f64.add 	$push339=, $pop337, $pop338
	f64.mul 	$push340=, $pop1441, $pop339
	f64.const	$push341=, 0x1.8c8366516db0ep-2
	f64.add 	$push1297=, $pop340, $pop341
	return  	$pop1297
.LBB0_50:                               # %sw.bb717
	end_block                       # label16:
	f64.add 	$push302=, $0, $0
	f64.const	$push303=, -0x1.3ap7
	f64.add 	$push1444=, $pop302, $pop303
	tee_local	$push1443=, $0=, $pop1444
	f64.const	$push304=, 0x1.21c2f83820157p-43
	f64.mul 	$push305=, $0, $pop304
	f64.const	$push306=, 0x1.0f800d94a2092p-35
	f64.add 	$push307=, $pop305, $pop306
	f64.mul 	$push308=, $0, $pop307
	f64.const	$push309=, 0x1.80c0e3f424adbp-28
	f64.add 	$push310=, $pop308, $pop309
	f64.mul 	$push311=, $0, $pop310
	f64.const	$push312=, 0x1.abd0fa96201dcp-21
	f64.add 	$push313=, $pop311, $pop312
	f64.mul 	$push314=, $0, $pop313
	f64.const	$push315=, 0x1.791b0dbc4504p-14
	f64.add 	$push316=, $pop314, $pop315
	f64.mul 	$push317=, $0, $pop316
	f64.const	$push318=, 0x1.055d3712bbc46p-7
	f64.add 	$push319=, $pop317, $pop318
	f64.mul 	$push320=, $pop1443, $pop319
	f64.const	$push321=, 0x1.9c7cd898b2e9dp-2
	f64.add 	$push1296=, $pop320, $pop321
	return  	$pop1296
.LBB0_51:                               # %sw.bb732
	end_block                       # label15:
	f64.add 	$push282=, $0, $0
	f64.const	$push283=, -0x1.3ep7
	f64.add 	$push1446=, $pop282, $pop283
	tee_local	$push1445=, $0=, $pop1446
	f64.const	$push284=, 0x1.2d72cd087e7bbp-43
	f64.mul 	$push285=, $0, $pop284
	f64.const	$push286=, 0x1.1d5aa343f6318p-35
	f64.add 	$push287=, $pop285, $pop286
	f64.mul 	$push288=, $0, $pop287
	f64.const	$push289=, 0x1.9680d13c59f19p-28
	f64.add 	$push290=, $pop288, $pop289
	f64.mul 	$push291=, $0, $pop290
	f64.const	$push292=, 0x1.c488ab13d0509p-21
	f64.add 	$push293=, $pop291, $pop292
	f64.mul 	$push294=, $0, $pop293
	f64.const	$push295=, 0x1.8dbbb74822a5fp-14
	f64.add 	$push296=, $pop294, $pop295
	f64.mul 	$push297=, $0, $pop296
	f64.const	$push298=, 0x1.1177f7886239bp-7
	f64.add 	$push299=, $pop297, $pop298
	f64.mul 	$push300=, $pop1445, $pop299
	f64.const	$push301=, 0x1.ad330941c8217p-2
	f64.add 	$push1295=, $pop300, $pop301
	return  	$pop1295
.LBB0_52:                               # %sw.bb747
	end_block                       # label14:
	f64.add 	$push262=, $0, $0
	f64.const	$push263=, -0x1.42p7
	f64.add 	$push1448=, $pop262, $pop263
	tee_local	$push1447=, $0=, $pop1448
	f64.const	$push264=, 0x1.39620afb5e24cp-43
	f64.mul 	$push265=, $0, $pop264
	f64.const	$push266=, 0x1.2bc315fa4db79p-35
	f64.add 	$push267=, $pop265, $pop266
	f64.mul 	$push268=, $0, $pop267
	f64.const	$push269=, 0x1.ad5bfa78c898bp-28
	f64.add 	$push270=, $pop268, $pop269
	f64.mul 	$push271=, $0, $pop270
	f64.const	$push272=, 0x1.dea712c78e8fap-21
	f64.add 	$push273=, $pop271, $pop272
	f64.mul 	$push274=, $0, $pop273
	f64.const	$push275=, 0x1.a383a840a6635p-14
	f64.add 	$push276=, $pop274, $pop275
	f64.mul 	$push277=, $0, $pop276
	f64.const	$push278=, 0x1.1e3c2b2979761p-7
	f64.add 	$push279=, $pop277, $pop278
	f64.mul 	$push280=, $pop1447, $pop279
	f64.const	$push281=, 0x1.beadd590c0adp-2
	f64.add 	$push1294=, $pop280, $pop281
	return  	$pop1294
.LBB0_53:                               # %sw.bb762
	end_block                       # label13:
	f64.add 	$push242=, $0, $0
	f64.const	$push243=, -0x1.46p7
	f64.add 	$push1450=, $pop242, $pop243
	tee_local	$push1449=, $0=, $pop1450
	f64.const	$push244=, 0x1.457f66d8ca5b7p-43
	f64.mul 	$push245=, $0, $pop244
	f64.const	$push246=, 0x1.3abde6a390555p-35
	f64.add 	$push247=, $pop245, $pop246
	f64.mul 	$push248=, $0, $pop247
	f64.const	$push249=, 0x1.c55b2b76313ap-28
	f64.add 	$push250=, $pop248, $pop249
	f64.mul 	$push251=, $0, $pop250
	f64.const	$push252=, 0x1.fa3b4ff945de5p-21
	f64.add 	$push253=, $pop251, $pop252
	f64.mul 	$push254=, $0, $pop253
	f64.const	$push255=, 0x1.ba9ff98511a24p-14
	f64.add 	$push256=, $pop254, $pop255
	f64.mul 	$push257=, $0, $pop256
	f64.const	$push258=, 0x1.2bb4b9b090562p-7
	f64.add 	$push259=, $pop257, $pop258
	f64.mul 	$push260=, $pop1449, $pop259
	f64.const	$push261=, 0x1.d0fcf80dc3372p-2
	f64.add 	$push1293=, $pop260, $pop261
	return  	$pop1293
.LBB0_54:                               # %sw.bb777
	end_block                       # label12:
	f64.add 	$push222=, $0, $0
	f64.const	$push223=, -0x1.4ap7
	f64.add 	$push1452=, $pop222, $pop223
	tee_local	$push1451=, $0=, $pop1452
	f64.const	$push224=, 0x1.51d6681b66433p-43
	f64.mul 	$push225=, $0, $pop224
	f64.const	$push226=, 0x1.4a48d4c9ca2dbp-35
	f64.add 	$push227=, $pop225, $pop226
	f64.mul 	$push228=, $0, $pop227
	f64.const	$push229=, 0x1.de8c7715c7fa3p-28
	f64.add 	$push230=, $pop228, $pop229
	f64.mul 	$push231=, $0, $pop230
	f64.const	$push232=, 0x1.0bac503c6dc37p-20
	f64.add 	$push233=, $pop231, $pop232
	f64.mul 	$push234=, $0, $pop233
	f64.const	$push235=, 0x1.d30926f02ed1ap-14
	f64.add 	$push236=, $pop234, $pop235
	f64.mul 	$push237=, $0, $pop236
	f64.const	$push238=, 0x1.39ea06997734fp-7
	f64.add 	$push239=, $pop237, $pop238
	f64.mul 	$push240=, $pop1451, $pop239
	f64.const	$push241=, 0x1.e42aed1394318p-2
	f64.add 	$push1292=, $pop240, $pop241
	return  	$pop1292
.LBB0_55:                               # %sw.bb792
	end_block                       # label11:
	f64.add 	$push202=, $0, $0
	f64.const	$push203=, -0x1.4ep7
	f64.add 	$push1454=, $pop202, $pop203
	tee_local	$push1453=, $0=, $pop1454
	f64.const	$push204=, 0x1.5e5b87488eb8ap-43
	f64.mul 	$push205=, $0, $pop204
	f64.const	$push206=, 0x1.5a6aa1ced6d78p-35
	f64.add 	$push207=, $pop205, $pop206
	f64.mul 	$push208=, $0, $pop207
	f64.const	$push209=, 0x1.f8fa6b8073f4dp-28
	f64.add 	$push210=, $pop208, $pop209
	f64.mul 	$push211=, $0, $pop210
	f64.const	$push212=, 0x1.1b09d0f71975ap-20
	f64.add 	$push213=, $pop211, $pop212
	f64.mul 	$push214=, $0, $pop213
	f64.const	$push215=, 0x1.ecd4aa10e0221p-14
	f64.add 	$push216=, $pop214, $pop215
	f64.mul 	$push217=, $0, $pop216
	f64.const	$push218=, 0x1.48e4755ffe6d6p-7
	f64.add 	$push219=, $pop217, $pop218
	f64.mul 	$push220=, $pop1453, $pop219
	f64.const	$push221=, 0x1.f83f91e646f15p-2
	f64.add 	$push1291=, $pop220, $pop221
	return  	$pop1291
.LBB0_56:                               # %sw.bb807
	end_block                       # label10:
	f64.add 	$push182=, $0, $0
	f64.const	$push183=, -0x1.52p7
	f64.add 	$push1456=, $pop182, $pop183
	tee_local	$push1455=, $0=, $pop1456
	f64.const	$push184=, 0x1.6b0900a2f22ap-43
	f64.mul 	$push185=, $0, $pop184
	f64.const	$push186=, 0x1.6b210d3cc275ep-35
	f64.add 	$push187=, $pop185, $pop186
	f64.mul 	$push188=, $0, $pop187
	f64.const	$push189=, 0x1.0a58ac9da165p-27
	f64.add 	$push190=, $pop188, $pop189
	f64.mul 	$push191=, $0, $pop190
	f64.const	$push192=, 0x1.2b3999c8a140ap-20
	f64.add 	$push193=, $pop191, $pop192
	f64.mul 	$push194=, $0, $pop193
	f64.const	$push195=, 0x1.040bfe3b03e21p-13
	f64.add 	$push196=, $pop194, $pop195
	f64.mul 	$push197=, $0, $pop196
	f64.const	$push198=, 0x1.58b827fa1a0cfp-7
	f64.add 	$push199=, $pop197, $pop198
	f64.mul 	$push200=, $pop1455, $pop199
	f64.const	$push201=, 0x1.06a550870110ap-1
	f64.add 	$push1290=, $pop200, $pop201
	return  	$pop1290
.LBB0_57:                               # %sw.bb822
	end_block                       # label9:
	f64.add 	$push162=, $0, $0
	f64.const	$push163=, -0x1.56p7
	f64.add 	$push1458=, $pop162, $pop163
	tee_local	$push1457=, $0=, $pop1458
	f64.const	$push164=, 0x1.77ded42a90976p-43
	f64.mul 	$push165=, $0, $pop164
	f64.const	$push166=, 0x1.7c72d875689f8p-35
	f64.add 	$push167=, $pop165, $pop166
	f64.mul 	$push168=, $0, $pop167
	f64.const	$push169=, 0x1.18dde7378dcacp-27
	f64.add 	$push170=, $pop168, $pop169
	f64.mul 	$push171=, $0, $pop170
	f64.const	$push172=, 0x1.3c530808e4b56p-20
	f64.add 	$push173=, $pop171, $pop172
	f64.mul 	$push174=, $0, $pop173
	f64.const	$push175=, 0x1.1279aa3afc804p-13
	f64.add 	$push176=, $pop174, $pop175
	f64.mul 	$push177=, $0, $pop176
	f64.const	$push178=, 0x1.696e58a32f449p-7
	f64.add 	$push179=, $pop177, $pop178
	f64.mul 	$push180=, $pop1457, $pop179
	f64.const	$push181=, 0x1.11adea897635ep-1
	f64.add 	$push1289=, $pop180, $pop181
	return  	$pop1289
.LBB0_58:                               # %sw.bb837
	end_block                       # label8:
	f64.add 	$push142=, $0, $0
	f64.const	$push143=, -0x1.5ap7
	f64.add 	$push1460=, $pop142, $pop143
	tee_local	$push1459=, $0=, $pop1460
	f64.const	$push144=, 0x1.84d73e22186efp-43
	f64.mul 	$push145=, $0, $pop144
	f64.const	$push146=, 0x1.8e600378c9547p-35
	f64.add 	$push147=, $pop145, $pop146
	f64.mul 	$push148=, $0, $pop147
	f64.const	$push149=, 0x1.28130dd085fb9p-27
	f64.add 	$push150=, $pop148, $pop149
	f64.mul 	$push151=, $0, $pop150
	f64.const	$push152=, 0x1.4e5cfaefda49ep-20
	f64.add 	$push153=, $pop151, $pop152
	f64.mul 	$push154=, $0, $pop153
	f64.const	$push155=, 0x1.21b8b76c1277dp-13
	f64.add 	$push156=, $pop154, $pop155
	f64.mul 	$push157=, $0, $pop156
	f64.const	$push158=, 0x1.7b0f6ad70e6f3p-7
	f64.add 	$push159=, $pop157, $pop158
	f64.mul 	$push160=, $pop1459, $pop159
	f64.const	$push161=, 0x1.1d3ed527e5215p-1
	f64.add 	$push1288=, $pop160, $pop161
	return  	$pop1288
.LBB0_59:                               # %sw.bb852
	end_block                       # label7:
	f64.add 	$push122=, $0, $0
	f64.const	$push123=, -0x1.5ep7
	f64.add 	$push1462=, $pop122, $pop123
	tee_local	$push1461=, $0=, $pop1462
	f64.const	$push124=, 0x1.91f23e8989b0cp-43
	f64.mul 	$push125=, $0, $pop124
	f64.const	$push126=, 0x1.a0e88e46e494ap-35
	f64.add 	$push127=, $pop125, $pop126
	f64.mul 	$push128=, $0, $pop127
	f64.const	$push129=, 0x1.37ff29d92409fp-27
	f64.add 	$push130=, $pop128, $pop129
	f64.mul 	$push131=, $0, $pop130
	f64.const	$push132=, 0x1.615e51b578741p-20
	f64.add 	$push133=, $pop131, $pop132
	f64.mul 	$push134=, $0, $pop133
	f64.const	$push135=, 0x1.31d940f96f6d2p-13
	f64.add 	$push136=, $pop134, $pop135
	f64.mul 	$push137=, $0, $pop136
	f64.const	$push138=, 0x1.8da3c21187e7cp-7
	f64.add 	$push139=, $pop137, $pop138
	f64.mul 	$push140=, $pop1461, $pop139
	f64.const	$push141=, 0x1.29613d31b9b67p-1
	f64.add 	$push1287=, $pop140, $pop141
	return  	$pop1287
.LBB0_60:                               # %sw.bb867
	end_block                       # label6:
	f64.add 	$push102=, $0, $0
	f64.const	$push103=, -0x1.62p7
	f64.add 	$push1464=, $pop102, $pop103
	tee_local	$push1463=, $0=, $pop1464
	f64.const	$push104=, 0x1.9f1e8a28efa7bp-43
	f64.mul 	$push105=, $0, $pop104
	f64.const	$push106=, 0x1.b40eb955ae3dp-35
	f64.add 	$push107=, $pop105, $pop106
	f64.mul 	$push108=, $0, $pop107
	f64.const	$push109=, 0x1.48a78265db839p-27
	f64.add 	$push110=, $pop108, $pop109
	f64.mul 	$push111=, $0, $pop110
	f64.const	$push112=, 0x1.755deb91b5a9ep-20
	f64.add 	$push113=, $pop111, $pop112
	f64.mul 	$push114=, $0, $pop113
	f64.const	$push115=, 0x1.42e0a546cbec5p-13
	f64.add 	$push116=, $pop114, $pop115
	f64.mul 	$push117=, $0, $pop116
	f64.const	$push118=, 0x1.a14cec41dd1a2p-7
	f64.add 	$push119=, $pop117, $pop118
	f64.mul 	$push120=, $pop1463, $pop119
	f64.const	$push121=, 0x1.361cffeb074a7p-1
	f64.add 	$push1286=, $pop120, $pop121
	return  	$pop1286
.LBB0_61:                               # %sw.bb882
	end_block                       # label5:
	f64.add 	$push82=, $0, $0
	f64.const	$push83=, -0x1.66p7
	f64.add 	$push1466=, $pop82, $pop83
	tee_local	$push1465=, $0=, $pop1466
	f64.const	$push84=, 0x1.ac67a87aed773p-43
	f64.mul 	$push85=, $0, $pop84
	f64.const	$push86=, 0x1.c7d4c51b1a2a8p-35
	f64.add 	$push87=, $pop85, $pop86
	f64.mul 	$push88=, $0, $pop87
	f64.const	$push89=, 0x1.5a123fb933389p-27
	f64.add 	$push90=, $pop88, $pop89
	f64.mul 	$push91=, $0, $pop90
	f64.const	$push92=, 0x1.8a7745646bc3p-20
	f64.add 	$push93=, $pop91, $pop92
	f64.mul 	$push94=, $0, $pop93
	f64.const	$push95=, 0x1.54deff7f5199dp-13
	f64.add 	$push96=, $pop94, $pop95
	f64.mul 	$push97=, $0, $pop96
	f64.const	$push98=, 0x1.b60ae9680e065p-7
	f64.add 	$push99=, $pop97, $pop98
	f64.mul 	$push100=, $pop1465, $pop99
	f64.const	$push101=, 0x1.4378ab0c88a48p-1
	f64.add 	$push1285=, $pop100, $pop101
	return  	$pop1285
.LBB0_62:                               # %sw.bb897
	end_block                       # label4:
	f64.add 	$push62=, $0, $0
	f64.const	$push63=, -0x1.6ap7
	f64.add 	$push1468=, $pop62, $pop63
	tee_local	$push1467=, $0=, $pop1468
	f64.const	$push64=, 0x1.b9b68a8a3cd86p-43
	f64.mul 	$push65=, $0, $pop64
	f64.const	$push66=, 0x1.dc38712134803p-35
	f64.add 	$push67=, $pop65, $pop66
	f64.mul 	$push68=, $0, $pop67
	f64.const	$push69=, 0x1.6c3f61d32b28ep-27
	f64.add 	$push70=, $pop68, $pop69
	f64.mul 	$push71=, $0, $pop70
	f64.const	$push72=, 0x1.a0a37ff5a4498p-20
	f64.add 	$push73=, $pop71, $pop72
	f64.mul 	$push74=, $0, $pop73
	f64.const	$push75=, 0x1.67df0c6a718dep-13
	f64.add 	$push76=, $pop74, $pop75
	f64.mul 	$push77=, $0, $pop76
	f64.const	$push78=, 0x1.cbee807bbb624p-7
	f64.add 	$push79=, $pop77, $pop78
	f64.mul 	$push80=, $pop1467, $pop79
	f64.const	$push81=, 0x1.51800a7c5ac47p-1
	f64.add 	$push1284=, $pop80, $pop81
	return  	$pop1284
.LBB0_63:                               # %sw.bb912
	end_block                       # label3:
	f64.add 	$push42=, $0, $0
	f64.const	$push43=, -0x1.6ep7
	f64.add 	$push1470=, $pop42, $pop43
	tee_local	$push1469=, $0=, $pop1470
	f64.const	$push44=, 0x1.c710f4142f5dp-43
	f64.mul 	$push45=, $0, $pop44
	f64.const	$push46=, 0x1.f13e3e53e4f7ep-35
	f64.add 	$push47=, $pop45, $pop46
	f64.mul 	$push48=, $0, $pop47
	f64.const	$push49=, 0x1.7f486aebf1d72p-27
	f64.add 	$push50=, $pop48, $pop49
	f64.mul 	$push51=, $0, $pop50
	f64.const	$push52=, 0x1.b804f75d2f8b2p-20
	f64.add 	$push53=, $pop51, $pop52
	f64.mul 	$push54=, $0, $pop53
	f64.const	$push55=, 0x1.7bf0e733556cfp-13
	f64.add 	$push56=, $pop54, $pop55
	f64.mul 	$push57=, $0, $pop56
	f64.const	$push58=, 0x1.e308787485e3ep-7
	f64.add 	$push59=, $pop57, $pop58
	f64.mul 	$push60=, $pop1469, $pop59
	f64.const	$push61=, 0x1.603afb7e90ff9p-1
	f64.add 	$push1283=, $pop60, $pop61
	return  	$pop1283
.LBB0_64:                               # %sw.bb927
	end_block                       # label2:
	f64.add 	$push22=, $0, $0
	f64.const	$push23=, -0x1.72p7
	f64.add 	$push1472=, $pop22, $pop23
	tee_local	$push1471=, $0=, $pop1472
	f64.const	$push24=, 0x1.d471215b73735p-43
	f64.mul 	$push25=, $0, $pop24
	f64.const	$push26=, 0x1.0371f61e9bda6p-34
	f64.add 	$push27=, $pop25, $pop26
	f64.mul 	$push28=, $0, $pop27
	f64.const	$push29=, 0x1.931bc36a06157p-27
	f64.add 	$push30=, $pop28, $pop29
	f64.mul 	$push31=, $0, $pop30
	f64.const	$push32=, 0x1.d094cc631711fp-20
	f64.add 	$push33=, $pop31, $pop32
	f64.mul 	$push34=, $0, $pop33
	f64.const	$push35=, 0x1.9124ab0526db6p-13
	f64.add 	$push36=, $pop34, $pop35
	f64.mul 	$push37=, $0, $pop36
	f64.const	$push38=, 0x1.fb71fbc5de9cp-7
	f64.add 	$push39=, $pop37, $pop38
	f64.mul 	$push40=, $pop1471, $pop39
	f64.const	$push41=, 0x1.6fb549f94855ep-1
	f64.add 	$push1282=, $pop40, $pop41
	return  	$pop1282
.LBB0_65:                               # %sw.bb942
	end_block                       # label1:
	f64.add 	$push2=, $0, $0
	f64.const	$push3=, -0x1.76p7
	f64.add 	$push1474=, $pop2, $pop3
	tee_local	$push1473=, $0=, $pop1474
	f64.const	$push4=, 0x1.e1c5c72814664p-43
	f64.mul 	$push5=, $0, $pop4
	f64.const	$push6=, 0x1.0e94bd6e965b5p-34
	f64.add 	$push7=, $pop5, $pop6
	f64.mul 	$push8=, $0, $pop7
	f64.const	$push9=, 0x1.a7d3ceb3a9a89p-27
	f64.add 	$push10=, $pop8, $pop9
	f64.mul 	$push11=, $0, $pop10
	f64.const	$push12=, 0x1.ea679caf3e3fbp-20
	f64.add 	$push13=, $pop11, $pop12
	f64.mul 	$push14=, $0, $pop13
	f64.const	$push15=, 0x1.a78514a756f18p-13
	f64.add 	$push16=, $pop14, $pop15
	f64.mul 	$push17=, $0, $pop16
	f64.const	$push18=, 0x1.0a99b6f5caf2dp-6
	f64.add 	$push19=, $pop17, $pop18
	f64.mul 	$push20=, $pop1473, $pop19
	f64.const	$push21=, 0x1.7ff6d330941c8p-1
	f64.add 	$2=, $pop20, $pop21
.LBB0_66:                               # %cleanup
	end_block                       # label0:
	copy_local	$push1475=, $2
                                        # fallthrough-return: $pop1475
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f64
# BB#0:                                 # %entry
	block   	
	f64.const	$push0=, 0x1.399999999999ap6
	f64.call	$push9=, foo@FUNCTION, $pop0
	tee_local	$push8=, $0=, $pop9
	f64.const	$push1=, 0x1.851eb851eb852p-2
	f64.lt  	$push2=, $pop8, $pop1
	br_if   	0, $pop2        # 0: down to label65
# BB#1:                                 # %entry
	f64.const	$push3=, 0x1.ae147ae147ae1p-2
	f64.le  	$push4=, $0, $pop3
	f64.ne  	$push5=, $0, $0
	i32.or  	$push6=, $pop4, $pop5
	i32.eqz 	$push10=, $pop6
	br_if   	0, $pop10       # 0: down to label65
# BB#2:                                 # %if.end
	i32.const	$push7=, 0
	return  	$pop7
.LBB1_3:                                # %if.then
	end_block                       # label65:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
