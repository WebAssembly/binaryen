	.text
	.file	"pr54471.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i64, i64, i32
	.local  	i64, i64, i32
# %bb.0:                                # %entry
	i32.const	$push7=, 0
	i32.load	$push6=, __stack_pointer($pop7)
	i32.const	$push8=, 32
	i32.sub 	$6=, $pop6, $pop8
	i32.const	$push9=, 0
	i32.store	__stack_pointer($pop9), $6
	block   	
	i32.eqz 	$push22=, $3
	br_if   	0, $pop22       # 0: down to label0
# %bb.1:                                # %for.body.preheader
	i64.const	$5=, 0
	i64.const	$4=, 1
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	call    	__multi3@FUNCTION, $6, $1, $2, $4, $5
	i32.const	$push13=, 16
	i32.add 	$push14=, $6, $pop13
	call    	__multi3@FUNCTION, $pop14, $1, $2, $1, $2
	i32.const	$push19=, -1
	i32.add 	$3=, $3, $pop19
	i32.const	$push15=, 16
	i32.add 	$push16=, $6, $pop15
	i32.const	$push18=, 8
	i32.add 	$push0=, $pop16, $pop18
	i64.load	$2=, 0($pop0)
	i32.const	$push17=, 8
	i32.add 	$push1=, $6, $pop17
	i64.load	$5=, 0($pop1)
	i64.load	$1=, 16($6)
	i64.load	$4=, 0($6)
	br_if   	0, $3           # 0: up to label1
# %bb.3:                                # %for.end
	end_loop
	i64.const	$push20=, 14348907
	i64.xor 	$push2=, $4, $pop20
	i64.or  	$push3=, $pop2, $5
	i64.eqz 	$push4=, $pop3
	i32.eqz 	$push23=, $pop4
	br_if   	0, $pop23       # 0: down to label0
# %bb.4:                                # %if.end
	i64.const	$push5=, 0
	i64.store	8($0), $pop5
	i64.const	$push21=, 14348907
	i64.store	0($0), $pop21
	i32.const	$push12=, 0
	i32.const	$push10=, 32
	i32.add 	$push11=, $6, $pop10
	i32.store	__stack_pointer($pop12), $pop11
	return
.LBB0_5:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push5=, 0
	i32.load	$push4=, __stack_pointer($pop5)
	i32.const	$push6=, 16
	i32.sub 	$0=, $pop4, $pop6
	i32.const	$push7=, 0
	i32.store	__stack_pointer($pop7), $0
	i64.const	$push2=, 3
	i64.const	$push1=, 0
	i32.const	$push0=, 4
	call    	foo@FUNCTION, $0, $pop2, $pop1, $pop0
	i32.const	$push10=, 0
	i32.const	$push8=, 16
	i32.add 	$push9=, $0, $pop8
	i32.store	__stack_pointer($pop10), $pop9
	i32.const	$push3=, 0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
