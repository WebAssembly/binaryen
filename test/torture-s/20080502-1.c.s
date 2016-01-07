	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20080502-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i64, i64
# BB#0:                                 # %entry
	i64.const	$push0=, 63
	i64.shr_s	$2=, $2, $pop0
	i32.const	$push5=, 8
	i32.add 	$push6=, $0, $pop5
	i64.const	$push3=, 4611846683310179025
	i64.and 	$push4=, $2, $pop3
	i64.store	$discard=, 0($pop6), $pop4
	i64.const	$push1=, -8905435550453399112
	i64.and 	$push2=, $2, $pop1
	i64.store	$discard=, 0($0), $pop2
	return
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$5=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$5=, 0($1), $5
	i64.const	$push1=, 0
	i64.const	$push0=, -4611967493404098560
	i32.const	$3=, 0
	i32.add 	$3=, $5, $3
	call    	foo, $3, $pop1, $pop0
	i64.load	$push5=, 0($5)
	i32.const	$push2=, 8
	i32.const	$4=, 0
	i32.add 	$4=, $5, $4
	block   	.LBB1_2
	i32.or  	$push3=, $4, $pop2
	i64.load	$push4=, 0($pop3)
	i64.const	$push7=, -8905435550453399112
	i64.const	$push6=, 4611846683310179025
	i32.call	$push8=, __eqtf2, $pop5, $pop4, $pop7, $pop6
	br_if   	$pop8, .LBB1_2
# BB#1:                                 # %if.end
	i32.const	$push9=, 0
	i32.const	$2=, 16
	i32.add 	$5=, $5, $2
	i32.const	$2=, __stack_pointer
	i32.store	$5=, 0($2), $5
	return  	$pop9
.LBB1_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
