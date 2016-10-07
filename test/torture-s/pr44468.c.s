	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr44468.c"
	.section	.text.test1,"ax",@progbits
	.hidden	test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.store	s+4($pop0), $pop4
	i32.const	$push1=, 3
	i32.store	4($0), $pop1
	i32.const	$push3=, 0
	i32.load	$push2=, s+4($pop3)
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
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.store	s+4($pop0), $pop4
	i32.const	$push1=, 3
	i32.store	4($0), $pop1
	i32.const	$push3=, 0
	i32.load	$push2=, s+4($pop3)
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
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.store	s+4($pop0), $pop4
	i32.const	$push1=, 3
	i32.store	4($0), $pop1
	i32.const	$push3=, 0
	i32.load	$push2=, s+4($pop3)
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
# BB#0:                                 # %entry
	i32.const	$push12=, 0
	i64.const	$push11=, 8589934593
	i64.store	s+4($pop12):p2align=2, $pop11
	block   	
	i32.const	$push10=, s
	i32.call	$push0=, test1@FUNCTION, $pop10
	i32.const	$push9=, 3
	i32.ne  	$push1=, $pop0, $pop9
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push16=, 0
	i64.const	$push15=, 8589934593
	i64.store	s+4($pop16):p2align=2, $pop15
	i32.const	$push14=, s
	i32.call	$push2=, test2@FUNCTION, $pop14
	i32.const	$push13=, 3
	i32.ne  	$push3=, $pop2, $pop13
	br_if   	0, $pop3        # 0: down to label0
# BB#2:                                 # %if.end4
	i32.const	$push17=, 0
	i64.const	$push4=, 8589934593
	i64.store	s+4($pop17):p2align=2, $pop4
	i32.const	$push5=, s
	i32.call	$push6=, test3@FUNCTION, $pop5
	i32.const	$push7=, 3
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#3:                                 # %if.end8
	i32.const	$push18=, 0
	return  	$pop18
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
