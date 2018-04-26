	.text
	.file	"pr44202-1.c"
	.section	.text.add512,"ax",@progbits
	.hidden	add512                  # -- Begin function add512
	.globl	add512
	.type	add512,@function
add512:                                 # @add512
	.param  	i32, i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 512
	i32.add 	$2=, $0, $pop0
	block   	
	i32.eqz 	$push1=, $2
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %if.then
	i32.store	0($1), $0
.LBB0_2:                                # %if.end
	end_block                       # label0:
	copy_local	$push2=, $2
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	add512, .Lfunc_end0-add512
                                        # -- End function
	.section	.text.add513,"ax",@progbits
	.hidden	add513                  # -- Begin function add513
	.globl	add513
	.type	add513,@function
add513:                                 # @add513
	.param  	i32, i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 513
	i32.add 	$2=, $0, $pop0
	block   	
	i32.eqz 	$push1=, $2
	br_if   	0, $pop1        # 0: down to label1
# %bb.1:                                # %if.end
	return  	$2
.LBB1_2:                                # %if.then
	end_block                       # label1:
	i32.store	0($1), $0
	copy_local	$push2=, $2
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end1:
	.size	add513, .Lfunc_end1-add513
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push9=, 0
	i32.load	$push8=, __stack_pointer($pop9)
	i32.const	$push10=, 16
	i32.sub 	$0=, $pop8, $pop10
	i32.const	$push11=, 0
	i32.store	__stack_pointer($pop11), $0
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
# %bb.1:                                # %entry
	i32.load	$push0=, 12($0)
	i32.const	$push18=, -1
	i32.ne  	$push3=, $pop0, $pop18
	br_if   	0, $pop3        # 0: down to label2
# %bb.2:                                # %lor.lhs.false2
	i32.const	$push19=, -513
	i32.const	$push14=, 8
	i32.add 	$push15=, $0, $pop14
	i32.call	$push5=, add513@FUNCTION, $pop19, $pop15
	br_if   	0, $pop5        # 0: down to label2
# %bb.3:                                # %lor.lhs.false2
	i32.load	$push4=, 8($0)
	i32.const	$push20=, -513
	i32.ne  	$push6=, $pop4, $pop20
	br_if   	0, $pop6        # 0: down to label2
# %bb.4:                                # %if.end
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
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
