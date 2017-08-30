	.text
	.file	"ashldi-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i64
# BB#0:                                 # %entry
	i64.const	$3=, -1
	i32.const	$1=, .Lswitch.table.main
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	i64.const	$push10=, 81985529216486895
	i64.const	$push9=, 1
	i64.add 	$push8=, $3, $pop9
	tee_local	$push7=, $3=, $pop8
	i64.shl 	$push1=, $pop10, $pop7
	i64.load	$push2=, 0($1)
	i64.ne  	$push3=, $pop1, $pop2
	br_if   	1, $pop3        # 1: down to label0
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push12=, 8
	i32.add 	$1=, $1, $pop12
	i64.const	$push11=, 63
	i64.lt_u	$push4=, $3, $pop11
	br_if   	0, $pop4        # 0: up to label1
# BB#3:                                 # %for.body4.preheader
	end_loop
	i32.const	$1=, 0
	i32.const	$0=, .Lswitch.table.main
.LBB0_4:                                # %for.body4
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push13=, 64
	i32.ge_u	$push5=, $1, $pop13
	br_if   	1, $pop5        # 1: down to label0
# BB#5:                                 # %switch.lookup
                                        #   in Loop: Header=BB0_4 Depth=1
	i32.const	$push14=, 1
	i32.eqz 	$push18=, $pop14
	br_if   	1, $pop18       # 1: down to label0
# BB#6:                                 # %for.cond2
                                        #   in Loop: Header=BB0_4 Depth=1
	i32.const	$push17=, 8
	i32.add 	$0=, $0, $pop17
	i32.const	$push16=, 62
	i32.gt_u	$2=, $1, $pop16
	i32.const	$push15=, 1
	i32.add 	$push0=, $1, $pop15
	copy_local	$1=, $pop0
	i32.eqz 	$push19=, $2
	br_if   	0, $pop19       # 0: up to label2
# BB#7:                                 # %for.end13
	end_loop
	i32.const	$push6=, 0
	call    	exit@FUNCTION, $pop6
	unreachable
.LBB0_8:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.type	.Lswitch.table.main,@object # @switch.table.main
	.section	.rodata..Lswitch.table.main,"a",@progbits
	.p2align	4
.Lswitch.table.main:
	.int64	81985529216486895       # 0x123456789abcdef
	.int64	163971058432973790      # 0x2468acf13579bde
	.int64	327942116865947580      # 0x48d159e26af37bc
	.int64	655884233731895160      # 0x91a2b3c4d5e6f78
	.int64	1311768467463790320     # 0x123456789abcdef0
	.int64	2623536934927580640     # 0x2468acf13579bde0
	.int64	5247073869855161280     # 0x48d159e26af37bc0
	.int64	-7952596333999229056    # 0x91a2b3c4d5e6f780
	.int64	2541551405711093504     # 0x23456789abcdef00
	.int64	5083102811422187008     # 0x468acf13579bde00
	.int64	-8280538450865177600    # 0x8d159e26af37bc00
	.int64	1885667171979196416     # 0x1a2b3c4d5e6f7800
	.int64	3771334343958392832     # 0x3456789abcdef000
	.int64	7542668687916785664     # 0x68acf13579bde000
	.int64	-3361406697875980288    # 0xd159e26af37bc000
	.int64	-6722813395751960576    # 0xa2b3c4d5e6f78000
	.int64	5001117282205630464     # 0x456789abcdef0000
	.int64	-8444509509298290688    # 0x8acf13579bde0000
	.int64	1557725055112970240     # 0x159e26af37bc0000
	.int64	3115450110225940480     # 0x2b3c4d5e6f780000
	.int64	6230900220451880960     # 0x56789abcdef00000
	.int64	-5984943632805789696    # 0xacf13579bde00000
	.int64	6476856808097972224     # 0x59e26af37bc00000
	.int64	-5493030457513607168    # 0xb3c4d5e6f7800000
	.int64	7460683158682337280     # 0x6789abcdef000000
	.int64	-3525377756344877056    # 0xcf13579bde000000
	.int64	-7050755512689754112    # 0x9e26af37bc000000
	.int64	4345233048330043392     # 0x3c4d5e6f78000000
	.int64	8690466096660086784     # 0x789abcdef0000000
	.int64	-1065811880389378048    # 0xf13579bde0000000
	.int64	-2131623760778756096    # 0xe26af37bc0000000
	.int64	-4263247521557512192    # 0xc4d5e6f780000000
	.int64	-8526495043115024384    # 0x89abcdef00000000
	.int64	1393753987479502848     # 0x13579bde00000000
	.int64	2787507974959005696     # 0x26af37bc00000000
	.int64	5575015949918011392     # 0x4d5e6f7800000000
	.int64	-7296712173873528832    # 0x9abcdef000000000
	.int64	3853319725962493952     # 0x3579bde000000000
	.int64	7706639451924987904     # 0x6af37bc000000000
	.int64	-3033465169859575808    # 0xd5e6f78000000000
	.int64	-6066930339719151616    # 0xabcdef0000000000
	.int64	6312883394271248384     # 0x579bde0000000000
	.int64	-5820977285167054848    # 0xaf37bc0000000000
	.int64	6804789503375441920     # 0x5e6f780000000000
	.int64	-4837165066958667776    # 0xbcdef00000000000
	.int64	8772413939792216064     # 0x79bde00000000000
	.int64	-901916194125119488     # 0xf37bc00000000000
	.int64	-1803832388250238976    # 0xe6f7800000000000
	.int64	-3607664776500477952    # 0xcdef000000000000
	.int64	-7215329553000955904    # 0x9bde000000000000
	.int64	4016084967707639808     # 0x37bc000000000000
	.int64	8032169935415279616     # 0x6f78000000000000
	.int64	-2382404202878992384    # 0xdef0000000000000
	.int64	-4764808405757984768    # 0xbde0000000000000
	.int64	8917127262193582080     # 0x7bc0000000000000
	.int64	-612489549322387456     # 0xf780000000000000
	.int64	-1224979098644774912    # 0xef00000000000000
	.int64	-2449958197289549824    # 0xde00000000000000
	.int64	-4899916394579099648    # 0xbc00000000000000
	.int64	8646911284551352320     # 0x7800000000000000
	.int64	-1152921504606846976    # 0xf000000000000000
	.int64	-2305843009213693952    # 0xe000000000000000
	.int64	-4611686018427387904    # 0xc000000000000000
	.int64	-9223372036854775808    # 0x8000000000000000
	.size	.Lswitch.table.main, 512


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
