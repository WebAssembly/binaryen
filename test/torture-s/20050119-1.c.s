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
	i32.load8_u	$push0=, 0($0)
	i32.load8_u	$push1=, 1($0)
	i32.ne  	$push2=, $pop0, $pop1
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push7=, __stack_pointer
	i32.load	$push8=, 0($pop7)
	i32.const	$push9=, 16
	i32.sub 	$2=, $pop8, $pop9
	i32.const	$push10=, __stack_pointer
	i32.store	$discard=, 0($pop10), $2
	i32.const	$push0=, 1
	i32.store8	$push1=, 8($2):p2align=3, $pop0
	i32.store8	$discard=, 9($2), $pop1
	i32.const	$push2=, 2
	i32.store8	$discard=, 10($2):p2align=1, $pop2
	i32.const	$push3=, 3
	i32.store8	$push4=, 11($2), $pop3
	i32.store8	$discard=, 12($2):p2align=2, $pop4
	i32.const	$push5=, 258
	i32.store16	$discard=, 13($2):p2align=0, $pop5
	i32.const	$push6=, 0
	i32.store8	$0=, 15($2), $pop6
	i32.const	$1=, 8
	i32.add 	$1=, $2, $1
	call    	foo@FUNCTION, $1
	call    	exit@FUNCTION, $0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
