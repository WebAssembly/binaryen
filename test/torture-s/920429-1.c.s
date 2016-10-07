	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920429-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.load8_u	$push13=, 0($0)
	tee_local	$push12=, $1=, $pop13
	i32.const	$push0=, 7
	i32.and 	$push1=, $pop12, $pop0
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	j($pop4), $pop3
	i32.const	$push11=, 0
	i32.const	$push10=, 1
	i32.shr_u	$push5=, $1, $pop10
	i32.const	$push9=, 1
	i32.and 	$push6=, $pop5, $pop9
	i32.store	i($pop11), $pop6
	i32.const	$push8=, 1
	i32.add 	$push7=, $0, $pop8
                                        # fallthrough-return: $pop7
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push1=, 0
	i32.const	$push0=, 2
	i32.store	j($pop1), $pop0
	i32.const	$push4=, 0
	i32.const	$push3=, 0
	i32.store	i($pop4), $pop3
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.hidden	j                       # @j
	.type	j,@object
	.section	.bss.j,"aw",@nobits
	.globl	j
	.p2align	2
j:
	.int32	0                       # 0x0
	.size	j, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
