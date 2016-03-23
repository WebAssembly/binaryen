	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20021219-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push20=, __stack_pointer
	i32.load	$push21=, 0($pop20)
	i32.const	$push22=, 16
	i32.sub 	$2=, $pop21, $pop22
	i32.const	$push23=, 4
	i32.add 	$push24=, $2, $pop23
	i32.const	$push2=, 10
	i32.add 	$push3=, $pop24, $pop2
	i32.const	$push0=, 0
	i32.load8_u	$push1=, .Lmain.str+10($pop0)
	i32.store8	$discard=, 0($pop3):p2align=1, $pop1
	i32.const	$push25=, 4
	i32.add 	$push26=, $2, $pop25
	i32.const	$push5=, 8
	i32.add 	$push6=, $pop26, $pop5
	i32.const	$push13=, 0
	i32.load16_u	$push4=, .Lmain.str+8($pop13):p2align=0
	i32.store16	$discard=, 0($pop6):p2align=2, $pop4
	i32.const	$push12=, 0
	i64.load	$push7=, .Lmain.str($pop12):p2align=0
	i64.store	$discard=, 4($2):p2align=2, $pop7
	i32.const	$push27=, 4
	i32.add 	$push28=, $2, $pop27
	i32.const	$push8=, 6
	i32.add 	$0=, $pop28, $pop8
	i32.const	$1=, 32
.LBB1_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	block
	i32.const	$push17=, 255
	i32.and 	$push16=, $1, $pop17
	tee_local	$push15=, $1=, $pop16
	i32.const	$push14=, 32
	i32.eq  	$push9=, $pop15, $pop14
	br_if   	0, $pop9        # 0: down to label2
# BB#2:                                 # %while.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push18=, 13
	i32.ne  	$push10=, $1, $pop18
	br_if   	2, $pop10       # 2: down to label1
.LBB1_3:                                # %while.body
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	i32.load8_u	$1=, 0($0)
	i32.const	$push19=, 1
	i32.add 	$0=, $0, $pop19
	br      	0               # 0: up to label0
.LBB1_4:                                # %while.end
	end_loop                        # label1:
	i32.const	$push11=, 0
	return  	$pop11
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.Lmain.str,@object      # @main.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lmain.str:
	.asciz	"foo { xx }"
	.size	.Lmain.str, 11


	.ident	"clang version 3.9.0 "
