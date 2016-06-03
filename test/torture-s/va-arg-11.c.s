	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-11.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push9=, 0
	i32.const	$push6=, 0
	i32.load	$push7=, __stack_pointer($pop6)
	i32.const	$push8=, 32
	i32.sub 	$push10=, $pop7, $pop8
	i32.store	$push12=, __stack_pointer($pop9), $pop10
	tee_local	$push11=, $1=, $pop12
	i32.const	$push0=, 16
	i32.add 	$push1=, $pop11, $pop0
	i32.const	$push2=, 0
	i32.store	$0=, 0($pop1), $pop2
	i64.const	$push3=, 4294967298
	i64.store	$drop=, 8($1), $pop3
	i64.const	$push4=, 12884901892
	i64.store	$drop=, 0($1), $pop4
	block
	i32.call	$push5=, foo@FUNCTION, $1, $1
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %if.end
	call    	exit@FUNCTION, $0
	unreachable
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.foo,"ax",@progbits
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.load	$push6=, __stack_pointer($pop5)
	i32.const	$push7=, 16
	i32.sub 	$push11=, $pop6, $pop7
	tee_local	$push10=, $2=, $pop11
	i32.store	$push9=, 12($2), $1
	tee_local	$push8=, $1=, $pop9
	i32.const	$push0=, 20
	i32.add 	$push1=, $pop8, $pop0
	i32.store	$drop=, 12($pop10), $pop1
	i32.const	$push2=, 16
	i32.add 	$push3=, $1, $pop2
	i32.load	$push4=, 0($pop3)
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
