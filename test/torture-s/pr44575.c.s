	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr44575.c"
	.section	.text.check,"ax",@progbits
	.hidden	check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32, i32
	.local  	i32, f32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push14=, $pop9, $pop10
	tee_local	$push13=, $5=, $pop14
	i32.store	12($pop13), $1
	i32.const	$push12=, 4
	i32.shl 	$2=, $0, $pop12
	i32.const	$push11=, 0
	f32.load	$3=, a+32($pop11)
	i32.const	$0=, 3
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	block   	
	block   	
	block   	
	i32.const	$push17=, -1
	i32.add 	$push1=, $0, $pop17
	i32.const	$push16=, -2
	i32.and 	$push2=, $pop1, $pop16
	i32.or  	$push3=, $pop2, $2
	i32.const	$push15=, 18
	i32.ne  	$push4=, $pop3, $pop15
	br_if   	0, $pop4        # 0: down to label3
# BB#2:                                 # %land.lhs.true
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.load	$push21=, 12($5)
	tee_local	$push20=, $4=, $pop21
	i32.const	$push19=, 12
	i32.add 	$push5=, $pop20, $pop19
	i32.store	12($5), $pop5
	i32.const	$push18=, 0
	i32.load	$1=, fails($pop18)
	f32.load	$push6=, 8($4)
	f32.ne  	$push7=, $3, $pop6
	br_if   	1, $pop7        # 1: down to label2
	br      	2               # 2: down to label1
.LBB0_3:                                # %sw.epilog.thread
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.const	$push22=, 0
	i32.load	$1=, fails($pop22)
.LBB0_4:                                # %if.end.sink.split
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$push26=, 0
	i32.const	$push25=, 1
	i32.add 	$push24=, $1, $pop25
	tee_local	$push23=, $1=, $pop24
	i32.store	fails($pop26), $pop23
.LBB0_5:                                # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label1:
	block   	
	br_if   	0, $1           # 0: down to label4
# BB#6:                                 # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push28=, 4
	i32.lt_s	$1=, $0, $pop28
	i32.const	$push27=, 1
	i32.add 	$push0=, $0, $pop27
	copy_local	$0=, $pop0
	br_if   	1, $1           # 1: up to label0
.LBB0_7:                                # %for.end
	end_block                       # label4:
	end_loop
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	check, .Lfunc_end0-check

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push14=, 0
	i32.const	$push11=, 0
	i32.load	$push12=, __stack_pointer($pop11)
	i32.const	$push13=, 32
	i32.sub 	$push29=, $pop12, $pop13
	tee_local	$push28=, $0=, $pop29
	i32.store	__stack_pointer($pop14), $pop28
	i32.const	$push27=, 0
	i32.const	$push0=, -952139264
	i32.store	a+32($pop27), $pop0
	i32.const	$push1=, 24
	i32.add 	$push2=, $0, $pop1
	i32.const	$push26=, 0
	i64.load	$push3=, a+28($pop26):p2align=2
	i64.store	0($pop2):p2align=2, $pop3
	i32.const	$push25=, 0
	i32.load	$push4=, a+24($pop25)
	i32.store	20($0), $pop4
	i32.const	$push5=, 16
	i32.add 	$push6=, $0, $pop5
	i32.const	$push24=, 0
	i32.load	$push7=, a+32($pop24)
	i32.store	0($pop6), $pop7
	i32.const	$push23=, 0
	i64.load	$push8=, a+24($pop23)
	i64.store	8($0):p2align=2, $pop8
	i32.const	$push18=, 20
	i32.add 	$push19=, $0, $pop18
	i32.store	0($0), $pop19
	i32.const	$push20=, 8
	i32.add 	$push21=, $0, $pop20
	i32.store	4($0), $pop21
	i32.const	$push9=, 1
	call    	check@FUNCTION, $pop9, $0
	block   	
	i32.const	$push22=, 0
	i32.load	$push10=, fails($pop22)
	br_if   	0, $pop10       # 0: down to label5
# BB#1:                                 # %if.end
	i32.const	$push17=, 0
	i32.const	$push15=, 32
	i32.add 	$push16=, $0, $pop15
	i32.store	__stack_pointer($pop17), $pop16
	i32.const	$push30=, 0
	return  	$pop30
.LBB1_2:                                # %if.then
	end_block                       # label5:
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
