	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20080502-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i64, i64
# BB#0:                                 # %entry
	i32.const	$push0=, 8
	i32.add 	$push1=, $0, $pop0
	i64.const	$push2=, 63
	i64.shr_s	$push8=, $2, $pop2
	tee_local	$push7=, $2=, $pop8
	i64.const	$push3=, 4611846683310179025
	i64.and 	$push4=, $pop7, $pop3
	i64.store	0($pop1), $pop4
	i64.const	$push5=, -8905435550453399112
	i64.and 	$push6=, $2, $pop5
	i64.store	0($0), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push16=, $pop9, $pop10
	tee_local	$push15=, $0=, $pop16
	i32.store	__stack_pointer($pop11), $pop15
	i64.const	$push1=, 0
	i64.const	$push0=, -4611967493404098560
	call    	foo@FUNCTION, $0, $pop1, $pop0
	block   	
	i64.load	$push5=, 0($0)
	i64.load	$push4=, 8($0)
	i64.const	$push3=, -8905435550453399112
	i64.const	$push2=, 4611846683310179025
	i32.call	$push6=, __eqtf2@FUNCTION, $pop5, $pop4, $pop3, $pop2
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push14=, 0
	i32.const	$push12=, 16
	i32.add 	$push13=, $0, $pop12
	i32.store	__stack_pointer($pop14), $pop13
	i32.const	$push7=, 0
	return  	$pop7
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
