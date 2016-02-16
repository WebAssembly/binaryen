	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20071108-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, foo.s
	return  	$pop0
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

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

	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store	$discard=, foo.s($pop0), $0
	i32.const	$push2=, 0
	i32.store	$discard=, foo.s+4($pop2), $1
	i32.const	$push1=, foo.s
	return  	$pop1
	.endfunc
.Lfunc_end2:
	.size	test, .Lfunc_end2-test

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %lor.lhs.false
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$8=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$8=, 0($2), $8
	i32.const	$4=, 12
	i32.add 	$4=, $8, $4
	i32.const	$5=, 8
	i32.add 	$5=, $8, $5
	i32.call	$push10=, test@FUNCTION, $4, $5
	tee_local	$push9=, $0=, $pop10
	i32.load	$push0=, 0($pop9)
	i32.const	$6=, 12
	i32.add 	$6=, $8, $6
	block
	i32.ne  	$push1=, $pop0, $6
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %lor.lhs.false2
	i32.load	$push2=, 4($0)
	i32.const	$7=, 8
	i32.add 	$7=, $8, $7
	i32.ne  	$push3=, $pop2, $7
	br_if   	0, $pop3        # 0: down to label0
# BB#2:                                 # %lor.lhs.false4
	i32.load16_u	$push12=, 8($0):p2align=2
	tee_local	$push11=, $0=, $pop12
	i32.const	$push4=, 255
	i32.and 	$push5=, $pop11, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#3:                                 # %lor.lhs.false4
	i32.const	$push6=, 256
	i32.ge_u	$push7=, $0, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#4:                                 # %if.end
	i32.const	$push8=, 0
	i32.const	$3=, 16
	i32.add 	$8=, $8, $3
	i32.const	$3=, __stack_pointer
	i32.store	$8=, 0($3), $8
	return  	$pop8
.LBB3_5:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.type	foo.s,@object           # @foo.s
	.lcomm	foo.s,12,2

	.ident	"clang version 3.9.0 "
