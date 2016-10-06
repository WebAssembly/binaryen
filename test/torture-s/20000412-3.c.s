	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000412-3.c"
	.section	.text.z,"ax",@progbits
	.hidden	z
	.globl	z
	.type	z,@function
z:                                      # @z
	.result 	i32
# BB#0:                                 # %f.exit
	i32.const	$push0=, 96
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	z, .Lfunc_end0-z

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 70
	block   	
	i32.load8_u	$push1=, 0($0)
	i32.load8_u	$push0=, 0($1)
	i32.ne  	$push2=, $pop1, $pop0
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.load8_s	$push4=, 1($1)
	i32.load8_s	$push3=, 1($0)
	i32.add 	$2=, $pop4, $pop3
.LBB2_2:                                # %return
	end_block                       # label0:
	copy_local	$push5=, $2
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end2:
	.size	f, .Lfunc_end2-f


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
