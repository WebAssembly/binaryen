	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/931004-14.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push26=, 0
	i32.const	$push23=, 0
	i32.load	$push24=, __stack_pointer($pop23)
	i32.const	$push25=, 16
	i32.sub 	$push30=, $pop24, $pop25
	i32.store	$push36=, __stack_pointer($pop26), $pop30
	tee_local	$push35=, $3=, $pop36
	i32.store	$push34=, 12($3), $1
	tee_local	$push33=, $4=, $pop34
	i32.const	$push32=, 4
	i32.add 	$push2=, $pop33, $pop32
	i32.store	$drop=, 12($pop35), $pop2
	block
	block
	i32.const	$push31=, 1
	i32.lt_s	$push3=, $0, $pop31
	br_if   	0, $pop3        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i32.const	$push4=, 8
	i32.add 	$4=, $4, $pop4
	i32.const	$1=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push40=, 10
	i32.add 	$push5=, $1, $pop40
	copy_local	$push39=, $4
	tee_local	$push38=, $4=, $pop39
	i32.const	$push37=, -8
	i32.add 	$push6=, $pop38, $pop37
	i32.load8_s	$push7=, 0($pop6)
	i32.ne  	$push8=, $pop5, $pop7
	br_if   	3, $pop8        # 3: down to label0
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push42=, 20
	i32.add 	$push11=, $1, $pop42
	i32.const	$push41=, -7
	i32.add 	$push12=, $4, $pop41
	i32.load8_s	$push13=, 0($pop12)
	i32.ne  	$push14=, $pop11, $pop13
	br_if   	3, $pop14       # 3: down to label0
# BB#4:                                 # %if.end9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push44=, 30
	i32.add 	$push15=, $1, $pop44
	i32.const	$push43=, -6
	i32.add 	$push10=, $4, $pop43
	i32.load8_s	$push0=, 0($pop10)
	i32.ne  	$push16=, $pop15, $pop0
	br_if   	3, $pop16       # 3: down to label0
# BB#5:                                 # %if.end15
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push46=, 40
	i32.add 	$push17=, $1, $pop46
	i32.const	$push45=, -5
	i32.add 	$push9=, $4, $pop45
	i32.load8_s	$push1=, 0($pop9)
	i32.ne  	$push18=, $pop17, $pop1
	br_if   	3, $pop18       # 3: down to label0
# BB#6:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.store	$push52=, 12($3), $4
	tee_local	$push51=, $2=, $pop52
	i32.const	$push50=, 4
	i32.add 	$4=, $pop51, $pop50
	i32.const	$push49=, 1
	i32.add 	$push48=, $1, $pop49
	tee_local	$push47=, $1=, $pop48
	i32.lt_s	$push19=, $pop47, $0
	br_if   	0, $pop19       # 0: up to label2
# BB#7:
	end_loop                        # label3:
	i32.const	$push53=, -4
	i32.add 	$1=, $2, $pop53
.LBB0_8:                                # %for.end
	end_block                       # label1:
	i32.load	$push20=, 0($1)
	i32.const	$push21=, 123
	i32.ne  	$push22=, $pop20, $pop21
	br_if   	0, $pop22       # 0: down to label0
# BB#9:                                 # %if.end28
	i32.const	$push29=, 0
	i32.const	$push27=, 16
	i32.add 	$push28=, $3, $pop27
	i32.store	$drop=, __stack_pointer($pop29), $pop28
	return  	$1
.LBB0_10:                               # %if.then20
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push25=, 0
	i32.const	$push22=, 0
	i32.load	$push23=, __stack_pointer($pop22)
	i32.const	$push24=, 48
	i32.sub 	$push34=, $pop23, $pop24
	i32.store	$push36=, __stack_pointer($pop25), $pop34
	tee_local	$push35=, $1=, $pop36
	i32.const	$push0=, 41
	i32.add 	$push1=, $pop35, $pop0
	i32.const	$push2=, 22
	i32.store8	$drop=, 0($pop1), $pop2
	i32.const	$push3=, 12
	i32.store8	$drop=, 40($1), $pop3
	i32.const	$push4=, 5130
	i32.store16	$drop=, 32($1), $pop4
	i32.const	$push5=, 21
	i32.store8	$drop=, 37($1), $pop5
	i32.const	$push6=, 30
	i32.store8	$drop=, 34($1), $pop6
	i32.const	$push7=, 11
	i32.store8	$0=, 36($1), $pop7
	i32.const	$push8=, 31
	i32.store8	$drop=, 38($1), $pop8
	i32.const	$push9=, 42
	i32.add 	$push10=, $1, $pop9
	i32.const	$push11=, 32
	i32.store8	$drop=, 0($pop10), $pop11
	i32.const	$push12=, 40
	i32.store8	$drop=, 35($1), $pop12
	i32.const	$push13=, 41
	i32.store8	$drop=, 39($1), $pop13
	i32.const	$push26=, 32
	i32.add 	$push27=, $1, $pop26
	i32.add 	$push14=, $0, $pop27
	i32.const	$push15=, 42
	i32.store8	$drop=, 0($pop14), $pop15
	i32.load	$push16=, 32($1)
	i32.store	$drop=, 28($1), $pop16
	i32.load	$push17=, 36($1)
	i32.store	$drop=, 24($1), $pop17
	i32.load	$push18=, 40($1)
	i32.store	$drop=, 20($1), $pop18
	i32.const	$push19=, 123
	i32.store	$drop=, 12($1), $pop19
	i32.const	$push28=, 20
	i32.add 	$push29=, $1, $pop28
	i32.store	$drop=, 8($1), $pop29
	i32.const	$push30=, 24
	i32.add 	$push31=, $1, $pop30
	i32.store	$drop=, 4($1), $pop31
	i32.const	$push32=, 28
	i32.add 	$push33=, $1, $pop32
	i32.store	$drop=, 0($1), $pop33
	i32.const	$push20=, 3
	i32.call	$drop=, f@FUNCTION, $pop20, $1
	i32.const	$push21=, 0
	call    	exit@FUNCTION, $pop21
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
