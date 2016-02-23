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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push30=, __stack_pointer
	i32.load	$push31=, 0($pop30)
	i32.const	$push32=, 16
	i32.sub 	$8=, $pop31, $pop32
	i32.const	$push33=, __stack_pointer
	i32.store	$discard=, 0($pop33), $8
	i32.load	$2=, 0($0)
	i32.const	$push1=, 0
	i32.store	$push2=, 8($8), $pop1
	i32.store	$3=, 12($8), $pop2
	block
	i32.const	$push36=, 0
	i32.eq  	$push37=, $2, $pop36
	br_if   	0, $pop37       # 0: down to label1
# BB#1:
	i32.const	$1=, -1
	copy_local	$4=, $3
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	copy_local	$push0=, $0
	i32.load	$push3=, 4($pop0)
	i32.const	$push24=, 3
	i32.shl 	$push23=, $pop3, $pop24
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
	i32.const	$push19=, 1
	i32.add 	$1=, $1, $pop19
	br_if   	0, $2           # 0: up to label2
# BB#3:                                 # %for.end
	end_loop                        # label3:
	i32.store	$2=, 8($8), $4
	i32.const	$push8=, 4
	i32.const	$6=, 8
	i32.add 	$6=, $8, $6
	i32.add 	$push26=, $6, $pop8
	tee_local	$push25=, $4=, $pop26
	i32.store	$discard=, 0($pop25), $3
	i32.const	$push9=, 0
	i32.lt_s	$push10=, $1, $pop9
	br_if   	0, $pop10       # 0: down to label1
# BB#4:                                 # %if.end
	i32.load	$push11=, 4($0)
	i32.const	$push12=, 3
	i32.shl 	$push29=, $pop11, $pop12
	tee_local	$push28=, $0=, $pop29
	i32.load	$1=, reg_class_contents($pop28):p2align=3
	i32.load	$push16=, reg_class_contents+4($0)
	i32.const	$push13=, -1
	i32.xor 	$push17=, $pop16, $pop13
	i32.or  	$push18=, $3, $pop17
	i32.store	$discard=, 0($4), $pop18
	i32.const	$push27=, -1
	i32.xor 	$push14=, $1, $pop27
	i32.or  	$push15=, $2, $pop14
	i32.store	$discard=, 8($8), $pop15
	i32.const	$7=, 8
	i32.add 	$7=, $8, $7
	call    	merge_overlapping_regs@FUNCTION, $7
.LBB1_5:                                # %cleanup
	end_block                       # label1:
	i32.const	$push34=, 16
	i32.add 	$8=, $8, $pop34
	i32.const	$push35=, __stack_pointer
	i32.store	$discard=, 0($pop35), $8
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push7=, __stack_pointer
	i32.load	$push8=, 0($pop7)
	i32.const	$push9=, 16
	i32.sub 	$1=, $pop8, $pop9
	i32.const	$push10=, __stack_pointer
	i32.store	$discard=, 0($pop10), $1
	i32.const	$push2=, 1
	i32.store	$discard=, 4($1), $pop2
	i32.const	$push4=, 0
	i64.const	$push3=, -1
	i64.store	$discard=, reg_class_contents($pop4):p2align=4, $pop3
	i32.const	$push6=, 0
	i64.const	$push0=, 0
	i64.store	$push1=, 8($1), $pop0
	i64.store	$discard=, reg_class_contents+8($pop6), $pop1
	i32.const	$0=, 8
	i32.add 	$0=, $1, $0
	i32.store	$discard=, 0($1):p2align=3, $0
	call    	regrename_optimize@FUNCTION, $1
	i32.const	$push5=, 0
	i32.const	$push11=, 16
	i32.add 	$1=, $1, $pop11
	i32.const	$push12=, __stack_pointer
	i32.store	$discard=, 0($pop12), $1
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
