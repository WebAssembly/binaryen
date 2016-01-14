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
	.local  	i32, i32, i32, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 16
	i32.sub 	$13=, $7, $8
	i32.const	$8=, __stack_pointer
	i32.store	$13=, 0($8), $13
	i32.const	$1=, 0
	i32.const	$2=, 1
	i32.const	$push1=, 10
	i32.const	$10=, 0
	i32.add 	$10=, $13, $10
	i32.add 	$push2=, $10, $pop1
	i32.load8_u	$push0=, .Lmain.str+10($1)
	i32.store8	$discard=, 0($pop2), $pop0
	i32.const	$6=, 8
	i32.const	$11=, 0
	i32.add 	$11=, $13, $11
	i32.add 	$push9=, $11, $6
	i32.const	$push3=, .Lmain.str+8
	i32.add 	$push4=, $pop3, $2
	i32.load8_u	$push5=, 0($pop4)
	i32.shl 	$push6=, $pop5, $6
	i32.load8_u	$push7=, .Lmain.str+8($1)
	i32.or  	$push8=, $pop6, $pop7
	i32.store16	$discard=, 0($pop9), $pop8
	i32.const	$6=, .Lmain.str
	i32.const	$5=, 6
	i64.const	$3=, 8
	i64.const	$4=, 16
	i32.const	$push18=, 7
	i32.add 	$push19=, $6, $pop18
	i64.load8_u	$push20=, 0($pop19)
	i64.shl 	$push21=, $pop20, $3
	i32.add 	$push22=, $6, $5
	i64.load8_u	$push23=, 0($pop22)
	i64.or  	$push24=, $pop21, $pop23
	i64.shl 	$push25=, $pop24, $4
	i32.const	$push10=, 5
	i32.add 	$push11=, $6, $pop10
	i64.load8_u	$push12=, 0($pop11)
	i64.shl 	$push13=, $pop12, $3
	i32.const	$push14=, 4
	i32.add 	$push15=, $6, $pop14
	i64.load8_u	$push16=, 0($pop15)
	i64.or  	$push17=, $pop13, $pop16
	i64.or  	$push26=, $pop25, $pop17
	i64.const	$push27=, 32
	i64.shl 	$push28=, $pop26, $pop27
	i32.const	$push29=, 3
	i32.add 	$push30=, $6, $pop29
	i64.load8_u	$push31=, 0($pop30)
	i64.shl 	$push32=, $pop31, $3
	i32.const	$push33=, 2
	i32.add 	$push34=, $6, $pop33
	i64.load8_u	$push35=, 0($pop34)
	i64.or  	$push36=, $pop32, $pop35
	i64.shl 	$push37=, $pop36, $4
	i32.add 	$push38=, $6, $2
	i64.load8_u	$push39=, 0($pop38)
	i64.shl 	$push40=, $pop39, $3
	i64.load8_u	$push41=, .Lmain.str($1)
	i64.or  	$push42=, $pop40, $pop41
	i64.or  	$push43=, $pop37, $pop42
	i64.or  	$push44=, $pop28, $pop43
	i64.store	$discard=, 0($13), $pop44
	i32.const	$0=, 32
	i32.const	$12=, 0
	i32.add 	$12=, $13, $12
	i32.or  	$6=, $12, $5
	copy_local	$5=, $0
.LBB1_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	block
	i32.const	$push45=, 255
	i32.and 	$5=, $5, $pop45
	i32.eq  	$push46=, $5, $0
	br_if   	$pop46, 0       # 0: down to label2
# BB#2:                                 # %while.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push47=, 13
	i32.eq  	$push48=, $5, $pop47
	br_if   	$pop48, 0       # 0: down to label2
# BB#3:                                 # %while.end
	i32.const	$9=, 16
	i32.add 	$13=, $13, $9
	i32.const	$9=, __stack_pointer
	i32.store	$13=, 0($9), $13
	return  	$1
.LBB1_4:                                # %while.body
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	i32.load8_u	$5=, 0($6)
	i32.add 	$6=, $6, $2
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
	.section	".note.GNU-stack","",@progbits
