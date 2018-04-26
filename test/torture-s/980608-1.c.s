	.text
	.file	"980608-1.c"
	.section	.text.f1,"ax",@progbits
	.hidden	f1                      # -- Begin function f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	f1, .Lfunc_end0-f1
                                        # -- End function
	.section	.text.debug,"ax",@progbits
	.hidden	debug                   # -- Begin function debug
	.globl	debug
	.type	debug,@function
debug:                                  # @debug
	.param  	i32, i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push26=, 0
	i32.load	$push25=, __stack_pointer($pop26)
	i32.const	$push27=, 16
	i32.sub 	$4=, $pop25, $pop27
	i32.const	$push28=, 0
	i32.store	__stack_pointer($pop28), $4
	i32.const	$push0=, 4
	i32.add 	$2=, $1, $pop0
	i32.store	12($4), $2
	block   	
	i32.load	$push1=, 0($1)
	i32.const	$push2=, 101
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push4=, 8
	i32.add 	$3=, $1, $pop4
	i32.store	12($4), $3
	i32.load	$push5=, 0($2)
	i32.const	$push6=, 102
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# %bb.2:                                # %if.end6
	i32.const	$push8=, 12
	i32.add 	$2=, $1, $pop8
	i32.store	12($4), $2
	i32.load	$push9=, 0($3)
	i32.const	$push10=, 103
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label0
# %bb.3:                                # %if.end11
	i32.const	$push12=, 16
	i32.add 	$3=, $1, $pop12
	i32.store	12($4), $3
	i32.load	$push13=, 0($2)
	i32.const	$push14=, 104
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	0, $pop15       # 0: down to label0
# %bb.4:                                # %if.end16
	i32.const	$push16=, 20
	i32.add 	$2=, $1, $pop16
	i32.store	12($4), $2
	i32.load	$push17=, 0($3)
	i32.const	$push18=, 105
	i32.ne  	$push19=, $pop17, $pop18
	br_if   	0, $pop19       # 0: down to label0
# %bb.5:                                # %if.end21
	i32.const	$push20=, 24
	i32.add 	$push21=, $1, $pop20
	i32.store	12($4), $pop21
	i32.load	$push22=, 0($2)
	i32.const	$push23=, 106
	i32.ne  	$push24=, $pop22, $pop23
	br_if   	0, $pop24       # 0: down to label0
# %bb.6:                                # %if.end26
	i32.const	$push31=, 0
	i32.const	$push29=, 16
	i32.add 	$push30=, $4, $pop29
	i32.store	__stack_pointer($pop31), $pop30
	return
.LBB1_7:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	debug, .Lfunc_end1-debug
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push7=, 0
	i32.load	$push6=, __stack_pointer($pop7)
	i32.const	$push8=, 32
	i32.sub 	$0=, $pop6, $pop8
	i32.const	$push9=, 0
	i32.store	__stack_pointer($pop9), $0
	i32.const	$push0=, 16
	i32.add 	$push1=, $0, $pop0
	i64.const	$push2=, 455266533481
	i64.store	0($pop1), $pop2
	i64.const	$push3=, 446676598887
	i64.store	8($0), $pop3
	i64.const	$push4=, 438086664293
	i64.store	0($0), $pop4
	call    	debug@FUNCTION, $0, $0
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
