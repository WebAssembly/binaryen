	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20120111-1.c"
	.section	.text.f0a,"ax",@progbits
	.hidden	f0a
	.globl	f0a
	.type	f0a,@function
f0a:                                    # @f0a
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i64.const	$push0=, -3
	i64.gt_u	$push1=, $0, $pop0
	i32.const	$push2=, -1
	i32.xor 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	f0a, .Lfunc_end0-f0a

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i64.const	$push0=, -6352373499721454287
	i32.call	$push1=, f0a@FUNCTION, $pop0
	i32.const	$push2=, -1
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
