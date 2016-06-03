	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr41395-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	i32.shl 	$push1=, $1, $pop0
	i32.add 	$push2=, $0, $pop1
	i32.const	$push3=, 8
	i32.add 	$push10=, $pop2, $pop3
	tee_local	$push9=, $1=, $pop10
	i32.const	$push4=, 0
	i32.store16	$drop=, 0($pop9), $pop4
	i32.const	$push5=, 24
	i32.add 	$push6=, $0, $pop5
	i32.const	$push8=, 1
	i32.store16	$drop=, 0($pop6), $pop8
	i32.load16_s	$push7=, 0($1)
                                        # fallthrough-return: $pop7
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 268
	i32.call	$push1=, malloc@FUNCTION, $pop0
	i32.const	$push2=, 8
	i32.call	$push3=, foo@FUNCTION, $pop1, $pop2
	i32.const	$push4=, 65535
	i32.and 	$push5=, $pop3, $pop4
	i32.const	$push6=, 1
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push8=, 0
	return  	$pop8
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	malloc, i32, i32
	.functype	abort, void
