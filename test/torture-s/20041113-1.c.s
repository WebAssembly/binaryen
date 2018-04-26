	.text
	.file	"20041113-1.c"
	.section	.text.test,"ax",@progbits
	.hidden	test                    # -- Begin function test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32, i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push18=, 0
	i32.load	$push17=, __stack_pointer($pop18)
	i32.const	$push19=, 16
	i32.sub 	$4=, $pop17, $pop19
	i32.const	$push20=, 0
	i32.store	__stack_pointer($pop20), $4
	i32.const	$push0=, 4
	i32.add 	$2=, $1, $pop0
	i32.store	12($4), $2
	block   	
	i32.load	$push1=, 0($1)
	i32.const	$push2=, 1
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push4=, 8
	i32.add 	$3=, $1, $pop4
	i32.store	12($4), $3
	i32.load	$push5=, 0($2)
	i32.const	$push6=, 2
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# %bb.2:                                # %if.end6
	i32.const	$push8=, 12
	i32.add 	$2=, $1, $pop8
	i32.store	12($4), $2
	i32.load	$push9=, 0($3)
	i32.const	$push10=, 3
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label0
# %bb.3:                                # %if.end11
	i32.const	$push12=, 16
	i32.add 	$push13=, $1, $pop12
	i32.store	12($4), $pop13
	i32.load	$push14=, 0($2)
	i32.const	$push15=, 4
	i32.ne  	$push16=, $pop14, $pop15
	br_if   	0, $pop16       # 0: down to label0
# %bb.4:                                # %if.end16
	i32.const	$push23=, 0
	i32.const	$push21=, 16
	i32.add 	$push22=, $4, $pop21
	i32.store	__stack_pointer($pop23), $pop22
	return
.LBB0_5:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	test, .Lfunc_end0-test
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	f64, i32, i32
# %bb.0:                                # %entry
	i32.const	$push8=, 0
	i32.load	$push7=, __stack_pointer($pop8)
	i32.const	$push9=, 16
	i32.sub 	$4=, $pop7, $pop9
	i32.const	$push10=, 0
	i32.store	__stack_pointer($pop10), $4
	i64.const	$push0=, 12884901890
	i64.store	4($4):p2align=2, $pop0
	i32.const	$push1=, 1
	i32.store	0($4), $pop1
	i32.const	$push11=, 0
	f64.load	$push2=, a($pop11)
	f64.const	$push3=, 0x1.4p3
	f64.div 	$2=, $pop2, $pop3
	block   	
	block   	
	f64.abs 	$push4=, $2
	f64.const	$push5=, 0x1p31
	f64.lt  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label2
# %bb.1:                                # %entry
	i32.const	$3=, -2147483648
	br      	1               # 1: down to label1
.LBB1_2:                                # %entry
	end_block                       # label2:
	i32.trunc_s/f64	$3=, $2
.LBB1_3:                                # %entry
	end_block                       # label1:
	i32.store	12($4), $3
	call    	test@FUNCTION, $4, $4
	i32.const	$push12=, 0
	call    	exit@FUNCTION, $pop12
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	3
a:
	.int64	4630826316843712512     # double 40
	.size	a, 8


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
