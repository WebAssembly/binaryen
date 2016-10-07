	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/bf-pack-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i64
# BB#0:                                 # %entry
	block   	
	i64.load	$push9=, 0($0):p2align=2
	tee_local	$push8=, $1=, $pop9
	i64.const	$push0=, 65535
	i64.and 	$push1=, $pop8, $pop0
	i64.const	$push2=, 4660
	i64.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i64.const	$push4=, 281474976645120
	i64.and 	$push5=, $1, $pop4
	i64.const	$push6=, 95075992076288
	i64.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#2:                                 # %if.end6
	return  	$0
.LBB0_3:                                # %if.then5
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
	i32.sub 	$push9=, $pop3, $pop4
	tee_local	$push8=, $0=, $pop9
	i32.store	__stack_pointer($pop5), $pop8
	i64.const	$push0=, 95075992080948
	i64.store	8($0), $pop0
	i32.const	$push6=, 8
	i32.add 	$push7=, $0, $pop6
	i32.call	$drop=, f@FUNCTION, $pop7
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
