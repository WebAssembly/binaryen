	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr23324.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, f64, f32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	f64.load	$1=, wv6+32($0)
	block
	f64.ne  	$push0=, $1, $1
	br_if   	$pop0, 0        # 0: down to label0
# BB#1:                                 # %caller_bf6.exit
	f32.load	$2=, yv7($0)
	block
	f32.ne  	$push1=, $2, $2
	br_if   	$pop1, 0        # 0: down to label1
# BB#2:                                 # %if.end26.i.i
	f64.load	$1=, yv7+16($0)
	block
	f64.ne  	$push2=, $1, $1
	br_if   	$pop2, 0        # 0: down to label2
# BB#3:                                 # %if.end30.i.i
	f32.load	$2=, yv7+24($0)
	block
	f32.ne  	$push3=, $2, $2
	br_if   	$pop3, 0        # 0: down to label3
# BB#4:                                 # %if.end34.i.i
	f32.load	$2=, zv7($0)
	block
	f32.ne  	$push4=, $2, $2
	br_if   	$pop4, 0        # 0: down to label4
# BB#5:                                 # %caller_bf7.exit
	return  	$0
.LBB0_6:                                # %if.then37.i.i
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_7:                                # %if.then33.i.i
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_8:                                # %if.then29.i.i
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_9:                                # %if.then5.i.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_10:                               # %if.then109.i.i
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	wv6,@object             # @wv6
	.section	.data.wv6,"aw",@progbits
	.align	3
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
	.align	2
zv7:
	.int32	1167954387              # float 5042.22803
	.size	zv7, 4

	.type	yv7,@object             # @yv7
	.section	.data.yv7,"aw",@progbits
	.align	3
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


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
