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
	i32.const	$push1=, 2
	i32.shl 	$push12=, $2, $pop1
	tee_local	$push11=, $5=, $pop12
	i32.add 	$0=, $0, $pop11
	i32.const	$push10=, -1
	i32.add 	$4=, $2, $pop10
	i32.add 	$push2=, $5, $1
	i32.const	$push9=, 4
	i32.add 	$2=, $pop2, $pop9
	i32.const	$1=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.load	$push3=, 0($2)
	i32.const	$push17=, -4
	i32.add 	$push4=, $2, $pop17
	i32.load	$push5=, 0($pop4)
	i32.sub 	$push6=, $pop3, $pop5
	i32.add 	$1=, $pop6, $1
	i32.const	$push16=, -1
	i32.add 	$push7=, $1, $pop16
	i32.store	$discard=, 0($0), $pop7
	i32.const	$push15=, 1
	i32.add 	$4=, $4, $pop15
	i32.const	$push14=, 4
	i32.add 	$2=, $2, $pop14
	i32.const	$push13=, 4
	i32.add 	$0=, $0, $pop13
	i32.lt_s	$push8=, $4, $3
	br_if   	0, $pop8        # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	return
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$3=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$3=, 0($1), $3
	i32.const	$push0=, b
	i32.const	$push2=, 0
	i32.const	$push1=, 2
	i32.const	$2=, 4
	i32.add 	$2=, $3, $2
	call    	f@FUNCTION, $2, $pop0, $pop2, $pop1
	block
	i32.load	$push3=, 4($3)
	i32.const	$push4=, 3
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label3
# BB#1:                                 # %lor.lhs.false
	i32.load	$push6=, 8($3)
	i32.const	$push7=, 9
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label3
# BB#2:                                 # %lor.lhs.false3
	i32.load	$push9=, 12($3)
	i32.const	$push10=, 21
	i32.ne  	$push11=, $pop9, $pop10
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


	.ident	"clang version 3.9.0 "
