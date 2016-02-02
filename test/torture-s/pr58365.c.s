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
	i32.load8_s	$push1=, i($pop0):p2align=2
	return  	$pop1
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 32
	i32.sub 	$13=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$13=, 0($3), $13
	block
	block
	i32.const	$push27=, 0
	i32.load8_u	$push0=, i($pop27):p2align=2
	i32.const	$push40=, 0
	i32.eq  	$push41=, $pop0, $pop40
	br_if   	$pop41, 0       # 0: down to label1
# BB#1:                                 # %if.then.i
	i32.const	$push2=, 16
	i32.const	$11=, 8
	i32.add 	$11=, $13, $11
	i32.add 	$push3=, $11, $pop2
	i32.const	$push30=, 0
	i32.load	$push1=, f+16($pop30)
	i32.store	$discard=, 0($pop3):p2align=3, $pop1
	i32.const	$push29=, 0
	i64.load	$0=, f($pop29):p2align=2
	i32.const	$push5=, 8
	i32.const	$12=, 8
	i32.add 	$12=, $13, $12
	i32.add 	$push6=, $12, $pop5
	i32.const	$push28=, 0
	i64.load	$push4=, f+8($pop28):p2align=2
	i64.store	$discard=, 0($pop6), $pop4
	i64.store	$discard=, 8($13), $0
	br      	1               # 1: down to label0
.LBB1_2:                                # %if.end.i
	end_block                       # label1:
	i32.const	$push7=, 16
	i32.const	$5=, 8
	i32.add 	$5=, $13, $5
	i32.add 	$push8=, $5, $pop7
	i32.const	$push31=, 0
	i32.store	$discard=, 0($pop8):p2align=3, $pop31
	i32.const	$push9=, 8
	i32.const	$6=, 8
	i32.add 	$6=, $13, $6
	i32.add 	$push10=, $6, $pop9
	i64.const	$push11=, 0
	i64.store	$push12=, 0($pop10), $pop11
	i64.store	$discard=, 8($13), $pop12
.LBB1_3:                                # %bar.exit
	end_block                       # label0:
	i32.const	$push38=, 0
	i32.load	$push13=, 8($13):p2align=3
	i32.store	$discard=, h($pop38), $pop13
	i32.const	$push37=, 0
	i32.const	$push14=, 16
	i32.const	$7=, 8
	i32.add 	$7=, $13, $7
	i32.add 	$push15=, $7, $pop14
	i32.load	$push16=, 0($pop15):p2align=3
	i32.store	$discard=, h+16($pop37), $pop16
	i32.const	$push36=, 0
	i32.const	$push17=, 12
	i32.const	$8=, 8
	i32.add 	$8=, $13, $8
	i32.add 	$push18=, $8, $pop17
	i32.load	$push19=, 0($pop18)
	i32.store	$discard=, h+12($pop36), $pop19
	i32.const	$push35=, 0
	i32.const	$push20=, 8
	i32.const	$9=, 8
	i32.add 	$9=, $13, $9
	i32.add 	$push21=, $9, $pop20
	i32.load	$push22=, 0($pop21):p2align=3
	i32.store	$discard=, h+8($pop35), $pop22
	i32.const	$push34=, 0
	i32.const	$push23=, 4
	i32.const	$10=, 8
	i32.add 	$10=, $13, $10
	i32.or  	$push24=, $10, $pop23
	i32.load	$push25=, 0($pop24)
	i32.store	$discard=, h+4($pop34), $pop25
	i32.const	$push33=, 0
	i32.load	$1=, h+4($pop33)
	i32.const	$push32=, 0
	i32.const	$push26=, 1
	i32.store	$discard=, f+4($pop32), $pop26
	block
	br_if   	$1, 0           # 0: down to label2
# BB#4:                                 # %if.end
	i32.const	$push39=, 0
	i32.const	$4=, 32
	i32.add 	$13=, $13, $4
	i32.const	$4=, __stack_pointer
	i32.store	$13=, 0($4), $13
	return  	$pop39
.LBB1_5:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	i                       # @i
	.type	i,@object
	.section	.data.i,"aw",@progbits
	.globl	i
	.p2align	2
i:
	.int32	1                       # 0x1
	.size	i, 4

	.type	h,@object               # @h
	.lcomm	h,20,2
	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.p2align	2
f:
	.skip	20
	.size	f, 20


	.ident	"clang version 3.9.0 "
