	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr44468.c"
	.section	.text.test1,"ax",@progbits
	.hidden	test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push3=, 0
	i32.store	$1=, s+4($pop0), $pop3
	i32.const	$push1=, 3
	i32.store	$drop=, 4($0), $pop1
	i32.load	$push2=, s+4($1)
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	test1, .Lfunc_end0-test1

	.section	.text.test2,"ax",@progbits
	.hidden	test2
	.globl	test2
	.type	test2,@function
test2:                                  # @test2
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push3=, 0
	i32.store	$1=, s+4($pop0), $pop3
	i32.const	$push1=, 3
	i32.store	$drop=, 4($0), $pop1
	i32.load	$push2=, s+4($1)
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end1:
	.size	test2, .Lfunc_end1-test2

	.section	.text.test3,"ax",@progbits
	.hidden	test3
	.globl	test3
	.type	test3,@function
test3:                                  # @test3
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push3=, 0
	i32.store	$1=, s+4($pop0), $pop3
	i32.const	$push1=, 3
	i32.store	$drop=, 4($0), $pop1
	i32.load	$push2=, s+4($1)
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end2:
	.size	test3, .Lfunc_end2-test3

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64
# BB#0:                                 # %entry
	i32.const	$push12=, 0
	i64.const	$push0=, 8589934593
	i64.store	$0=, s+4($pop12):p2align=2, $pop0
	block
	i32.const	$push11=, s
	i32.call	$push1=, test1@FUNCTION, $pop11
	i32.const	$push10=, 3
	i32.ne  	$push2=, $pop1, $pop10
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push15=, 0
	i64.store	$drop=, s+4($pop15):p2align=2, $0
	i32.const	$push14=, s
	i32.call	$push3=, test2@FUNCTION, $pop14
	i32.const	$push13=, 3
	i32.ne  	$push4=, $pop3, $pop13
	br_if   	0, $pop4        # 0: down to label0
# BB#2:                                 # %if.end4
	i32.const	$push16=, 0
	i64.const	$push5=, 8589934593
	i64.store	$drop=, s+4($pop16):p2align=2, $pop5
	i32.const	$push6=, s
	i32.call	$push7=, test3@FUNCTION, $pop6
	i32.const	$push8=, 3
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label0
# BB#3:                                 # %if.end8
	i32.const	$push17=, 0
	return  	$pop17
.LBB3_4:                                # %if.then7
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.p2align	2
s:
	.skip	12
	.size	s, 12


	.ident	"clang version 3.9.0 "
	.functype	abort, void
