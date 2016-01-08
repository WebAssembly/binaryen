	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr56799.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$6=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$6=, 0($3), $6
	i32.const	$push2=, 65536
	i32.store	$discard=, 8($6), $pop2
	i32.const	$push3=, 4
	i32.const	$4=, 8
	i32.add 	$4=, $6, $4
	i32.or  	$push4=, $4, $pop3
	i32.const	$push5=, 1
	i32.store	$0=, 0($pop4), $pop5
	i32.const	$5=, 8
	i32.add 	$5=, $6, $5
	block   	.LBB0_4
	i32.call	$push6=, foo, $5
	i32.const	$push7=, 2
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	$pop8, .LBB0_4
# BB#1:                                 # %entry
	i32.const	$1=, 0
	i32.load	$push0=, lo($1)
	br_if   	$pop0, .LBB0_4
# BB#2:                                 # %entry
	i32.load	$push1=, hi($1)
	i32.ne  	$push9=, $pop1, $0
	br_if   	$pop9, .LBB0_4
# BB#3:                                 # %if.then
	call    	exit, $1
	unreachable
.LBB0_4:                                # %if.end
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.load	$1=, 0($0)
	i32.const	$2=, 65535
	i32.const	$3=, 0
	block   	.LBB1_2
	i32.and 	$push0=, $1, $2
	i32.const	$push7=, 0
	i32.eq  	$push8=, $pop0, $pop7
	br_if   	$pop8, .LBB1_2
# BB#1:                                 # %if.then
	i32.const	$push1=, 0
	i32.const	$push2=, 1
	i32.store	$discard=, lo($pop1), $pop2
	i32.load	$3=, 4($0)
.LBB1_2:                                # %if.end
	block   	.LBB1_5
	block   	.LBB1_4
	i32.le_u	$push3=, $1, $2
	br_if   	$pop3, .LBB1_4
# BB#3:                                 # %if.then7
	i32.const	$push4=, 0
	i32.const	$push5=, 1
	i32.store	$discard=, hi($pop4), $pop5
	i32.load	$0=, 4($0)
	i32.add 	$3=, $0, $3
	br      	.LBB1_5
.LBB1_4:                                # %if.end.if.end10_crit_edge
	i32.load	$0=, 4($0)
.LBB1_5:                                # %if.end10
	i32.add 	$push6=, $0, $3
	return  	$pop6
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.hidden	hi                      # @hi
	.type	hi,@object
	.section	.bss.hi,"aw",@nobits
	.globl	hi
	.align	2
hi:
	.int32	0                       # 0x0
	.size	hi, 4

	.hidden	lo                      # @lo
	.type	lo,@object
	.section	.bss.lo,"aw",@nobits
	.globl	lo
	.align	2
lo:
	.int32	0                       # 0x0
	.size	lo, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
