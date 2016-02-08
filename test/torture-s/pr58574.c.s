	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58574.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	f64
	.result 	f64
	.local  	f64, i32
# BB#0:                                 # %entry
	f64.const	$1=, 0x1p0
	block
	i32.trunc_s/f64	$push0=, $0
	tee_local	$push1283=, $2=, $pop0
	i32.const	$push1=, 93
	i32.gt_u	$push2=, $pop1283, $pop1
	br_if   	0, $pop2        # 0: down to label0
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
	tableswitch	$2, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 64, 64, 64, 27, 64, 64, 64, 64, 64, 64, 64, 64, 64, 28, 64, 64, 64, 64, 64, 64, 64, 64, 64, 29, 64, 64, 64, 64, 64, 64, 64, 64, 64, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63 # 0: down to label64
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
	f64.add 	$push1263=, $0, $0
	f64.const	$push1264=, -0x1p0
	f64.add 	$0=, $pop1263, $pop1264
	f64.const	$push1265=, 0x1.cac6baec528a3p-50
	f64.mul 	$push1266=, $0, $pop1265
	f64.const	$push1267=, 0x1.9f49c634d36c8p-42
	f64.add 	$push1268=, $pop1266, $pop1267
	f64.mul 	$push1269=, $0, $pop1268
	f64.const	$push1270=, 0x1.675d48090d1d6p-34
	f64.add 	$push1271=, $pop1269, $pop1270
	f64.mul 	$push1272=, $0, $pop1271
	f64.const	$push1273=, 0x1.2afb34142b11cp-26
	f64.add 	$push1274=, $pop1272, $pop1273
	f64.mul 	$push1275=, $0, $pop1274
	f64.const	$push1276=, 0x1.e037b539626b4p-19
	f64.add 	$push1277=, $pop1275, $pop1276
	f64.mul 	$push1278=, $0, $pop1277
	f64.const	$push1279=, 0x1.7578a807708cbp-11
	f64.add 	$push1280=, $pop1278, $pop1279
	f64.mul 	$push1281=, $0, $pop1280
	f64.const	$push1282=, 0x1.739ad75c47d48p-11
	f64.add 	$1=, $pop1281, $pop1282
	br      	63              # 63: down to label0
.LBB0_3:                                # %sw.bb12
	end_block                       # label63:
	f64.add 	$push1243=, $0, $0
	f64.const	$push1244=, -0x1.8p1
	f64.add 	$0=, $pop1243, $pop1244
	f64.const	$push1245=, 0x1.e62fdf221a945p-50
	f64.mul 	$push1246=, $0, $pop1245
	f64.const	$push1247=, 0x1.b56f4407b2b3fp-42
	f64.add 	$push1248=, $pop1246, $pop1247
	f64.mul 	$push1249=, $0, $pop1248
	f64.const	$push1250=, 0x1.7803f03d4db15p-34
	f64.add 	$push1251=, $pop1249, $pop1250
	f64.mul 	$push1252=, $0, $pop1251
	f64.const	$push1253=, 0x1.3675193770057p-26
	f64.add 	$push1254=, $pop1252, $pop1253
	f64.mul 	$push1255=, $0, $pop1254
	f64.const	$push1256=, 0x1.ee7f95858f80dp-19
	f64.add 	$push1257=, $pop1255, $pop1256
	f64.mul 	$push1258=, $0, $pop1257
	f64.const	$push1259=, 0x1.7d157f6e1f426p-11
	f64.add 	$push1260=, $pop1258, $pop1259
	f64.mul 	$push1261=, $0, $pop1260
	f64.const	$push1262=, 0x1.1987908299a2dp-9
	f64.add 	$1=, $pop1261, $pop1262
	br      	62              # 62: down to label0
.LBB0_4:                                # %sw.bb27
	end_block                       # label62:
	f64.add 	$push1223=, $0, $0
	f64.const	$push1224=, -0x1.4p2
	f64.add 	$0=, $pop1223, $pop1224
	f64.const	$push1225=, 0x1.01900ac1a16a7p-49
	f64.mul 	$push1226=, $0, $pop1225
	f64.const	$push1227=, 0x1.cce31abf0cfe7p-42
	f64.add 	$push1228=, $pop1226, $pop1227
	f64.mul 	$push1229=, $0, $pop1228
	f64.const	$push1230=, 0x1.898e06fac46dfp-34
	f64.add 	$push1231=, $pop1229, $pop1230
	f64.mul 	$push1232=, $0, $pop1231
	f64.const	$push1233=, 0x1.427bbb26be687p-26
	f64.add 	$push1234=, $pop1232, $pop1233
	f64.mul 	$push1235=, $0, $pop1234
	f64.const	$push1236=, 0x1.fd5455ccf9081p-19
	f64.add 	$push1237=, $pop1235, $pop1236
	f64.mul 	$push1238=, $0, $pop1237
	f64.const	$push1239=, 0x1.84ed651dbbfdap-11
	f64.add 	$push1240=, $pop1238, $pop1239
	f64.mul 	$push1241=, $0, $pop1240
	f64.const	$push1242=, 0x1.da059a73b42ccp-9
	f64.add 	$1=, $pop1241, $pop1242
	br      	61              # 61: down to label0
.LBB0_5:                                # %sw.bb42
	end_block                       # label61:
	f64.add 	$push1203=, $0, $0
	f64.const	$push1204=, -0x1.cp2
	f64.add 	$0=, $pop1203, $pop1204
	f64.const	$push1205=, 0x1.10f093c3894a7p-49
	f64.mul 	$push1206=, $0, $pop1205
	f64.const	$push1207=, 0x1.e5bf3b2ed15bap-42
	f64.add 	$push1208=, $pop1206, $pop1207
	f64.mul 	$push1209=, $0, $pop1208
	f64.const	$push1210=, 0x1.9c0a2f40226f1p-34
	f64.add 	$push1211=, $pop1209, $pop1210
	f64.mul 	$push1212=, $0, $pop1211
	f64.const	$push1213=, 0x1.4f137fc876864p-26
	f64.add 	$push1214=, $pop1212, $pop1213
	f64.mul 	$push1215=, $0, $pop1214
	f64.const	$push1216=, 0x1.065e6aa3cabb7p-18
	f64.add 	$push1217=, $pop1215, $pop1216
	f64.mul 	$push1218=, $0, $pop1217
	f64.const	$push1219=, 0x1.8d00591646be5p-11
	f64.add 	$push1220=, $pop1218, $pop1219
	f64.mul 	$push1221=, $0, $pop1220
	f64.const	$push1222=, 0x1.4f3e2bb4b9b09p-8
	f64.add 	$1=, $pop1221, $pop1222
	br      	60              # 60: down to label0
.LBB0_6:                                # %sw.bb57
	end_block                       # label60:
	f64.add 	$push1183=, $0, $0
	f64.const	$push1184=, -0x1.2p3
	f64.add 	$0=, $pop1183, $pop1184
	f64.const	$push1185=, 0x1.21535de6eaaa3p-49
	f64.mul 	$push1186=, $0, $pop1185
	f64.const	$push1187=, 0x1.000d5a2623093p-41
	f64.add 	$push1188=, $pop1186, $pop1187
	f64.mul 	$push1189=, $0, $pop1188
	f64.const	$push1190=, 0x1.af85ebd11ee25p-34
	f64.add 	$push1191=, $pop1189, $pop1190
	f64.mul 	$push1192=, $0, $pop1191
	f64.const	$push1193=, 0x1.5c40cd02f8aa5p-26
	f64.add 	$push1194=, $pop1192, $pop1193
	f64.mul 	$push1195=, $0, $pop1194
	f64.const	$push1196=, 0x1.0e5ff996ada1ap-18
	f64.add 	$push1197=, $pop1195, $pop1196
	f64.mul 	$push1198=, $0, $pop1197
	f64.const	$push1199=, 0x1.9553b9bb7810bp-11
	f64.add 	$push1200=, $pop1198, $pop1199
	f64.mul 	$push1201=, $0, $pop1200
	f64.const	$push1202=, 0x1.b3885828b601bp-8
	f64.add 	$1=, $pop1201, $pop1202
	br      	59              # 59: down to label0
.LBB0_7:                                # %sw.bb72
	end_block                       # label59:
	f64.add 	$push1163=, $0, $0
	f64.const	$push1164=, -0x1.6p3
	f64.add 	$0=, $pop1163, $pop1164
	f64.const	$push1165=, 0x1.32bfca1e19775p-49
	f64.mul 	$push1166=, $0, $pop1165
	f64.const	$push1167=, 0x1.0e04d99704505p-41
	f64.add 	$push1168=, $pop1166, $pop1167
	f64.mul 	$push1169=, $0, $pop1168
	f64.const	$push1170=, 0x1.c407fe0f955e6p-34
	f64.add 	$push1171=, $pop1169, $pop1170
	f64.mul 	$push1172=, $0, $pop1171
	f64.const	$push1173=, 0x1.6a0c6ea3056bap-26
	f64.add 	$push1174=, $pop1172, $pop1173
	f64.mul 	$push1175=, $0, $pop1174
	f64.const	$push1176=, 0x1.16b2475b20719p-18
	f64.add 	$push1177=, $pop1175, $pop1176
	f64.mul 	$push1178=, $0, $pop1177
	f64.const	$push1179=, 0x1.9de7870d4ff4bp-11
	f64.add 	$push1180=, $pop1178, $pop1179
	f64.mul 	$push1181=, $0, $pop1180
	f64.const	$push1182=, 0x1.0cf75f478e341p-7
	f64.add 	$1=, $pop1181, $pop1182
	br      	58              # 58: down to label0
.LBB0_8:                                # %sw.bb87
	end_block                       # label58:
	f64.add 	$push1143=, $0, $0
	f64.const	$push1144=, -0x1.ap3
	f64.add 	$0=, $pop1143, $pop1144
	f64.const	$push1145=, 0x1.454fabb93b71cp-49
	f64.mul 	$push1146=, $0, $pop1145
	f64.const	$push1147=, 0x1.1cd31454040b1p-41
	f64.add 	$push1148=, $pop1146, $pop1147
	f64.mul 	$push1149=, $0, $pop1148
	f64.const	$push1150=, 0x1.d9b6add0b78edp-34
	f64.add 	$push1151=, $pop1149, $pop1150
	f64.mul 	$push1152=, $0, $pop1151
	f64.const	$push1153=, 0x1.7883965bbdac9p-26
	f64.add 	$push1154=, $pop1152, $pop1153
	f64.mul 	$push1155=, $0, $pop1154
	f64.const	$push1156=, 0x1.1f5a7b5b1c03bp-18
	f64.add 	$push1157=, $pop1155, $pop1156
	f64.mul 	$push1158=, $0, $pop1157
	f64.const	$push1159=, 0x1.a6bfc7d698d37p-11
	f64.add 	$push1160=, $pop1158, $pop1159
	f64.mul 	$push1161=, $0, $pop1160
	f64.const	$push1162=, 0x1.414112efc6ccep-7
	f64.add 	$1=, $pop1161, $pop1162
	br      	57              # 57: down to label0
