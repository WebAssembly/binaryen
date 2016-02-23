	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-13.c"
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
	i32.const	$push11=, __stack_pointer
	i32.load	$push12=, 0($pop11)
	i32.const	$push13=, 16
	i32.sub 	$2=, $pop12, $pop13
	i32.const	$push14=, __stack_pointer
	i32.store	$discard=, 0($pop14), $2
	block
	i32.store	$push9=, 4($2), $1
	tee_local	$push8=, $1=, $pop9
	i32.load	$push2=, 0($pop8)
	i32.const	$push7=, 1234
	i32.ne  	$push3=, $pop2, $pop7
	br_if   	0, $pop3        # 0: down to label1
# BB#1:                                 # %dummy.exit
	i32.const	$push1=, 4
	i32.or  	$push0=, $2, $pop1
	i32.store	$discard=, 0($pop0), $1
	i32.load	$push4=, 4($2)
	i32.load	$push5=, 0($pop4)
	i32.const	$push10=, 1234
	i32.ne  	$push6=, $pop5, $pop10
	br_if   	0, $pop6        # 0: down to label1
# BB#2:                                 # %dummy.exit15
	i32.const	$push15=, 16
	i32.add 	$2=, $2, $pop15
	i32.const	$push16=, __stack_pointer
	i32.store	$discard=, 0($pop16), $2
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push2=, __stack_pointer
	i32.load	$push3=, 0($pop2)
	i32.const	$push4=, 16
	i32.sub 	$1=, $pop3, $pop4
	i32.const	$push5=, __stack_pointer
	i32.store	$discard=, 0($pop5), $1
	i32.const	$push0=, 1234
	i32.store	$discard=, 0($1):p2align=4, $pop0
	call    	test@FUNCTION, $0, $1
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
