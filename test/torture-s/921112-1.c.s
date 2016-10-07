	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/921112-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	8($0), $pop0
	copy_local	$push1=, $0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i64.const	$push1=, 8589934593
	i64.store	x+8($pop2), $pop1
	i32.const	$push7=, 0
	i64.const	$push6=, 8589934593
	i64.store	v($pop7), $pop6
	block   	
	i32.const	$push5=, 0
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %entry
	i64.const	$push0=, 8589934592
	i64.const	$push8=, 8589934592
	i64.ne  	$push3=, $pop0, $pop8
	br_if   	0, $pop3        # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
	unreachable
.LBB1_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.p2align	4
x:
	.skip	16
	.size	x, 16

	.hidden	v                       # @v
	.type	v,@object
	.section	.bss.v,"aw",@nobits
	.globl	v
	.p2align	3
v:
	.skip	8
	.size	v, 8


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
