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
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push30=, 0
	i32.const	$push27=, 0
	i32.load	$push28=, __stack_pointer($pop27)
	i32.const	$push29=, 32
	i32.sub 	$push34=, $pop28, $pop29
	i32.store	$0=, __stack_pointer($pop30), $pop34
	block
	block
	i32.const	$push35=, 0
	i32.load8_u	$push1=, i($pop35)
	i32.eqz 	$push48=, $pop1
	br_if   	0, $pop48       # 0: down to label1
# BB#1:                                 # %if.then.i
	i32.const	$push3=, 24
	i32.add 	$push4=, $0, $pop3
	i32.const	$push38=, 0
	i32.load	$push2=, f+16($pop38)
	i32.store	$drop=, 0($pop4), $pop2
	i32.const	$push6=, 16
	i32.add 	$push7=, $0, $pop6
	i32.const	$push37=, 0
	i64.load	$push5=, f+8($pop37):p2align=2
	i64.store	$drop=, 0($pop7), $pop5
	i32.const	$push36=, 0
	i64.load	$push8=, f($pop36):p2align=2
	i64.store	$drop=, 8($0), $pop8
	br      	1               # 1: down to label0
.LBB1_2:                                # %if.end.i
	end_block                       # label1:
	i32.const	$push9=, 24
	i32.add 	$push10=, $0, $pop9
	i32.const	$push39=, 0
	i32.store	$drop=, 0($pop10), $pop39
	i32.const	$push11=, 16
	i32.add 	$push12=, $0, $pop11
	i64.const	$push13=, 0
	i64.store	$push0=, 0($pop12), $pop13
	i64.store	$drop=, 8($0), $pop0
.LBB1_3:                                # %bar.exit
	end_block                       # label0:
	i32.const	$push46=, 0
	i32.load	$push14=, 12($0)
	i32.store	$drop=, h+4($pop46), $pop14
	i32.const	$push45=, 0
	i32.load	$push15=, 8($0)
	i32.store	$drop=, h($pop45), $pop15
	i32.const	$push44=, 0
	i32.const	$push16=, 24
	i32.add 	$push17=, $0, $pop16
	i32.load	$push18=, 0($pop17)
	i32.store	$drop=, h+16($pop44), $pop18
	i32.const	$push43=, 0
	i32.const	$push19=, 20
	i32.add 	$push20=, $0, $pop19
	i32.load	$push21=, 0($pop20)
	i32.store	$drop=, h+12($pop43), $pop21
	i32.const	$push42=, 0
	i32.const	$push22=, 16
	i32.add 	$push23=, $0, $pop22
	i32.load	$push24=, 0($pop23)
	i32.store	$drop=, h+8($pop42), $pop24
	i32.const	$push41=, 0
	i32.const	$push25=, 1
	i32.store	$drop=, f+4($pop41), $pop25
	block
	i32.const	$push40=, 0
	i32.load	$push26=, h+4($pop40)
	br_if   	0, $pop26       # 0: down to label2
# BB#4:                                 # %if.end
	i32.const	$push33=, 0
	i32.const	$push31=, 32
	i32.add 	$push32=, $0, $pop31
	i32.store	$drop=, __stack_pointer($pop33), $pop32
	i32.const	$push47=, 0
	return  	$pop47
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
	.functype	abort, void
