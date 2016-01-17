	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr20527-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.gt_s	$push0=, $2, $3
	br_if   	$pop0, 0        # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$push1=, 2
	i32.shl 	$5=, $2, $pop1
	i32.add 	$0=, $0, $5
	i32.const	$4=, -1
	i32.add 	$7=, $2, $4
	i32.const	$6=, 4
	i32.add 	$push2=, $5, $1
	i32.add 	$2=, $pop2, $6
	i32.const	$1=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.load	$push3=, 0($2)
	i32.const	$push4=, -4
	i32.add 	$push5=, $2, $pop4
	i32.load	$push6=, 0($pop5)
	i32.sub 	$push7=, $pop3, $pop6
	i32.add 	$1=, $pop7, $1
	i32.add 	$push8=, $1, $4
	i32.store	$discard=, 0($0), $pop8
	i32.const	$push9=, 1
	i32.add 	$7=, $7, $pop9
	i32.add 	$2=, $2, $6
	i32.add 	$0=, $0, $6
	i32.lt_s	$push10=, $7, $3
	br_if   	$pop10, 0       # 0: up to label1
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
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$4=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	i32.const	$0=, 0
	i32.const	$push0=, b
	i32.const	$push1=, 2
	i32.const	$3=, 4
	i32.add 	$3=, $4, $3
	block
	call    	f@FUNCTION, $3, $pop0, $0, $pop1
	i32.load	$push2=, 4($4)
	i32.const	$push3=, 3
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	$pop4, 0        # 0: down to label3
# BB#1:                                 # %lor.lhs.false
	i32.load	$push5=, 8($4)
	i32.const	$push6=, 9
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	$pop7, 0        # 0: down to label3
# BB#2:                                 # %lor.lhs.false3
	i32.load	$push8=, 12($4)
	i32.const	$push9=, 21
	i32.ne  	$push10=, $pop8, $pop9
	br_if   	$pop10, 0       # 0: down to label3
# BB#3:                                 # %if.end
	call    	exit@FUNCTION, $0
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
	.align	4
b:
	.int32	1                       # 0x1
	.int32	5                       # 0x5
	.int32	11                      # 0xb
	.int32	23                      # 0x17
	.size	b, 16


	.ident	"clang version 3.9.0 "
