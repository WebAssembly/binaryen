	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/961017-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
.LBB0_1:                                # %do.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$push3=, 16384
	i32.add 	$push2=, $0, $pop3
	tee_local	$push1=, $0=, $pop2
	br_if   	0, $pop1        # 0: up to label0
# BB#2:                                 # %do.end
	end_loop                        # label1:
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.9.0 "
