	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20080522-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.store	i($pop1), $pop0
	i32.const	$push2=, 2
	i32.store	0($0), $pop2
	i32.const	$push4=, 0
	i32.load	$push3=, i($pop4)
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	i32.store	0($0), $pop0
	i32.const	$push2=, 0
	i32.const	$push1=, 1
	i32.store	i($pop2), $pop1
	i32.load	$push3=, 0($0)
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push19=, 0
	i32.const	$push16=, 0
	i32.load	$push17=, __stack_pointer($pop16)
	i32.const	$push18=, 16
	i32.sub 	$push29=, $pop17, $pop18
	tee_local	$push28=, $0=, $pop29
	i32.store	__stack_pointer($pop19), $pop28
	i32.const	$push0=, 0
	i32.store	12($0), $pop0
	block   	
	i32.const	$push27=, i
	i32.call	$push1=, foo@FUNCTION, $pop27
	i32.const	$push2=, 2
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push31=, i
	i32.call	$push4=, bar@FUNCTION, $pop31
	i32.const	$push30=, 1
	i32.ne  	$push5=, $pop4, $pop30
	br_if   	0, $pop5        # 0: down to label0
# BB#2:                                 # %if.end4
	i32.const	$push23=, 12
	i32.add 	$push24=, $0, $pop23
	i32.call	$push6=, foo@FUNCTION, $pop24
	i32.const	$push32=, 1
	i32.ne  	$push7=, $pop6, $pop32
	br_if   	0, $pop7        # 0: down to label0
# BB#3:                                 # %if.end8
	i32.load	$push8=, 12($0)
	i32.const	$push33=, 2
	i32.ne  	$push9=, $pop8, $pop33
	br_if   	0, $pop9        # 0: down to label0
# BB#4:                                 # %if.end11
	i32.const	$push25=, 12
	i32.add 	$push26=, $0, $pop25
	i32.call	$push10=, bar@FUNCTION, $pop26
	i32.const	$push34=, 2
	i32.ne  	$push11=, $pop10, $pop34
	br_if   	0, $pop11       # 0: down to label0
# BB#5:                                 # %if.end15
	i32.load	$push13=, 12($0)
	i32.const	$push12=, 2
	i32.ne  	$push14=, $pop13, $pop12
	br_if   	0, $pop14       # 0: down to label0
# BB#6:                                 # %if.end18
	i32.const	$push22=, 0
	i32.const	$push20=, 16
	i32.add 	$push21=, $0, $pop20
	i32.store	__stack_pointer($pop22), $pop21
	i32.const	$push15=, 0
	return  	$pop15
.LBB2_7:                                # %if.then17
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	i,@object               # @i
	.section	.bss.i,"aw",@nobits
	.p2align	2
i:
	.int32	0                       # 0x0
	.size	i, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
