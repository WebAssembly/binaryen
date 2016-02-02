	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr48717.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.add 	$push0=, $1, $0
	i32.const	$push1=, 65535
	i32.and 	$push2=, $pop0, $pop1
	return  	$pop2
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push8=, 0
	i32.load	$push1=, w($pop8)
	tee_local	$push7=, $0=, $pop1
	i32.const	$push2=, -1
	i32.xor 	$push3=, $pop7, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 65535
	i32.and 	$push6=, $pop4, $pop5
	i32.store	$discard=, v($pop0), $pop6
	return
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
	block
	i32.const	$push11=, 0
	i32.const	$push10=, 0
	i32.load	$push0=, w($pop10)
	tee_local	$push9=, $0=, $pop0
	i32.const	$push1=, -1
	i32.xor 	$push2=, $pop9, $pop1
	i32.add 	$push3=, $pop2, $0
	i32.const	$push4=, 65535
	i32.and 	$push5=, $pop3, $pop4
	i32.store	$push6=, v($pop11), $pop5
	i32.const	$push8=, 65535
	i32.ne  	$push7=, $pop6, $pop8
	br_if   	$pop7, 0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push12=, 0
	return  	$pop12
.LBB2_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	v                       # @v
	.type	v,@object
	.section	.data.v,"aw",@progbits
	.globl	v
	.p2align	2
v:
	.int32	1                       # 0x1
	.size	v, 4

	.hidden	w                       # @w
	.type	w,@object
	.section	.bss.w,"aw",@nobits
	.globl	w
	.p2align	2
w:
	.int32	0                       # 0x0
	.size	w, 4


	.ident	"clang version 3.9.0 "