.LBB0_9:                                # %sw.bb102
	end_block                       # label57:
	f64.add 	$push1123=, $0, $0
	f64.const	$push1124=, -0x1.ep3
	f64.add 	$0=, $pop1123, $pop1124
	f64.const	$push1125=, 0x1.5911c49cf8751p-49
	f64.mul 	$push1126=, $0, $pop1125
	f64.const	$push1127=, 0x1.2c89559516ee9p-41
	f64.add 	$push1128=, $pop1126, $pop1127
	f64.mul 	$push1129=, $0, $pop1128
	f64.const	$push1130=, 0x1.f0955bc5733f2p-34
	f64.add 	$push1131=, $pop1129, $pop1130
	f64.mul 	$push1132=, $0, $pop1131
	f64.const	$push1133=, 0x1.87aaaa1381b8bp-26
	f64.add 	$push1134=, $pop1132, $pop1133
	f64.mul 	$push1135=, $0, $pop1134
	f64.const	$push1136=, 0x1.285a4d649df58p-18
	f64.add 	$push1137=, $pop1135, $pop1136
	f64.mul 	$push1138=, $0, $pop1137
	f64.const	$push1139=, 0x1.afddd3b040dp-11
	f64.add 	$push1140=, $pop1138, $pop1139
	f64.mul 	$push1141=, $0, $pop1140
	f64.const	$push1142=, 0x1.76a2f48c2e771p-7
	f64.add 	$1=, $pop1141, $pop1142
	br      	56              # 56: down to label0
.LBB0_10:                               # %sw.bb117
	end_block                       # label56:
	f64.add 	$push1103=, $0, $0
	f64.const	$push1104=, -0x1.1p4
	f64.add 	$0=, $pop1103, $pop1104
	f64.const	$push1105=, 0x1.6e18872722536p-49
	f64.mul 	$push1106=, $0, $pop1105
	f64.const	$push1107=, 0x1.3d3324d4e01e3p-41
	f64.add 	$push1108=, $pop1106, $pop1107
	f64.mul 	$push1109=, $0, $pop1108
	f64.const	$push1110=, 0x1.0457a51dc5dfep-33
	f64.add 	$push1111=, $pop1109, $pop1110
	f64.mul 	$push1112=, $0, $pop1111
	f64.const	$push1113=, 0x1.978edb7d72726p-26
	f64.add 	$push1114=, $pop1112, $pop1113
	f64.mul 	$push1115=, $0, $pop1114
	f64.const	$push1116=, 0x1.31b6e4e19f1f7p-18
	f64.add 	$push1117=, $pop1115, $pop1116
	f64.mul 	$push1118=, $0, $pop1117
	f64.const	$push1119=, 0x1.b94708fe00767p-11
	f64.add 	$push1120=, $pop1118, $pop1119
	f64.mul 	$push1121=, $0, $pop1120
	f64.const	$push1122=, 0x1.ad3a604e1e71p-7
	f64.add 	$1=, $pop1121, $pop1122
	br      	55              # 55: down to label0
.LBB0_11:                               # %sw.bb132
	end_block                       # label55:
	f64.add 	$push1083=, $0, $0
	f64.const	$push1084=, -0x1.3p4
	f64.add 	$0=, $pop1083, $pop1084
	f64.const	$push1085=, 0x1.847dc6a7decccp-49
	f64.mul 	$push1086=, $0, $pop1085
	f64.const	$push1087=, 0x1.4ee05c5bffeaap-41
	f64.add 	$push1088=, $pop1086, $pop1087
	f64.mul 	$push1089=, $0, $pop1088
	f64.const	$push1090=, 0x1.1113200e25815p-33
	f64.add 	$push1091=, $pop1089, $pop1090
	f64.mul 	$push1092=, $0, $pop1091
	f64.const	$push1093=, 0x1.a83d5c4cb0bc1p-26
	f64.add 	$push1094=, $pop1092, $pop1093
	f64.mul 	$push1095=, $0, $pop1094
	f64.const	$push1096=, 0x1.3b77210a15f77p-18
	f64.add 	$push1097=, $pop1095, $pop1096
	f64.mul 	$push1098=, $0, $pop1097
	f64.const	$push1099=, 0x1.c2fb67bfd7c6dp-11
	f64.add 	$push1100=, $pop1098, $pop1099
	f64.mul 	$push1101=, $0, $pop1100
	f64.const	$push1102=, 0x1.e4f765fd8adacp-7
	f64.add 	$1=, $pop1101, $pop1102
	br      	54              # 54: down to label0
.LBB0_12:                               # %sw.bb147
	end_block                       # label54:
	f64.add 	$push1063=, $0, $0
	f64.const	$push1064=, -0x1.5p4
	f64.add 	$0=, $pop1063, $pop1064
	f64.const	$push1065=, 0x1.9c57a5f629aa4p-49
	f64.mul 	$push1066=, $0, $pop1065
	f64.const	$push1067=, 0x1.61a5294113d1fp-41
	f64.add 	$push1068=, $pop1066, $pop1067
	f64.mul 	$push1069=, $0, $pop1068
	f64.const	$push1070=, 0x1.1e8861019bd46p-33
	f64.add 	$push1071=, $pop1069, $pop1070
	f64.mul 	$push1072=, $0, $pop1071
	f64.const	$push1073=, 0x1.b9b62c813c95dp-26
	f64.add 	$push1074=, $pop1072, $pop1073
	f64.mul 	$push1075=, $0, $pop1074
	f64.const	$push1076=, 0x1.459cb9ac001bp-18
	f64.add 	$push1077=, $pop1075, $pop1076
	f64.mul 	$push1078=, $0, $pop1077
	f64.const	$push1079=, 0x1.ccfef6c0912a3p-11
	f64.add 	$push1080=, $pop1078, $pop1079
	f64.mul 	$push1081=, $0, $pop1080
	f64.const	$push1082=, 0x1.0efdc9c4da9p-6
	f64.add 	$1=, $pop1081, $pop1082
	br      	53              # 53: down to label0
.LBB0_13:                               # %sw.bb162
	end_block                       # label53:
	f64.add 	$push1043=, $0, $0
	f64.const	$push1044=, -0x1.7p4
	f64.add 	$0=, $pop1043, $pop1044
	f64.const	$push1045=, 0x1.b5bff86228abep-49
	f64.mul 	$push1046=, $0, $pop1045
	f64.const	$push1047=, 0x1.758ff4dd67c05p-41
	f64.add 	$push1048=, $pop1046, $pop1047
	f64.mul 	$push1049=, $0, $pop1048
	f64.const	$push1050=, 0x1.2cb767f828d91p-33
	f64.add 	$push1051=, $pop1049, $pop1050
	f64.mul 	$push1052=, $0, $pop1051
	f64.const	$push1053=, 0x1.cc0f499af778fp-26
	f64.add 	$push1054=, $pop1052, $pop1053
	f64.mul 	$push1055=, $0, $pop1054
	f64.const	$push1056=, 0x1.502cd63156628p-18
	f64.add 	$push1057=, $pop1055, $pop1056
	f64.mul 	$push1058=, $0, $pop1057
	f64.const	$push1059=, 0x1.d755bccaf709bp-11
	f64.add 	$push1060=, $pop1058, $pop1059
	f64.mul 	$push1061=, $0, $pop1060
	f64.const	$push1062=, 0x1.2c1f42bb6673p-6
	f64.add 	$1=, $pop1061, $pop1062
	br      	52              # 52: down to label0
.LBB0_14:                               # %sw.bb177
	end_block                       # label52:
	f64.add 	$push1023=, $0, $0
	f64.const	$push1024=, -0x1.9p4
	f64.add 	$0=, $pop1023, $pop1024
	f64.const	$push1025=, 0x1.d0cce0c2d79abp-49
	f64.mul 	$push1026=, $0, $pop1025
	f64.const	$push1027=, 0x1.8ab4ec479933cp-41
	f64.add 	$push1028=, $pop1026, $pop1027
	f64.mul 	$push1029=, $0, $pop1028
	f64.const	$push1030=, 0x1.3bb6b98d5330ap-33
	f64.add 	$push1031=, $pop1029, $pop1030
	f64.mul 	$push1032=, $0, $pop1031
	f64.const	$push1033=, 0x1.df517f66a1fc6p-26
	f64.add 	$push1034=, $pop1032, $pop1033
	f64.mul 	$push1035=, $0, $pop1034
	f64.const	$push1036=, 0x1.5b2e55d20f44p-18
	f64.add 	$push1037=, $pop1035, $pop1036
	f64.mul 	$push1038=, $0, $pop1037
	f64.const	$push1039=, 0x1.e2026910e5ab7p-11
	f64.add 	$push1040=, $pop1038, $pop1039
	f64.mul 	$push1041=, $0, $pop1040
	f64.const	$push1042=, 0x1.49e8815e39714p-6
	f64.add 	$1=, $pop1041, $pop1042
	br      	51              # 51: down to label0
.LBB0_15:                               # %sw.bb192
	end_block                       # label51:
	f64.add 	$push1003=, $0, $0
	f64.const	$push1004=, -0x1.bp4
	f64.add 	$0=, $pop1003, $pop1004
	f64.const	$push1005=, 0x1.ed9be2e1862d9p-49
	f64.mul 	$push1006=, $0, $pop1005
	f64.const	$push1007=, 0x1.a129ad859a0ebp-41
	f64.add 	$push1008=, $pop1006, $pop1007
	f64.mul 	$push1009=, $0, $pop1008
	f64.const	$push1010=, 0x1.4b91980ede2b9p-33
	f64.add 	$push1011=, $pop1009, $pop1010
	f64.mul 	$push1012=, $0, $pop1011
	f64.const	$push1013=, 0x1.f38e657dbd4e3p-26
	f64.add 	$push1014=, $pop1012, $pop1013
	f64.mul 	$push1015=, $0, $pop1014
	f64.const	$push1016=, 0x1.66a65ff82397dp-18
	f64.add 	$push1017=, $pop1015, $pop1016
	f64.mul 	$push1018=, $0, $pop1017
	f64.const	$push1019=, 0x1.ed0a59f6159b7p-11
	f64.add 	$push1020=, $pop1018, $pop1019
	f64.mul 	$push1021=, $0, $pop1020
	f64.const	$push1022=, 0x1.6861e92923e5cp-6
	f64.add 	$1=, $pop1021, $pop1022
	br      	50              # 50: down to label0
.LBB0_16:                               # %sw.bb207
	end_block                       # label50:
	f64.add 	$push983=, $0, $0
	f64.const	$push984=, -0x1.dp4
	f64.add 	$0=, $pop983, $pop984
	f64.const	$push985=, 0x1.0627198057091p-48
	f64.mul 	$push986=, $0, $pop985
	f64.const	$push987=, 0x1.b903d69d5c337p-41
	f64.add 	$push988=, $pop986, $pop987
	f64.mul 	$push989=, $0, $pop988
	f64.const	$push990=, 0x1.5c5345ca8d1a8p-33
	f64.add 	$push991=, $pop989, $pop990
	f64.mul 	$push992=, $0, $pop991
	f64.const	$push993=, 0x1.046530e354dcep-25
	f64.add 	$push994=, $pop992, $pop993
	f64.mul 	$push995=, $0, $pop994
	f64.const	$push996=, 0x1.729bd3db89d4p-18
	f64.add 	$push997=, $pop995, $pop996
	f64.mul 	$push998=, $0, $pop997
	f64.const	$push999=, 0x1.f86ee71374fcdp-11
	f64.add 	$push1000=, $pop998, $pop999
	f64.mul 	$push1001=, $0, $pop1000
	f64.const	$push1002=, 0x1.878b7a1c25d07p-6
	f64.add 	$1=, $pop1001, $pop1002
	br      	49              # 49: down to label0
