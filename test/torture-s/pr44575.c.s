	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr44575.c"
	.section	.text.check,"ax",@progbits
	.hidden	check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push27=, __stack_pointer
	i32.load	$push28=, 0($pop27)
	i32.const	$push29=, 16
	i32.sub 	$4=, $pop28, $pop29
	i32.store	$discard=, 12($4), $1
	i32.const	$push11=, 4
	i32.shl 	$2=, $0, $pop11
	i32.const	$1=, 3
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	block
	block
	i32.const	$push14=, -1
	i32.add 	$push2=, $1, $pop14
	i32.const	$push13=, -2
	i32.and 	$push3=, $pop2, $pop13
	i32.or  	$push4=, $pop3, $2
	i32.const	$push12=, 18
	i32.ne  	$push5=, $pop4, $pop12
	br_if   	0, $pop5        # 0: down to label3
# BB#2:                                 # %land.lhs.true
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.load	$push22=, 12($4)
	tee_local	$push21=, $3=, $pop22
	i32.const	$push20=, 12
	i32.add 	$push7=, $pop21, $pop20
	i32.store	$discard=, 12($4), $pop7
	i32.const	$push19=, 0
	i32.load	$0=, fails($pop19)
	i32.const	$push18=, 0
	f32.load	$push9=, a+32($pop18):p2align=4
	f32.load	$push8=, 8($3)
	f32.eq  	$push10=, $pop9, $pop8
	br_if   	1, $pop10       # 1: down to label2
# BB#3:                                 # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push24=, 0
	i32.const	$push23=, 1
	i32.add 	$push1=, $0, $pop23
	i32.store	$0=, fails($pop24), $pop1
	br      	1               # 1: down to label2
.LBB0_4:                                # %sw.epilog.thread
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.const	$push17=, 0
	i32.const	$push16=, 0
	i32.load	$push6=, fails($pop16)
	i32.const	$push15=, 1
	i32.add 	$push0=, $pop6, $pop15
	i32.store	$0=, fails($pop17), $pop0
.LBB0_5:                                # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	br_if   	1, $0           # 1: down to label1
# BB#6:                                 # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push26=, 1
	i32.add 	$0=, $1, $pop26
	i32.const	$push25=, 4
	i32.lt_s	$3=, $1, $pop25
	copy_local	$1=, $0
	br_if   	0, $3           # 0: up to label0
.LBB0_7:                                # %for.end
	end_loop                        # label1:
	return
	.endfunc
.Lfunc_end0:
	.size	check, .Lfunc_end0-check

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push17=, __stack_pointer
	i32.load	$push18=, 0($pop17)
	i32.const	$push19=, 32
	i32.sub 	$4=, $pop18, $pop19
	i32.const	$push20=, __stack_pointer
	i32.store	$discard=, 0($pop20), $4
	i32.const	$push2=, 8
	i32.const	$0=, 20
	i32.add 	$0=, $4, $0
	i32.add 	$push3=, $0, $pop2
	i32.const	$push15=, 0
	i32.const	$push0=, -952139264
	i32.store	$push1=, a+32($pop15):p2align=4, $pop0
	i32.store	$discard=, 0($pop3), $pop1
	i32.const	$push14=, 0
	i64.load	$push4=, a+24($pop14)
	i64.store	$discard=, 20($4):p2align=2, $pop4
	i32.const	$push13=, 8
	i32.const	$1=, 8
	i32.add 	$1=, $4, $1
	i32.add 	$push5=, $1, $pop13
	i32.const	$push12=, 0
	i32.load	$push6=, a+32($pop12):p2align=4
	i32.store	$discard=, 0($pop5), $pop6
	i32.const	$push11=, 0
	i64.load	$push7=, a+24($pop11)
	i64.store	$discard=, 8($4):p2align=2, $pop7
	i32.const	$2=, 8
	i32.add 	$2=, $4, $2
	i32.store	$discard=, 4($4), $2
	i32.const	$3=, 20
	i32.add 	$3=, $4, $3
	i32.store	$discard=, 0($4):p2align=4, $3
	i32.const	$push8=, 1
	call    	check@FUNCTION, $pop8, $4
	block
	i32.const	$push10=, 0
	i32.load	$push9=, fails($pop10)
	br_if   	0, $pop9        # 0: down to label4
# BB#1:                                 # %if.end
	i32.const	$push16=, 0
	i32.const	$push21=, 32
	i32.add 	$4=, $4, $pop21
	i32.const	$push22=, __stack_pointer
	i32.store	$discard=, 0($pop22), $4
	return  	$pop16
.LBB1_2:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	fails                   # @fails
	.type	fails,@object
	.section	.bss.fails,"aw",@nobits
	.globl	fails
	.p2align	2
fails:
	.int32	0                       # 0x0
	.size	fails, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	4
a:
	.skip	60
	.size	a, 60


	.ident	"clang version 3.9.0 "
