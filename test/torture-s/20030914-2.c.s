	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030914-2.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	return  	$1
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push8=, __stack_pointer
	i32.load	$push9=, 0($pop8)
	i32.const	$push10=, 80
	i32.sub 	$2=, $pop9, $pop10
	i32.const	$push11=, __stack_pointer
	i32.store	$discard=, 0($pop11), $2
	i32.const	$push0=, gs
	i32.const	$push1=, 72
	i32.const	$0=, 8
	i32.add 	$0=, $2, $0
	i32.call	$discard=, memcpy@FUNCTION, $0, $pop0, $pop1
	i32.const	$push2=, 4660
	i32.const	$push6=, 0
	i32.const	$1=, 8
	i32.add 	$1=, $2, $1
	block
	i32.call	$push3=, f@FUNCTION, $1, $pop2, $pop6
	i32.const	$push5=, 4660
	i32.ne  	$push4=, $pop3, $pop5
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push7=, 0
	call    	exit@FUNCTION, $pop7
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	gs                      # @gs
	.type	gs,@object
	.section	.bss.gs,"aw",@nobits
	.globl	gs
	.p2align	2
gs:
	.skip	72
	.size	gs, 72


	.ident	"clang version 3.9.0 "
