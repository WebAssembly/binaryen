	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/divcmp-3.c"
	.section	.text.test1,"ax",@progbits
	.hidden	test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, -300
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 100
	i32.lt_u	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	test1, .Lfunc_end0-test1

	.section	.text.test1u,"ax",@progbits
	.hidden	test1u
	.globl	test1u
	.type	test1u,@function
test1u:                                 # @test1u
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	test1u, .Lfunc_end1-test1u

	.section	.text.test2,"ax",@progbits
	.hidden	test2
	.globl	test2
	.type	test2,@function
test2:                                  # @test2
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, -300
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 99
	i32.gt_u	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end2:
	.size	test2, .Lfunc_end2-test2

	.section	.text.test2u,"ax",@progbits
	.hidden	test2u
	.globl	test2u
	.type	test2u,@function
test2u:                                 # @test2u
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end3:
	.size	test2u, .Lfunc_end3-test2u

	.section	.text.test3,"ax",@progbits
	.hidden	test3
	.globl	test3
	.type	test3,@function
test3:                                  # @test3
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end4:
	.size	test3, .Lfunc_end4-test3

	.section	.text.test3u,"ax",@progbits
	.hidden	test3u
	.globl	test3u
	.type	test3u,@function
test3u:                                 # @test3u
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end5:
	.size	test3u, .Lfunc_end5-test3u

	.section	.text.test4,"ax",@progbits
	.hidden	test4
	.globl	test4
	.type	test4,@function
test4:                                  # @test4
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end6:
	.size	test4, .Lfunc_end6-test4

	.section	.text.test4u,"ax",@progbits
	.hidden	test4u
	.globl	test4u
	.type	test4u,@function
test4u:                                 # @test4u
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end7:
	.size	test4u, .Lfunc_end7-test4u

	.section	.text.test5,"ax",@progbits
	.hidden	test5
	.globl	test5
	.type	test5,@function
test5:                                  # @test5
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end8:
	.size	test5, .Lfunc_end8-test5

	.section	.text.test5u,"ax",@progbits
	.hidden	test5u
	.globl	test5u
	.type	test5u,@function
test5u:                                 # @test5u
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end9:
	.size	test5u, .Lfunc_end9-test5u

	.section	.text.test6,"ax",@progbits
	.hidden	test6
	.globl	test6
	.type	test6,@function
test6:                                  # @test6
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end10:
	.size	test6, .Lfunc_end10-test6

	.section	.text.test6u,"ax",@progbits
	.hidden	test6u
	.globl	test6u
	.type	test6u,@function
test6u:                                 # @test6u
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end11:
	.size	test6u, .Lfunc_end11-test6u

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, -128
	i32.const	$0=, -2147483648
.LBB12_1:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label1:
	i32.const	$push7=, 24
	i32.shr_s	$push0=, $0, $pop7
	i32.const	$push6=, -300
	i32.add 	$push1=, $pop0, $pop6
	i32.const	$push5=, 99
	i32.le_u	$push2=, $pop1, $pop5
	br_if   	2, $pop2        # 2: down to label0
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB12_1 Depth=1
	i32.const	$push12=, 16777216
	i32.add 	$0=, $0, $pop12
	i32.const	$push11=, 1
	i32.add 	$push10=, $1, $pop11
	tee_local	$push9=, $1=, $pop10
	i32.const	$push8=, 255
	i32.le_s	$push3=, $pop9, $pop8
	br_if   	0, $pop3        # 0: up to label1
# BB#3:                                 # %for.end
	end_loop                        # label2:
	i32.const	$push4=, 0
	return  	$pop4
.LBB12_4:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end12:
	.size	main, .Lfunc_end12-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
