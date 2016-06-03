	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr39120.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, x($pop0)
	i32.const	$push2=, 1
	i32.store	$drop=, 0($pop1), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.const	$push5=, 0
	i32.load	$push6=, __stack_pointer($pop5)
	i32.const	$push7=, 16
	i32.sub 	$push14=, $pop6, $pop7
	i32.store	$push18=, __stack_pointer($pop8), $pop14
	tee_local	$push17=, $1=, $pop18
	i32.const	$push0=, 0
	i32.store	$push16=, 12($pop17), $pop0
	tee_local	$push15=, $0=, $pop16
	i32.const	$push12=, 12
	i32.add 	$push13=, $1, $pop12
	i32.call	$push1=, foo@FUNCTION, $pop13
	i32.store	$drop=, x($pop15), $pop1
	call    	bar@FUNCTION
	block
	i32.load	$push3=, 12($1)
	i32.const	$push2=, 1
	i32.ne  	$push4=, $pop3, $pop2
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push11=, 0
	i32.const	$push9=, 16
	i32.add 	$push10=, $1, $pop9
	i32.store	$drop=, __stack_pointer($pop11), $pop10
	return  	$0
.LBB2_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.p2align	2
x:
	.skip	4
	.size	x, 4


	.ident	"clang version 3.9.0 "
	.functype	abort, void
