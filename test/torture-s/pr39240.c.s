	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr39240.c"
	.section	.text.bar1,"ax",@progbits
	.hidden	bar1
	.globl	bar1
	.type	bar1,@function
bar1:                                   # @bar1
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 6
	i32.add 	$push1=, $0, $pop0
	i32.call	$push2=, foo1@FUNCTION, $pop1
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	bar1, .Lfunc_end0-bar1

	.section	.text.foo1,"ax",@progbits
	.type	foo1,@function
foo1:                                   # @foo1
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	foo1, .Lfunc_end1-foo1

	.section	.text.bar2,"ax",@progbits
	.hidden	bar2
	.globl	bar2
	.type	bar2,@function
bar2:                                   # @bar2
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 6
	i32.add 	$push1=, $0, $pop0
	i32.call	$push2=, foo2@FUNCTION, $pop1
	i32.const	$push3=, 65535
	i32.and 	$push4=, $pop2, $pop3
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end2:
	.size	bar2, .Lfunc_end2-bar2

	.section	.text.foo2,"ax",@progbits
	.type	foo2,@function
foo2:                                   # @foo2
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 16
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push3=, 16
	i32.shr_s	$push2=, $pop1, $pop3
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end3:
	.size	foo2, .Lfunc_end3-foo2

	.section	.text.bar3,"ax",@progbits
	.hidden	bar3
	.globl	bar3
	.type	bar3,@function
bar3:                                   # @bar3
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 6
	i32.add 	$push1=, $0, $pop0
	i32.call	$push2=, foo3@FUNCTION, $pop1
	i32.const	$push3=, 255
	i32.and 	$push4=, $pop2, $pop3
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end4:
	.size	bar3, .Lfunc_end4-bar3

	.section	.text.foo3,"ax",@progbits
	.type	foo3,@function
foo3:                                   # @foo3
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 24
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push3=, 24
	i32.shr_s	$push2=, $pop1, $pop3
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end5:
	.size	foo3, .Lfunc_end5-foo3

	.section	.text.bar4,"ax",@progbits
	.hidden	bar4
	.globl	bar4
	.type	bar4,@function
bar4:                                   # @bar4
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 6
	i32.add 	$push1=, $0, $pop0
	i32.call	$push2=, foo4@FUNCTION, $pop1
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end6:
	.size	bar4, .Lfunc_end6-bar4

	.section	.text.foo4,"ax",@progbits
	.type	foo4,@function
foo4:                                   # @foo4
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end7:
	.size	foo4, .Lfunc_end7-foo4

	.section	.text.bar5,"ax",@progbits
	.hidden	bar5
	.globl	bar5
	.type	bar5,@function
bar5:                                   # @bar5
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 6
	i32.add 	$push1=, $0, $pop0
	i32.call	$push2=, foo5@FUNCTION, $pop1
	i32.const	$push3=, 16
	i32.shl 	$push4=, $pop2, $pop3
	i32.const	$push6=, 16
	i32.shr_s	$push5=, $pop4, $pop6
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end8:
	.size	bar5, .Lfunc_end8-bar5

	.section	.text.foo5,"ax",@progbits
	.type	foo5,@function
foo5:                                   # @foo5
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 65535
	i32.and 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end9:
	.size	foo5, .Lfunc_end9-foo5

	.section	.text.bar6,"ax",@progbits
	.hidden	bar6
	.globl	bar6
	.type	bar6,@function
bar6:                                   # @bar6
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 6
	i32.add 	$push1=, $0, $pop0
	i32.call	$push2=, foo6@FUNCTION, $pop1
	i32.const	$push3=, 24
	i32.shl 	$push4=, $pop2, $pop3
	i32.const	$push6=, 24
	i32.shr_s	$push5=, $pop4, $pop6
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end10:
	.size	bar6, .Lfunc_end10-bar6

	.section	.text.foo6,"ax",@progbits
	.type	foo6,@function
foo6:                                   # @foo6
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 255
	i32.and 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end11:
	.size	foo6, .Lfunc_end11-foo6

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push20=, -10
	i32.call	$push0=, bar1@FUNCTION, $pop20
	i32.const	$push19=, 0
	i32.load	$push1=, l1($pop19)
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push22=, -10
	i32.call	$push3=, bar2@FUNCTION, $pop22
	i32.const	$push21=, 0
	i32.load	$push4=, l2($pop21)
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#2:                                 # %if.end5
	i32.const	$push24=, -10
	i32.call	$push6=, bar3@FUNCTION, $pop24
	i32.const	$push23=, 0
	i32.load	$push7=, l3($pop23)
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push26=, -10
	i32.call	$push9=, bar4@FUNCTION, $pop26
	i32.const	$push25=, 0
	i32.load	$push10=, l4($pop25)
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#4:                                 # %if.end16
	i32.const	$push28=, -10
	i32.call	$push12=, bar5@FUNCTION, $pop28
	i32.const	$push27=, 0
	i32.load	$push13=, l5($pop27)
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label0
# BB#5:                                 # %if.end22
	i32.const	$push30=, -10
	i32.call	$push15=, bar6@FUNCTION, $pop30
	i32.const	$push29=, 0
	i32.load	$push16=, l6($pop29)
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	0, $pop17       # 0: down to label0
# BB#6:                                 # %if.end28
	i32.const	$push18=, 0
	return  	$pop18
.LBB12_7:                               # %if.then27
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end12:
	.size	main, .Lfunc_end12-main

	.hidden	l1                      # @l1
	.type	l1,@object
	.section	.data.l1,"aw",@progbits
	.globl	l1
	.p2align	2
l1:
	.int32	4294967292              # 0xfffffffc
	.size	l1, 4

	.hidden	l2                      # @l2
	.type	l2,@object
	.section	.data.l2,"aw",@progbits
	.globl	l2
	.p2align	2
l2:
	.int32	65532                   # 0xfffc
	.size	l2, 4

	.hidden	l3                      # @l3
	.type	l3,@object
	.section	.data.l3,"aw",@progbits
	.globl	l3
	.p2align	2
l3:
	.int32	252                     # 0xfc
	.size	l3, 4

	.hidden	l4                      # @l4
	.type	l4,@object
	.section	.data.l4,"aw",@progbits
	.globl	l4
	.p2align	2
l4:
	.int32	4294967292              # 0xfffffffc
	.size	l4, 4

	.hidden	l5                      # @l5
	.type	l5,@object
	.section	.data.l5,"aw",@progbits
	.globl	l5
	.p2align	2
l5:
	.int32	4294967292              # 0xfffffffc
	.size	l5, 4

	.hidden	l6                      # @l6
	.type	l6,@object
	.section	.data.l6,"aw",@progbits
	.globl	l6
	.p2align	2
l6:
	.int32	4294967292              # 0xfffffffc
	.size	l6, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
