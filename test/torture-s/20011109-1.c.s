	.text
	.file	"20011109-1.c"
	.section	.text.fail1,"ax",@progbits
	.hidden	fail1                   # -- Begin function fail1
	.globl	fail1
	.type	fail1,@function
fail1:                                  # @fail1
# %bb.0:                                # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	fail1, .Lfunc_end0-fail1
                                        # -- End function
	.section	.text.fail2,"ax",@progbits
	.hidden	fail2                   # -- Begin function fail2
	.globl	fail2
	.type	fail2,@function
fail2:                                  # @fail2
# %bb.0:                                # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	fail2, .Lfunc_end1-fail2
                                        # -- End function
	.section	.text.fail3,"ax",@progbits
	.hidden	fail3                   # -- Begin function fail3
	.globl	fail3
	.type	fail3,@function
fail3:                                  # @fail3
# %bb.0:                                # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	fail3, .Lfunc_end2-fail3
                                        # -- End function
	.section	.text.fail4,"ax",@progbits
	.hidden	fail4                   # -- Begin function fail4
	.globl	fail4
	.type	fail4,@function
fail4:                                  # @fail4
# %bb.0:                                # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	fail4, .Lfunc_end3-fail4
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %sw.epilog9
	return
.LBB4_2:                                # %entry
	end_block                       # label0:
	i32.const	$push2=, 6
	i32.add 	$0=, $0, $pop2
	block   	
	i32.const	$push3=, 11
	i32.gt_u	$push4=, $0, $pop3
	br_if   	0, $pop4        # 0: down to label1
# %bb.3:                                # %entry
	block   	
	block   	
	block   	
	block   	
	br_table 	$0, 1, 4, 4, 4, 4, 4, 2, 4, 3, 0, 0, 0, 1 # 1: down to label4
                                        # 4: down to label1
                                        # 2: down to label3
                                        # 3: down to label2
                                        # 0: down to label5
.LBB4_4:                                # %sw.bb3
	end_block                       # label5:
	call    	fail3@FUNCTION
	unreachable
.LBB4_5:                                # %sw.bb
	end_block                       # label4:
	call    	fail1@FUNCTION
	unreachable
.LBB4_6:                                # %sw.bb1
	end_block                       # label3:
	call    	fail2@FUNCTION
	unreachable
.LBB4_7:                                # %sw.bb7
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB4_8:                                # %sw.default
	end_block                       # label1:
	call    	fail4@FUNCTION
	unreachable
	.endfunc
.Lfunc_end4:
	.size	foo, .Lfunc_end4-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end5:
	.size	main, .Lfunc_end5-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
