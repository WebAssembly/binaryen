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
                                        # -- End function
	.section	.text.add513,"ax",@progbits
	.hidden	add513                  # -- Begin function add513
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
	i32.eqz 	$push3=, $pop1
	br_if   	0, $pop3        # 0: down to label1
# BB#1:                                 # %if.end
	return  	$2
.LBB1_2:                                # %if.then
	end_block                       # label1:
	i32.store	0($1), $0
	copy_local	$push4=, $2
                                        # fallthrough-return: $pop4
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
# BB#0:                                 # %entry
	i32.const	$push11=, 0
	i32.const	$push9=, 0
	i32.load	$push8=, __stack_pointer($pop9)
	i32.const	$push10=, 16
	i32.sub 	$push19=, $pop8, $pop10
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
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
