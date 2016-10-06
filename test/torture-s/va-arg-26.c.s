	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-26.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	f32, f32, f32, f32, f32, f32, i32
	.result 	f64
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push6=, 0
	i32.load	$push7=, __stack_pointer($pop6)
	i32.const	$push8=, 16
	i32.sub 	$push12=, $pop7, $pop8
	tee_local	$push11=, $7=, $pop12
	i32.store	12($pop11), $6
	i32.const	$push0=, 7
	i32.add 	$push1=, $6, $pop0
	i32.const	$push2=, -8
	i32.and 	$push10=, $pop1, $pop2
	tee_local	$push9=, $6=, $pop10
	i32.const	$push3=, 8
	i32.add 	$push4=, $pop9, $pop3
	i32.store	12($7), $pop4
	f64.load	$push5=, 0($6)
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f32, i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.const	$push5=, 0
	i32.load	$push6=, __stack_pointer($pop5)
	i32.const	$push7=, 16
	i32.sub 	$push10=, $pop6, $pop7
	tee_local	$push9=, $1=, $pop10
	i32.store	__stack_pointer($pop8), $pop9
	i64.const	$push0=, 4619567317775286272
	i64.store	0($1), $pop0
	block   	
	f64.call	$push1=, f@FUNCTION, $0, $0, $0, $0, $0, $0, $1
	f64.const	$push2=, 0x1.cp2
	f64.eq  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB1_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
