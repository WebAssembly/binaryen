	.text
	.file	"va-arg-13.c"
	.section	.text.dummy,"ax",@progbits
	.hidden	dummy                   # -- Begin function dummy
	.globl	dummy
	.type	dummy,@function
dummy:                                  # @dummy
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.load	$push0=, 0($0)
	i32.const	$push1=, 1234
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	dummy, .Lfunc_end0-dummy
                                        # -- End function
	.section	.text.test,"ax",@progbits
	.hidden	test                    # -- Begin function test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32, i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push8=, 0
	i32.load	$push7=, __stack_pointer($pop8)
	i32.const	$push9=, 16
	i32.sub 	$2=, $pop7, $pop9
	i32.const	$push10=, 0
	i32.store	__stack_pointer($pop10), $2
	i32.store	4($2), $1
	block   	
	i32.load	$push1=, 0($1)
	i32.const	$push14=, 1234
	i32.ne  	$push2=, $pop1, $pop14
	br_if   	0, $pop2        # 0: down to label1
# %bb.1:                                # %dummy.exit
	i32.const	$push3=, 4
	i32.or  	$push0=, $2, $pop3
	i32.store	0($pop0), $1
	i32.load	$push4=, 4($2)
	i32.load	$push5=, 0($pop4)
	i32.const	$push15=, 1234
	i32.ne  	$push6=, $pop5, $pop15
	br_if   	0, $pop6        # 0: down to label1
# %bb.2:                                # %dummy.exit15
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $2, $pop11
	i32.store	__stack_pointer($pop13), $pop12
	return
.LBB1_3:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	test, .Lfunc_end1-test
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push3=, 0
	i32.load	$push2=, __stack_pointer($pop3)
	i32.const	$push4=, 16
	i32.sub 	$0=, $pop2, $pop4
	i32.const	$push5=, 0
	i32.store	__stack_pointer($pop5), $0
	i32.const	$push0=, 1234
	i32.store	0($0), $pop0
	call    	test@FUNCTION, $0, $0
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
