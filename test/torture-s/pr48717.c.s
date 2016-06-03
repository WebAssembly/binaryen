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
                                        # fallthrough-return: $pop2
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
	i32.load	$push7=, w($pop8)
	tee_local	$push6=, $0=, $pop7
	i32.const	$push1=, -1
	i32.xor 	$push2=, $pop6, $pop1
	i32.add 	$push3=, $pop2, $0
	i32.const	$push4=, 65535
	i32.and 	$push5=, $pop3, $pop4
	i32.store	$drop=, v($pop0), $pop5
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
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push11=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, w($pop10)
	tee_local	$push8=, $0=, $pop9
	i32.const	$push1=, -1
	i32.xor 	$push2=, $pop8, $pop1
	i32.add 	$push3=, $pop2, $0
	i32.const	$push4=, 65535
	i32.and 	$push5=, $pop3, $pop4
	i32.store	$push0=, v($pop11), $pop5
	i32.const	$push7=, 65535
	i32.ne  	$push6=, $pop0, $pop7
	br_if   	0, $pop6        # 0: down to label0
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
	.functype	abort, void