.LBB0_17:                               # %sw.bb222
	end_block                       # label49:
	f64.add 	$push963=, $0, $0
	f64.const	$push964=, -0x1.fp4
	f64.add 	$0=, $pop963, $pop964
	f64.const	$push965=, 0x1.167ed2383a844p-48
	f64.mul 	$push966=, $0, $pop965
	f64.const	$push967=, 0x1.d2590594d1848p-41
	f64.add 	$push968=, $pop966, $pop967
	f64.mul 	$push969=, $0, $pop968
	f64.const	$push970=, 0x1.6e0ca63504f66p-33
	f64.add 	$push971=, $pop969, $pop970
	f64.mul 	$push972=, $0, $pop971
	f64.const	$push973=, 0x1.0f8db8e0a45c3p-25
	f64.add 	$push974=, $pop972, $pop973
	f64.mul 	$push975=, $0, $pop974
	f64.const	$push976=, 0x1.7f1221183d337p-18
	f64.add 	$push977=, $pop975, $pop976
	f64.mul 	$push978=, $0, $pop977
	f64.const	$push979=, 0x1.021ab7665e2dep-10
	f64.add 	$push980=, $pop978, $pop979
	f64.mul 	$push981=, $0, $pop980
	f64.const	$push982=, 0x1.a771c970f7b9ep-6
	f64.add 	$1=, $pop981, $pop982
	br      	48              # 48: down to label0
.LBB0_18:                               # %sw.bb237
	end_block                       # label48:
	f64.add 	$push943=, $0, $0
	f64.const	$push944=, -0x1.08p5
	f64.add 	$0=, $pop943, $pop944
	f64.const	$push945=, 0x1.27e96632d455fp-48
	f64.mul 	$push946=, $0, $pop945
	f64.const	$push947=, 0x1.ed449c2f3d75fp-41
	f64.add 	$push948=, $pop946, $pop947
	f64.mul 	$push949=, $0, $pop948
	f64.const	$push950=, 0x1.80c8fb9c090fap-33
	f64.add 	$push951=, $pop949, $pop950
	f64.mul 	$push952=, $0, $pop951
	f64.const	$push953=, 0x1.1b4996838dbc1p-25
	f64.add 	$push954=, $pop952, $pop953
	f64.mul 	$push955=, $0, $pop954
	f64.const	$push956=, 0x1.8c1396822f672p-18
	f64.add 	$push957=, $pop955, $pop956
	f64.mul 	$push958=, $0, $pop957
	f64.const	$push959=, 0x1.08305029e3ff2p-10
	f64.add 	$push960=, $pop958, $pop959
	f64.mul 	$push961=, $0, $pop960
	f64.const	$push962=, 0x1.c814d72799a2p-6
	f64.add 	$1=, $pop961, $pop962
	br      	47              # 47: down to label0
.LBB0_19:                               # %sw.bb252
	end_block                       # label47:
	f64.add 	$push923=, $0, $0
	f64.const	$push924=, -0x1.18p5
	f64.add 	$0=, $pop923, $pop924
	f64.const	$push925=, 0x1.3a73bf18375e2p-48
	f64.mul 	$push926=, $0, $pop925
	f64.const	$push927=, 0x1.04ef8d289d598p-40
	f64.add 	$push928=, $pop926, $pop927
	f64.mul 	$push929=, $0, $pop928
	f64.const	$push930=, 0x1.949929743e5f4p-33
	f64.add 	$push931=, $pop929, $pop930
	f64.mul 	$push932=, $0, $pop931
	f64.const	$push933=, 0x1.279d2fb27147fp-25
	f64.add 	$push934=, $pop932, $pop933
	f64.mul 	$push935=, $0, $pop934
	f64.const	$push936=, 0x1.99a3a3b55ba9ep-18
	f64.add 	$push937=, $pop935, $pop936
	f64.mul 	$push938=, $0, $pop937
	f64.const	$push939=, 0x1.0e7aed0628383p-10
	f64.add 	$push940=, $pop938, $pop939
	f64.mul 	$push941=, $0, $pop940
	f64.const	$push942=, 0x1.e9813879c4114p-6
	f64.add 	$1=, $pop941, $pop942
	br      	46              # 46: down to label0
.LBB0_20:                               # %sw.bb267
	end_block                       # label46:
	f64.add 	$push903=, $0, $0
	f64.const	$push904=, -0x1.28p5
	f64.add 	$0=, $pop903, $pop904
	f64.const	$push905=, 0x1.4e35d7fbf4617p-48
	f64.mul 	$push906=, $0, $pop905
	f64.const	$push907=, 0x1.1421f0df0657fp-40
	f64.add 	$push908=, $pop906, $pop907
	f64.mul 	$push909=, $0, $pop908
	f64.const	$push910=, 0x1.a993b4592b866p-33
	f64.add 	$push911=, $pop909, $pop910
	f64.mul 	$push912=, $0, $pop911
	f64.const	$push913=, 0x1.3495b6206fe24p-25
	f64.add 	$push914=, $pop912, $pop913
	f64.mul 	$push915=, $0, $pop914
	f64.const	$push916=, 0x1.a7cc9785b3accp-18
	f64.add 	$push917=, $pop915, $pop916
	f64.mul 	$push918=, $0, $pop917
	f64.const	$push919=, 0x1.14fb39c7a1eaap-10
	f64.add 	$push920=, $pop918, $pop919
	f64.mul 	$push921=, $0, $pop920
	f64.const	$push922=, 0x1.05db76b3bb83dp-5
	f64.add 	$1=, $pop921, $pop922
	br      	45              # 45: down to label0
.LBB0_21:                               # %sw.bb282
	end_block                       # label45:
	f64.add 	$push883=, $0, $0
	f64.const	$push884=, -0x1.38p5
	f64.add 	$0=, $pop883, $pop884
	f64.const	$push885=, 0x1.633e72c2b33b3p-48
	f64.mul 	$push886=, $0, $pop885
	f64.const	$push887=, 0x1.24489b0bcfd4cp-40
	f64.add 	$push888=, $pop886, $pop887
	f64.mul 	$push889=, $0, $pop888
	f64.const	$push890=, 0x1.bfc3de9893d59p-33
	f64.add 	$push891=, $pop889, $pop890
	f64.mul 	$push892=, $0, $pop891
	f64.const	$push893=, 0x1.4239c2a719fc4p-25
	f64.add 	$push894=, $pop892, $pop893
	f64.mul 	$push895=, $0, $pop894
	f64.const	$push896=, 0x1.b695512b2de5ap-18
	f64.add 	$push897=, $pop895, $pop896
	f64.mul 	$push898=, $0, $pop897
	f64.const	$push899=, 0x1.1bb7ec6af7c5ap-10
	f64.add 	$push900=, $pop898, $pop899
	f64.mul 	$push901=, $0, $pop900
	f64.const	$push902=, 0x1.176145953586dp-5
	f64.add 	$1=, $pop901, $pop902
	br      	44              # 44: down to label0
.LBB0_22:                               # %sw.bb297
	end_block                       # label44:
	f64.add 	$push863=, $0, $0
	f64.const	$push864=, -0x1.48p5
	f64.add 	$0=, $pop863, $pop864
	f64.const	$push865=, 0x1.79a58a8004affp-48
	f64.mul 	$push866=, $0, $pop865
	f64.const	$push867=, 0x1.35741e6f4452cp-40
	f64.add 	$push868=, $pop866, $pop867
	f64.mul 	$push869=, $0, $pop868
	f64.const	$push870=, 0x1.d745cdf4df966p-33
	f64.add 	$push871=, $pop869, $pop870
	f64.mul 	$push872=, $0, $pop871
	f64.const	$push873=, 0x1.509686f990786p-25
	f64.add 	$push874=, $pop872, $pop873
	f64.mul 	$push875=, $0, $pop874
	f64.const	$push876=, 0x1.c604afddc0ca6p-18
	f64.add 	$push877=, $pop875, $pop876
	f64.mul 	$push878=, $0, $pop877
	f64.const	$push879=, 0x1.22b104f029c92p-10
	f64.add 	$push880=, $pop878, $pop879
	f64.mul 	$push881=, $0, $pop880
	f64.const	$push882=, 0x1.295421c044285p-5
	f64.add 	$1=, $pop881, $pop882
	br      	43              # 43: down to label0
.LBB0_23:                               # %sw.bb312
	end_block                       # label43:
	f64.add 	$push843=, $0, $0
	f64.const	$push844=, -0x1.58p5
	f64.add 	$0=, $pop843, $pop844
	f64.const	$push845=, 0x1.91831a4779845p-48
	f64.mul 	$push846=, $0, $pop845
	f64.const	$push847=, 0x1.47b173735b59fp-40
	f64.add 	$push848=, $pop846, $pop847
	f64.mul 	$push849=, $0, $pop848
	f64.const	$push850=, 0x1.f02a65e2b3c19p-33
	f64.add 	$push851=, $pop849, $pop850
	f64.mul 	$push852=, $0, $pop851
	f64.const	$push853=, 0x1.5fb29bf163c7cp-25
	f64.add 	$push854=, $pop852, $pop853
	f64.mul 	$push855=, $0, $pop854
	f64.const	$push856=, 0x1.d626ba3f5ba98p-18
	f64.add 	$push857=, $pop855, $pop856
	f64.mul 	$push858=, $0, $pop857
	f64.const	$push859=, 0x1.29e6835737f54p-10
	f64.add 	$push860=, $pop858, $pop859
	f64.mul 	$push861=, $0, $pop860
	f64.const	$push862=, 0x1.3bb83cf2cf95dp-5
	f64.add 	$1=, $pop861, $pop862
	br      	42              # 42: down to label0
.LBB0_24:                               # %sw.bb327
	end_block                       # label42:
	f64.add 	$push823=, $0, $0
	f64.const	$push824=, -0x1.68p5
	f64.add 	$0=, $pop823, $pop824
	f64.const	$push825=, 0x1.aae99476e38a8p-48
	f64.mul 	$push826=, $0, $pop825
	f64.const	$push827=, 0x1.5b1d6ccaacc2cp-40
	f64.add 	$push828=, $pop826, $pop827
	f64.mul 	$push829=, $0, $pop828
	f64.const	$push830=, 0x1.054144eb5aa81p-32
	f64.add 	$push831=, $pop829, $pop830
	f64.mul 	$push832=, $0, $pop831
	f64.const	$push833=, 0x1.6f9d6634e4f2bp-25
	f64.add 	$push834=, $pop832, $pop833
	f64.mul 	$push835=, $0, $pop834
	f64.const	$push836=, 0x1.e70097b9f75b6p-18
	f64.add 	$push837=, $pop835, $pop836
	f64.mul 	$push838=, $0, $pop837
	f64.const	$push839=, 0x1.3165d3996fa83p-10
	f64.add 	$push840=, $pop838, $pop839
	f64.mul 	$push841=, $0, $pop840
	f64.const	$push842=, 0x1.4e93e1c9b413ap-5
	f64.add 	$1=, $pop841, $pop842
	br      	41              # 41: down to label0
