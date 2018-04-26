	.text
	.file	"pr41750.c"
	.section	.text.foo_create_got_section,"ax",@progbits
	.hidden	foo_create_got_section  # -- Begin function foo_create_got_section
	.globl	foo_create_got_section
	.type	foo_create_got_section,@function
foo_create_got_section:                 # @foo_create_got_section
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.load	$push0=, 0($1)
	i32.store	8($pop0), $0
	i32.const	$push1=, 1
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end0:
	.size	foo_create_got_section, .Lfunc_end0-foo_create_got_section
                                        # -- End function
	.section	.text.elf64_ia64_check_relocs,"ax",@progbits
	.hidden	elf64_ia64_check_relocs # -- Begin function elf64_ia64_check_relocs
	.globl	elf64_ia64_check_relocs
	.type	elf64_ia64_check_relocs,@function
elf64_ia64_check_relocs:                # @elf64_ia64_check_relocs
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.load	$2=, 0($1)
	i32.load	$3=, 8($2)
	block   	
	i32.eqz 	$push5=, $3
	br_if   	0, $pop5        # 0: down to label0
# %bb.1:                                # %get_got.exit
	return  	$3
.LBB1_2:                                # %if.then.i
	end_block                       # label0:
	i32.load	$3=, 4($2)
	block   	
	br_if   	0, $3           # 0: down to label1
# %bb.3:                                # %if.then3.i
	i32.const	$push0=, 4
	i32.add 	$push1=, $2, $pop0
	i32.store	0($pop1), $0
	copy_local	$3=, $0
.LBB1_4:                                # %if.end.i
	end_block                       # label1:
	i32.call	$drop=, foo_create_got_section@FUNCTION, $3, $1
	i32.const	$push2=, 8
	i32.add 	$push3=, $2, $pop2
	i32.load	$push4=, 0($pop3)
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end1:
	.size	elf64_ia64_check_relocs, .Lfunc_end1-elf64_ia64_check_relocs
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push6=, 0
	i32.const	$push0=, hash
	i32.store	link_info($pop6), $pop0
	block   	
	i32.const	$push2=, abfd
	i32.const	$push1=, link_info
	i32.call	$push3=, elf64_ia64_check_relocs@FUNCTION, $pop2, $pop1
	i32.const	$push5=, abfd
	i32.ne  	$push4=, $pop3, $pop5
	br_if   	0, $pop4        # 0: down to label2
# %bb.1:                                # %if.end
	i32.const	$push7=, 0
	return  	$pop7
.LBB2_2:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	hash                    # @hash
	.type	hash,@object
	.section	.bss.hash,"aw",@nobits
	.globl	hash
	.p2align	2
hash:
	.skip	12
	.size	hash, 12

	.hidden	link_info               # @link_info
	.type	link_info,@object
	.section	.bss.link_info,"aw",@nobits
	.globl	link_info
	.p2align	2
link_info:
	.skip	4
	.size	link_info, 4

	.hidden	abfd                    # @abfd
	.type	abfd,@object
	.section	.bss.abfd,"aw",@nobits
	.globl	abfd
	.p2align	2
abfd:
	.int32	0                       # 0x0
	.size	abfd, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
