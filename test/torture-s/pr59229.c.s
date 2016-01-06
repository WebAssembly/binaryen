	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr59229.c"
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$1=, i($pop0)
	i32.const	$2=, 6
	block   	BB0_4
	i32.const	$push1=, -1
	i32.add 	$push2=, $1, $pop1
	i32.ge_u	$push3=, $pop2, $2
	br_if   	$pop3, BB0_4
# BB#1:                                 # %if.end
	i32.const	$3=, 1
	block   	BB0_3
	i32.const	$push5=, .str
	i32.add 	$push4=, $1, $3
	i32.call	$push6=, memcmp, $0, $pop5, $pop4
	br_if   	$pop6, BB0_3
# BB#2:                                 # %if.end4
	i32.const	$push7=, 32
	i32.store8	$1=, 0($0), $pop7
	i32.add 	$push8=, $0, $2
	i32.store8	$discard=, 0($pop8), $1
	i32.const	$push9=, 5
	i32.add 	$push10=, $0, $pop9
	i32.store8	$discard=, 0($pop10), $1
	i32.const	$push11=, 4
	i32.add 	$push12=, $0, $pop11
	i32.store8	$discard=, 0($pop12), $1
	i32.const	$push13=, 3
	i32.add 	$push14=, $0, $pop13
	i32.store8	$discard=, 0($pop14), $1
	i32.const	$push15=, 2
	i32.add 	$push16=, $0, $pop15
	i32.store8	$discard=, 0($pop16), $1
	i32.add 	$push17=, $0, $3
	i32.store8	$discard=, 0($pop17), $1
	return
BB0_3:                                  # %if.then3
	call    	abort
	unreachable
BB0_4:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	bar, func_end0-bar

	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	block   	BB1_2
	i32.const	$push0=, -1
	i32.add 	$push1=, $1, $pop0
	i32.const	$push2=, 5
	i32.gt_u	$push3=, $pop1, $pop2
	br_if   	$pop3, BB1_2
# BB#1:                                 # %if.end
	i32.const	$push4=, 1
	i32.add 	$push5=, $1, $pop4
	i32.const	$5=, 9
	i32.add 	$5=, $5, $5
	call    	memcpy, $5, $0, $pop5
	i32.const	$6=, 9
	i32.add 	$6=, $5, $6
	call    	bar, $6
BB1_2:                                  # %return
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return
func_end1:
	.size	foo, func_end1-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.store	$0=, i($1), $1
	copy_local	$1=, $0
BB2_1:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB2_2
	i32.const	$push1=, .str.1
	call    	foo, $pop1, $1
	i32.load	$push2=, i($0)
	i32.const	$push3=, 1
	i32.add 	$push0=, $pop2, $pop3
	i32.store	$1=, i($0), $pop0
	i32.const	$push4=, 16
	i32.lt_s	$push5=, $1, $pop4
	br_if   	$pop5, BB2_1
BB2_2:                                  # %for.end
	i32.const	$push6=, 0
	return  	$pop6
func_end2:
	.size	main, func_end2-main

	.type	i,@object               # @i
	.bss
	.globl	i
	.align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.type	.str,@object            # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.str:
	.asciz	"abcdefg"
	.size	.str, 8

	.type	.str.1,@object          # @.str.1
.str.1:
	.asciz	"abcdefghijklmnop"
	.size	.str.1, 17


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