.LBB0_25:                               # %sw.bb342
	end_block                       # label41:
	f64.add 	$push803=, $0, $0
	f64.const	$push804=, -0x1.78p5
	f64.add 	$0=, $pop803, $pop804
	f64.const	$push805=, 0x1.c5f67cd792795p-48
	f64.mul 	$push806=, $0, $pop805
	f64.const	$push807=, 0x1.6fbf3f21de835p-40
	f64.add 	$push808=, $pop806, $pop807
	f64.mul 	$push809=, $0, $pop808
	f64.const	$push810=, 0x1.13352fc9a645bp-32
	f64.add 	$push811=, $pop809, $pop810
	f64.mul 	$push812=, $0, $pop811
	f64.const	$push813=, 0x1.805fb190d49p-25
	f64.add 	$push814=, $pop812, $pop813
	f64.mul 	$push815=, $0, $pop814
	f64.const	$push816=, 0x1.f8a006bd80cbep-18
	f64.add 	$push817=, $pop815, $pop816
	f64.mul 	$push818=, $0, $pop817
	f64.const	$push819=, 0x1.392189bd8383bp-10
	f64.add 	$push820=, $pop818, $pop819
	f64.mul 	$push821=, $0, $pop820
	f64.const	$push822=, 0x1.61e71044f1a1ap-5
	f64.add 	$1=, $pop821, $pop822
	br      	40              # 40: down to label0
.LBB0_26:                               # %sw.bb357
	end_block                       # label40:
	f64.add 	$push783=, $0, $0
	f64.const	$push784=, -0x1.88p5
	f64.add 	$0=, $pop783, $pop784
	f64.const	$push785=, 0x1.e2c1ce7d17156p-48
	f64.mul 	$push786=, $0, $pop785
	f64.const	$push787=, 0x1.85b3bd2b88744p-40
	f64.add 	$push788=, $pop786, $pop787
	f64.mul 	$push789=, $0, $pop788
	f64.const	$push790=, 0x1.21ff066d70de7p-32
	f64.add 	$push791=, $pop789, $pop790
	f64.mul 	$push792=, $0, $pop791
	f64.const	$push793=, 0x1.9208e2ab83a8p-25
	f64.add 	$push794=, $pop792, $pop793
	f64.mul 	$push795=, $0, $pop794
	f64.const	$push796=, 0x1.0586cf27f6074p-17
	f64.add 	$push797=, $pop795, $pop796
	f64.mul 	$push798=, $0, $pop797
	f64.const	$push799=, 0x1.412711bcc0e61p-10
	f64.add 	$push800=, $pop798, $pop799
	f64.mul 	$push801=, $0, $pop800
	f64.const	$push802=, 0x1.75ba2be0589adp-5
	f64.add 	$1=, $pop801, $pop802
	br      	39              # 39: down to label0
.LBB0_27:                               # %sw.bb372
	end_block                       # label39:
	f64.add 	$push763=, $0, $0
	f64.const	$push764=, -0x1.98p5
	f64.add 	$0=, $pop763, $pop764
	f64.const	$push765=, 0x1.00b39a7a160dp-47
	f64.mul 	$push766=, $0, $pop765
	f64.const	$push767=, 0x1.9d095040f681cp-40
	f64.add 	$push768=, $pop766, $pop767
	f64.mul 	$push769=, $0, $pop768
	f64.const	$push770=, 0x1.31acdbb7ee971p-32
	f64.add 	$push771=, $pop769, $pop770
	f64.mul 	$push772=, $0, $pop771
	f64.const	$push773=, 0x1.a4a3f844e2f75p-25
	f64.add 	$push774=, $pop772, $pop773
	f64.mul 	$push775=, $0, $pop774
	f64.const	$push776=, 0x1.0f2ab2899438cp-17
	f64.add 	$push777=, $pop775, $pop776
	f64.mul 	$push778=, $0, $pop777
	f64.const	$push779=, 0x1.497d2193ce7e8p-10
	f64.add 	$push780=, $pop778, $pop779
	f64.mul 	$push781=, $0, $pop780
	f64.const	$push782=, 0x1.8a0f4d7add15fp-5
	f64.add 	$1=, $pop781, $pop782
	br      	38              # 38: down to label0
.LBB0_28:                               # %sw.bb387
	end_block                       # label38:
	f64.add 	$push743=, $0, $0
	f64.const	$push744=, -0x1.d8p5
	f64.add 	$0=, $pop743, $pop744
	f64.const	$push745=, 0x1.4870426dcdb0ep-47
	f64.mul 	$push746=, $0, $pop745
	f64.const	$push747=, 0x1.05189fcd8287bp-39
	f64.add 	$push748=, $pop746, $pop747
	f64.mul 	$push749=, $0, $pop748
	f64.const	$push750=, 0x1.7a62cc6986c28p-32
	f64.add 	$push751=, $pop749, $pop750
	f64.mul 	$push752=, $0, $pop751
	f64.const	$push753=, 0x1.f9cae3284854ep-25
	f64.add 	$push754=, $pop752, $pop753
	f64.mul 	$push755=, $0, $pop754
	f64.const	$push756=, 0x1.3a73b6897e136p-17
	f64.add 	$push757=, $pop755, $pop756
	f64.mul 	$push758=, $0, $pop757
	f64.const	$push759=, 0x1.6e01655acdabfp-10
	f64.add 	$push760=, $pop758, $pop759
	f64.mul 	$push761=, $0, $pop760
	f64.const	$push762=, 0x1.e0e30446b69dbp-5
	f64.add 	$1=, $pop761, $pop762
	br      	37              # 37: down to label0
.LBB0_29:                               # %sw.bb402
	end_block                       # label37:
	f64.add 	$push723=, $0, $0
	f64.const	$push724=, -0x1.3cp6
	f64.add 	$0=, $pop723, $pop724
	f64.const	$push725=, 0x1.2ee9801a347abp-46
	f64.mul 	$push726=, $0, $pop725
	f64.const	$push727=, 0x1.d9aa84ed5f7f8p-39
	f64.add 	$push728=, $pop726, $pop727
	f64.mul 	$push729=, $0, $pop728
	f64.const	$push730=, 0x1.487d76cb7622ap-31
	f64.add 	$push731=, $pop729, $pop730
	f64.mul 	$push732=, $0, $pop731
	f64.const	$push733=, 0x1.9a613c8cbadfcp-24
	f64.add 	$push734=, $pop732, $pop733
	f64.mul 	$push735=, $0, $pop734
	f64.const	$push736=, 0x1.d281dc526a9fdp-17
	f64.add 	$push737=, $pop735, $pop736
	f64.mul 	$push738=, $0, $pop737
	f64.const	$push739=, 0x1.e61ead6a30f64p-10
	f64.add 	$push740=, $pop738, $pop739
	f64.mul 	$push741=, $0, $pop740
	f64.const	$push742=, 0x1.745bf26f1dc51p-4
	f64.add 	$1=, $pop741, $pop742
	br      	36              # 36: down to label0
.LBB0_30:                               # %sw.bb417
	end_block                       # label36:
	f64.add 	$push703=, $0, $0
	f64.const	$push704=, -0x1.8cp6
	f64.add 	$0=, $pop703, $pop704
	f64.const	$push705=, 0x1.11ed4c2f43d7ep-45
	f64.mul 	$push706=, $0, $pop705
	f64.const	$push707=, 0x1.af109a3630d2ep-38
	f64.add 	$push708=, $pop706, $pop707
	f64.mul 	$push709=, $0, $pop708
	f64.const	$push710=, 0x1.22f550d281614p-30
	f64.add 	$push711=, $pop709, $pop710
	f64.mul 	$push712=, $0, $pop711
	f64.const	$push713=, 0x1.5782f0a3274a4p-23
	f64.add 	$push714=, $pop712, $pop713
	f64.mul 	$push715=, $0, $pop714
	f64.const	$push716=, 0x1.66c7e028f516cp-16
	f64.add 	$push717=, $pop715, $pop716
	f64.mul 	$push718=, $0, $pop717
	f64.const	$push719=, 0x1.4de48f6131734p-9
	f64.add 	$push720=, $pop718, $pop719
	f64.mul 	$push721=, $0, $pop720
	f64.const	$push722=, 0x1.1350092ccf6bep-3
	f64.add 	$1=, $pop721, $pop722
	br      	35              # 35: down to label0
.LBB0_31:                               # %sw.bb432
	end_block                       # label35:
	f64.add 	$push683=, $0, $0
	f64.const	$push684=, -0x1.dcp6
	f64.add 	$0=, $pop683, $pop684
	f64.const	$push685=, 0x1.dcc29389c0b3bp-45
	f64.mul 	$push686=, $0, $pop685
	f64.const	$push687=, 0x1.83c457cdf69a8p-37
	f64.add 	$push688=, $pop686, $pop687
	f64.mul 	$push689=, $0, $pop688
	f64.const	$push690=, 0x1.043a1711a52c6p-29
	f64.add 	$push691=, $pop689, $pop690
	f64.mul 	$push692=, $0, $pop691
	f64.const	$push693=, 0x1.270db3366ba97p-22
	f64.add 	$push694=, $pop692, $pop693
	f64.mul 	$push695=, $0, $pop694
	f64.const	$push696=, 0x1.1e049a3af6987p-15
	f64.add 	$push697=, $pop695, $pop696
	f64.mul 	$push698=, $0, $pop697
	f64.const	$push699=, 0x1.dc57844b53bb7p-9
	f64.add 	$push700=, $pop698, $pop699
	f64.mul 	$push701=, $0, $pop700
	f64.const	$push702=, 0x1.902de00d1b717p-3
	f64.add 	$1=, $pop701, $pop702
	br      	34              # 34: down to label0
.LBB0_32:                               # %sw.bb447
	end_block                       # label34:
	f64.add 	$push663=, $0, $0
	f64.const	$push664=, -0x1.e4p6
	f64.add 	$0=, $pop663, $pop664
	f64.const	$push665=, 0x1.f682fb42899afp-45
	f64.mul 	$push666=, $0, $pop665
	f64.const	$push667=, 0x1.9ab5097251322p-37
	f64.add 	$push668=, $pop666, $pop667
	f64.mul 	$push669=, $0, $pop668
	f64.const	$push670=, 0x1.13cfff76e3d9cp-29
	f64.add 	$push671=, $pop669, $pop670
	f64.mul 	$push672=, $0, $pop671
	f64.const	$push673=, 0x1.37cb0bef2ef1ep-22
	f64.add 	$push674=, $pop672, $pop673
	f64.mul 	$push675=, $0, $pop674
	f64.const	$push676=, 0x1.2c3c9655b9bd4p-15
	f64.add 	$push677=, $pop675, $pop676
	f64.mul 	$push678=, $0, $pop677
	f64.const	$push679=, 0x1.eea7122820b08p-9
	f64.add 	$push680=, $pop678, $pop679
	f64.mul 	$push681=, $0, $pop680
	f64.const	$push682=, 0x1.9f5ad96a6a012p-3
	f64.add 	$1=, $pop681, $pop682
	br      	33              # 33: down to label0
.LBB0_33:                               # %sw.bb462
	end_block                       # label33:
	f64.add 	$push643=, $0, $0
	f64.const	$push644=, -0x1.ecp6
	f64.add 	$0=, $pop643, $pop644
	f64.const	$push645=, 0x1.08ad32632c073p-44
	f64.mul 	$push646=, $0, $pop645
	f64.const	$push647=, 0x1.b2e9fd6fd80ddp-37
	f64.add 	$push648=, $pop646, $pop647
	f64.mul 	$push649=, $0, $pop648
	f64.const	$push650=, 0x1.245528d098f79p-29
	f64.add 	$push651=, $pop649, $pop650
	f64.mul 	$push652=, $0, $pop651
	f64.const	$push653=, 0x1.498ac7468b8cbp-22
	f64.add 	$push654=, $pop652, $pop653
	f64.mul 	$push655=, $0, $pop654
	f64.const	$push656=, 0x1.3b42baff5eb43p-15
	f64.add 	$push657=, $pop655, $pop656
	f64.mul 	$push658=, $0, $pop657
	f64.const	$push659=, 0x1.00f0c0c7dbcc4p-8
	f64.add 	$push660=, $pop658, $pop659
	f64.mul 	$push661=, $0, $pop660
	f64.const	$push662=, 0x1.af1a9fbe76c8bp-3
	f64.add 	$1=, $pop661, $pop662
	br      	32              # 32: down to label0
