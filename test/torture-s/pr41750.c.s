	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr41750.c"
	.globl	foo_create_got_section
	.type	foo_create_got_section,@function
foo_create_got_section:                 # @foo_create_got_section
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.load	$push0=, 0($1)
	i32.store	$discard=, 8($pop0), $0
	i32.const	$push1=, 1
	return  	$pop1
func_end0:
	.size	foo_create_got_section, func_end0-foo_create_got_section

	.globl	elf64_ia64_check_relocs
	.type	elf64_ia64_check_relocs,@function
elf64_ia64_check_relocs:                # @elf64_ia64_check_relocs
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.load	$2=, 0($1)
	i32.load	$3=, 8($2)
	block   	BB1_4
	br_if   	$3, BB1_4
# BB#1:                                 # %if.then.i
	i32.load	$3=, 4($2)
	block   	BB1_3
	br_if   	$3, BB1_3
# BB#2:                                 # %if.then3.i
	i32.const	$push0=, 4
	i32.add 	$push1=, $2, $pop0
	i32.store	$3=, 0($pop1), $0
BB1_3:                                  # %if.end.i
	i32.call	$discard=, foo_create_got_section, $3, $1
	i32.const	$push2=, 8
	i32.add 	$push3=, $2, $pop2
	i32.load	$3=, 0($pop3)
BB1_4:                                  # %get_got.exit
	return  	$3
func_end1:
	.size	elf64_ia64_check_relocs, func_end1-elf64_ia64_check_relocs

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$1=, abfd
	block   	BB2_2
	i32.const	$push0=, hash
	i32.store	$discard=, link_info($0), $pop0
	i32.const	$push1=, link_info
	i32.call	$push2=, elf64_ia64_check_relocs, $1, $pop1
	i32.ne  	$push3=, $pop2, $1
	br_if   	$pop3, BB2_2
# BB#1:                                 # %if.end
	return  	$0
BB2_2:                                  # %if.then
	call    	abort
	unreachable
func_end2:
	.size	main, func_end2-main

	.type	hash,@object            # @hash
	.bss
	.globl	hash
	.align	2
hash:
	.zero	12
	.size	hash, 12

	.type	link_info,@object       # @link_info
	.globl	link_info
	.align	2
link_info:
	.zero	4
	.size	link_info, 4

	.type	abfd,@object            # @abfd
	.globl	abfd
	.align	2
abfd:
	.int32	0                       # 0x0
	.size	abfd, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
