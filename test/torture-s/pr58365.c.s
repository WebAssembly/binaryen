	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58365.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load8_s	$push1=, i($pop0)
	return  	$pop1
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 32
	i32.sub 	$16=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$16=, 0($6), $16
	i32.const	$0=, 0
	block
	block
	i32.load8_u	$push0=, i($0)
	i32.const	$push36=, 0
	i32.eq  	$push37=, $pop0, $pop36
	br_if   	$pop37, 0       # 0: down to label1
# BB#1:                                 # %if.then.i
	i32.const	$push2=, 16
	i32.const	$14=, 8
	i32.add 	$14=, $16, $14
	i32.add 	$push3=, $14, $pop2
	i32.load	$push1=, f+16($0)
	i32.store	$discard=, 0($pop3), $pop1
	i32.const	$4=, 4
	i32.const	$push12=, f
	i32.add 	$push13=, $pop12, $4
	i64.load32_u	$2=, 0($pop13)
	i64.const	$1=, 32
	i64.load32_u	$3=, f($0)
	i32.const	$push10=, 8
	i32.const	$15=, 8
	i32.add 	$15=, $16, $15
	i32.add 	$push11=, $15, $pop10
	i32.const	$push4=, f+8
	i32.add 	$push5=, $pop4, $4
	i64.load32_u	$push6=, 0($pop5)
	i64.shl 	$push7=, $pop6, $1
	i64.load32_u	$push8=, f+8($0)
	i64.or  	$push9=, $pop7, $pop8
	i64.store	$discard=, 0($pop11), $pop9
	i64.shl 	$push14=, $2, $1
	i64.or  	$push15=, $pop14, $3
	i64.store	$discard=, 8($16), $pop15
	br      	1               # 1: down to label0
.LBB1_2:                                # %if.end.i
	end_block                       # label1:
	i32.const	$push16=, 16
	i32.const	$8=, 8
	i32.add 	$8=, $16, $8
	i32.add 	$push17=, $8, $pop16
	i32.store	$discard=, 0($pop17), $0
	i32.const	$push18=, 8
	i32.const	$9=, 8
	i32.add 	$9=, $16, $9
	i32.add 	$push19=, $9, $pop18
	i64.const	$push20=, 0
	i64.store	$push21=, 0($pop19), $pop20
	i64.store	$discard=, 8($16), $pop21
.LBB1_3:                                # %bar.exit
	end_block                       # label0:
	i32.load	$push22=, 8($16)
	i32.store	$discard=, h($0), $pop22
	i32.const	$push23=, 16
	i32.const	$10=, 8
	i32.add 	$10=, $16, $10
	i32.add 	$push24=, $10, $pop23
	i32.load	$push25=, 0($pop24)
	i32.store	$discard=, h+16($0), $pop25
	i32.const	$push26=, 12
	i32.const	$11=, 8
	i32.add 	$11=, $16, $11
	i32.add 	$push27=, $11, $pop26
	i32.load	$push28=, 0($pop27)
	i32.store	$discard=, h+12($0), $pop28
	i32.const	$push29=, 8
	i32.const	$12=, 8
	i32.add 	$12=, $16, $12
	i32.add 	$push30=, $12, $pop29
	i32.load	$push31=, 0($pop30)
	i32.store	$discard=, h+8($0), $pop31
	i32.const	$push32=, 4
	i32.const	$13=, 8
	i32.add 	$13=, $16, $13
	i32.or  	$push33=, $13, $pop32
	i32.load	$push34=, 0($pop33)
	i32.store	$discard=, h+4($0), $pop34
	i32.load	$4=, h+4($0)
	block
	i32.const	$push35=, 1
	i32.store	$discard=, f+4($0), $pop35
	br_if   	$4, 0           # 0: down to label2
# BB#4:                                 # %if.end
	i32.const	$7=, 32
	i32.add 	$16=, $16, $7
	i32.const	$7=, __stack_pointer
	i32.store	$16=, 0($7), $16
	return  	$0
.LBB1_5:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	i                       # @i
	.type	i,@object
	.section	.data.i,"aw",@progbits
	.globl	i
	.align	2
i:
	.int32	1                       # 0x1
	.size	i, 4

	.type	h,@object               # @h
	.lcomm	h,20,2
	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.align	2
f:
	.skip	20
	.size	f, 20

	.type	g,@object               # @g
	.section	.rodata.g,"a",@progbits
	.align	2
g:
	.skip	20
	.size	g, 20


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
