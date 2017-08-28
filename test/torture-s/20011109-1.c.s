	.text
	.file	"20011109-1.c"
	.section	.text.fail1,"ax",@progbits
	.hidden	fail1                   # -- Begin function fail1
	.globl	fail1
	.type	fail1,@function
fail1:                                  # @fail1
# BB#0:                                 # %entry
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
# BB#0:                                 # %entry
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
# BB#0:                                 # %entry
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
# BB#0:                                 # %entry
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
# BB#0:                                 # %entry
	block   	
	block   	
	block   	
	block   	
	i32.const	$push0=, 6
	i32.add 	$push4=, $0, $pop0
	tee_local	$push3=, $0=, $pop4
	i32.const	$push1=, 11
	i32.gt_u	$push2=, $pop3, $pop1
	br_if   	0, $pop2        # 0: down to label3
# BB#1:                                 # %entry
	block   	
	block   	
	br_table 	$0, 3, 2, 2, 2, 2, 2, 4, 0, 5, 1, 1, 1, 3 # 3: down to label2
                                        # 2: down to label3
                                        # 4: down to label1
                                        # 0: down to label5
                                        # 5: down to label0
                                        # 1: down to label4
.LBB4_2:                                # %sw.epilog9
	end_block                       # label5:
	return
.LBB4_3:                                # %sw.bb3
	end_block                       # label4:
	call    	fail3@FUNCTION
	unreachable
.LBB4_4:                                # %sw.default
	end_block                       # label3:
	call    	fail4@FUNCTION
	unreachable
.LBB4_5:                                # %sw.bb
	end_block                       # label2:
	call    	fail1@FUNCTION
	unreachable
.LBB4_6:                                # %sw.bb1
	end_block                       # label1:
	call    	fail2@FUNCTION
	unreachable
.LBB4_7:                                # %sw.bb7
	end_block                       # label0:
	call    	abort@FUNCTION
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
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end5:
	.size	main, .Lfunc_end5-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
