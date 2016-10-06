	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr33992.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i64
# BB#0:                                 # %entry
	block   	
	i64.eqz 	$push0=, $0
	i32.eqz 	$push1=, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.do_test,"ax",@progbits
	.hidden	do_test
	.globl	do_test
	.type	do_test,@function
do_test:                                # @do_test
	.param  	i32
	.local  	i64, i64, i64, i64
# BB#0:                                 # %entry
	i64.load	$1=, 0($0)
	i64.const	$4=, -4294967296
	i64.const	$3=, 63
.LBB1_1:                                # %for.cond.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i64.const	$push15=, 4294967296
	i64.add 	$4=, $4, $pop15
	i64.const	$push14=, 4294967295
	i64.and 	$2=, $3, $pop14
	i64.const	$push13=, -1
	i64.add 	$push0=, $3, $pop13
	copy_local	$3=, $pop0
	i64.const	$push12=, 1
	i64.shl 	$push2=, $pop12, $2
	i64.and 	$push3=, $pop2, $1
	i64.eqz 	$push4=, $pop3
	br_if   	0, $pop4        # 0: up to label1
# BB#2:                                 # %foo.exit
	end_loop
	i64.const	$push5=, 32
	i64.shr_s	$push6=, $4, $pop5
	call    	bar@FUNCTION, $pop6
	i64.load	$1=, 0($0)
	i64.const	$4=, -4294967296
	i64.const	$3=, 63
.LBB1_3:                                # %for.cond.i.1
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i64.const	$push19=, 4294967296
	i64.add 	$4=, $4, $pop19
	i64.const	$push18=, 4294967295
	i64.and 	$2=, $3, $pop18
	i64.const	$push17=, -1
	i64.add 	$push1=, $3, $pop17
	copy_local	$3=, $pop1
	i64.const	$push16=, 1
	i64.shl 	$push7=, $pop16, $2
	i64.and 	$push8=, $pop7, $1
	i64.eqz 	$push9=, $pop8
	br_if   	0, $pop9        # 0: up to label2
# BB#4:                                 # %foo.exit.1
	end_loop
	i64.const	$push10=, 32
	i64.shr_s	$push11=, $4, $pop10
	call    	bar@FUNCTION, $pop11
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	do_test, .Lfunc_end1-do_test

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
	i32.sub 	$push12=, $pop3, $pop4
	tee_local	$push11=, $0=, $pop12
	i32.store	__stack_pointer($pop5), $pop11
	i64.const	$push0=, -9223372036854775807
	i64.store	8($0), $pop0
	i32.const	$push9=, 8
	i32.add 	$push10=, $0, $pop9
	call    	do_test@FUNCTION, $pop10
	i32.const	$push8=, 0
	i32.const	$push6=, 16
	i32.add 	$push7=, $0, $pop6
	i32.store	__stack_pointer($pop8), $pop7
	i32.const	$push1=, 0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
