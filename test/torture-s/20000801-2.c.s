	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000801-2.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push1=, 0
	i32.eq  	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label0
.LBB0_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.load	$0=, 0($0)
	br_if   	0, $0           # 0: up to label1
.LBB0_2:                                # %while.end
	end_loop                        # label2:
	end_block                       # label0:
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end0:
	.size	test, .Lfunc_end0-test

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.baz,"ax",@progbits
	.hidden	baz
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end2:
	.size	baz, .Lfunc_end2-baz

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push5=, __stack_pointer
	i32.const	$push2=, __stack_pointer
	i32.load	$push3=, 0($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push10=, $pop3, $pop4
	i32.store	$push12=, 0($pop5), $pop10
	tee_local	$push11=, $1=, $pop12
	i32.const	$push6=, 12
	i32.add 	$push7=, $pop11, $pop6
	copy_local	$0=, $pop7
	i32.const	$push0=, 0
	i32.store	$discard=, 8($1), $pop0
	i32.const	$push8=, 8
	i32.add 	$push9=, $1, $pop8
	i32.store	$discard=, 12($1), $pop9
.LBB3_1:                                # %while.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.load	$0=, 0($0)
	br_if   	0, $0           # 0: up to label3
# BB#2:                                 # %if.end
	end_loop                        # label4:
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main


	.ident	"clang version 3.9.0 "
