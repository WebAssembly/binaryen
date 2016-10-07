	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920908-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push18=, $pop9, $pop10
	tee_local	$push17=, $3=, $pop18
	i32.store	__stack_pointer($pop11), $pop17
	i32.store	12($3), $1
	i32.const	$push0=, 4
	i32.add 	$push16=, $1, $pop0
	tee_local	$push15=, $2=, $pop16
	i32.store	12($3), $pop15
	block   	
	i32.load	$push1=, 0($1)
	i32.const	$push2=, 10
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 8
	i32.add 	$push5=, $1, $pop4
	i32.store	12($3), $pop5
	i32.load	$push6=, 0($2)
	i32.const	$push19=, 20
	i32.ne  	$push7=, $pop6, $pop19
	br_if   	0, $pop7        # 0: down to label0
# BB#2:                                 # %if.end7
	i32.const	$push14=, 0
	i32.const	$push12=, 16
	i32.add 	$push13=, $3, $pop12
	i32.store	__stack_pointer($pop14), $pop13
	i32.const	$push20=, 20
	return  	$pop20
.LBB0_3:                                # %if.then6
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push7=, $pop3, $pop4
	tee_local	$push6=, $0=, $pop7
	i32.store	__stack_pointer($pop5), $pop6
	i64.const	$push0=, 85899345930
	i64.store	0($0), $pop0
	i32.call	$drop=, f@FUNCTION, $0, $0
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
