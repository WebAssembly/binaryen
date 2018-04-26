	.text
	.file	"string-opt-17.c"
	.section	.text.test1,"ax",@progbits
	.hidden	test1                   # -- Begin function test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, .L.str
	i32.add 	$push1=, $1, $pop0
	i32.call	$drop=, strcpy@FUNCTION, $0, $pop1
	i32.const	$push2=, 1
	i32.add 	$push3=, $1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	test1, .Lfunc_end0-test1
                                        # -- End function
	.section	.text.check2,"ax",@progbits
	.hidden	check2                  # -- Begin function check2
	.globl	check2
	.type	check2,@function
check2:                                 # @check2
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push3=, 0
	i32.load8_u	$push0=, check2.r($pop3)
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push4=, 0
	i32.const	$push1=, 1
	i32.store8	check2.r($pop4), $pop1
	i32.const	$push2=, 6
	return  	$pop2
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	check2, .Lfunc_end1-check2
                                        # -- End function
	.section	.text.test2,"ax",@progbits
	.hidden	test2                   # -- Begin function test2
	.globl	test2
	.type	test2,@function
test2:                                  # @test2
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push3=, 0
	i32.load8_u	$push0=, check2.r($pop3)
	br_if   	0, $pop0        # 0: down to label1
# %bb.1:                                # %check2.exit
	i32.const	$push4=, 0
	i32.const	$push1=, 1
	i32.store8	check2.r($pop4), $pop1
	i32.const	$push2=, 8020322
	i32.store	0($0):p2align=0, $pop2
	return
.LBB2_2:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	test2, .Lfunc_end2-test2
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %lor.lhs.false
	i32.const	$push9=, 0
	i32.load	$push8=, __stack_pointer($pop9)
	i32.const	$push10=, 16
	i32.sub 	$0=, $pop8, $pop10
	i32.const	$push11=, 0
	i32.store	__stack_pointer($pop11), $0
	i32.const	$push15=, 0
	i32.load8_u	$push0=, .L.str+9($pop15)
	i32.store8	6($0), $pop0
	i32.const	$push14=, 0
	i32.load16_u	$push1=, .L.str+7($pop14):p2align=0
	i32.store16	4($0), $pop1
	block   	
	block   	
	i32.const	$push12=, 4
	i32.add 	$push13=, $0, $pop12
	i32.const	$push3=, .L.str.1
	i32.const	$push2=, 3
	i32.call	$push4=, memcmp@FUNCTION, $pop13, $pop3, $pop2
	br_if   	0, $pop4        # 0: down to label3
# %bb.1:                                # %if.end
	i32.const	$push16=, 0
	i32.load8_u	$push5=, check2.r($pop16)
	i32.eqz 	$push18=, $pop5
	br_if   	1, $pop18       # 1: down to label2
.LBB3_2:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB3_3:                                # %test2.exit
	end_block                       # label2:
	i32.const	$push7=, 0
	i32.const	$push6=, 1
	i32.store8	check2.r($pop7), $pop6
	i32.const	$push17=, 0
	call    	exit@FUNCTION, $pop17
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
                                        # -- End function
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"foobarbaz"
	.size	.L.str, 10

	.type	check2.r,@object        # @check2.r
	.section	.bss.check2.r,"aw",@nobits
	.p2align	2
check2.r:
	.int8	0                       # 0x0
	.size	check2.r, 1

	.type	.L.str.1,@object        # @.str.1
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.1:
	.asciz	"az"
	.size	.L.str.1, 3


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	strcpy, i32, i32, i32
	.functype	abort, void
	.functype	memcmp, i32, i32, i32, i32
	.functype	exit, void, i32
