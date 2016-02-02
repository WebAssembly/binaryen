	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr33669.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i64, i32
	.result 	i64
	.local  	i64, i64, i32
# BB#0:                                 # %entry
	i32.load	$push0=, 0($0)
	tee_local	$push15=, $5=, $pop0
	i32.add 	$push4=, $2, $pop15
	i64.extend_u/i32	$push1=, $5
	i64.rem_s	$push2=, $1, $pop1
	tee_local	$push14=, $4=, $pop2
	i32.wrap/i64	$push3=, $pop14
	i32.add 	$push5=, $pop4, $pop3
	i32.const	$push6=, -1
	i32.add 	$2=, $pop5, $pop6
	i64.const	$3=, -1
	block
	i32.rem_u	$push7=, $2, $5
	i32.sub 	$push8=, $2, $pop7
	i32.lt_u	$push9=, $5, $pop8
	br_if   	$pop9, 0        # 0: down to label0
# BB#1:                                 # %if.end
	i64.sub 	$3=, $1, $4
	i32.load	$push10=, 4($0)
	i32.le_u	$push11=, $pop10, $5
	br_if   	$pop11, 0       # 0: down to label0
# BB#2:                                 # %if.then13
	i32.const	$push12=, 4
	i32.add 	$push13=, $0, $pop12
	i32.store	$discard=, 0($pop13), $5
.LBB0_3:                                # %cleanup
	end_block                       # label0:
	return  	$3
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
