	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20071018-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 8
	i32.call	$push1=, __builtin_malloc@FUNCTION, $pop0
	i32.store	$discard=, 0($0), $pop1
	return
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 5
	i32.shl 	$push3=, $0, $pop2
	i32.const	$push0=, 16
	i32.call	$push1=, __builtin_malloc@FUNCTION, $pop0
	i32.add 	$push4=, $pop3, $pop1
	i32.const	$push5=, -20
	i32.add 	$push9=, $pop4, $pop5
	tee_local	$push8=, $0=, $pop9
	i32.const	$push6=, 0
	i32.store	$discard=, 0($pop8), $pop6
	call    	bar@FUNCTION, $0
	i32.load	$push7=, 0($0)
	return  	$pop7
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 1
	i32.call	$push1=, foo@FUNCTION, $pop0
	i32.const	$push3=, 0
	i32.eq  	$push4=, $pop1, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push2=, 0
	return  	$pop2
.LBB2_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
