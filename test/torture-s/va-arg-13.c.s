	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-13.c"
	.section	.text.dummy,"ax",@progbits
	.hidden	dummy
	.globl	dummy
	.type	dummy,@function
dummy:                                  # @dummy
	.param  	i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push0=, 0($0)
	i32.const	$push1=, 1234
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	dummy, .Lfunc_end0-dummy

	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 16
	i32.sub 	$push16=, $pop8, $pop9
	tee_local	$push15=, $2=, $pop16
	i32.store	__stack_pointer($pop10), $pop15
	i32.store	4($2), $1
	block   	
	i32.load	$push1=, 0($1)
	i32.const	$push14=, 1234
	i32.ne  	$push2=, $pop1, $pop14
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %dummy.exit
	i32.const	$push3=, 4
	i32.or  	$push0=, $2, $pop3
	i32.store	0($pop0), $1
	i32.load	$push4=, 4($2)
	i32.load	$push5=, 0($pop4)
	i32.const	$push17=, 1234
	i32.ne  	$push6=, $pop5, $pop17
	br_if   	0, $pop6        # 0: down to label1
# BB#2:                                 # %dummy.exit15
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $2, $pop11
	i32.store	__stack_pointer($pop13), $pop12
	return
.LBB1_3:                                # %if.then.i14
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	test, .Lfunc_end1-test

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
	i32.const	$push0=, 1234
	i32.store	0($0), $pop0
	call    	test@FUNCTION, $0, $0
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
