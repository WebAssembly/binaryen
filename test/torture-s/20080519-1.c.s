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
	i32.const	$push21=, 0
	i32.const	$push18=, 0
	i32.load	$push19=, __stack_pointer($pop18)
	i32.const	$push20=, 16
	i32.sub 	$push27=, $pop19, $pop20
	i32.store	$push31=, __stack_pointer($pop21), $pop27
	tee_local	$push30=, $1=, $pop31
	i64.const	$push0=, 0
	i64.store	$drop=, 8($pop30):p2align=2, $pop0
	block
	i32.load	$push29=, 0($0)
	tee_local	$push28=, $4=, $pop29
	i32.eqz 	$push47=, $pop28
	br_if   	0, $pop47       # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i32.const	$5=, 0
	i32.const	$3=, -1
	i32.const	$6=, 0
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push41=, 1
	i32.add 	$3=, $3, $pop41
	i32.load	$push1=, 4($0)
	i32.const	$push40=, 3
	i32.shl 	$push39=, $pop1, $pop40
	tee_local	$push38=, $0=, $pop39
	i32.load	$push2=, reg_class_contents+4($pop38)
	i32.const	$push37=, -1
	i32.xor 	$push3=, $pop2, $pop37
	i32.or  	$5=, $5, $pop3
	i32.load	$push4=, reg_class_contents($0)
	i32.const	$push36=, -1
	i32.xor 	$push5=, $pop4, $pop36
	i32.or  	$6=, $6, $pop5
	copy_local	$push35=, $4
	tee_local	$push34=, $2=, $pop35
	copy_local	$0=, $pop34
	i32.load	$push33=, 0($2)
	tee_local	$push32=, $4=, $pop33
	br_if   	0, $pop32       # 0: up to label2
# BB#3:                                 # %for.end
	end_loop                        # label3:
	i32.const	$push6=, 12
	i32.add 	$push43=, $1, $pop6
	tee_local	$push42=, $0=, $pop43
	i32.store	$drop=, 0($pop42), $5
	i32.store	$drop=, 8($1), $6
	i32.const	$push7=, 0
	i32.lt_s	$push8=, $3, $pop7
	br_if   	0, $pop8        # 0: down to label1
# BB#4:                                 # %if.end
	i32.load	$push9=, 4($2)
	i32.const	$push10=, 3
	i32.shl 	$push46=, $pop9, $pop10
	tee_local	$push45=, $3=, $pop46
	i32.load	$push11=, reg_class_contents+4($pop45)
	i32.const	$push12=, -1
	i32.xor 	$push13=, $pop11, $pop12
	i32.or  	$push14=, $5, $pop13
	i32.store	$drop=, 0($0), $pop14
	i32.load	$push15=, reg_class_contents($3)
	i32.const	$push44=, -1
	i32.xor 	$push16=, $pop15, $pop44
	i32.or  	$push17=, $6, $pop16
	i32.store	$drop=, 8($1), $pop17
	i32.const	$push25=, 8
	i32.add 	$push26=, $1, $pop25
	call    	merge_overlapping_regs@FUNCTION, $pop26
.LBB1_5:                                # %cleanup
	end_block                       # label1:
	i32.const	$push24=, 0
	i32.const	$push22=, 16
	i32.add 	$push23=, $1, $pop22
	i32.store	$drop=, __stack_pointer($pop24), $pop23
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
	.local  	i64, i32
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push13=, $pop5, $pop6
	i32.store	$push17=, __stack_pointer($pop7), $pop13
	tee_local	$push16=, $1=, $pop17
	i64.const	$push0=, 0
	i64.store	$0=, 8($pop16), $pop0
	i32.const	$push2=, 0
	i64.const	$push1=, -1
	i64.store	$drop=, reg_class_contents($pop2), $pop1
	i32.const	$push15=, 0
	i64.store	$drop=, reg_class_contents+8($pop15), $0
	i32.const	$push3=, 1
	i32.store	$drop=, 4($1), $pop3
	i32.const	$push11=, 8
	i32.add 	$push12=, $1, $pop11
	i32.store	$drop=, 0($1), $pop12
	call    	regrename_optimize@FUNCTION, $1
	i32.const	$push10=, 0
	i32.const	$push8=, 16
	i32.add 	$push9=, $1, $pop8
	i32.store	$drop=, __stack_pointer($pop10), $pop9
	i32.const	$push14=, 0
                                        # fallthrough-return: $pop14
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
	.functype	abort, void