.LBB0_34:                               # %sw.bb477
	end_block                       # label32:
	f64.add 	$push623=, $0, $0
	f64.const	$push624=, -0x1.f4p6
	f64.add 	$0=, $pop623, $pop624
	f64.const	$push625=, 0x1.16a6b65650415p-44
	f64.mul 	$push626=, $0, $pop625
	f64.const	$push627=, 0x1.cc5a31eebbb9ep-37
	f64.add 	$push628=, $pop626, $pop627
	f64.mul 	$push629=, $0, $pop628
	f64.const	$push630=, 0x1.35d09c8f5e982p-29
	f64.add 	$push631=, $pop629, $pop630
	f64.mul 	$push632=, $0, $pop631
	f64.const	$push633=, 0x1.5c5aa3ac6e65cp-22
	f64.add 	$push634=, $pop632, $pop633
	f64.mul 	$push635=, $0, $pop634
	f64.const	$push636=, 0x1.4b261082509f2p-15
	f64.add 	$push637=, $pop635, $pop636
	f64.mul 	$push638=, $0, $pop637
	f64.const	$push639=, 0x1.0b0a1f3db2e8fp-8
	f64.add 	$push640=, $pop638, $pop639
	f64.mul 	$push641=, $0, $pop640
	f64.const	$push642=, 0x1.bf77af640639dp-3
	f64.add 	$1=, $pop641, $pop642
	br      	31              # 31: down to label0
.LBB0_35:                               # %sw.bb492
	end_block                       # label31:
	f64.add 	$push603=, $0, $0
	f64.const	$push604=, -0x1.fcp6
	f64.add 	$0=, $pop603, $pop604
	f64.const	$push605=, 0x1.252f30a08e99p-44
	f64.mul 	$push606=, $0, $pop605
	f64.const	$push607=, 0x1.e729ae4e3a05p-37
	f64.add 	$push608=, $pop606, $pop607
	f64.mul 	$push609=, $0, $pop608
	f64.const	$push610=, 0x1.48506d9468e04p-29
	f64.add 	$push611=, $pop609, $pop610
	f64.mul 	$push612=, $0, $pop611
	f64.const	$push613=, 0x1.704b1f40c0981p-22
	f64.add 	$push614=, $pop612, $pop613
	f64.mul 	$push615=, $0, $pop614
	f64.const	$push616=, 0x1.5bef2de483919p-15
	f64.add 	$push617=, $pop615, $pop616
	f64.mul 	$push618=, $0, $pop617
	f64.const	$push619=, 0x1.15a65a723c5d8p-8
	f64.add 	$push620=, $pop618, $pop619
	f64.mul 	$push621=, $0, $pop620
	f64.const	$push622=, 0x1.d07c84b5dcc64p-3
	f64.add 	$1=, $pop621, $pop622
	br      	30              # 30: down to label0
.LBB0_36:                               # %sw.bb507
	end_block                       # label30:
	f64.add 	$push583=, $0, $0
	f64.const	$push584=, -0x1.02p7
	f64.add 	$0=, $pop583, $pop584
	f64.const	$push585=, 0x1.3448ef8da1489p-44
	f64.mul 	$push586=, $0, $pop585
	f64.const	$push587=, 0x1.01ac394729779p-36
	f64.add 	$push588=, $pop586, $pop587
	f64.mul 	$push589=, $0, $pop588
	f64.const	$push590=, 0x1.5be2aec0ebf4bp-29
	f64.add 	$push591=, $pop589, $pop590
	f64.mul 	$push592=, $0, $pop591
	f64.const	$push593=, 0x1.856cb8236b3ecp-22
	f64.add 	$push594=, $pop592, $pop593
	f64.mul 	$push595=, $0, $pop594
	f64.const	$push596=, 0x1.6db166f35cb72p-15
	f64.add 	$push597=, $pop595, $pop596
	f64.mul 	$push598=, $0, $pop597
	f64.const	$push599=, 0x1.20cc28621ed91p-8
	f64.add 	$push600=, $pop598, $pop599
	f64.mul 	$push601=, $0, $pop600
	f64.const	$push602=, 0x1.e2339c0ebedfap-3
	f64.add 	$1=, $pop601, $pop602
	br      	29              # 29: down to label0
.LBB0_37:                               # %sw.bb522
	end_block                       # label29:
	f64.add 	$push563=, $0, $0
	f64.const	$push564=, -0x1.06p7
	f64.add 	$0=, $pop563, $pop564
	f64.const	$push565=, 0x1.43f51a43656d1p-44
	f64.mul 	$push566=, $0, $pop565
	f64.const	$push567=, 0x1.107c412f52afep-36
	f64.add 	$push568=, $pop566, $pop567
	f64.mul 	$push569=, $0, $pop568
	f64.const	$push570=, 0x1.7098f7ae69034p-29
	f64.add 	$push571=, $pop569, $pop570
	f64.mul 	$push572=, $0, $pop571
	f64.const	$push573=, 0x1.9bcd2cc45b459p-22
	f64.add 	$push574=, $pop572, $pop573
	f64.mul 	$push575=, $0, $pop574
	f64.const	$push576=, 0x1.807778764d281p-15
	f64.add 	$push577=, $pop575, $pop576
	f64.mul 	$push578=, $0, $pop577
	f64.const	$push579=, 0x1.2c83ec892ab69p-8
	f64.add 	$push580=, $pop578, $pop579
	f64.mul 	$push581=, $0, $pop580
	f64.const	$push582=, 0x1.f49cf56eac86p-3
	f64.add 	$1=, $pop581, $pop582
	br      	28              # 28: down to label0
.LBB0_38:                               # %sw.bb537
	end_block                       # label28:
	f64.add 	$push543=, $0, $0
	f64.const	$push544=, -0x1.0ap7
	f64.add 	$0=, $pop543, $pop544
	f64.const	$push545=, 0x1.5434d7e7b823ap-44
	f64.mul 	$push546=, $0, $pop545
	f64.const	$push547=, 0x1.200df0b7681fp-36
	f64.add 	$push548=, $pop546, $pop547
	f64.mul 	$push549=, $0, $pop548
	f64.const	$push550=, 0x1.867a51cd7a1e6p-29
	f64.add 	$push551=, $pop549, $pop550
	f64.mul 	$push552=, $0, $pop551
	f64.const	$push553=, 0x1.b3853a536e553p-22
	f64.add 	$push554=, $pop552, $pop553
	f64.mul 	$push555=, $0, $pop554
	f64.const	$push556=, 0x1.945290793d0b5p-15
	f64.add 	$push557=, $pop555, $pop556
	f64.mul 	$push558=, $0, $pop557
	f64.const	$push559=, 0x1.38d60a633051p-8
	f64.add 	$push560=, $pop558, $pop559
	f64.mul 	$push561=, $0, $pop560
	f64.const	$push562=, 0x1.03e1869835159p-2
	f64.add 	$1=, $pop561, $pop562
	br      	27              # 27: down to label0
.LBB0_39:                               # %sw.bb552
	end_block                       # label27:
	f64.add 	$push523=, $0, $0
	f64.const	$push524=, -0x1.0ep7
	f64.add 	$0=, $pop523, $pop524
	f64.const	$push525=, 0x1.65094fa076898p-44
	f64.mul 	$push526=, $0, $pop525
	f64.const	$push527=, 0x1.3065c8cb517eep-36
	f64.add 	$push528=, $pop526, $pop527
	f64.mul 	$push529=, $0, $pop528
	f64.const	$push530=, 0x1.9d9f5e283a865p-29
	f64.add 	$push531=, $pop529, $pop530
	f64.mul 	$push532=, $0, $pop531
	f64.const	$push533=, 0x1.cca55ef08d88ap-22
	f64.add 	$push534=, $pop532, $pop533
	f64.mul 	$push535=, $0, $pop534
	f64.const	$push536=, 0x1.a951b7469782dp-15
	f64.add 	$push537=, $pop535, $pop536
	f64.mul 	$push538=, $0, $pop537
	f64.const	$push539=, 0x1.45cc92eb29af2p-8
	f64.add 	$push540=, $pop538, $pop539
	f64.mul 	$push541=, $0, $pop540
	f64.const	$push542=, 0x1.0ddd6e04c0592p-2
	f64.add 	$1=, $pop541, $pop542
	br      	26              # 26: down to label0
.LBB0_40:                               # %sw.bb567
	end_block                       # label26:
	f64.add 	$push503=, $0, $0
	f64.const	$push504=, -0x1.12p7
	f64.add 	$0=, $pop503, $pop504
	f64.const	$push505=, 0x1.7672816da09eap-44
	f64.mul 	$push506=, $0, $pop505
	f64.const	$push507=, 0x1.41884a56f6894p-36
	f64.add 	$push508=, $pop506, $pop507
	f64.mul 	$push509=, $0, $pop508
	f64.const	$push510=, 0x1.b612aae79156ap-29
	f64.add 	$push511=, $pop509, $pop510
	f64.mul 	$push512=, $0, $pop511
	f64.const	$push513=, 0x1.e740d86b9e2a1p-22
	f64.add 	$push514=, $pop512, $pop513
	f64.mul 	$push515=, $0, $pop514
	f64.const	$push516=, 0x1.bf8840abc1ba5p-15
	f64.add 	$push517=, $pop515, $pop516
	f64.mul 	$push518=, $0, $pop517
	f64.const	$push519=, 0x1.536e3c1dbd803p-8
	f64.add 	$push520=, $pop518, $pop519
	f64.mul 	$push521=, $0, $pop520
	f64.const	$push522=, 0x1.184230fcf80dcp-2
	f64.add 	$1=, $pop521, $pop522
	br      	25              # 25: down to label0
.LBB0_41:                               # %sw.bb582
	end_block                       # label25:
	f64.add 	$push483=, $0, $0
	f64.const	$push484=, -0x1.16p7
	f64.add 	$0=, $pop483, $pop484
	f64.const	$push485=, 0x1.88706d4f3663p-44
	f64.mul 	$push486=, $0, $pop485
	f64.const	$push487=, 0x1.5382f81e0e6bap-36
	f64.add 	$push488=, $pop486, $pop487
	f64.mul 	$push489=, $0, $pop488
	f64.const	$push490=, 0x1.cfe24aecb2b41p-29
	f64.add 	$push491=, $pop489, $pop490
	f64.mul 	$push492=, $0, $pop491
	f64.const	$push493=, 0x1.01b6d22240d98p-21
	f64.add 	$push494=, $pop492, $pop493
	f64.mul 	$push495=, $0, $pop494
	f64.const	$push496=, 0x1.d70534f326d3bp-15
	f64.add 	$push497=, $pop495, $pop496
	f64.mul 	$push498=, $0, $pop497
	f64.const	$push499=, 0x1.61c871f439226p-8
	f64.add 	$push500=, $pop498, $pop499
	f64.mul 	$push501=, $0, $pop500
	f64.const	$push502=, 0x1.23150dae3e6c5p-2
	f64.add 	$1=, $pop501, $pop502
	br      	24              # 24: down to label0
