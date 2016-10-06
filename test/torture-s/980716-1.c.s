	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/980716-1.c"
	.section	.text.stub,"ax",@progbits
	.hidden	stub
	.globl	stub
	.type	stub,@function
stub:                                   # @stub
	.param  	i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, __stack_pointer($pop0)
	i32.const	$push2=, 16
	i32.sub 	$push4=, $pop1, $pop2
	tee_local	$push3=, $5=, $pop4
	i32.store	12($pop3), $1
	copy_local	$4=, $1
.LBB0_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push7=, 4
	i32.add 	$push6=, $4, $pop7
	tee_local	$push5=, $2=, $pop6
	i32.store	12($5), $pop5
	i32.load	$3=, 0($4)
	copy_local	$4=, $2
	br_if   	0, $3           # 0: up to label0
# BB#2:                                 # %while.end
	end_loop
	i32.store	12($5), $1
.LBB0_3:                                # %while.cond.1
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push10=, 4
	i32.add 	$push9=, $1, $pop10
	tee_local	$push8=, $4=, $pop9
	i32.store	12($5), $pop8
	i32.load	$2=, 0($1)
	copy_local	$1=, $4
	br_if   	0, $2           # 0: up to label1
# BB#4:                                 # %while.end.1
	end_loop
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	stub, .Lfunc_end0-stub

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push10=, $pop5, $pop6
	tee_local	$push9=, $0=, $pop10
	i32.store	__stack_pointer($pop7), $pop9
	i32.const	$push0=, 0
	i32.store	12($0), $pop0
	i32.const	$push1=, .L.str.2
	i32.store	8($0), $pop1
	i32.const	$push2=, .L.str.1
	i32.store	4($0), $pop2
	i32.const	$push3=, .L.str
	i32.store	0($0), $pop3
	call    	stub@FUNCTION, $0, $0
	i32.const	$push8=, 0
	call    	exit@FUNCTION, $pop8
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"ab"
	.size	.L.str, 3

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"bc"
	.size	.L.str.1, 3

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"cx"
	.size	.L.str.2, 3


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
