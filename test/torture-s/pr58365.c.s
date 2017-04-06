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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push27=, 0
	i32.const	$push25=, 0
	i32.load	$push24=, __stack_pointer($pop25)
	i32.const	$push26=, 32
	i32.sub 	$push33=, $pop24, $pop26
	tee_local	$push32=, $1=, $pop33
	i32.store	__stack_pointer($pop27), $pop32
	block   	
	block   	
	i32.const	$push31=, 0
	i32.load8_u	$push0=, i($pop31)
	i32.eqz 	$push48=, $pop0
	br_if   	0, $pop48       # 0: down to label1
# BB#1:                                 # %if.then.i
	i32.const	$push2=, 24
	i32.add 	$push3=, $1, $pop2
	i32.const	$push36=, 0
	i32.load	$push1=, f+16($pop36)
	i32.store	0($pop3), $pop1
	i32.const	$push5=, 16
	i32.add 	$push6=, $1, $pop5
	i32.const	$push35=, 0
	i64.load	$push4=, f+8($pop35):p2align=2
	i64.store	0($pop6), $pop4
	i32.const	$push34=, 0
	i64.load	$push7=, f($pop34):p2align=2
	i64.store	8($1), $pop7
	br      	1               # 1: down to label0
.LBB1_2:                                # %if.end.i
	end_block                       # label1:
	i32.const	$push8=, 24
	i32.add 	$push9=, $1, $pop8
	i32.const	$push38=, 0
	i32.store	0($pop9), $pop38
	i32.const	$push10=, 16
	i32.add 	$push11=, $1, $pop10
	i64.const	$push12=, 0
	i64.store	0($pop11), $pop12
	i64.const	$push37=, 0
	i64.store	8($1), $pop37
.LBB1_3:                                # %bar.exit
	end_block                       # label0:
	i32.const	$push46=, 0
	i32.load	$push45=, 12($1)
	tee_local	$push44=, $0=, $pop45
	i32.store	h+4($pop46), $pop44
	i32.const	$push43=, 0
	i32.load	$push13=, 8($1)
	i32.store	h($pop43), $pop13
	i32.const	$push42=, 0
	i32.const	$push14=, 1
	i32.store	f+4($pop42), $pop14
	i32.const	$push41=, 0
	i32.const	$push15=, 24
	i32.add 	$push16=, $1, $pop15
	i32.load	$push17=, 0($pop16)
	i32.store	h+16($pop41), $pop17
	i32.const	$push40=, 0
	i32.const	$push18=, 20
	i32.add 	$push19=, $1, $pop18
	i32.load	$push20=, 0($pop19)
	i32.store	h+12($pop40), $pop20
	i32.const	$push39=, 0
	i32.const	$push21=, 16
	i32.add 	$push22=, $1, $pop21
	i32.load	$push23=, 0($pop22)
	i32.store	h+8($pop39), $pop23
	block   	
	br_if   	0, $0           # 0: down to label2
# BB#4:                                 # %if.end
	i32.const	$push30=, 0
	i32.const	$push28=, 32
	i32.add 	$push29=, $1, $pop28
	i32.store	__stack_pointer($pop30), $pop29
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
	.section	.bss.h,"aw",@nobits
	.p2align	2
h:
	.skip	20
	.size	h, 20

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.p2align	2
f:
	.skip	20
	.size	f, 20


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
