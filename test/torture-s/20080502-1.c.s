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
	i64.store	$discard=, 0($0), $pop2
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push11=, __stack_pointer
	i32.const	$push8=, __stack_pointer
	i32.load	$push9=, 0($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push15=, $pop9, $pop10
	i32.store	$push17=, 0($pop11), $pop15
	tee_local	$push16=, $0=, $pop17
	i64.const	$push1=, 0
	i64.const	$push0=, -4611967493404098560
	call    	foo@FUNCTION, $pop16, $pop1, $pop0
	block
	i64.load	$push3=, 0($0)
	i64.load	$push2=, 8($0)
	i64.const	$push5=, -8905435550453399112
	i64.const	$push4=, 4611846683310179025
	i32.call	$push6=, __eqtf2@FUNCTION, $pop3, $pop2, $pop5, $pop4
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push14=, __stack_pointer
	i32.const	$push12=, 16
	i32.add 	$push13=, $0, $pop12
	i32.store	$discard=, 0($pop14), $pop13
	i32.const	$push7=, 0
	return  	$pop7
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
