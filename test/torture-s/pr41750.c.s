	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr41750.c"
	.section	.text.foo_create_got_section,"ax",@progbits
	.hidden	foo_create_got_section
	.globl	foo_create_got_section
	.type	foo_create_got_section,@function
foo_create_got_section:                 # @foo_create_got_section
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.load	$push0=, 0($1)
	i32.store	$drop=, 8($pop0), $0
	i32.const	$push1=, 1
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end0:
	.size	foo_create_got_section, .Lfunc_end0-foo_create_got_section

	.section	.text.elf64_ia64_check_relocs,"ax",@progbits
	.hidden	elf64_ia64_check_relocs
	.globl	elf64_ia64_check_relocs
	.type	elf64_ia64_check_relocs,@function
elf64_ia64_check_relocs:                # @elf64_ia64_check_relocs
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block
	i32.load	$push8=, 0($1)
	tee_local	$push7=, $2=, $pop8
	i32.load	$push6=, 8($pop7)
	tee_local	$push5=, $3=, $pop6
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %if.then.i
	block
	i32.load	$push10=, 4($2)
	tee_local	$push9=, $3=, $pop10
	br_if   	0, $pop9        # 0: down to label1
# BB#2:                                 # %if.then3.i
	i32.const	$push1=, 4
	i32.add 	$push2=, $2, $pop1
	i32.store	$push0=, 0($pop2), $0
	copy_local	$3=, $pop0
.LBB1_3:                                # %if.end.i
	end_block                       # label1:
	i32.call	$drop=, foo_create_got_section@FUNCTION, $3, $1
	i32.const	$push3=, 8
	i32.add 	$push4=, $2, $pop3
	i32.load	$3=, 0($pop4)
.LBB1_4:                                # %get_got.exit
	end_block                       # label0:
	copy_local	$push11=, $3
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end1:
	.size	elf64_ia64_check_relocs, .Lfunc_end1-elf64_ia64_check_relocs

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push6=, 0
	i32.const	$push0=, hash
	i32.store	$drop=, link_info($pop6), $pop0
	block
	i32.const	$push2=, abfd
	i32.const	$push1=, link_info
	i32.call	$push3=, elf64_ia64_check_relocs@FUNCTION, $pop2, $pop1
	i32.const	$push5=, abfd
	i32.ne  	$push4=, $pop3, $pop5
	br_if   	0, $pop4        # 0: down to label2
# BB#1:                                 # %if.end
	i32.const	$push7=, 0
	return  	$pop7
.LBB2_2:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

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


	.ident	"clang version 3.9.0 "
	.functype	abort, void
