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
	copy_local	$push0=, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.const	$push5=, 0
	i32.load	$push6=, __stack_pointer($pop5)
	i32.const	$push7=, 80
	i32.sub 	$push13=, $pop6, $pop7
	i32.store	$push17=, __stack_pointer($pop8), $pop13
	tee_local	$push16=, $0=, $pop17
	i32.const	$push9=, 8
	i32.add 	$push10=, $pop16, $pop9
	i32.const	$push1=, gs
	i32.const	$push0=, 72
	i32.call	$drop=, memcpy@FUNCTION, $pop10, $pop1, $pop0
	block
	i32.const	$push11=, 8
	i32.add 	$push12=, $0, $pop11
	i32.const	$push2=, 4660
	i32.const	$push15=, 0
	i32.call	$push3=, f@FUNCTION, $pop12, $pop2, $pop15
	i32.const	$push14=, 4660
	i32.ne  	$push4=, $pop3, $pop14
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push18=, 0
	call    	exit@FUNCTION, $pop18
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
	.functype	abort, void
	.functype	exit, void, i32
