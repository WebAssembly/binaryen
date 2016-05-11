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
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push21=, __stack_pointer
	i32.const	$push18=, __stack_pointer
	i32.load	$push19=, 0($pop18)
	i32.const	$push20=, 16
	i32.sub 	$push27=, $pop19, $pop20
	i32.store	$1=, 0($pop21), $pop27
	i32.load	$5=, 0($0)
	i64.const	$push1=, 0
	i64.store	$discard=, 8($1):p2align=2, $pop1
	block
	i32.const	$push43=, 0
	i32.eq  	$push44=, $5, $pop43
	br_if   	0, $pop44       # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i32.const	$3=, 0
	i32.const	$2=, -1
	i32.const	$4=, 0
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	copy_local	$push0=, $0
	i32.load	$push2=, 4($pop0)
	i32.const	$push37=, 3
	i32.shl 	$push36=, $pop2, $pop37
	tee_local	$push35=, $0=, $pop36
	i32.load	$push3=, reg_class_contents($pop35)
	i32.const	$push34=, -1
	i32.xor 	$push4=, $pop3, $pop34
	i32.or  	$4=, $4, $pop4
	i32.load	$push5=, reg_class_contents+4($0)
	i32.const	$push33=, -1
	i32.xor 	$push6=, $pop5, $pop33
	i32.or  	$3=, $3, $pop6
	i32.const	$push32=, 1
	i32.add 	$2=, $2, $pop32
	copy_local	$push31=, $5
	tee_local	$push30=, $0=, $pop31
	i32.load	$push29=, 0($pop30)
	tee_local	$push28=, $5=, $pop29
	br_if   	0, $pop28       # 0: up to label2
# BB#3:                                 # %for.end
	end_loop                        # label3:
	i32.store	$5=, 8($1), $4
	i32.const	$push7=, 12
	i32.add 	$push39=, $1, $pop7
	tee_local	$push38=, $4=, $pop39
	i32.store	$discard=, 0($pop38), $3
	i32.const	$push8=, 0
	i32.lt_s	$push9=, $2, $pop8
	br_if   	0, $pop9        # 0: down to label1
# BB#4:                                 # %if.end
	i32.load	$push10=, 4($0)
	i32.const	$push11=, 3
	i32.shl 	$push42=, $pop10, $pop11
	tee_local	$push41=, $0=, $pop42
	i32.load	$2=, reg_class_contents($pop41)
	i32.load	$push15=, reg_class_contents+4($0)
	i32.const	$push12=, -1
	i32.xor 	$push16=, $pop15, $pop12
	i32.or  	$push17=, $3, $pop16
	i32.store	$discard=, 0($4), $pop17
	i32.const	$push40=, -1
	i32.xor 	$push13=, $2, $pop40
	i32.or  	$push14=, $5, $pop13
	i32.store	$discard=, 8($1), $pop14
	i32.const	$push25=, 8
	i32.add 	$push26=, $1, $pop25
	call    	merge_overlapping_regs@FUNCTION, $pop26
.LBB1_5:                                # %cleanup
	end_block                       # label1:
	i32.const	$push24=, __stack_pointer
	i32.const	$push22=, 16
	i32.add 	$push23=, $1, $pop22
	i32.store	$discard=, 0($pop24), $pop23
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
	i32.const	$push8=, __stack_pointer
	i32.const	$push5=, __stack_pointer
	i32.load	$push6=, 0($pop5)
	i32.const	$push7=, 16
	i32.sub 	$push14=, $pop6, $pop7
	i32.store	$push18=, 0($pop8), $pop14
	tee_local	$push17=, $0=, $pop18
	i32.const	$push2=, 1
	i32.store	$discard=, 4($pop17), $pop2
	i32.const	$push4=, 0
	i64.const	$push3=, -1
	i64.store	$discard=, reg_class_contents($pop4), $pop3
	i32.const	$push16=, 0
	i64.const	$push1=, 0
	i64.store	$push0=, 8($0), $pop1
	i64.store	$discard=, reg_class_contents+8($pop16), $pop0
	i32.const	$push12=, 8
	i32.add 	$push13=, $0, $pop12
	i32.store	$discard=, 0($0), $pop13
	call    	regrename_optimize@FUNCTION, $0
	i32.const	$push11=, __stack_pointer
	i32.const	$push9=, 16
	i32.add 	$push10=, $0, $pop9
	i32.store	$discard=, 0($pop11), $pop10
	i32.const	$push15=, 0
	return  	$pop15
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
