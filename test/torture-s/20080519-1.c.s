	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20080519-1.c"
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
	i32.const	$push29=, __stack_pointer
	i32.load	$push30=, 0($pop29)
	i32.const	$push31=, 16
	i32.sub 	$6=, $pop30, $pop31
	i32.const	$push32=, __stack_pointer
	i32.store	$discard=, 0($pop32), $6
	i32.load	$2=, 0($0)
	i64.const	$push1=, 0
	i64.store	$discard=, 8($6):p2align=2, $pop1
	block
	i32.const	$push40=, 0
	i32.eq  	$push41=, $2, $pop40
	br_if   	0, $pop41       # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i32.const	$3=, 0
	i32.const	$1=, -1
	i32.const	$4=, 0
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	copy_local	$push0=, $0
	i32.load	$push2=, 4($pop0)
	i32.const	$push23=, 3
	i32.shl 	$push22=, $pop2, $pop23
	tee_local	$push21=, $5=, $pop22
	i32.load	$push3=, reg_class_contents($pop21)
	i32.const	$push20=, -1
	i32.xor 	$push4=, $pop3, $pop20
	i32.or  	$4=, $4, $pop4
	copy_local	$0=, $2
	i32.load	$2=, 0($0)
	i32.load	$push5=, reg_class_contents+4($5)
	i32.const	$push19=, -1
	i32.xor 	$push6=, $pop5, $pop19
	i32.or  	$3=, $3, $pop6
	i32.const	$push18=, 1
	i32.add 	$1=, $1, $pop18
	br_if   	0, $2           # 0: up to label2
# BB#3:                                 # %for.end
	end_loop                        # label3:
	i32.store	$2=, 8($6), $4
	i32.const	$push36=, 8
	i32.add 	$push37=, $6, $pop36
	i32.const	$push7=, 4
	i32.add 	$push25=, $pop37, $pop7
	tee_local	$push24=, $4=, $pop25
	i32.store	$discard=, 0($pop24), $3
	i32.const	$push8=, 0
	i32.lt_s	$push9=, $1, $pop8
	br_if   	0, $pop9        # 0: down to label1
# BB#4:                                 # %if.end
	i32.load	$push10=, 4($0)
	i32.const	$push11=, 3
	i32.shl 	$push28=, $pop10, $pop11
	tee_local	$push27=, $0=, $pop28
	i32.load	$1=, reg_class_contents($pop27)
	i32.load	$push15=, reg_class_contents+4($0)
	i32.const	$push12=, -1
	i32.xor 	$push16=, $pop15, $pop12
	i32.or  	$push17=, $3, $pop16
	i32.store	$discard=, 0($4), $pop17
	i32.const	$push26=, -1
	i32.xor 	$push13=, $1, $pop26
	i32.or  	$push14=, $2, $pop13
	i32.store	$discard=, 8($6), $pop14
	i32.const	$push38=, 8
	i32.add 	$push39=, $6, $pop38
	call    	merge_overlapping_regs@FUNCTION, $pop39
.LBB1_5:                                # %cleanup
	end_block                       # label1:
	i32.const	$push35=, __stack_pointer
	i32.const	$push33=, 16
	i32.add 	$push34=, $6, $pop33
	i32.store	$discard=, 0($pop35), $pop34
	return
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
	i32.const	$push7=, __stack_pointer
	i32.load	$push8=, 0($pop7)
	i32.const	$push9=, 16
	i32.sub 	$0=, $pop8, $pop9
	i32.const	$push10=, __stack_pointer
	i32.store	$discard=, 0($pop10), $0
	i32.const	$push2=, 1
	i32.store	$discard=, 4($0), $pop2
	i32.const	$push4=, 0
	i64.const	$push3=, -1
	i64.store	$discard=, reg_class_contents($pop4), $pop3
	i32.const	$push6=, 0
	i64.const	$push0=, 0
	i64.store	$push1=, 8($0), $pop0
	i64.store	$discard=, reg_class_contents+8($pop6), $pop1
	i32.const	$push14=, 8
	i32.add 	$push15=, $0, $pop14
	i32.store	$discard=, 0($0), $pop15
	call    	regrename_optimize@FUNCTION, $0
	i32.const	$push5=, 0
	i32.const	$push13=, __stack_pointer
	i32.const	$push11=, 16
	i32.add 	$push12=, $0, $pop11
	i32.store	$discard=, 0($pop13), $pop12
	return  	$pop5
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


	.ident	"clang version 3.9.0 "
