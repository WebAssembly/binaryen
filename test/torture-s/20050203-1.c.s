	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050203-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push6=, 0
	i32.const	$push3=, 0
	i32.load	$push4=, __stack_pointer($pop3)
	i32.const	$push5=, 16
	i32.sub 	$push9=, $pop4, $pop5
	i32.store	$push11=, __stack_pointer($pop6), $pop9
	tee_local	$push10=, $0=, $pop11
	i32.const	$push7=, 15
	i32.add 	$push8=, $pop10, $pop7
	call    	foo@FUNCTION, $pop8
	i32.load8_s	$0=, 15($0)
	call    	bar@FUNCTION
	block
	i32.const	$push0=, -1
	i32.gt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
.LBB0_2:                                # %if.else
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.foo,"ax",@progbits
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 129
	i32.store8	$drop=, 0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.bar,"ax",@progbits
	.type	bar,@function
bar:                                    # @bar
# BB#0:                                 # %entry
	#APP
	#NO_APP
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	bar, .Lfunc_end2-bar


	.ident	"clang version 3.9.0 "
	.functype	exit, void, i32
	.functype	abort, void
