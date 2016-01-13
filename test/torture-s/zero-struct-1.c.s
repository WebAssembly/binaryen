	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/zero-struct-1.c"
	.section	.text.h,"ax",@progbits
	.hidden	h
	.globl	h
	.type	h,@function
h:                                      # @h
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, ff($0)
	i32.const	$2=, 2
	i32.load	$push0=, f($0)
	i32.add 	$push1=, $pop0, $2
	i32.store	$discard=, f($0), $pop1
	i32.add 	$push2=, $1, $2
	i32.store	$discard=, ff($0), $pop2
	return
.Lfunc_end0:
	.size	h, .Lfunc_end0-h

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, f($0)
	i32.load	$2=, ff($0)
	i32.const	$3=, 2
	block
	i32.add 	$push1=, $1, $3
	i32.store	$discard=, f($0), $pop1
	i32.add 	$push0=, $2, $3
	i32.store	$3=, ff($0), $pop0
	i32.const	$push2=, y
	i32.ne  	$push3=, $1, $pop2
	br_if   	$pop3, 0        # 0: down to label0
# BB#1:                                 # %if.end
	block
	i32.const	$push4=, y+2
	i32.ne  	$push5=, $3, $pop4
	br_if   	$pop5, 0        # 0: down to label1
# BB#2:                                 # %if.end3
	return  	$0
.LBB1_3:                                # %if.then2
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB1_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
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
	.align	2
f:
	.int32	y
	.size	f, 4

	.hidden	ff                      # @ff
	.type	ff,@object
	.section	.data.ff,"aw",@progbits
	.globl	ff
	.align	2
ff:
	.int32	y
	.size	ff, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
