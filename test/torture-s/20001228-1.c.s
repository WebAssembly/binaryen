	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20001228-1.c"
	.section	.text.foo1,"ax",@progbits
	.hidden	foo1
	.globl	foo1
	.type	foo1,@function
foo1:                                   # @foo1
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	foo1, .Lfunc_end0-foo1

	.section	.text.foo2,"ax",@progbits
	.hidden	foo2
	.globl	foo2
	.type	foo2,@function
foo2:                                   # @foo2
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push6=, $pop3, $pop4
	tee_local	$push5=, $0=, $pop6
	i32.const	$push0=, 1
	i32.store	$drop=, 12($pop5), $pop0
	i32.load8_s	$push1=, 12($0)
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end1:
	.size	foo2, .Lfunc_end1-foo2

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push8=, 0
	i32.const	$push5=, 0
	i32.load	$push6=, __stack_pointer($pop5)
	i32.const	$push7=, 16
	i32.sub 	$push9=, $pop6, $pop7
	i32.store	$push11=, __stack_pointer($pop8), $pop9
	tee_local	$push10=, $0=, $pop11
	i32.const	$push1=, 1
	i32.store	$push0=, 12($pop10), $pop1
	i32.load8_u	$push2=, 12($0)
	i32.ne  	$push3=, $pop0, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
	unreachable
.LBB2_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
