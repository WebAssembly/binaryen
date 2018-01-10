	.text
	.file	"pr34456.c"
	.section	.text.debug,"ax",@progbits
	.hidden	debug                   # -- Begin function debug
	.globl	debug
	.type	debug,@function
debug:                                  # @debug
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	debug, .Lfunc_end0-debug
                                        # -- End function
	.section	.text.bad_compare,"ax",@progbits
	.hidden	bad_compare             # -- Begin function bad_compare
	.globl	bad_compare
	.type	bad_compare,@function
bad_compare:                            # @bad_compare
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.sub 	$push1=, $pop0, $0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end1:
	.size	bad_compare, .Lfunc_end1-bad_compare
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push3=, array
	i32.const	$push2=, 2
	i32.const	$push1=, 8
	i32.const	$push0=, compare@FUNCTION
	call    	qsort@FUNCTION, $pop3, $pop2, $pop1, $pop0
	i32.const	$push4=, 0
	i32.load	$push5=, errors($pop4)
	i32.eqz 	$push6=, $pop5
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.section	.text.compare,"ax",@progbits
	.type	compare,@function       # -- Begin function compare
compare:                                # @compare
	.param  	i32, i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.load	$1=, 0($1)
	i32.load	$2=, 4($0)
	block   	
	i32.eqz 	$push8=, $1
	br_if   	0, $pop8        # 0: down to label0
# %bb.1:                                # %land.lhs.true
	i32.load	$push0=, 0($0)
	i32.call_indirect	$push1=, $pop0, $2
	i32.eqz 	$push9=, $pop1
	br_if   	0, $pop9        # 0: down to label0
# %bb.2:                                # %if.then
	i32.const	$push2=, 0
	i32.const	$push7=, 0
	i32.load	$push3=, errors($pop7)
	i32.const	$push4=, 1
	i32.add 	$push5=, $pop3, $pop4
	i32.store	errors($pop2), $pop5
.LBB3_3:                                # %if.end
	end_block                       # label0:
	i32.call_indirect	$push6=, $1, $2
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end3:
	.size	compare, .Lfunc_end3-compare
                                        # -- End function
	.hidden	array                   # @array
	.type	array,@object
	.section	.data.array,"aw",@progbits
	.globl	array
	.p2align	4
array:
	.int32	1                       # 0x1
	.int32	bad_compare@FUNCTION
	.int32	4294967295              # 0xffffffff
	.int32	bad_compare@FUNCTION
	.size	array, 16

	.hidden	errors                  # @errors
	.type	errors,@object
	.section	.bss.errors,"aw",@nobits
	.globl	errors
	.p2align	2
errors:
	.int32	0                       # 0x0
	.size	errors, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	qsort, void, i32, i32, i32, i32
