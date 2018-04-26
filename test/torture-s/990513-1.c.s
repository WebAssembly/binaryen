	.text
	.file	"990513-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$3=, 1024
.LBB0_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.add 	$2=, $0, $3
	i32.const	$push8=, -8
	i32.add 	$push0=, $2, $pop8
	i32.store	0($pop0), $1
	i32.const	$push7=, -4
	i32.add 	$push1=, $2, $pop7
	i32.store	0($pop1), $1
	i32.const	$push6=, -12
	i32.add 	$push2=, $2, $pop6
	i32.store	0($pop2), $1
	i32.const	$push5=, -16
	i32.add 	$push3=, $2, $pop5
	i32.store	0($pop3), $1
	i32.const	$push4=, -16
	i32.add 	$3=, $3, $pop4
	br_if   	0, $3           # 0: up to label0
# %bb.2:                                # %while.end
	end_loop
                                        # fallthrough-return
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
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push8=, 0
	i32.load	$push7=, __stack_pointer($pop8)
	i32.const	$push9=, 1024
	i32.sub 	$1=, $pop7, $pop9
	i32.const	$push10=, 0
	i32.store	__stack_pointer($pop10), $1
	i32.const	$2=, 1024
	i32.const	$push0=, 0
	i32.const	$push14=, 1024
	i32.call	$0=, memset@FUNCTION, $1, $pop0, $pop14
.LBB1_1:                                # %while.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.add 	$1=, $0, $2
	i32.const	$push19=, -8
	i32.add 	$push1=, $1, $pop19
	i64.const	$push18=, 25769803782
	i64.store	0($pop1):p2align=2, $pop18
	i32.const	$push17=, -16
	i32.add 	$push2=, $1, $pop17
	i64.const	$push16=, 25769803782
	i64.store	0($pop2):p2align=2, $pop16
	i32.const	$push15=, -16
	i32.add 	$2=, $2, $pop15
	br_if   	0, $2           # 0: up to label1
# %bb.2:                                # %foo.exit
	end_loop
	block   	
	i32.load	$push4=, 0($0)
	i32.const	$push3=, 6
	i32.ne  	$push5=, $pop4, $pop3
	br_if   	0, $pop5        # 0: down to label2
# %bb.3:                                # %if.end
	i32.const	$push13=, 0
	i32.const	$push11=, 1024
	i32.add 	$push12=, $0, $pop11
	i32.store	__stack_pointer($pop13), $pop12
	i32.const	$push6=, 0
	return  	$pop6
.LBB1_4:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