.LBB0_42:                               # %sw.bb597
	end_block                       # label24:
	f64.add 	$push463=, $0, $0
	f64.const	$push464=, -0x1.1ap7
	f64.add 	$0=, $pop463, $pop464
	f64.const	$push465=, 0x1.9b01ec1f5ab98p-44
	f64.mul 	$push466=, $0, $pop465
	f64.const	$push467=, 0x1.6655d22099262p-36
	f64.add 	$push468=, $pop466, $pop467
	f64.mul 	$push469=, $0, $pop468
	f64.const	$push470=, 0x1.eb235a896cd5bp-29
	f64.add 	$push471=, $pop469, $pop470
	f64.mul 	$push472=, $0, $pop471
	f64.const	$push473=, 0x1.10a23fd58ae5ep-21
	f64.add 	$push474=, $pop472, $pop473
	f64.mul 	$push475=, $0, $pop474
	f64.const	$push476=, 0x1.efe0336d26046p-15
	f64.add 	$push477=, $pop475, $pop476
	f64.mul 	$push478=, $0, $pop477
	f64.const	$push479=, 0x1.70e397ea6cf0cp-8
	f64.add 	$push480=, $pop478, $pop479
	f64.mul 	$push481=, $0, $pop480
	f64.const	$push482=, 0x1.2e60807357e67p-2
	f64.add 	$1=, $pop481, $pop482
	br      	23              # 23: down to label0
.LBB0_43:                               # %sw.bb612
	end_block                       # label23:
	f64.add 	$push443=, $0, $0
	f64.const	$push444=, -0x1.1ep7
	f64.add 	$0=, $pop443, $pop444
	f64.const	$push445=, 0x1.ae26fdde0da22p-44
	f64.mul 	$push446=, $0, $pop445
	f64.const	$push447=, 0x1.7a0e5b224de62p-36
	f64.add 	$push448=, $pop446, $pop447
	f64.mul 	$push449=, $0, $pop448
	f64.const	$push450=, 0x1.03f1f64f79f02p-28
	f64.add 	$push451=, $pop449, $pop450
	f64.mul 	$push452=, $0, $pop451
	f64.const	$push453=, 0x1.206db40f9df7p-21
	f64.add 	$push454=, $pop452, $pop453
	f64.mul 	$push455=, $0, $pop454
	f64.const	$push456=, 0x1.051647f3923c1p-14
	f64.add 	$push457=, $pop455, $pop456
	f64.mul 	$push458=, $0, $pop457
	f64.const	$push459=, 0x1.80c9befb52f21p-8
	f64.add 	$push460=, $pop458, $pop459
	f64.mul 	$push461=, $0, $pop460
	f64.const	$push462=, 0x1.3a272862f598ap-2
	f64.add 	$1=, $pop461, $pop462
	br      	22              # 22: down to label0
.LBB0_44:                               # %sw.bb627
	end_block                       # label22:
	f64.add 	$push423=, $0, $0
	f64.const	$push424=, -0x1.22p7
	f64.add 	$0=, $pop423, $pop424
	f64.const	$push425=, 0x1.c1de7b6571ffbp-44
	f64.mul 	$push426=, $0, $pop425
	f64.const	$push427=, 0x1.8eac93232cabap-36
	f64.add 	$push428=, $pop426, $pop427
	f64.mul 	$push429=, $0, $pop428
	f64.const	$push430=, 0x1.131e511bb18ap-28
	f64.add 	$push431=, $pop429, $pop430
	f64.mul 	$push432=, $0, $pop431
	f64.const	$push433=, 0x1.31242d906ac99p-21
	f64.add 	$push434=, $pop432, $pop433
	f64.mul 	$push435=, $0, $pop434
	f64.const	$push436=, 0x1.12fecf1743ad4p-14
	f64.add 	$push437=, $pop435, $pop436
	f64.mul 	$push438=, $0, $pop437
	f64.const	$push439=, 0x1.918a009f62307p-8
	f64.add 	$push440=, $pop438, $pop439
	f64.mul 	$push441=, $0, $pop440
	f64.const	$push442=, 0x1.466e43aa79bbbp-2
	f64.add 	$1=, $pop441, $pop442
	br      	21              # 21: down to label0
.LBB0_45:                               # %sw.bb642
	end_block                       # label21:
	f64.add 	$push403=, $0, $0
	f64.const	$push404=, -0x1.26p7
	f64.add 	$0=, $pop403, $pop404
	f64.const	$push405=, 0x1.d62179d259236p-44
	f64.mul 	$push406=, $0, $pop405
	f64.const	$push407=, 0x1.a43dfce6eca43p-36
	f64.add 	$push408=, $pop406, $pop407
	f64.mul 	$push409=, $0, $pop408
	f64.const	$push410=, 0x1.231c04bdd0c64p-28
	f64.add 	$push411=, $pop409, $pop410
	f64.mul 	$push412=, $0, $pop411
	f64.const	$push413=, 0x1.42d62a77da788p-21
	f64.add 	$push414=, $pop412, $pop413
	f64.mul 	$push415=, $0, $pop414
	f64.const	$push416=, 0x1.21b57ec9d6f09p-14
	f64.add 	$push417=, $pop415, $pop416
	f64.mul 	$push418=, $0, $pop417
	f64.const	$push419=, 0x1.a32e6dd194b2bp-8
	f64.add 	$push420=, $pop418, $pop419
	f64.mul 	$push421=, $0, $pop420
	f64.const	$push422=, 0x1.53404ea4a8c15p-2
	f64.add 	$1=, $pop421, $pop422
	br      	20              # 20: down to label0
.LBB0_46:                               # %sw.bb657
	end_block                       # label20:
	f64.add 	$push383=, $0, $0
	f64.const	$push384=, -0x1.2ap7
	f64.add 	$0=, $pop383, $pop384
	f64.const	$push385=, 0x1.eaeff924c30d3p-44
	f64.mul 	$push386=, $0, $pop385
	f64.const	$push387=, 0x1.bac2986d8dcfdp-36
	f64.add 	$push388=, $pop386, $pop387
	f64.mul 	$push389=, $0, $pop388
	f64.const	$push390=, 0x1.33f59f5ebec07p-28
	f64.add 	$push391=, $pop389, $pop390
	f64.mul 	$push392=, $0, $pop391
	f64.const	$push393=, 0x1.558d49addfa8fp-21
	f64.add 	$push394=, $pop392, $pop393
	f64.mul 	$push395=, $0, $pop394
	f64.const	$push396=, 0x1.314626b37ba09p-14
	f64.add 	$push397=, $pop395, $pop396
	f64.mul 	$push398=, $0, $pop397
	f64.const	$push399=, 0x1.b5c4728b37d7p-8
	f64.add 	$push400=, $pop398, $pop399
	f64.mul 	$push401=, $0, $pop400
	f64.const	$push402=, 0x1.60a5269595feep-2
	f64.add 	$1=, $pop401, $pop402
	br      	19              # 19: down to label0
.LBB0_47:                               # %sw.bb672
	end_block                       # label19:
	f64.add 	$push363=, $0, $0
	f64.const	$push364=, -0x1.2ep7
	f64.add 	$0=, $pop363, $pop364
	f64.const	$push365=, 0x1.002a2cd8bae1cp-43
	f64.mul 	$push366=, $0, $pop365
	f64.const	$push367=, 0x1.d247e87ac75bfp-36
	f64.add 	$push368=, $pop366, $pop367
	f64.mul 	$push369=, $0, $pop368
	f64.const	$push370=, 0x1.45b5af2762942p-28
	f64.add 	$push371=, $pop369, $pop370
	f64.mul 	$push372=, $0, $pop371
	f64.const	$push373=, 0x1.6958a97a655e7p-21
	f64.add 	$push374=, $pop372, $pop373
	f64.mul 	$push375=, $0, $pop374
	f64.const	$push376=, 0x1.41bebc3dde5cfp-14
	f64.add 	$push377=, $pop375, $pop376
	f64.mul 	$push378=, $0, $pop377
	f64.const	$push379=, 0x1.c95b2844c2a7bp-8
	f64.add 	$push380=, $pop378, $pop379
	f64.mul 	$push381=, $0, $pop380
	f64.const	$push382=, 0x1.6e9f6a93f290bp-2
	f64.add 	$1=, $pop381, $pop382
	br      	18              # 18: down to label0
.LBB0_48:                               # %sw.bb687
	end_block                       # label18:
	f64.add 	$push343=, $0, $0
	f64.const	$push344=, -0x1.32p7
	f64.add 	$0=, $pop343, $pop344
	f64.const	$push345=, 0x1.0b1bc641957fap-43
	f64.mul 	$push346=, $0, $pop345
	f64.const	$push347=, 0x1.eacded0e9948ap-36
	f64.add 	$push348=, $pop346, $pop347
	f64.mul 	$push349=, $0, $pop348
	f64.const	$push350=, 0x1.5866c240a35cdp-28
	f64.add 	$push351=, $pop349, $pop350
	f64.mul 	$push352=, $0, $pop351
	f64.const	$push353=, 0x1.7e48c7fd54b3fp-21
	f64.add 	$push354=, $pop352, $pop353
	f64.mul 	$push355=, $0, $pop354
	f64.const	$push356=, 0x1.532b0f112ec05p-14
	f64.add 	$push357=, $pop355, $pop356
	f64.mul 	$push358=, $0, $pop357
	f64.const	$push359=, 0x1.de01a876ac2ecp-8
	f64.add 	$push360=, $pop358, $pop359
	f64.mul 	$push361=, $0, $pop360
	f64.const	$push362=, 0x1.7d3c36113404fp-2
	f64.add 	$1=, $pop361, $pop362
	br      	17              # 17: down to label0
.LBB0_49:                               # %sw.bb702
	end_block                       # label17:
	f64.add 	$push323=, $0, $0
	f64.const	$push324=, -0x1.36p7
	f64.add 	$0=, $pop323, $pop324
	f64.const	$push325=, 0x1.16528c8a42f2p-43
	f64.mul 	$push326=, $0, $pop325
	f64.const	$push327=, 0x1.022ed4006984cp-35
	f64.add 	$push328=, $pop326, $pop327
	f64.mul 	$push329=, $0, $pop328
	f64.const	$push330=, 0x1.6c11a47741b18p-28
	f64.add 	$push331=, $pop329, $pop330
	f64.mul 	$push332=, $0, $pop331
	f64.const	$push333=, 0x1.946b63a69a956p-21
	f64.add 	$push334=, $pop332, $pop333
	f64.mul 	$push335=, $0, $pop334
	f64.const	$push336=, 0x1.659a2777d7ecbp-14
	f64.add 	$push337=, $pop335, $pop336
	f64.mul 	$push338=, $0, $pop337
	f64.const	$push339=, 0x1.f3c70c996b767p-8
	f64.add 	$push340=, $pop338, $pop339
	f64.mul 	$push341=, $0, $pop340
	f64.const	$push342=, 0x1.8c8366516db0ep-2
	f64.add 	$1=, $pop341, $pop342
	br      	16              # 16: down to label0
