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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push8=, __stack_pointer
	i32.const	$push5=, __stack_pointer
	i32.load	$push6=, 0($pop5)
	i32.const	$push7=, 16
	i32.sub 	$push11=, $pop6, $pop7
	i32.store	$push15=, 0($pop8), $pop11
	tee_local	$push14=, $0=, $pop15
	i32.const	$push2=, 12
	i32.add 	$push3=, $pop14, $pop2
	i32.const	$push0=, 0
	i32.load	$push1=, .Lmain.x+8($pop0)
	i32.store	$discard=, 0($pop3), $pop1
	i32.const	$push13=, 0
	i64.load	$push4=, .Lmain.x($pop13):p2align=2
	i64.store	$discard=, 4($0):p2align=2, $pop4
	i32.const	$push9=, 4
	i32.add 	$push10=, $0, $pop9
	call    	bar@FUNCTION, $pop10, $0, $0
	i32.const	$push12=, 0
	call    	exit@FUNCTION, $pop12
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
