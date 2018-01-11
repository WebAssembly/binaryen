	.text
	.file	"980701-1.c"
	.section	.text.ns_name_skip,"ax",@progbits
	.hidden	ns_name_skip            # -- Begin function ns_name_skip
	.globl	ns_name_skip
	.type	ns_name_skip,@function
ns_name_skip:                           # @ns_name_skip
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.store	0($0), $pop0
	i32.const	$push1=, 0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end0:
	.size	ns_name_skip, .Lfunc_end0-ns_name_skip
                                        # -- End function
	.section	.text.dn_skipname,"ax",@progbits
	.hidden	dn_skipname             # -- Begin function dn_skipname
	.globl	dn_skipname
	.type	dn_skipname,@function
dn_skipname:                            # @dn_skipname
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.sub 	$push1=, $pop0, $0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end1:
	.size	dn_skipname, .Lfunc_end1-dn_skipname
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, a
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB2_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
a:
	.skip	2
	.size	a, 2


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