.LBB0_50:                               # %sw.bb717
	end_block                       # label16:
	f64.add 	$push303=, $0, $0
	f64.const	$push304=, -0x1.3ap7
	f64.add 	$0=, $pop303, $pop304
	f64.const	$push305=, 0x1.21c2f83820157p-43
	f64.mul 	$push306=, $0, $pop305
	f64.const	$push307=, 0x1.0f800d94a2092p-35
	f64.add 	$push308=, $pop306, $pop307
	f64.mul 	$push309=, $0, $pop308
	f64.const	$push310=, 0x1.80c0e3f424adbp-28
	f64.add 	$push311=, $pop309, $pop310
	f64.mul 	$push312=, $0, $pop311
	f64.const	$push313=, 0x1.abd0fa96201dcp-21
	f64.add 	$push314=, $pop312, $pop313
	f64.mul 	$push315=, $0, $pop314
	f64.const	$push316=, 0x1.791b0dbc4504p-14
	f64.add 	$push317=, $pop315, $pop316
	f64.mul 	$push318=, $0, $pop317
	f64.const	$push319=, 0x1.055d3712bbc46p-7
	f64.add 	$push320=, $pop318, $pop319
	f64.mul 	$push321=, $0, $pop320
	f64.const	$push322=, 0x1.9c7cd898b2e9dp-2
	f64.add 	$1=, $pop321, $pop322
	br      	15              # 15: down to label0
.LBB0_51:                               # %sw.bb732
	end_block                       # label15:
	f64.add 	$push283=, $0, $0
	f64.const	$push284=, -0x1.3ep7
	f64.add 	$0=, $pop283, $pop284
	f64.const	$push285=, 0x1.2d72cd087e7bbp-43
	f64.mul 	$push286=, $0, $pop285
	f64.const	$push287=, 0x1.1d5aa343f6318p-35
	f64.add 	$push288=, $pop286, $pop287
	f64.mul 	$push289=, $0, $pop288
	f64.const	$push290=, 0x1.9680d13c59f19p-28
	f64.add 	$push291=, $pop289, $pop290
	f64.mul 	$push292=, $0, $pop291
	f64.const	$push293=, 0x1.c488ab13d0509p-21
	f64.add 	$push294=, $pop292, $pop293
	f64.mul 	$push295=, $0, $pop294
	f64.const	$push296=, 0x1.8dbbb74822a5fp-14
	f64.add 	$push297=, $pop295, $pop296
	f64.mul 	$push298=, $0, $pop297
	f64.const	$push299=, 0x1.1177f7886239bp-7
	f64.add 	$push300=, $pop298, $pop299
	f64.mul 	$push301=, $0, $pop300
	f64.const	$push302=, 0x1.ad330941c8217p-2
	f64.add 	$1=, $pop301, $pop302
	br      	14              # 14: down to label0
.LBB0_52:                               # %sw.bb747
	end_block                       # label14:
	f64.add 	$push263=, $0, $0
	f64.const	$push264=, -0x1.42p7
	f64.add 	$0=, $pop263, $pop264
	f64.const	$push265=, 0x1.39620afb5e24cp-43
	f64.mul 	$push266=, $0, $pop265
	f64.const	$push267=, 0x1.2bc315fa4db79p-35
	f64.add 	$push268=, $pop266, $pop267
	f64.mul 	$push269=, $0, $pop268
	f64.const	$push270=, 0x1.ad5bfa78c898bp-28
	f64.add 	$push271=, $pop269, $pop270
	f64.mul 	$push272=, $0, $pop271
	f64.const	$push273=, 0x1.dea712c78e8fap-21
	f64.add 	$push274=, $pop272, $pop273
	f64.mul 	$push275=, $0, $pop274
	f64.const	$push276=, 0x1.a383a840a6635p-14
	f64.add 	$push277=, $pop275, $pop276
	f64.mul 	$push278=, $0, $pop277
	f64.const	$push279=, 0x1.1e3c2b2979761p-7
	f64.add 	$push280=, $pop278, $pop279
	f64.mul 	$push281=, $0, $pop280
	f64.const	$push282=, 0x1.beadd590c0adp-2
	f64.add 	$1=, $pop281, $pop282
	br      	13              # 13: down to label0
.LBB0_53:                               # %sw.bb762
	end_block                       # label13:
	f64.add 	$push243=, $0, $0
	f64.const	$push244=, -0x1.46p7
	f64.add 	$0=, $pop243, $pop244
	f64.const	$push245=, 0x1.457f66d8ca5b7p-43
	f64.mul 	$push246=, $0, $pop245
	f64.const	$push247=, 0x1.3abde6a390555p-35
	f64.add 	$push248=, $pop246, $pop247
	f64.mul 	$push249=, $0, $pop248
	f64.const	$push250=, 0x1.c55b2b76313ap-28
	f64.add 	$push251=, $pop249, $pop250
	f64.mul 	$push252=, $0, $pop251
	f64.const	$push253=, 0x1.fa3b4ff945de5p-21
	f64.add 	$push254=, $pop252, $pop253
	f64.mul 	$push255=, $0, $pop254
	f64.const	$push256=, 0x1.ba9ff98511a24p-14
	f64.add 	$push257=, $pop255, $pop256
	f64.mul 	$push258=, $0, $pop257
	f64.const	$push259=, 0x1.2bb4b9b090562p-7
	f64.add 	$push260=, $pop258, $pop259
	f64.mul 	$push261=, $0, $pop260
	f64.const	$push262=, 0x1.d0fcf80dc3372p-2
	f64.add 	$1=, $pop261, $pop262
	br      	12              # 12: down to label0
.LBB0_54:                               # %sw.bb777
	end_block                       # label12:
	f64.add 	$push223=, $0, $0
	f64.const	$push224=, -0x1.4ap7
	f64.add 	$0=, $pop223, $pop224
	f64.const	$push225=, 0x1.51d6681b66433p-43
	f64.mul 	$push226=, $0, $pop225
	f64.const	$push227=, 0x1.4a48d4c9ca2dbp-35
	f64.add 	$push228=, $pop226, $pop227
	f64.mul 	$push229=, $0, $pop228
	f64.const	$push230=, 0x1.de8c7715c7fa3p-28
	f64.add 	$push231=, $pop229, $pop230
	f64.mul 	$push232=, $0, $pop231
	f64.const	$push233=, 0x1.0bac503c6dc37p-20
	f64.add 	$push234=, $pop232, $pop233
	f64.mul 	$push235=, $0, $pop234
	f64.const	$push236=, 0x1.d30926f02ed1ap-14
	f64.add 	$push237=, $pop235, $pop236
	f64.mul 	$push238=, $0, $pop237
	f64.const	$push239=, 0x1.39ea06997734fp-7
	f64.add 	$push240=, $pop238, $pop239
	f64.mul 	$push241=, $0, $pop240
	f64.const	$push242=, 0x1.e42aed1394318p-2
	f64.add 	$1=, $pop241, $pop242
	br      	11              # 11: down to label0
.LBB0_55:                               # %sw.bb792
	end_block                       # label11:
	f64.add 	$push203=, $0, $0
	f64.const	$push204=, -0x1.4ep7
	f64.add 	$0=, $pop203, $pop204
	f64.const	$push205=, 0x1.5e5b87488eb8ap-43
	f64.mul 	$push206=, $0, $pop205
	f64.const	$push207=, 0x1.5a6aa1ced6d78p-35
	f64.add 	$push208=, $pop206, $pop207
	f64.mul 	$push209=, $0, $pop208
	f64.const	$push210=, 0x1.f8fa6b8073f4dp-28
	f64.add 	$push211=, $pop209, $pop210
	f64.mul 	$push212=, $0, $pop211
	f64.const	$push213=, 0x1.1b09d0f71975ap-20
	f64.add 	$push214=, $pop212, $pop213
	f64.mul 	$push215=, $0, $pop214
	f64.const	$push216=, 0x1.ecd4aa10e0221p-14
	f64.add 	$push217=, $pop215, $pop216
	f64.mul 	$push218=, $0, $pop217
	f64.const	$push219=, 0x1.48e4755ffe6d6p-7
	f64.add 	$push220=, $pop218, $pop219
	f64.mul 	$push221=, $0, $pop220
	f64.const	$push222=, 0x1.f83f91e646f15p-2
	f64.add 	$1=, $pop221, $pop222
	br      	10              # 10: down to label0
.LBB0_56:                               # %sw.bb807
	end_block                       # label10:
	f64.add 	$push183=, $0, $0
	f64.const	$push184=, -0x1.52p7
	f64.add 	$0=, $pop183, $pop184
	f64.const	$push185=, 0x1.6b0900a2f22ap-43
	f64.mul 	$push186=, $0, $pop185
	f64.const	$push187=, 0x1.6b210d3cc275ep-35
	f64.add 	$push188=, $pop186, $pop187
	f64.mul 	$push189=, $0, $pop188
	f64.const	$push190=, 0x1.0a58ac9da165p-27
	f64.add 	$push191=, $pop189, $pop190
	f64.mul 	$push192=, $0, $pop191
	f64.const	$push193=, 0x1.2b3999c8a140ap-20
	f64.add 	$push194=, $pop192, $pop193
	f64.mul 	$push195=, $0, $pop194
	f64.const	$push196=, 0x1.040bfe3b03e21p-13
	f64.add 	$push197=, $pop195, $pop196
	f64.mul 	$push198=, $0, $pop197
	f64.const	$push199=, 0x1.58b827fa1a0cfp-7
	f64.add 	$push200=, $pop198, $pop199
	f64.mul 	$push201=, $0, $pop200
	f64.const	$push202=, 0x1.06a550870110ap-1
	f64.add 	$1=, $pop201, $pop202
	br      	9               # 9: down to label0
.LBB0_57:                               # %sw.bb822
	end_block                       # label9:
	f64.add 	$push163=, $0, $0
	f64.const	$push164=, -0x1.56p7
	f64.add 	$0=, $pop163, $pop164
	f64.const	$push165=, 0x1.77ded42a90976p-43
	f64.mul 	$push166=, $0, $pop165
	f64.const	$push167=, 0x1.7c72d875689f8p-35
	f64.add 	$push168=, $pop166, $pop167
	f64.mul 	$push169=, $0, $pop168
	f64.const	$push170=, 0x1.18dde7378dcacp-27
	f64.add 	$push171=, $pop169, $pop170
	f64.mul 	$push172=, $0, $pop171
	f64.const	$push173=, 0x1.3c530808e4b56p-20
	f64.add 	$push174=, $pop172, $pop173
	f64.mul 	$push175=, $0, $pop174
	f64.const	$push176=, 0x1.1279aa3afc804p-13
	f64.add 	$push177=, $pop175, $pop176
	f64.mul 	$push178=, $0, $pop177
	f64.const	$push179=, 0x1.696e58a32f449p-7
	f64.add 	$push180=, $pop178, $pop179
	f64.mul 	$push181=, $0, $pop180
	f64.const	$push182=, 0x1.11adea897635ep-1
	f64.add 	$1=, $pop181, $pop182
	br      	8               # 8: down to label0
