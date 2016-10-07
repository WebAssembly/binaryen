	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr44202-1.c"
	.section	.text.add512,"ax",@progbits
	.hidden	add512
	.globl	add512
	.type	add512,@function
add512:                                 # @add512
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 512
	i32.add 	$push2=, $0, $pop0
	tee_local	$push1=, $2=, $pop2
	i32.eqz 	$push3=, $pop1
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.then
	i32.store	0($1), $0
.LBB0_2:                                # %if.end
	end_block                       # label0:
	copy_local	$push4=, $2
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end0:
	.size	add512, .Lfunc_end0-add512

	.section	.text.add513,"ax",@progbits
	.hidden	add513
	.globl	add513
	.type	add513,@function
add513:                                 # @add513
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 513
	i32.add 	$push2=, $0, $pop0
	tee_local	$push1=, $2=, $pop2
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %if.then
	i32.store	0($1), $0
.LBB1_2:                                # %if.end
	end_block                       # label1:
	copy_local	$push3=, $2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	add513, .Lfunc_end1-add513

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push19=, $pop9, $pop10
	tee_local	$push18=, $0=, $pop19
	i32.store	__stack_pointer($pop11), $pop18
	i32.const	$push17=, -1
	i32.store	12($0), $pop17
	i32.const	$push16=, -1
	i32.store	8($0), $pop16
	block   	
	i32.const	$push1=, -512
	i32.const	$push12=, 12
	i32.add 	$push13=, $0, $pop12
	i32.call	$push2=, add512@FUNCTION, $pop1, $pop13
	br_if   	0, $pop2        # 0: down to label2
# BB#1:                                 # %entry
	i32.load	$push0=, 12($0)
	i32.const	$push20=, -1
	i32.ne  	$push3=, $pop0, $pop20
	br_if   	0, $pop3        # 0: down to label2
# BB#2:                                 # %lor.lhs.false2
	i32.const	$push21=, -513
	i32.const	$push14=, 8
	i32.add 	$push15=, $0, $pop14
	i32.call	$push5=, add513@FUNCTION, $pop21, $pop15
	br_if   	0, $pop5        # 0: down to label2
# BB#3:                                 # %lor.lhs.false2
	i32.load	$push4=, 8($0)
	i32.const	$push22=, -513
	i32.ne  	$push6=, $pop4, $pop22
	br_if   	0, $pop6        # 0: down to label2
# BB#4:                                 # %if.end
	i32.const	$push7=, 0
	call    	exit@FUNCTION, $pop7
	unreachable
.LBB2_5:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
