	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000707-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 4
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.load	$push0=, 4($0)
	i32.const	$push1=, 4
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %foo.exit
	return
.LBB1_2:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
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
	i32.const	$push7=, __stack_pointer
	i32.load	$push8=, 0($pop7)
	i32.const	$push9=, 16
	i32.sub 	$1=, $pop8, $pop9
	i32.const	$push10=, __stack_pointer
	i32.store	$discard=, 0($pop10), $1
	i32.const	$push11=, 4
	i32.add 	$push12=, $1, $pop11
	i32.const	$push2=, 8
	i32.add 	$push3=, $pop12, $pop2
	i32.const	$push0=, 0
	i32.load	$push1=, .Lmain.x+8($pop0)
	i32.store	$discard=, 0($pop3), $pop1
	i32.const	$push6=, 0
	i64.load	$push4=, .Lmain.x($pop6):p2align=2
	i64.store	$discard=, 4($1):p2align=2, $pop4
	i32.const	$push13=, 4
	i32.add 	$push14=, $1, $pop13
	call    	bar@FUNCTION, $pop14, $0, $0
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	.Lmain.x,@object        # @main.x
	.section	.rodata..Lmain.x,"a",@progbits
	.p2align	2
.Lmain.x:
	.int32	3                       # 0x3
	.int32	4                       # 0x4
	.int32	5                       # 0x5
	.size	.Lmain.x, 12


	.ident	"clang version 3.9.0 "
