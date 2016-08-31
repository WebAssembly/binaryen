	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr20527-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block
	i32.gt_s	$push0=, $2, $3
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$push9=, -1
	i32.add 	$5=, $2, $pop9
	i32.const	$push1=, 2
	i32.shl 	$push8=, $2, $pop1
	tee_local	$push7=, $4=, $pop8
	i32.add 	$2=, $1, $pop7
	i32.add 	$0=, $0, $4
	i32.const	$1=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push19=, 4
	i32.add 	$push18=, $2, $pop19
	tee_local	$push17=, $4=, $pop18
	i32.load	$push2=, 0($pop17)
	i32.load	$push3=, 0($2)
	i32.sub 	$push4=, $pop2, $pop3
	i32.add 	$push16=, $pop4, $1
	tee_local	$push15=, $1=, $pop16
	i32.const	$push14=, -1
	i32.add 	$push5=, $pop15, $pop14
	i32.store	$drop=, 0($0), $pop5
	i32.const	$push13=, 4
	i32.add 	$0=, $0, $pop13
	copy_local	$2=, $4
	i32.const	$push12=, 1
	i32.add 	$push11=, $5, $pop12
	tee_local	$push10=, $5=, $pop11
	i32.lt_s	$push6=, $pop10, $3
	br_if   	0, $pop6        # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push16=, 0
	i32.const	$push13=, 0
	i32.load	$push14=, __stack_pointer($pop13)
	i32.const	$push15=, 16
	i32.sub 	$push20=, $pop14, $pop15
	tee_local	$push19=, $0=, $pop20
	i32.store	$drop=, __stack_pointer($pop16), $pop19
	i32.const	$push17=, 4
	i32.add 	$push18=, $0, $pop17
	i32.const	$push2=, b
	i32.const	$push1=, 0
	i32.const	$push0=, 2
	call    	f@FUNCTION, $pop18, $pop2, $pop1, $pop0
	block
	i32.load	$push4=, 4($0)
	i32.const	$push3=, 3
	i32.ne  	$push5=, $pop4, $pop3
	br_if   	0, $pop5        # 0: down to label3
# BB#1:                                 # %lor.lhs.false
	i32.load	$push7=, 8($0)
	i32.const	$push6=, 9
	i32.ne  	$push8=, $pop7, $pop6
	br_if   	0, $pop8        # 0: down to label3
# BB#2:                                 # %lor.lhs.false3
	i32.load	$push10=, 12($0)
	i32.const	$push9=, 21
	i32.ne  	$push11=, $pop10, $pop9
	br_if   	0, $pop11       # 0: down to label3
# BB#3:                                 # %if.end
	i32.const	$push12=, 0
	call    	exit@FUNCTION, $pop12
	unreachable
.LBB1_4:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	b                       # @b
	.type	b,@object
	.section	.data.b,"aw",@progbits
	.globl	b
	.p2align	4
b:
	.int32	1                       # 0x1
	.int32	5                       # 0x5
	.int32	11                      # 0xb
	.int32	23                      # 0x17
	.size	b, 16


	.ident	"clang version 4.0.0 "
	.functype	abort, void
	.functype	exit, void, i32
