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
                                        # fallthrough-return: $pop0
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
                                        # fallthrough-return: $pop0
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
	i32.store	$drop=, foo.s+4($pop0), $1
	i32.const	$push2=, 0
	i32.store	$drop=, foo.s($pop2), $0
	i32.const	$push1=, foo.s
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end2:
	.size	test, .Lfunc_end2-test

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %lor.lhs.false
	block
	i32.const	$push12=, 0
	i32.const	$push9=, 0
	i32.load	$push10=, __stack_pointer($pop9)
	i32.const	$push11=, 16
	i32.sub 	$push24=, $pop10, $pop11
	i32.store	$push28=, __stack_pointer($pop12), $pop24
	tee_local	$push27=, $0=, $pop28
	i32.const	$push16=, 12
	i32.add 	$push17=, $pop27, $pop16
	i32.const	$push18=, 8
	i32.add 	$push19=, $0, $pop18
	i32.call	$push26=, test@FUNCTION, $pop17, $pop19
	tee_local	$push25=, $1=, $pop26
	i32.load	$push0=, 0($pop25)
	i32.const	$push20=, 12
	i32.add 	$push21=, $0, $pop20
	i32.ne  	$push1=, $pop0, $pop21
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %lor.lhs.false2
	i32.load	$push2=, 4($1)
	i32.const	$push22=, 8
	i32.add 	$push23=, $0, $pop22
	i32.ne  	$push3=, $pop2, $pop23
	br_if   	0, $pop3        # 0: down to label0
# BB#2:                                 # %lor.lhs.false4
	i32.load16_u	$push30=, 8($1)
	tee_local	$push29=, $1=, $pop30
	i32.const	$push4=, 255
	i32.and 	$push5=, $pop29, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#3:                                 # %lor.lhs.false4
	i32.const	$push6=, 256
	i32.ge_u	$push7=, $1, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#4:                                 # %if.end
	i32.const	$push15=, 0
	i32.const	$push13=, 16
	i32.add 	$push14=, $0, $pop13
	i32.store	$drop=, __stack_pointer($pop15), $pop14
	i32.const	$push8=, 0
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
	.functype	abort, void
