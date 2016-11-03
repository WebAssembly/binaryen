	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr34456.c"
	.section	.text.debug,"ax",@progbits
	.hidden	debug
	.globl	debug
	.type	debug,@function
debug:                                  # @debug
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	debug, .Lfunc_end0-debug

	.section	.text.bad_compare,"ax",@progbits
	.hidden	bad_compare
	.globl	bad_compare
	.type	bad_compare,@function
bad_compare:                            # @bad_compare
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.sub 	$push1=, $pop0, $0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end1:
	.size	bad_compare, .Lfunc_end1-bad_compare

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
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

	.section	.text.compare,"ax",@progbits
	.type	compare,@function
compare:                                # @compare
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load	$2=, 4($0)
	block   	
	i32.load	$push8=, 0($1)
	tee_local	$push7=, $1=, $pop8
	i32.eqz 	$push10=, $pop7
	br_if   	0, $pop10       # 0: down to label0
# BB#1:                                 # %land.lhs.true
	i32.load	$push0=, 0($0)
	i32.call_indirect	$push1=, $pop0, $2
	i32.eqz 	$push11=, $pop1
	br_if   	0, $pop11       # 0: down to label0
# BB#2:                                 # %if.then
	i32.const	$push2=, 0
	i32.const	$push9=, 0
	i32.load	$push3=, errors($pop9)
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


	.ident	"clang version 4.0.0 "
	.functype	qsort, void, i32, i32, i32, i32
