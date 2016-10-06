	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20080519-1.c"
	.section	.text.merge_overlapping_regs,"ax",@progbits
	.hidden	merge_overlapping_regs
	.globl	merge_overlapping_regs
	.type	merge_overlapping_regs,@function
merge_overlapping_regs:                 # @merge_overlapping_regs
	.param  	i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push0=, 0($0)
	i32.const	$push4=, -1
	i32.ne  	$push1=, $pop0, $pop4
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.load	$push2=, 4($0)
	i32.const	$push5=, -1
	i32.ne  	$push3=, $pop2, $pop5
	br_if   	0, $pop3        # 0: down to label0
# BB#2:                                 # %if.end
	return
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	merge_overlapping_regs, .Lfunc_end0-merge_overlapping_regs

	.section	.text.regrename_optimize,"ax",@progbits
	.hidden	regrename_optimize
	.globl	regrename_optimize
	.type	regrename_optimize,@function
regrename_optimize:                     # @regrename_optimize
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push27=, 0
	i32.const	$push24=, 0
	i32.load	$push25=, __stack_pointer($pop24)
	i32.const	$push26=, 16
	i32.sub 	$push36=, $pop25, $pop26
	tee_local	$push35=, $6=, $pop36
	i32.store	__stack_pointer($pop27), $pop35
	i64.const	$push0=, 0
	i64.store	8($6):p2align=2, $pop0
	block   	
	i32.load	$push34=, 0($0)
	tee_local	$push33=, $5=, $pop34
	i32.eqz 	$push54=, $pop33
	br_if   	0, $pop54       # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i32.const	$3=, 0
	i32.const	$2=, -1
	i32.const	$4=, 0
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push48=, 1
	i32.add 	$2=, $2, $pop48
	i32.load	$push1=, 4($0)
	i32.const	$push47=, 3
	i32.shl 	$push46=, $pop1, $pop47
	tee_local	$push45=, $0=, $pop46
	i32.const	$push44=, reg_class_contents+4
	i32.add 	$push2=, $pop45, $pop44
	i32.load	$push3=, 0($pop2)
	i32.const	$push43=, -1
	i32.xor 	$push4=, $pop3, $pop43
	i32.or  	$3=, $3, $pop4
	i32.const	$push42=, reg_class_contents
	i32.add 	$push5=, $0, $pop42
	i32.load	$push6=, 0($pop5)
	i32.const	$push41=, -1
	i32.xor 	$push7=, $pop6, $pop41
	i32.or  	$4=, $4, $pop7
	copy_local	$push40=, $5
	tee_local	$push39=, $1=, $pop40
	copy_local	$0=, $pop39
	i32.load	$push38=, 0($1)
	tee_local	$push37=, $5=, $pop38
	br_if   	0, $pop37       # 0: up to label2
# BB#3:                                 # %for.end
	end_loop
	i32.const	$push8=, 12
	i32.add 	$push50=, $6, $pop8
	tee_local	$push49=, $0=, $pop50
	i32.store	0($pop49), $3
	i32.store	8($6), $4
	i32.const	$push9=, 0
	i32.lt_s	$push10=, $2, $pop9
	br_if   	0, $pop10       # 0: down to label1
# BB#4:                                 # %if.end
	i32.load	$push11=, 4($1)
	i32.const	$push12=, 3
	i32.shl 	$push53=, $pop11, $pop12
	tee_local	$push52=, $2=, $pop53
	i32.const	$push13=, reg_class_contents+4
	i32.add 	$push14=, $pop52, $pop13
	i32.load	$push15=, 0($pop14)
	i32.const	$push16=, -1
	i32.xor 	$push17=, $pop15, $pop16
	i32.or  	$push18=, $3, $pop17
	i32.store	0($0), $pop18
	i32.const	$push19=, reg_class_contents
	i32.add 	$push20=, $2, $pop19
	i32.load	$push21=, 0($pop20)
	i32.const	$push51=, -1
	i32.xor 	$push22=, $pop21, $pop51
	i32.or  	$push23=, $4, $pop22
	i32.store	8($6), $pop23
	i32.const	$push31=, 8
	i32.add 	$push32=, $6, $pop31
	call    	merge_overlapping_regs@FUNCTION, $pop32
.LBB1_5:                                # %cleanup
	end_block                       # label1:
	i32.const	$push30=, 0
	i32.const	$push28=, 16
	i32.add 	$push29=, $6, $pop28
	i32.store	__stack_pointer($pop30), $pop29
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	regrename_optimize, .Lfunc_end1-regrename_optimize

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push17=, $pop5, $pop6
	tee_local	$push16=, $0=, $pop17
	i32.store	__stack_pointer($pop7), $pop16
	i64.const	$push0=, 0
	i64.store	8($0), $pop0
	i32.const	$push2=, 0
	i64.const	$push1=, -1
	i64.store	reg_class_contents($pop2), $pop1
	i32.const	$push15=, 0
	i64.const	$push14=, 0
	i64.store	reg_class_contents+8($pop15), $pop14
	i32.const	$push3=, 1
	i32.store	4($0), $pop3
	i32.const	$push11=, 8
	i32.add 	$push12=, $0, $pop11
	i32.store	0($0), $pop12
	call    	regrename_optimize@FUNCTION, $0
	i32.const	$push10=, 0
	i32.const	$push8=, 16
	i32.add 	$push9=, $0, $pop8
	i32.store	__stack_pointer($pop10), $pop9
	i32.const	$push13=, 0
                                        # fallthrough-return: $pop13
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	reg_class_contents      # @reg_class_contents
	.type	reg_class_contents,@object
	.section	.bss.reg_class_contents,"aw",@nobits
	.globl	reg_class_contents
	.p2align	4
reg_class_contents:
	.skip	16
	.size	reg_class_contents, 16


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
