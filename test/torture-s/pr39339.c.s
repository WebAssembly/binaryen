	.text
	.file	"pr39339.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push15=, 12
	i32.add 	$push1=, $0, $pop15
	i32.load	$4=, 0($pop1)
	i32.load	$push0=, 4($0)
	i32.const	$push2=, 3
	i32.shl 	$5=, $pop0, $pop2
	i32.load	$push3=, 0($3)
	i32.load	$push4=, 0($pop3)
	i32.add 	$0=, $pop4, $5
	i32.store	0($0), $1
	i32.const	$push7=, -16
	i32.and 	$push8=, $4, $pop7
	i32.const	$push5=, 15
	i32.and 	$push6=, $2, $pop5
	i32.or  	$4=, $pop8, $pop6
	i32.store	4($0), $4
	block   	
	i32.const	$push10=, 2
	i32.lt_s	$push11=, $2, $pop10
	br_if   	0, $pop11       # 0: down to label0
# %bb.1:                                # %for.body.preheader
	i32.const	$push9=, 4194304
	i32.or  	$4=, $4, $pop9
	i32.const	$push17=, -1
	i32.add 	$2=, $2, $pop17
	i32.const	$push16=, 12
	i32.add 	$0=, $5, $pop16
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.load	$push12=, 0($3)
	i32.load	$push13=, 0($pop12)
	i32.add 	$5=, $pop13, $0
	i32.store	0($5), $4
	i32.const	$push20=, -4
	i32.add 	$push14=, $5, $pop20
	i32.store	0($pop14), $1
	i32.const	$push19=, -1
	i32.add 	$2=, $2, $pop19
	i32.const	$push18=, 8
	i32.add 	$0=, $0, $pop18
	br_if   	0, $2           # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop
	end_block                       # label0:
                                        # fallthrough-return
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
# %bb.0:                                # %entry
	i32.const	$push20=, 0
	i32.load	$push19=, __stack_pointer($pop20)
	i32.const	$push21=, 64
	i32.sub 	$0=, $pop19, $pop21
	i32.const	$push22=, 0
	i32.store	__stack_pointer($pop22), $0
	i32.const	$push2=, 56
	i32.add 	$push3=, $0, $pop2
	i32.const	$push0=, 0
	i64.load	$push1=, .Lmain.e+8($pop0):p2align=2
	i64.store	0($pop3), $pop1
	i32.const	$push36=, 0
	i64.load	$push4=, .Lmain.e($pop36):p2align=2
	i64.store	48($0), $pop4
	i32.const	$push5=, 4
	i32.store	12($0), $pop5
	i32.const	$push26=, 16
	i32.add 	$push27=, $0, $pop26
	i32.store	8($0), $pop27
	i32.const	$push6=, 40
	i32.add 	$push7=, $0, $pop6
	i64.const	$push8=, 0
	i64.store	0($pop7), $pop8
	i32.const	$push9=, 32
	i32.add 	$push10=, $0, $pop9
	i64.const	$push35=, 0
	i64.store	0($pop10), $pop35
	i32.const	$push11=, 255
	i32.store8	4($0), $pop11
	i64.const	$push34=, 0
	i64.store	24($0), $pop34
	i64.const	$push33=, 0
	i64.store	16($0), $pop33
	i32.const	$push28=, 8
	i32.add 	$push29=, $0, $pop28
	i32.store	0($0), $pop29
	i32.const	$push30=, 48
	i32.add 	$push31=, $0, $pop30
	i32.const	$push13=, 65
	i32.const	$push12=, 2
	call    	foo@FUNCTION, $pop31, $pop13, $pop12, $0
	block   	
	i32.load	$push14=, 20($0)
	i32.const	$push32=, 1434451954
	i32.ne  	$push15=, $pop14, $pop32
	br_if   	0, $pop15       # 0: down to label2
# %bb.1:                                # %if.end
	i32.load	$push16=, 28($0)
	i32.const	$push37=, 1434451954
	i32.ne  	$push17=, $pop16, $pop37
	br_if   	0, $pop17       # 0: down to label2
# %bb.2:                                # %if.end13
	i32.const	$push25=, 0
	i32.const	$push23=, 64
	i32.add 	$push24=, $0, $pop23
	i32.store	__stack_pointer($pop25), $pop24
	i32.const	$push18=, 0
	return  	$pop18
.LBB1_3:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.type	.Lmain.e,@object        # @main.e
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	2
.Lmain.e:
	.int32	5                       # 0x5
	.int32	0                       # 0x0
	.int32	6                       # 0x6
	.int8	255                     # 0xff
	.int8	255                     # 0xff
	.int8	127                     # 0x7f
	.int8	85                      # 0x55
	.size	.Lmain.e, 16


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
