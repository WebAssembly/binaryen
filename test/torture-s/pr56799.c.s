	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr56799.c"
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
	i64.const	$push2=, 4295032832
	i64.store	$discard=, 8($3), $pop2
	i32.const	$2=, 8
	i32.add 	$2=, $3, $2
	block
	i32.call	$push3=, foo@FUNCTION, $2
	i32.const	$push4=, 2
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push9=, 0
	i32.load	$push0=, lo($pop9)
	br_if   	0, $pop0        # 0: down to label0
# BB#2:                                 # %entry
	i32.const	$push10=, 0
	i32.load	$push1=, hi($pop10)
	i32.const	$push6=, 1
	i32.ne  	$push7=, $pop1, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#3:                                 # %if.then
	i32.const	$push8=, 0
	call    	exit@FUNCTION, $pop8
	unreachable
.LBB0_4:                                # %if.end
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block
	i32.load	$push9=, 0($0)
	tee_local	$push8=, $2=, $pop9
	i32.const	$push7=, 65535
	i32.and 	$push0=, $pop8, $pop7
	i32.const	$push11=, 0
	i32.eq  	$push12=, $pop0, $pop11
	br_if   	0, $pop12       # 0: down to label1
# BB#1:                                 # %if.then
	i32.const	$push1=, 0
	i32.const	$push2=, 1
	i32.store	$discard=, lo($pop1), $pop2
	i32.load	$1=, 4($0)
.LBB1_2:                                # %if.end
	end_block                       # label1:
	block
	block
	i32.const	$push10=, 65535
	i32.le_u	$push3=, $2, $pop10
	br_if   	0, $pop3        # 0: down to label3
# BB#3:                                 # %if.then7
	i32.const	$push4=, 0
	i32.const	$push5=, 1
	i32.store	$discard=, hi($pop4), $pop5
	i32.load	$0=, 4($0)
	i32.add 	$1=, $0, $1
	br      	1               # 1: down to label2
.LBB1_4:                                # %if.end.if.end10_crit_edge
	end_block                       # label3:
	i32.load	$0=, 4($0)
.LBB1_5:                                # %if.end10
	end_block                       # label2:
	i32.add 	$push6=, $0, $1
	return  	$pop6
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.hidden	hi                      # @hi
	.type	hi,@object
	.section	.bss.hi,"aw",@nobits
	.globl	hi
	.p2align	2
hi:
	.int32	0                       # 0x0
	.size	hi, 4

	.hidden	lo                      # @lo
	.type	lo,@object
	.section	.bss.lo,"aw",@nobits
	.globl	lo
	.p2align	2
lo:
	.int32	0                       # 0x0
	.size	lo, 4


	.ident	"clang version 3.9.0 "
