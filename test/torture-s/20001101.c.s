	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20001101.c"
	.section	.text.dummy,"ax",@progbits
	.hidden	dummy
	.globl	dummy
	.type	dummy,@function
dummy:                                  # @dummy
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 7
	i32.store	$drop=, 0($1), $pop0
	i32.const	$push1=, 1
	i32.store	$drop=, 0($0), $pop1
	i32.const	$push2=, 1
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	dummy, .Lfunc_end0-dummy

	.section	.text.bogus,"ax",@progbits
	.hidden	bogus
	.globl	bogus
	.type	bogus,@function
bogus:                                  # @bogus
	.param  	i32, i32, i32
# BB#0:                                 # %if.end5
	i32.load8_u	$push0=, 0($0)
	i32.const	$push1=, 1
	i32.or  	$push2=, $pop0, $pop1
	i32.store8	$drop=, 0($0), $pop2
	block
	i32.const	$push3=, 7
	i32.ne  	$push4=, $1, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end8
	return
.LBB1_2:                                # %if.then7
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	bogus, .Lfunc_end1-bogus

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 4.0.0 "
	.functype	abort, void
	.functype	exit, void, i32
