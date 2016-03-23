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
	.local  	i64, i32, i32
# BB#0:                                 # %entry
	i32.const	$push38=, __stack_pointer
	i32.load	$push39=, 0($pop38)
	i32.const	$push40=, 32
	i32.sub 	$2=, $pop39, $pop40
	i32.const	$push41=, __stack_pointer
	i32.store	$discard=, 0($pop41), $2
	block
	block
	i32.const	$push25=, 0
	i32.load8_u	$push0=, i($pop25):p2align=2
	i32.const	$push59=, 0
	i32.eq  	$push60=, $pop0, $pop59
	br_if   	0, $pop60       # 0: down to label1
# BB#1:                                 # %if.then.i
	i32.const	$push55=, 8
	i32.add 	$push56=, $2, $pop55
	i32.const	$push2=, 16
	i32.add 	$push3=, $pop56, $pop2
	i32.const	$push28=, 0
	i32.load	$push1=, f+16($pop28)
	i32.store	$discard=, 0($pop3):p2align=3, $pop1
	i32.const	$push27=, 0
	i64.load	$0=, f($pop27):p2align=2
	i32.const	$push57=, 8
	i32.add 	$push58=, $2, $pop57
	i32.const	$push5=, 8
	i32.add 	$push6=, $pop58, $pop5
	i32.const	$push26=, 0
	i64.load	$push4=, f+8($pop26):p2align=2
	i64.store	$discard=, 0($pop6), $pop4
	i64.store	$discard=, 8($2), $0
	br      	1               # 1: down to label0
.LBB1_2:                                # %if.end.i
	end_block                       # label1:
	i32.const	$push45=, 8
	i32.add 	$push46=, $2, $pop45
	i32.const	$push7=, 16
	i32.add 	$push8=, $pop46, $pop7
	i32.const	$push29=, 0
	i32.store	$discard=, 0($pop8):p2align=3, $pop29
	i32.const	$push47=, 8
	i32.add 	$push48=, $2, $pop47
	i32.const	$push9=, 8
	i32.add 	$push10=, $pop48, $pop9
	i64.const	$push11=, 0
	i64.store	$push12=, 0($pop10), $pop11
	i64.store	$discard=, 8($2), $pop12
.LBB1_3:                                # %bar.exit
	end_block                       # label0:
	i32.const	$push36=, 0
	i32.load	$push13=, 12($2)
	i32.store	$discard=, h+4($pop36), $pop13
	i32.const	$push35=, 0
	i32.load	$push14=, 8($2):p2align=3
	i32.store	$discard=, h($pop35), $pop14
	i32.const	$push34=, 0
	i32.const	$push49=, 8
	i32.add 	$push50=, $2, $pop49
	i32.const	$push15=, 16
	i32.add 	$push16=, $pop50, $pop15
	i32.load	$push17=, 0($pop16):p2align=3
	i32.store	$discard=, h+16($pop34), $pop17
	i32.const	$push33=, 0
	i32.const	$push51=, 8
	i32.add 	$push52=, $2, $pop51
	i32.const	$push18=, 12
	i32.add 	$push19=, $pop52, $pop18
	i32.load	$push20=, 0($pop19)
	i32.store	$discard=, h+12($pop33), $pop20
	i32.const	$push32=, 0
	i32.const	$push53=, 8
	i32.add 	$push54=, $2, $pop53
	i32.const	$push21=, 8
	i32.add 	$push22=, $pop54, $pop21
	i32.load	$push23=, 0($pop22):p2align=3
	i32.store	$discard=, h+8($pop32), $pop23
	i32.const	$push31=, 0
	i32.load	$1=, h+4($pop31)
	i32.const	$push30=, 0
	i32.const	$push24=, 1
	i32.store	$discard=, f+4($pop30), $pop24
	block
	br_if   	0, $1           # 0: down to label2
# BB#4:                                 # %if.end
	i32.const	$push37=, 0
	i32.const	$push44=, __stack_pointer
	i32.const	$push42=, 32
	i32.add 	$push43=, $2, $pop42
	i32.store	$discard=, 0($pop44), $pop43
	return  	$pop37
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
