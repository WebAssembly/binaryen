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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 16
	i32.sub 	$11=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$11=, 0($7), $11
	i32.const	$push1=, 0
	i32.store	$3=, 8($11), $pop1
	i32.load	$2=, 0($0)
	i32.store	$discard=, 12($11), $3
	i32.const	$1=, -1
	copy_local	$4=, $3
	block
	i32.const	$push29=, 0
	i32.eq  	$push30=, $2, $pop29
	br_if   	0, $pop30       # 0: down to label1
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	copy_local	$push0=, $0
	i32.load	$push2=, 4($pop0)
	i32.const	$push3=, 3
	i32.shl 	$push23=, $pop2, $pop3
	tee_local	$push22=, $5=, $pop23
	i32.load	$push4=, reg_class_contents($pop22):p2align=3
	i32.const	$push21=, -1
	i32.xor 	$push5=, $pop4, $pop21
	i32.or  	$4=, $4, $pop5
	copy_local	$0=, $2
	i32.load	$2=, 0($0)
	i32.load	$push6=, reg_class_contents+4($5)
	i32.const	$push20=, -1
	i32.xor 	$push7=, $pop6, $pop20
	i32.or  	$3=, $3, $pop7
	i32.const	$push8=, 1
	i32.add 	$1=, $1, $pop8
	br_if   	0, $2           # 0: up to label2
# BB#2:                                 # %for.end
	end_loop                        # label3:
	i32.store	$2=, 8($11), $4
	i32.const	$push9=, 4
	i32.const	$9=, 8
	i32.add 	$9=, $11, $9
	i32.add 	$push25=, $9, $pop9
	tee_local	$push24=, $4=, $pop25
	i32.store	$discard=, 0($pop24), $3
	i32.const	$push10=, 0
	i32.lt_s	$push11=, $1, $pop10
	br_if   	0, $pop11       # 0: down to label1
# BB#3:                                 # %if.end
	i32.load	$push12=, 4($0)
	i32.const	$push13=, 3
	i32.shl 	$push28=, $pop12, $pop13
	tee_local	$push27=, $0=, $pop28
	i32.load	$1=, reg_class_contents($pop27):p2align=3
	i32.load	$push17=, reg_class_contents+4($0)
	i32.const	$push14=, -1
	i32.xor 	$push18=, $pop17, $pop14
	i32.or  	$push19=, $3, $pop18
	i32.store	$discard=, 0($4), $pop19
	i32.const	$push26=, -1
	i32.xor 	$push15=, $1, $pop26
	i32.or  	$push16=, $2, $pop15
	i32.store	$discard=, 8($11), $pop16
	i32.const	$10=, 8
	i32.add 	$10=, $11, $10
	call    	merge_overlapping_regs@FUNCTION, $10
.LBB1_4:                                # %cleanup
	end_block                       # label1:
	i32.const	$8=, 16
	i32.add 	$11=, $11, $8
	i32.const	$8=, __stack_pointer
	i32.store	$11=, 0($8), $11
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
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$4=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$4=, 0($1), $4
	i32.const	$push2=, 4
	i32.or  	$push3=, $4, $pop2
	i32.const	$push4=, 1
	i32.store	$discard=, 0($pop3), $pop4
	i32.const	$push6=, 0
	i64.const	$push5=, -1
	i64.store	$discard=, reg_class_contents($pop6):p2align=4, $pop5
	i32.const	$push8=, 0
	i64.const	$push0=, 0
	i64.store	$push1=, 8($4), $pop0
	i64.store	$discard=, reg_class_contents+8($pop8), $pop1
	i32.const	$3=, 8
	i32.add 	$3=, $4, $3
	i32.store	$discard=, 0($4):p2align=3, $3
	call    	regrename_optimize@FUNCTION, $4
	i32.const	$push7=, 0
	i32.const	$2=, 16
	i32.add 	$4=, $4, $2
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	return  	$pop7
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
