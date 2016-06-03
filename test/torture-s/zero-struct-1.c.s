	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/zero-struct-1.c"
	.section	.text.h,"ax",@progbits
	.hidden	h
	.globl	h
	.type	h,@function
h:                                      # @h
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push9=, 0
	i32.load	$push1=, f($pop9)
	i32.const	$push2=, 2
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$drop=, f($pop0), $pop3
	i32.const	$push8=, 0
	i32.const	$push7=, 0
	i32.load	$push4=, ff($pop7)
	i32.const	$push6=, 2
	i32.add 	$push5=, $pop4, $pop6
	i32.store	$drop=, ff($pop8), $pop5
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	h, .Lfunc_end0-h

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push13=, 0
	i32.load	$push2=, f($pop13)
	i32.const	$push3=, 2
	i32.add 	$push4=, $pop2, $pop3
	i32.store	$0=, f($pop1), $pop4
	i32.const	$push12=, 0
	i32.const	$push11=, 0
	i32.load	$push5=, ff($pop11)
	i32.const	$push10=, 2
	i32.add 	$push0=, $pop5, $pop10
	i32.store	$1=, ff($pop12), $pop0
	block
	i32.const	$push9=, y+2
	i32.ne  	$push6=, $0, $pop9
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push14=, y+2
	i32.ne  	$push7=, $1, $pop14
	br_if   	0, $pop7        # 0: down to label0
# BB#2:                                 # %if.end3
	i32.const	$push8=, 0
	return  	$pop8
.LBB1_3:                                # %if.then2
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	y                       # @y
	.type	y,@object
	.section	.bss.y,"aw",@nobits
	.globl	y
y:
	.skip	3
	.size	y, 3

	.hidden	f                       # @f
	.type	f,@object
	.section	.data.f,"aw",@progbits
	.globl	f
	.p2align	2
f:
	.int32	y
	.size	f, 4

	.hidden	ff                      # @ff
	.type	ff,@object
	.section	.data.ff,"aw",@progbits
	.globl	ff
	.p2align	2
ff:
	.int32	y
	.size	ff, 4


	.ident	"clang version 3.9.0 "
	.functype	abort, void
