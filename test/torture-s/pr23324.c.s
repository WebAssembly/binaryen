	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr23324.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f64, f32
# BB#0:                                 # %entry
	block   	
	i32.const	$push9=, 0
	f64.load	$push8=, wv6+32($pop9)
	tee_local	$push7=, $0=, $pop8
	f64.ne  	$push0=, $pop7, $0
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %caller_bf6.exit
	i32.const	$push12=, 0
	f32.load	$push11=, yv7($pop12)
	tee_local	$push10=, $1=, $pop11
	f32.ne  	$push1=, $pop10, $1
	br_if   	0, $pop1        # 0: down to label0
# BB#2:                                 # %if.end26.i.i
	i32.const	$push2=, 0
	f64.load	$push14=, yv7+16($pop2)
	tee_local	$push13=, $0=, $pop14
	f64.ne  	$push3=, $pop13, $0
	br_if   	0, $pop3        # 0: down to label0
# BB#3:                                 # %if.end30.i.i
	i32.const	$push17=, 0
	f32.load	$push16=, yv7+24($pop17)
	tee_local	$push15=, $1=, $pop16
	f32.ne  	$push4=, $pop15, $1
	br_if   	0, $pop4        # 0: down to label0
# BB#4:                                 # %if.end34.i.i
	i32.const	$push20=, 0
	f32.load	$push19=, zv7($pop20)
	tee_local	$push18=, $1=, $pop19
	f32.ne  	$push5=, $pop18, $1
	br_if   	0, $pop5        # 0: down to label0
# BB#5:                                 # %caller_bf7.exit
	i32.const	$push6=, 0
	return  	$pop6
.LBB0_6:                                # %if.then37.i.i
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	wv6,@object             # @wv6
	.section	.data.wv6,"aw",@progbits
	.p2align	3
wv6:
	.int8	72                      # 0x48
	.int8	66                      # 0x42
	.int8	32                      # 0x20
	.int8	16                      # 0x10
	.int32	67426805                # 0x404d9f5
	.int32	1047191860              # 0x3e6ae134
	.int32	1366022414              # 0x516bd90e
	.int8	90                      # 0x5a
	.int8	147                     # 0x93
	.int8	98                      # 0x62
	.int8	2                       # 0x2
	.int32	1069379046              # 0x3fbd6de6
	.int32	358273621
	.skip	4
	.int64	4659514866546242126     # double 3318.0419780000002
	.size	wv6, 40

	.type	zv7,@object             # @zv7
	.section	.data.zv7,"aw",@progbits
	.p2align	2
zv7:
	.int32	1167954387              # float 5042.22803
	.size	zv7, 4

	.type	yv7,@object             # @yv7
	.section	.data.yv7,"aw",@progbits
	.p2align	3
yv7:
	.int32	1189834750              # float 30135.9961
	.int16	42435                   # 0xa5c3
	.skip	2
	.int8	170                     # 0xaa
	.int8	0                       # 0x0
	.int16	22116                   # 0x5664
	.skip	4
	.int64	4673007878717811523     # double 26479.628148
	.int32	1165963103              # float 4082.96069
	.skip	4
	.size	yv7, 32


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
