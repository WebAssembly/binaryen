	.text
	.file	"va-arg-7.c"
	.section	.text.debug,"ax",@progbits
	.hidden	debug                   # -- Begin function debug
	.globl	debug
	.type	debug,@function
debug:                                  # @debug
	.param  	i32, i32, i32, i32, i32, i32, i32, f64, f64, f64, f64, f64, f64, f64, f64, f64, i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push15=, 0
	i32.load	$push14=, __stack_pointer($pop15)
	i32.const	$push16=, 16
	i32.sub 	$18=, $pop14, $pop16
	i32.const	$push17=, 0
	i32.store	__stack_pointer($pop17), $18
	i32.const	$push0=, 4
	i32.add 	$17=, $16, $pop0
	i32.store	12($18), $17
	block   	
	i32.load	$push1=, 0($16)
	i32.const	$push21=, 8
	i32.ne  	$push2=, $pop1, $pop21
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push22=, 8
	i32.add 	$push3=, $16, $pop22
	i32.store	12($18), $pop3
	i32.load	$push4=, 0($17)
	i32.const	$push5=, 9
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# %bb.2:                                # %if.end6
	i32.const	$push7=, 12
	i32.add 	$push8=, $16, $pop7
	i32.store	12($18), $pop8
	i32.const	$push9=, 8
	i32.add 	$push10=, $16, $pop9
	i32.load	$push11=, 0($pop10)
	i32.const	$push12=, 10
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label0
# %bb.3:                                # %if.end11
	i32.const	$push20=, 0
	i32.const	$push18=, 16
	i32.add 	$push19=, $18, $pop18
	i32.store	__stack_pointer($pop20), $pop19
	return
.LBB0_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	debug, .Lfunc_end0-debug
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f64, i32
# %bb.0:                                # %entry
	i32.const	$push4=, 0
	i32.load	$push3=, __stack_pointer($pop4)
	i32.const	$push5=, 16
	i32.sub 	$1=, $pop3, $pop5
	i32.const	$push6=, 0
	i32.store	__stack_pointer($pop6), $1
	i32.const	$push0=, 10
	i32.store	8($1), $pop0
	i64.const	$push1=, 38654705672
	i64.store	0($1), $pop1
	call    	debug@FUNCTION, $1, $1, $1, $1, $1, $1, $1, $0, $0, $0, $0, $0, $0, $0, $0, $0, $1
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
