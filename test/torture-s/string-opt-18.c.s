	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/string-opt-18.c"
	.section	.text.test1,"ax",@progbits
	.hidden	test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	test1, .Lfunc_end0-test1

	.section	.text.test2,"ax",@progbits
	.hidden	test2
	.globl	test2
	.type	test2,@function
test2:                                  # @test2
	.param  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 8
	i32.call	$push2=, mempcpy@FUNCTION, $0, $0, $pop0
	i32.const	$push4=, 8
	i32.add 	$push1=, $0, $pop4
	i32.ne  	$push3=, $pop2, $pop1
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	test2, .Lfunc_end1-test2

	.section	.text.test3,"ax",@progbits
	.hidden	test3
	.globl	test3
	.type	test3,@function
test3:                                  # @test3
	.param  	i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	test3, .Lfunc_end2-test3

	.section	.text.test4,"ax",@progbits
	.hidden	test4
	.globl	test4
	.type	test4,@function
test4:                                  # @test4
	.param  	i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end3:
	.size	test4, .Lfunc_end3-test4

	.section	.text.test5,"ax",@progbits
	.hidden	test5
	.globl	test5
	.type	test5,@function
test5:                                  # @test5
	.param  	i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end4:
	.size	test5, .Lfunc_end4-test5

	.section	.text.test6,"ax",@progbits
	.hidden	test6
	.globl	test6
	.type	test6,@function
test6:                                  # @test6
	.param  	i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end5:
	.size	test6, .Lfunc_end5-test6

	.section	.text.test7,"ax",@progbits
	.hidden	test7
	.globl	test7
	.type	test7,@function
test7:                                  # @test7
	.param  	i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end6:
	.size	test7, .Lfunc_end6-test7

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push8=, 0
	i32.const	$push5=, 0
	i32.load	$push6=, __stack_pointer($pop5)
	i32.const	$push7=, 16
	i32.sub 	$push18=, $pop6, $pop7
	i32.store	$push21=, __stack_pointer($pop8), $pop18
	tee_local	$push20=, $0=, $pop21
	i32.const	$push14=, 6
	i32.add 	$push15=, $pop20, $pop14
	i32.const	$push16=, 6
	i32.add 	$push17=, $0, $pop16
	i32.const	$push0=, 8
	i32.call	$push2=, mempcpy@FUNCTION, $pop15, $pop17, $pop0
	i32.const	$push12=, 6
	i32.add 	$push13=, $0, $pop12
	i32.const	$push19=, 8
	i32.add 	$push1=, $pop13, $pop19
	i32.ne  	$push3=, $pop2, $pop1
	br_if   	0, $pop3        # 0: down to label1
# BB#1:                                 # %test2.exit
	i32.const	$push11=, 0
	i32.const	$push9=, 16
	i32.add 	$push10=, $0, $pop9
	i32.store	$drop=, __stack_pointer($pop11), $pop10
	i32.const	$push4=, 0
	return  	$pop4
.LBB7_2:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end7:
	.size	main, .Lfunc_end7-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	mempcpy, i32, i32, i32, i32
