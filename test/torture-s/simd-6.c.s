	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/simd-6.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push8=, 7
	i32.add 	$push9=, $0, $pop8
	i32.mul 	$push7=, $16, $8
	i32.store8	$discard=, 0($pop9), $pop7
	i32.const	$push10=, 6
	i32.add 	$push11=, $0, $pop10
	i32.mul 	$push6=, $15, $7
	i32.store8	$discard=, 0($pop11), $pop6
	i32.const	$push12=, 5
	i32.add 	$push13=, $0, $pop12
	i32.mul 	$push5=, $14, $6
	i32.store8	$discard=, 0($pop13), $pop5
	i32.const	$push14=, 4
	i32.add 	$push15=, $0, $pop14
	i32.mul 	$push4=, $13, $5
	i32.store8	$discard=, 0($pop15), $pop4
	i32.const	$push16=, 3
	i32.add 	$push17=, $0, $pop16
	i32.mul 	$push3=, $12, $4
	i32.store8	$discard=, 0($pop17), $pop3
	i32.const	$push18=, 2
	i32.add 	$push19=, $0, $pop18
	i32.mul 	$push2=, $11, $3
	i32.store8	$discard=, 0($pop19), $pop2
	i32.const	$push20=, 1
	i32.add 	$push21=, $0, $pop20
	i32.mul 	$push1=, $10, $2
	i32.store8	$discard=, 0($pop21), $pop1
	i32.mul 	$push0=, $9, $1
	i32.store8	$discard=, 0($0), $pop0
	return
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
