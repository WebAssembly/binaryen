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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$8=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$8=, 0($3), $8
	i32.const	$push2=, 10
	i32.const	$5=, 4
	i32.add 	$5=, $8, $5
	i32.add 	$push3=, $5, $pop2
	i32.const	$push0=, 0
	i32.load8_u	$push1=, .Lmain.str+10($pop0)
	i32.store8	$discard=, 0($pop3):p2align=1, $pop1
	i32.const	$push5=, 8
	i32.const	$6=, 4
	i32.add 	$6=, $8, $6
	i32.add 	$push6=, $6, $pop5
	i32.const	$push14=, 0
	i32.load16_u	$push4=, .Lmain.str+8($pop14):p2align=0
	i32.store16	$discard=, 0($pop6):p2align=2, $pop4
	i32.const	$push13=, 0
	i64.load	$push7=, .Lmain.str($pop13):p2align=0
	i64.store	$discard=, 4($8):p2align=2, $pop7
	i32.const	$push8=, 6
	i32.const	$7=, 4
	i32.add 	$7=, $8, $7
	i32.add 	$0=, $7, $pop8
	i32.const	$1=, 32
.LBB1_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	block
	i32.const	$push17=, 255
	i32.and 	$push9=, $1, $pop17
	tee_local	$push16=, $1=, $pop9
	i32.const	$push15=, 32
	i32.eq  	$push10=, $pop16, $pop15
	br_if   	$pop10, 0       # 0: down to label2
# BB#2:                                 # %while.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push18=, 13
	i32.eq  	$push11=, $1, $pop18
	br_if   	$pop11, 0       # 0: down to label2
# BB#3:                                 # %while.end
	i32.const	$push12=, 0
	i32.const	$4=, 16
	i32.add 	$8=, $8, $4
	i32.const	$4=, __stack_pointer
	i32.store	$8=, 0($4), $8
	return  	$pop12
.LBB1_4:                                # %while.body
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	i32.load8_u	$1=, 0($0)
	i32.const	$push19=, 1
	i32.add 	$0=, $0, $pop19
	br      	0               # 0: up to label0
.LBB1_5:
	end_loop                        # label1:
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.Lmain.str,@object      # @main.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lmain.str:
	.asciz	"foo { xx }"
	.size	.Lmain.str, 11


	.ident	"clang version 3.9.0 "
