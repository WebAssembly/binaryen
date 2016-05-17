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
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i32
# BB#0:                                 # %entry
	i32.const	$push28=, __stack_pointer
	i32.const	$push25=, __stack_pointer
	i32.load	$push26=, 0($pop25)
	i32.const	$push27=, 32
	i32.sub 	$push32=, $pop26, $pop27
	i32.store	$0=, 0($pop28), $pop32
	block
	block
	i32.const	$push33=, 0
	i32.load8_u	$push1=, i($pop33)
	i32.eqz 	$push46=, $pop1
	br_if   	0, $pop46       # 0: down to label1
# BB#1:                                 # %if.then.i
	i32.const	$push3=, 24
	i32.add 	$push4=, $0, $pop3
	i32.const	$push36=, 0
	i32.load	$push2=, f+16($pop36)
	i32.store	$drop=, 0($pop4), $pop2
	i32.const	$push35=, 0
	i64.load	$1=, f($pop35):p2align=2
	i32.const	$push6=, 16
	i32.add 	$push7=, $0, $pop6
	i32.const	$push34=, 0
	i64.load	$push5=, f+8($pop34):p2align=2
	i64.store	$drop=, 0($pop7), $pop5
	i64.store	$drop=, 8($0), $1
	br      	1               # 1: down to label0
.LBB1_2:                                # %if.end.i
	end_block                       # label1:
	i32.const	$push8=, 24
	i32.add 	$push9=, $0, $pop8
	i32.const	$push37=, 0
	i32.store	$drop=, 0($pop9), $pop37
	i32.const	$push10=, 16
	i32.add 	$push11=, $0, $pop10
	i64.const	$push12=, 0
	i64.store	$push0=, 0($pop11), $pop12
	i64.store	$drop=, 8($0), $pop0
.LBB1_3:                                # %bar.exit
	end_block                       # label0:
	i32.const	$push44=, 0
	i32.load	$push13=, 12($0)
	i32.store	$drop=, h+4($pop44), $pop13
	i32.const	$push43=, 0
	i32.load	$push14=, 8($0)
	i32.store	$drop=, h($pop43), $pop14
	i32.const	$push42=, 0
	i32.const	$push15=, 24
	i32.add 	$push16=, $0, $pop15
	i32.load	$push17=, 0($pop16)
	i32.store	$drop=, h+16($pop42), $pop17
	i32.const	$push41=, 0
	i32.const	$push18=, 20
	i32.add 	$push19=, $0, $pop18
	i32.load	$push20=, 0($pop19)
	i32.store	$drop=, h+12($pop41), $pop20
	i32.const	$push40=, 0
	i32.const	$push21=, 16
	i32.add 	$push22=, $0, $pop21
	i32.load	$push23=, 0($pop22)
	i32.store	$drop=, h+8($pop40), $pop23
	i32.const	$push39=, 0
	i32.load	$2=, h+4($pop39)
	i32.const	$push38=, 0
	i32.const	$push24=, 1
	i32.store	$drop=, f+4($pop38), $pop24
	block
	br_if   	0, $2           # 0: down to label2
# BB#4:                                 # %if.end
	i32.const	$push31=, __stack_pointer
	i32.const	$push29=, 32
	i32.add 	$push30=, $0, $pop29
	i32.store	$drop=, 0($pop31), $pop30
	i32.const	$push45=, 0
	return  	$pop45
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
