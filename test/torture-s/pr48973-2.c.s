	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr48973-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push12=, 0
	i32.const	$push11=, 0
	i32.load8_u	$push2=, s($pop11)
	i32.const	$push3=, 254
	i32.and 	$push4=, $pop2, $pop3
	i32.const	$push10=, 0
	i32.load	$push0=, v($pop10)
	i32.const	$push1=, 31
	i32.shr_u	$push9=, $pop0, $pop1
	tee_local	$push8=, $0=, $pop9
	i32.or  	$push5=, $pop4, $pop8
	i32.store8	s($pop12), $pop5
	block   	
	i32.const	$push6=, 1
	i32.ne  	$push7=, $0, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push13=, 0
	return  	$pop13
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	v                       # @v
	.type	v,@object
	.section	.data.v,"aw",@progbits
	.globl	v
	.p2align	2
v:
	.int32	4294967295              # 0xffffffff
	.size	v, 4

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.p2align	2
s:
	.skip	4
	.size	s, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
