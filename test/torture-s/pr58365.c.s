	.text
	.file	"pr58365.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
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
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push25=, 0
	i32.const	$push23=, 0
	i32.load	$push22=, __stack_pointer($pop23)
	i32.const	$push24=, 32
	i32.sub 	$push31=, $pop22, $pop24
	tee_local	$push30=, $0=, $pop31
	i32.store	__stack_pointer($pop25), $pop30
	block   	
	block   	
	i32.const	$push29=, 0
	i32.load8_u	$push0=, i($pop29)
	i32.eqz 	$push43=, $pop0
	br_if   	0, $pop43       # 0: down to label1
# BB#1:                                 # %if.then.i
	i32.const	$push2=, 24
	i32.add 	$push3=, $0, $pop2
	i32.const	$push34=, 0
	i32.load	$push1=, f+16($pop34)
	i32.store	0($pop3), $pop1
	i32.const	$push5=, 16
	i32.add 	$push6=, $0, $pop5
	i32.const	$push33=, 0
	i64.load	$push4=, f+8($pop33):p2align=2
	i64.store	0($pop6), $pop4
	i32.const	$push32=, 0
	i64.load	$push7=, f($pop32):p2align=2
	i64.store	8($0), $pop7
	br      	1               # 1: down to label0
.LBB1_2:                                # %if.end.i
	end_block                       # label1:
	i32.const	$push8=, 24
	i32.add 	$push9=, $0, $pop8
	i32.const	$push36=, 0
	i32.store	0($pop9), $pop36
	i32.const	$push10=, 16
	i32.add 	$push11=, $0, $pop10
	i64.const	$push12=, 0
	i64.store	0($pop11), $pop12
	i64.const	$push35=, 0
	i64.store	8($0), $pop35
.LBB1_3:                                # %bar.exit
	end_block                       # label0:
	i32.const	$push41=, 0
	i64.load	$push13=, 8($0)
	i64.store	h($pop41):p2align=2, $pop13
	i32.const	$push40=, 0
	i32.const	$push14=, 1
	i32.store	f+4($pop40), $pop14
	i32.const	$push39=, 0
	i32.const	$push15=, 24
	i32.add 	$push16=, $0, $pop15
	i32.load	$push17=, 0($pop16)
	i32.store	h+16($pop39), $pop17
	i32.const	$push38=, 0
	i32.const	$push18=, 16
	i32.add 	$push19=, $0, $pop18
	i64.load	$push20=, 0($pop19)
	i64.store	h+8($pop38):p2align=2, $pop20
	block   	
	i32.const	$push37=, 0
	i32.load	$push21=, h+4($pop37)
	br_if   	0, $pop21       # 0: down to label2
# BB#4:                                 # %if.end
	i32.const	$push28=, 0
	i32.const	$push26=, 32
	i32.add 	$push27=, $0, $pop26
	i32.store	__stack_pointer($pop28), $pop27
	i32.const	$push42=, 0
	return  	$pop42
.LBB1_5:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
