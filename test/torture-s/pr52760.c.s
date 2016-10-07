	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr52760.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %for.body.preheader
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.load16_u	$push58=, 0($1)
	tee_local	$push57=, $2=, $pop58
	i32.const	$push56=, 24
	i32.shl 	$push2=, $pop57, $pop56
	i32.const	$push55=, 8
	i32.shl 	$push3=, $2, $pop55
	i32.const	$push54=, 16711680
	i32.and 	$push4=, $pop3, $pop54
	i32.or  	$push5=, $pop2, $pop4
	i32.const	$push53=, 16
	i32.shr_u	$push6=, $pop5, $pop53
	i32.store16	0($1), $pop6
	i32.const	$push52=, 2
	i32.add 	$push51=, $1, $pop52
	tee_local	$push50=, $2=, $pop51
	i32.load16_u	$push49=, 0($2)
	tee_local	$push48=, $2=, $pop49
	i32.const	$push47=, 24
	i32.shl 	$push7=, $pop48, $pop47
	i32.const	$push46=, 8
	i32.shl 	$push8=, $2, $pop46
	i32.const	$push45=, 16711680
	i32.and 	$push9=, $pop8, $pop45
	i32.or  	$push10=, $pop7, $pop9
	i32.const	$push44=, 16
	i32.shr_u	$push11=, $pop10, $pop44
	i32.store16	0($pop50), $pop11
	i32.const	$push43=, 4
	i32.add 	$push42=, $1, $pop43
	tee_local	$push41=, $2=, $pop42
	i32.load16_u	$push40=, 0($2)
	tee_local	$push39=, $2=, $pop40
	i32.const	$push38=, 24
	i32.shl 	$push12=, $pop39, $pop38
	i32.const	$push37=, 8
	i32.shl 	$push13=, $2, $pop37
	i32.const	$push36=, 16711680
	i32.and 	$push14=, $pop13, $pop36
	i32.or  	$push15=, $pop12, $pop14
	i32.const	$push35=, 16
	i32.shr_u	$push16=, $pop15, $pop35
	i32.store16	0($pop41), $pop16
	i32.const	$push34=, 6
	i32.add 	$push33=, $1, $pop34
	tee_local	$push32=, $2=, $pop33
	i32.load16_u	$push31=, 0($2)
	tee_local	$push30=, $2=, $pop31
	i32.const	$push29=, 24
	i32.shl 	$push17=, $pop30, $pop29
	i32.const	$push28=, 8
	i32.shl 	$push18=, $2, $pop28
	i32.const	$push27=, 16711680
	i32.and 	$push19=, $pop18, $pop27
	i32.or  	$push20=, $pop17, $pop19
	i32.const	$push26=, 16
	i32.shr_u	$push21=, $pop20, $pop26
	i32.store16	0($pop32), $pop21
	i32.const	$push25=, 8
	i32.add 	$1=, $1, $pop25
	i32.const	$push24=, -1
	i32.add 	$push23=, $0, $pop24
	tee_local	$push22=, $0=, $pop23
	br_if   	0, $pop22       # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop
	end_block                       # label0:
                                        # fallthrough-return
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
	i32.const	$push18=, 0
	i32.const	$push15=, 0
	i32.load	$push16=, __stack_pointer($pop15)
	i32.const	$push17=, 16
	i32.sub 	$push25=, $pop16, $pop17
	tee_local	$push24=, $0=, $pop25
	i32.store	__stack_pointer($pop18), $pop24
	i64.const	$push0=, 434320308619640833
	i64.store	8($0), $pop0
	i32.const	$push1=, 1
	i32.const	$push22=, 8
	i32.add 	$push23=, $0, $pop22
	call    	foo@FUNCTION, $pop1, $pop23
	block   	
	i32.load16_u	$push3=, 8($0)
	i32.const	$push2=, 256
	i32.ne  	$push4=, $pop3, $pop2
	br_if   	0, $pop4        # 0: down to label2
# BB#1:                                 # %lor.lhs.false
	i32.load16_u	$push6=, 10($0)
	i32.const	$push5=, 770
	i32.ne  	$push7=, $pop6, $pop5
	br_if   	0, $pop7        # 0: down to label2
# BB#2:                                 # %lor.lhs.false5
	i32.load16_u	$push9=, 12($0)
	i32.const	$push8=, 1284
	i32.ne  	$push10=, $pop9, $pop8
	br_if   	0, $pop10       # 0: down to label2
# BB#3:                                 # %lor.lhs.false9
	i32.load16_u	$push12=, 14($0)
	i32.const	$push11=, 1798
	i32.ne  	$push13=, $pop12, $pop11
	br_if   	0, $pop13       # 0: down to label2
# BB#4:                                 # %if.end
	i32.const	$push21=, 0
	i32.const	$push19=, 16
	i32.add 	$push20=, $0, $pop19
	i32.store	__stack_pointer($pop21), $pop20
	i32.const	$push14=, 0
	return  	$pop14
.LBB1_5:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
