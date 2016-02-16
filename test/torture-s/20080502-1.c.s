	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20080502-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i64, i64
# BB#0:                                 # %entry
	i32.const	$push5=, 8
	i32.add 	$push6=, $0, $pop5
	i64.const	$push0=, 63
	i64.shr_s	$push8=, $2, $pop0
	tee_local	$push7=, $2=, $pop8
	i64.const	$push3=, 4611846683310179025
	i64.and 	$push4=, $pop7, $pop3
	i64.store	$discard=, 0($pop6), $pop4
	i64.const	$push1=, -8905435550453399112
	i64.and 	$push2=, $2, $pop1
	i64.store	$discard=, 0($0):p2align=4, $pop2
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

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
	i64.const	$push1=, 0
	i64.const	$push0=, -4611967493404098560
	call    	foo@FUNCTION, $3, $pop1, $pop0
	block
	i64.load	$push5=, 0($3):p2align=4
	i32.const	$push2=, 8
	i32.or  	$push3=, $3, $pop2
	i64.load	$push4=, 0($pop3)
	i64.const	$push7=, -8905435550453399112
	i64.const	$push6=, 4611846683310179025
	i32.call	$push8=, __eqtf2@FUNCTION, $pop5, $pop4, $pop7, $pop6
	br_if   	0, $pop8        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push9=, 0
	i32.const	$2=, 16
	i32.add 	$3=, $3, $2
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $3
	return  	$pop9
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
