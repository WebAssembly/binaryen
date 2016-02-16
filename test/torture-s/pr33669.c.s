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
	i32.load	$push15=, 0($0)
	tee_local	$push14=, $5=, $pop15
	i32.add 	$push2=, $2, $pop14
	i64.extend_u/i32	$push0=, $5
	i64.rem_s	$push13=, $1, $pop0
	tee_local	$push12=, $4=, $pop13
	i32.wrap/i64	$push1=, $pop12
	i32.add 	$push3=, $pop2, $pop1
	i32.const	$push4=, -1
	i32.add 	$2=, $pop3, $pop4
	i64.const	$3=, -1
	block
	i32.rem_u	$push5=, $2, $5
	i32.sub 	$push6=, $2, $pop5
	i32.lt_u	$push7=, $5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %if.end
	i64.sub 	$3=, $1, $4
	i32.load	$push8=, 4($0)
	i32.le_u	$push9=, $pop8, $5
	br_if   	0, $pop9        # 0: down to label0
# BB#2:                                 # %if.then13
	i32.const	$push10=, 4
	i32.add 	$push11=, $0, $pop10
	i32.store	$discard=, 0($pop11), $5
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