.LBB0_58:                               # %sw.bb837
	end_block                       # label8:
	f64.add 	$push143=, $0, $0
	f64.const	$push144=, -0x1.5ap7
	f64.add 	$0=, $pop143, $pop144
	f64.const	$push145=, 0x1.84d73e22186efp-43
	f64.mul 	$push146=, $0, $pop145
	f64.const	$push147=, 0x1.8e600378c9547p-35
	f64.add 	$push148=, $pop146, $pop147
	f64.mul 	$push149=, $0, $pop148
	f64.const	$push150=, 0x1.28130dd085fb9p-27
	f64.add 	$push151=, $pop149, $pop150
	f64.mul 	$push152=, $0, $pop151
	f64.const	$push153=, 0x1.4e5cfaefda49ep-20
	f64.add 	$push154=, $pop152, $pop153
	f64.mul 	$push155=, $0, $pop154
	f64.const	$push156=, 0x1.21b8b76c1277dp-13
	f64.add 	$push157=, $pop155, $pop156
	f64.mul 	$push158=, $0, $pop157
	f64.const	$push159=, 0x1.7b0f6ad70e6f3p-7
	f64.add 	$push160=, $pop158, $pop159
	f64.mul 	$push161=, $0, $pop160
	f64.const	$push162=, 0x1.1d3ed527e5215p-1
	f64.add 	$1=, $pop161, $pop162
	br      	7               # 7: down to label0
.LBB0_59:                               # %sw.bb852
	end_block                       # label7:
	f64.add 	$push123=, $0, $0
	f64.const	$push124=, -0x1.5ep7
	f64.add 	$0=, $pop123, $pop124
	f64.const	$push125=, 0x1.91f23e8989b0cp-43
	f64.mul 	$push126=, $0, $pop125
	f64.const	$push127=, 0x1.a0e88e46e494ap-35
	f64.add 	$push128=, $pop126, $pop127
	f64.mul 	$push129=, $0, $pop128
	f64.const	$push130=, 0x1.37ff29d92409fp-27
	f64.add 	$push131=, $pop129, $pop130
	f64.mul 	$push132=, $0, $pop131
	f64.const	$push133=, 0x1.615e51b578741p-20
	f64.add 	$push134=, $pop132, $pop133
	f64.mul 	$push135=, $0, $pop134
	f64.const	$push136=, 0x1.31d940f96f6d2p-13
	f64.add 	$push137=, $pop135, $pop136
	f64.mul 	$push138=, $0, $pop137
	f64.const	$push139=, 0x1.8da3c21187e7cp-7
	f64.add 	$push140=, $pop138, $pop139
	f64.mul 	$push141=, $0, $pop140
	f64.const	$push142=, 0x1.29613d31b9b67p-1
	f64.add 	$1=, $pop141, $pop142
	br      	6               # 6: down to label0
.LBB0_60:                               # %sw.bb867
	end_block                       # label6:
	f64.add 	$push103=, $0, $0
	f64.const	$push104=, -0x1.62p7
	f64.add 	$0=, $pop103, $pop104
	f64.const	$push105=, 0x1.9f1e8a28efa7bp-43
	f64.mul 	$push106=, $0, $pop105
	f64.const	$push107=, 0x1.b40eb955ae3dp-35
	f64.add 	$push108=, $pop106, $pop107
	f64.mul 	$push109=, $0, $pop108
	f64.const	$push110=, 0x1.48a78265db839p-27
	f64.add 	$push111=, $pop109, $pop110
	f64.mul 	$push112=, $0, $pop111
	f64.const	$push113=, 0x1.755deb91b5a9ep-20
	f64.add 	$push114=, $pop112, $pop113
	f64.mul 	$push115=, $0, $pop114
	f64.const	$push116=, 0x1.42e0a546cbec5p-13
	f64.add 	$push117=, $pop115, $pop116
	f64.mul 	$push118=, $0, $pop117
	f64.const	$push119=, 0x1.a14cec41dd1a2p-7
	f64.add 	$push120=, $pop118, $pop119
	f64.mul 	$push121=, $0, $pop120
	f64.const	$push122=, 0x1.361cffeb074a7p-1
	f64.add 	$1=, $pop121, $pop122
	br      	5               # 5: down to label0
.LBB0_61:                               # %sw.bb882
	end_block                       # label5:
	f64.add 	$push83=, $0, $0
	f64.const	$push84=, -0x1.66p7
	f64.add 	$0=, $pop83, $pop84
	f64.const	$push85=, 0x1.ac67a87aed773p-43
	f64.mul 	$push86=, $0, $pop85
	f64.const	$push87=, 0x1.c7d4c51b1a2a8p-35
	f64.add 	$push88=, $pop86, $pop87
	f64.mul 	$push89=, $0, $pop88
	f64.const	$push90=, 0x1.5a123fb933389p-27
	f64.add 	$push91=, $pop89, $pop90
	f64.mul 	$push92=, $0, $pop91
	f64.const	$push93=, 0x1.8a7745646bc3p-20
	f64.add 	$push94=, $pop92, $pop93
	f64.mul 	$push95=, $0, $pop94
	f64.const	$push96=, 0x1.54deff7f5199dp-13
	f64.add 	$push97=, $pop95, $pop96
	f64.mul 	$push98=, $0, $pop97
	f64.const	$push99=, 0x1.b60ae9680e065p-7
	f64.add 	$push100=, $pop98, $pop99
	f64.mul 	$push101=, $0, $pop100
	f64.const	$push102=, 0x1.4378ab0c88a48p-1
	f64.add 	$1=, $pop101, $pop102
	br      	4               # 4: down to label0
.LBB0_62:                               # %sw.bb897
	end_block                       # label4:
	f64.add 	$push63=, $0, $0
	f64.const	$push64=, -0x1.6ap7
	f64.add 	$0=, $pop63, $pop64
	f64.const	$push65=, 0x1.b9b68a8a3cd86p-43
	f64.mul 	$push66=, $0, $pop65
	f64.const	$push67=, 0x1.dc38712134803p-35
	f64.add 	$push68=, $pop66, $pop67
	f64.mul 	$push69=, $0, $pop68
	f64.const	$push70=, 0x1.6c3f61d32b28ep-27
	f64.add 	$push71=, $pop69, $pop70
	f64.mul 	$push72=, $0, $pop71
	f64.const	$push73=, 0x1.a0a37ff5a4498p-20
	f64.add 	$push74=, $pop72, $pop73
	f64.mul 	$push75=, $0, $pop74
	f64.const	$push76=, 0x1.67df0c6a718dep-13
	f64.add 	$push77=, $pop75, $pop76
	f64.mul 	$push78=, $0, $pop77
	f64.const	$push79=, 0x1.cbee807bbb624p-7
	f64.add 	$push80=, $pop78, $pop79
	f64.mul 	$push81=, $0, $pop80
	f64.const	$push82=, 0x1.51800a7c5ac47p-1
	f64.add 	$1=, $pop81, $pop82
	br      	3               # 3: down to label0
.LBB0_63:                               # %sw.bb912
	end_block                       # label3:
	f64.add 	$push43=, $0, $0
	f64.const	$push44=, -0x1.6ep7
	f64.add 	$0=, $pop43, $pop44
	f64.const	$push45=, 0x1.c710f4142f5dp-43
	f64.mul 	$push46=, $0, $pop45
	f64.const	$push47=, 0x1.f13e3e53e4f7ep-35
	f64.add 	$push48=, $pop46, $pop47
	f64.mul 	$push49=, $0, $pop48
	f64.const	$push50=, 0x1.7f486aebf1d72p-27
	f64.add 	$push51=, $pop49, $pop50
	f64.mul 	$push52=, $0, $pop51
	f64.const	$push53=, 0x1.b804f75d2f8b2p-20
	f64.add 	$push54=, $pop52, $pop53
	f64.mul 	$push55=, $0, $pop54
	f64.const	$push56=, 0x1.7bf0e733556cfp-13
	f64.add 	$push57=, $pop55, $pop56
	f64.mul 	$push58=, $0, $pop57
	f64.const	$push59=, 0x1.e308787485e3ep-7
	f64.add 	$push60=, $pop58, $pop59
	f64.mul 	$push61=, $0, $pop60
	f64.const	$push62=, 0x1.603afb7e90ff9p-1
	f64.add 	$1=, $pop61, $pop62
	br      	2               # 2: down to label0
.LBB0_64:                               # %sw.bb927
	end_block                       # label2:
	f64.add 	$push23=, $0, $0
	f64.const	$push24=, -0x1.72p7
	f64.add 	$0=, $pop23, $pop24
	f64.const	$push25=, 0x1.d471215b73735p-43
	f64.mul 	$push26=, $0, $pop25
	f64.const	$push27=, 0x1.0371f61e9bda6p-34
	f64.add 	$push28=, $pop26, $pop27
	f64.mul 	$push29=, $0, $pop28
	f64.const	$push30=, 0x1.931bc36a06157p-27
	f64.add 	$push31=, $pop29, $pop30
	f64.mul 	$push32=, $0, $pop31
	f64.const	$push33=, 0x1.d094cc631711fp-20
	f64.add 	$push34=, $pop32, $pop33
	f64.mul 	$push35=, $0, $pop34
	f64.const	$push36=, 0x1.9124ab0526db6p-13
	f64.add 	$push37=, $pop35, $pop36
	f64.mul 	$push38=, $0, $pop37
	f64.const	$push39=, 0x1.fb71fbc5de9cp-7
	f64.add 	$push40=, $pop38, $pop39
	f64.mul 	$push41=, $0, $pop40
	f64.const	$push42=, 0x1.6fb549f94855ep-1
	f64.add 	$1=, $pop41, $pop42
	br      	1               # 1: down to label0
.LBB0_65:                               # %sw.bb942
	end_block                       # label1:
	f64.add 	$push3=, $0, $0
	f64.const	$push4=, -0x1.76p7
	f64.add 	$0=, $pop3, $pop4
	f64.const	$push5=, 0x1.e1c5c72814664p-43
	f64.mul 	$push6=, $0, $pop5
	f64.const	$push7=, 0x1.0e94bd6e965b5p-34
	f64.add 	$push8=, $pop6, $pop7
	f64.mul 	$push9=, $0, $pop8
	f64.const	$push10=, 0x1.a7d3ceb3a9a89p-27
	f64.add 	$push11=, $pop9, $pop10
	f64.mul 	$push12=, $0, $pop11
	f64.const	$push13=, 0x1.ea679caf3e3fbp-20
	f64.add 	$push14=, $pop12, $pop13
	f64.mul 	$push15=, $0, $pop14
	f64.const	$push16=, 0x1.a78514a756f18p-13
	f64.add 	$push17=, $pop15, $pop16
	f64.mul 	$push18=, $0, $pop17
	f64.const	$push19=, 0x1.0a99b6f5caf2dp-6
	f64.add 	$push20=, $pop18, $pop19
	f64.mul 	$push21=, $0, $pop20
	f64.const	$push22=, 0x1.7ff6d330941c8p-1
	f64.add 	$1=, $pop21, $pop22
.LBB0_66:                               # %cleanup
	end_block                       # label0:
	return  	$1
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
	f64.const	$push1=, 0x1.399999999999ap6
	f64.call	$push0=, foo@FUNCTION, $pop1
	tee_local	$push9=, $0=, $pop0
	f64.const	$push2=, 0x1.851eb851eb852p-2
	f64.lt  	$push3=, $pop9, $pop2
	br_if   	0, $pop3        # 0: down to label65
# BB#1:                                 # %entry
	f64.const	$push4=, 0x1.ae147ae147ae1p-2
	f64.le  	$push5=, $0, $pop4
	f64.ne  	$push6=, $0, $0
	i32.or  	$push7=, $pop5, $pop6
	i32.const	$push10=, 0
	i32.eq  	$push11=, $pop7, $pop10
	br_if   	0, $pop11       # 0: down to label65
# BB#2:                                 # %if.end
	i32.const	$push8=, 0
	return  	$pop8
.LBB1_3:                                # %if.then
	end_block                       # label65:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
