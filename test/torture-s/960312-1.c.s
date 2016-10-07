	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960312-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 16
	i32.add 	$push4=, $0, $pop0
	tee_local	$push3=, $3=, $pop4
	i32.load	$4=, 0($pop3)
	i32.load	$5=, 12($0)
	i32.load	$push2=, 8($0)
	tee_local	$push1=, $6=, $pop2
	i32.load	$7=, 0($pop1)
	i32.load	$2=, 8($6)
	i32.load	$1=, 4($6)
	#APP
	#NO_APP
	i32.store	0($6), $4
	i32.store	8($6), $7
	i32.store	0($0), $6
	i32.store	12($0), $2
	i32.store	0($3), $5
	i32.store	4($0), $1
	copy_local	$push5=, $0
                                        # fallthrough-return: $pop5
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
	i32.const	$push7=, 0
	i32.load	$2=, main.sc($pop7)
	i32.const	$push6=, 0
	i32.load	$1=, main.sc+8($pop6)
	i32.const	$push5=, 0
	i32.load	$0=, main.sc+4($pop5)
	#APP
	#NO_APP
	i32.const	$push4=, 0
	i32.const	$push0=, 11
	i32.store	main.sc($pop4), $pop0
	i32.const	$push3=, 0
	i32.store	main.sc+8($pop3), $2
	block   	
	i32.const	$push1=, 2
	i32.ne  	$push2=, $2, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push8=, 0
	call    	exit@FUNCTION, $pop8
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	main.sc,@object         # @main.sc
	.section	.data.main.sc,"aw",@progbits
	.p2align	2
main.sc:
	.int32	2                       # 0x2
	.int32	3                       # 0x3
	.int32	4                       # 0x4
	.size	main.sc, 12


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
