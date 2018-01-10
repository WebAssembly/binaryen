	.text
	.file	"pr33992.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i64
# %bb.0:                                # %entry
	block   	
	i64.eqz 	$push0=, $0
	i32.eqz 	$push1=, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar
                                        # -- End function
	.section	.text.do_test,"ax",@progbits
	.hidden	do_test                 # -- Begin function do_test
	.globl	do_test
	.type	do_test,@function
do_test:                                # @do_test
	.param  	i32
	.local  	i64, i64, i64, i64
# %bb.0:                                # %entry
	i64.load	$1=, 0($0)
	i64.const	$4=, 0
.LBB1_1:                                # %for.cond.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i64.const	$push17=, -1
	i64.add 	$2=, $4, $pop17
	i64.const	$push16=, 63
	i64.add 	$3=, $4, $pop16
	copy_local	$4=, $2
	i64.const	$push15=, 1
	i64.const	$push14=, 4294967295
	i64.and 	$push0=, $3, $pop14
	i64.shl 	$push1=, $pop15, $pop0
	i64.and 	$push2=, $pop1, $1
	i64.eqz 	$push3=, $pop2
	br_if   	0, $pop3        # 0: up to label1
# %bb.2:                                # %foo.exit
	end_loop
	i64.const	$push19=, -1
	i64.xor 	$push4=, $2, $pop19
	i64.const	$push18=, 4294967295
	i64.and 	$push5=, $pop4, $pop18
	call    	bar@FUNCTION, $pop5
	i64.load	$1=, 0($0)
	i64.const	$4=, 0
.LBB1_3:                                # %for.cond.i.1
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i64.const	$push23=, -1
	i64.add 	$2=, $4, $pop23
	i64.const	$push22=, 63
	i64.add 	$3=, $4, $pop22
	copy_local	$4=, $2
	i64.const	$push21=, 1
	i64.const	$push20=, 4294967295
	i64.and 	$push6=, $3, $pop20
	i64.shl 	$push7=, $pop21, $pop6
	i64.and 	$push8=, $pop7, $1
	i64.eqz 	$push9=, $pop8
	br_if   	0, $pop9        # 0: up to label2
# %bb.4:                                # %foo.exit.1
	end_loop
	i64.const	$push10=, -1
	i64.xor 	$push11=, $2, $pop10
	i64.const	$push12=, 4294967295
	i64.and 	$push13=, $pop11, $pop12
	call    	bar@FUNCTION, $pop13
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	do_test, .Lfunc_end1-do_test
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
	i64.const	$push0=, -9223372036854775807
	i64.store	8($0), $pop0
	i32.const	$push9=, 8
	i32.add 	$push10=, $0, $pop9
	call    	do_test@FUNCTION, $pop10
	i32.const	$push8=, 0
	i32.const	$push6=, 16
	i32.add 	$push7=, $0, $pop6
	i32.store	__stack_pointer($pop8), $pop7
	i32.const	$push1=, 0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
