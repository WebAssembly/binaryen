	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000419-1.c"
	.section	.text.brother,"ax",@progbits
	.hidden	brother
	.globl	brother
	.type	brother,@function
brother:                                # @brother
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	block   	
	br_if   	0, $0           # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	brother, .Lfunc_end0-brother

	.section	.text.sister,"ax",@progbits
	.hidden	sister
	.globl	sister
	.type	sister,@function
sister:                                 # @sister
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push0=, 4($0)
	i32.eq  	$push1=, $pop0, $1
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %brother.exit
	return
.LBB1_2:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	sister, .Lfunc_end1-sister

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %sister.exit
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
	.functype	exit, void, i32
