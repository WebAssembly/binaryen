	.text
	.file	"20020404-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	call    	dump_bfd_file@FUNCTION
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.dump_bfd_file,"ax",@progbits
	.type	dump_bfd_file,@function # -- Begin function dump_bfd_file
dump_bfd_file:                          # @dump_bfd_file
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load8_u	$push1=, bfd_make_section_anyway.foo_section.0($pop4)
	i32.const	$push2=, 1
	i32.or  	$push3=, $pop1, $pop2
	i32.store8	bfd_make_section_anyway.foo_section.0($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	dump_bfd_file, .Lfunc_end1-dump_bfd_file
                                        # -- End function
	.type	bfd_make_section_anyway.foo_section.0,@object # @bfd_make_section_anyway.foo_section.0
	.section	.bss.bfd_make_section_anyway.foo_section.0,"aw",@nobits
	.p2align	3
bfd_make_section_anyway.foo_section.0:
	.int8	0                       # 0x0
	.size	bfd_make_section_anyway.foo_section.0, 1


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
