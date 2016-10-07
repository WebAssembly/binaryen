	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000412-2.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push12=, $pop3, $pop4
	tee_local	$push11=, $2=, $pop12
	i32.store	__stack_pointer($pop5), $pop11
	i32.store	12($2), $0
	block   	
	block   	
	i32.eqz 	$push13=, $0
	br_if   	0, $pop13       # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push0=, -1
	i32.add 	$push1=, $0, $pop0
	i32.const	$push9=, 12
	i32.add 	$push10=, $2, $pop9
	i32.call	$0=, f@FUNCTION, $pop1, $pop10
	br      	1               # 1: down to label0
.LBB0_2:                                # %if.then
	end_block                       # label1:
	i32.load	$0=, 0($1)
.LBB0_3:                                # %cleanup
	end_block                       # label0:
	i32.const	$push8=, 0
	i32.const	$push6=, 16
	i32.add 	$push7=, $2, $pop6
	i32.store	__stack_pointer($pop8), $pop7
	copy_local	$push14=, $0
                                        # fallthrough-return: $pop14
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 100
	i32.const	$push4=, 0
	i32.call	$push1=, f@FUNCTION, $pop0, $pop4
	i32.const	$push2=, 1
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label2
# BB#1:                                 # %if.end
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
