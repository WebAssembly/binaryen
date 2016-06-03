	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050119-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	block
	i32.load8_u	$push1=, 0($0)
	i32.load8_u	$push0=, 1($0)
	i32.ne  	$push2=, $pop1, $pop0
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.load8_u	$push3=, 2($0)
	i32.const	$push4=, 2
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#2:                                 # %if.end7
	return
.LBB0_3:                                # %if.then6
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push10=, $pop5, $pop6
	i32.store	$push12=, __stack_pointer($pop7), $pop10
	tee_local	$push11=, $1=, $pop12
	i32.const	$push0=, 50462977
	i32.store	$drop=, 8($pop11), $pop0
	i32.const	$push1=, 3
	i32.store8	$drop=, 12($1), $pop1
	i32.const	$push2=, 258
	i32.store16	$drop=, 13($1):p2align=0, $pop2
	i32.const	$push3=, 0
	i32.store8	$0=, 15($1), $pop3
	i32.const	$push8=, 8
	i32.add 	$push9=, $1, $pop8
	call    	foo@FUNCTION, $pop9
	call    	exit@FUNCTION, $0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
