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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push12=, __stack_pointer
	i32.load	$push13=, 0($pop12)
	i32.const	$push14=, 16
	i32.sub 	$push18=, $pop13, $pop14
	tee_local	$push17=, $0=, $pop18
	i32.const	$push2=, 14
	i32.add 	$push3=, $pop17, $pop2
	i32.const	$push0=, 0
	i32.load8_u	$push1=, .Lmain.str+10($pop0)
	i32.store8	$discard=, 0($pop3), $pop1
	i32.const	$push5=, 12
	i32.add 	$push6=, $0, $pop5
	i32.const	$push16=, 0
	i32.load16_u	$push4=, .Lmain.str+8($pop16):p2align=0
	i32.store16	$discard=, 0($pop6), $pop4
	i32.const	$push15=, 0
	i64.load	$push7=, .Lmain.str($pop15):p2align=0
	i64.store	$discard=, 4($0):p2align=2, $pop7
	i32.const	$push8=, 10
	i32.add 	$0=, $0, $pop8
	i32.const	$1=, 32
.LBB1_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	block
	i32.const	$push23=, 255
	i32.and 	$push22=, $1, $pop23
	tee_local	$push21=, $1=, $pop22
	i32.const	$push20=, 32
	i32.eq  	$push9=, $pop21, $pop20
	br_if   	0, $pop9        # 0: down to label2
# BB#2:                                 # %while.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push24=, 13
	i32.ne  	$push10=, $1, $pop24
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
