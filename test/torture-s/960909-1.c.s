	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960909-1.c"
	.section	.text.ffs,"ax",@progbits
	.hidden	ffs
	.globl	ffs
	.type	ffs,@function
ffs:                                    # @ffs
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	block
	i32.eqz 	$push7=, $0
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %for.cond.preheader
	i32.const	$2=, 1
	i32.const	$push2=, 1
	i32.and 	$push0=, $0, $pop2
	br_if   	0, $pop0        # 0: down to label0
# BB#2:                                 # %for.inc.preheader
	i32.const	$1=, 1
	i32.const	$2=, 1
.LBB0_3:                                # %for.inc
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push6=, 1
	i32.add 	$2=, $2, $pop6
	i32.const	$push5=, 1
	i32.shl 	$push4=, $1, $pop5
	tee_local	$push3=, $1=, $pop4
	i32.and 	$push1=, $pop3, $0
	i32.eqz 	$push8=, $pop1
	br_if   	0, $pop8        # 0: up to label1
.LBB0_4:                                # %cleanup
	end_loop                        # label2:
	end_block                       # label0:
	copy_local	$push9=, $2
                                        # fallthrough-return: $pop9
	.endfunc
.Lfunc_end0:
	.size	ffs, .Lfunc_end0-ffs

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.eqz 	$push0=, $0
	br_if   	0, $pop0        # 0: down to label3
# BB#1:                                 # %if.end
	return  	$0
.LBB1_2:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	f, .Lfunc_end1-f

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


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
