	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/alloca-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push3=, 0
	i32.load	$push4=, __stack_pointer($pop3)
	i32.const	$push5=, 32
	i32.sub 	$push6=, $pop4, $pop5
	i32.const	$push0=, 15
	i32.and 	$push1=, $pop6, $pop0
	i32.eqz 	$push2=, $pop1
                                        # fallthrough-return: $pop2
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
	block
	i32.const	$push6=, 0
	i32.const	$push3=, 0
	i32.load	$push4=, __stack_pointer($pop3)
	i32.const	$push5=, 32
	i32.sub 	$push10=, $pop4, $pop5
	i32.store	$push12=, __stack_pointer($pop6), $pop10
	tee_local	$push11=, $0=, $pop12
	i32.const	$push0=, 15
	i32.and 	$push1=, $pop11, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push9=, 0
	i32.const	$push7=, 32
	i32.add 	$push8=, $0, $pop7
	i32.store	$drop=, __stack_pointer($pop9), $pop8
	i32.const	$push2=, 0
	return  	$pop2
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
