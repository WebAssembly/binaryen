	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030903-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push6=, 0
	i32.load	$push0=, test($pop6)
	i32.const	$push1=, -1
	i32.add 	$push5=, $pop0, $pop1
	tee_local	$push4=, $0=, $pop5
	i32.const	$push2=, 3
	i32.le_u	$push3=, $pop4, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %sw.epilog
	i32.const	$push7=, 0
	return  	$pop7
.LBB0_2:                                # %entry
	end_block                       # label0:
	block   	
	br_table 	$0, 0, 0, 0, 0, 0 # 0: down to label1
.LBB0_3:                                # %sw.bb
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	test,@object            # @test
	.section	.bss.test,"aw",@nobits
	.p2align	2
test:
	.int32	0                       # 0x0
	.size	test, 4


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
