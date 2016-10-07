	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020810-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push1=, 0($0)
	i32.const	$push6=, 0
	i32.load	$push0=, R($pop6)
	i32.ne  	$push2=, $pop1, $pop0
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.load	$push4=, 4($0)
	i32.const	$push7=, 0
	i32.load	$push3=, R+4($pop7)
	i32.ne  	$push5=, $pop4, $pop3
	br_if   	0, $pop5        # 0: down to label0
# BB#2:                                 # %if.end
	return
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i64.load	$push1=, R($pop0)
	i64.store	0($0):p2align=2, $pop1
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	g, .Lfunc_end1-g

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64
# BB#0:                                 # %f.exit
	block   	
	i32.const	$push12=, 0
	i64.load	$push11=, R($pop12)
	tee_local	$push10=, $0=, $pop11
	i32.wrap/i64	$push3=, $pop10
	i32.const	$push9=, 0
	i32.load	$push2=, R($pop9)
	i32.ne  	$push4=, $pop3, $pop2
	br_if   	0, $pop4        # 0: down to label1
# BB#1:                                 # %f.exit
	i64.const	$push5=, 32
	i64.shr_u	$push6=, $0, $pop5
	i32.wrap/i64	$push0=, $pop6
	i32.const	$push13=, 0
	i32.load	$push1=, R+4($pop13)
	i32.ne  	$push7=, $pop0, $pop1
	br_if   	0, $pop7        # 0: down to label1
# BB#2:                                 # %if.end
	i32.const	$push8=, 0
	return  	$pop8
.LBB2_3:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	R                       # @R
	.type	R,@object
	.section	.data.R,"aw",@progbits
	.globl	R
	.p2align	3
R:
	.int32	100                     # 0x64
	.int32	200                     # 0xc8
	.size	R, 8


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
