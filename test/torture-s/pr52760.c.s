	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr52760.c"
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
	loop                            # label1:
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
	i32.store16	$drop=, 0($1), $pop6
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
	i32.store16	$drop=, 0($pop50), $pop11
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
	i32.store16	$drop=, 0($pop41), $pop16
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
	i32.store16	$drop=, 0($pop32), $pop21
	i32.const	$push25=, 8
	i32.add 	$1=, $1, $pop25
	i32.const	$push24=, -1
	i32.add 	$push23=, $0, $pop24
	tee_local	$push22=, $0=, $pop23
	br_if   	0, $pop22       # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop                        # label2:
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
	i32.const	$push9=, 0
	i32.const	$push6=, 0
	i32.load	$push7=, __stack_pointer($pop6)
	i32.const	$push8=, 16
	i32.sub 	$push15=, $pop7, $pop8
	i32.store	$push17=, __stack_pointer($pop9), $pop15
	tee_local	$push16=, $0=, $pop17
	i64.const	$push0=, 434320308619640833
	i64.store	$drop=, 8($pop16), $pop0
	i32.const	$push1=, 1
	i32.const	$push13=, 8
	i32.add 	$push14=, $0, $pop13
	call    	foo@FUNCTION, $pop1, $pop14
	block
	i64.load	$push3=, 8($0)
	i64.const	$push2=, 506097522914230528
	i64.ne  	$push4=, $pop3, $pop2
	br_if   	0, $pop4        # 0: down to label3
# BB#1:                                 # %if.end
	i32.const	$push12=, 0
	i32.const	$push10=, 16
	i32.add 	$push11=, $0, $pop10
	i32.store	$drop=, __stack_pointer($pop12), $pop11
	i32.const	$push5=, 0
	return  	$pop5
.LBB1_2:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
