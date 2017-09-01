	.text
	.file	"20020404-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
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
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i64.const	$push0=, 3735928559
	i64.store	bfd_make_section_anyway.foo_section+8($pop1), $pop0
	i32.const	$push10=, 0
	i64.const	$push9=, 3735928559
	i64.store	bfd_make_section_anyway.foo_section+16($pop10), $pop9
	i32.const	$push8=, 0
	i64.const	$push2=, 0
	i64.store	bfd_make_section_anyway.foo_section+24($pop8), $pop2
	i32.const	$push7=, 0
	i32.const	$push6=, 0
	i32.load8_u	$push3=, bfd_make_section_anyway.foo_section($pop6)
	i32.const	$push4=, 1
	i32.or  	$push5=, $pop3, $pop4
	i32.store8	bfd_make_section_anyway.foo_section($pop7), $pop5
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	dump_bfd_file, .Lfunc_end1-dump_bfd_file
                                        # -- End function
	.type	bfd_make_section_anyway.foo_section,@object # @bfd_make_section_anyway.foo_section
	.section	.bss.bfd_make_section_anyway.foo_section,"aw",@nobits
	.p2align	3
bfd_make_section_anyway.foo_section:
	.skip	32
	.size	bfd_make_section_anyway.foo_section, 32


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
