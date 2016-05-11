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
	i32.const	$push26=, __stack_pointer
	i32.const	$push23=, __stack_pointer
	i32.load	$push24=, 0($pop23)
	i32.const	$push25=, 16
	i32.sub 	$push30=, $pop24, $pop25
	i32.store	$2=, 0($pop26), $pop30
	i32.store	$push34=, 12($2), $1
	tee_local	$push33=, $3=, $pop34
	i32.const	$push32=, 4
	i32.add 	$push2=, $pop33, $pop32
	i32.store	$discard=, 12($2), $pop2
	block
	block
	i32.const	$push31=, 1
	i32.lt_s	$push3=, $0, $pop31
	br_if   	0, $pop3        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i32.const	$push4=, 8
	i32.add 	$3=, $3, $pop4
	i32.const	$1=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push38=, 10
	i32.add 	$push9=, $1, $pop38
	copy_local	$push37=, $3
	tee_local	$push36=, $3=, $pop37
	i32.const	$push35=, -8
	i32.add 	$push5=, $pop36, $pop35
	i32.load8_s	$push8=, 0($pop5)
	i32.ne  	$push10=, $pop9, $pop8
	br_if   	3, $pop10       # 3: down to label0
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push40=, 20
	i32.add 	$push13=, $1, $pop40
	i32.const	$push39=, -7
	i32.add 	$push11=, $3, $pop39
	i32.load8_s	$push12=, 0($pop11)
	i32.ne  	$push14=, $pop13, $pop12
	br_if   	3, $pop14       # 3: down to label0
# BB#4:                                 # %if.end9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push42=, 30
	i32.add 	$push15=, $1, $pop42
	i32.const	$push41=, -6
	i32.add 	$push6=, $3, $pop41
	i32.load8_s	$push0=, 0($pop6)
	i32.ne  	$push16=, $pop15, $pop0
	br_if   	3, $pop16       # 3: down to label0
# BB#5:                                 # %if.end15
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push44=, 40
	i32.add 	$push17=, $1, $pop44
	i32.const	$push43=, -5
	i32.add 	$push7=, $3, $pop43
	i32.load8_s	$push1=, 0($pop7)
	i32.ne  	$push18=, $pop17, $pop1
	br_if   	3, $pop18       # 3: down to label0
# BB#6:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push48=, 1
	i32.add 	$1=, $1, $pop48
	i32.store	$push47=, 12($2), $3
	tee_local	$push46=, $4=, $pop47
	i32.const	$push45=, 4
	i32.add 	$3=, $pop46, $pop45
	i32.lt_s	$push19=, $1, $0
	br_if   	0, $pop19       # 0: up to label2
# BB#7:
	end_loop                        # label3:
	i32.const	$push49=, -4
	i32.add 	$1=, $4, $pop49
.LBB0_8:                                # %for.end
	end_block                       # label1:
	i32.load	$push20=, 0($1)
	i32.const	$push21=, 123
	i32.ne  	$push22=, $pop20, $pop21
	br_if   	0, $pop22       # 0: down to label0
# BB#9:                                 # %if.end28
	i32.const	$push29=, __stack_pointer
	i32.const	$push27=, 16
	i32.add 	$push28=, $2, $pop27
	i32.store	$discard=, 0($pop29), $pop28
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push25=, __stack_pointer
	i32.const	$push22=, __stack_pointer
	i32.load	$push23=, 0($pop22)
	i32.const	$push24=, 48
	i32.sub 	$push34=, $pop23, $pop24
	i32.store	$push37=, 0($pop25), $pop34
	tee_local	$push36=, $0=, $pop37
	i32.const	$push4=, 41
	i32.add 	$push5=, $pop36, $pop4
	i32.const	$push6=, 22
	i32.store8	$discard=, 0($pop5), $pop6
	i32.const	$push9=, 42
	i32.add 	$push10=, $0, $pop9
	i32.const	$push11=, 32
	i32.store8	$discard=, 0($pop10), $pop11
	i32.const	$push26=, 32
	i32.add 	$push27=, $0, $pop26
	i32.const	$push1=, 11
	i32.add 	$push14=, $pop27, $pop1
	i32.const	$push15=, 42
	i32.store8	$discard=, 0($pop14), $pop15
	i32.const	$push0=, 5130
	i32.store16	$discard=, 32($0), $pop0
	i32.const	$push35=, 11
	i32.store8	$discard=, 36($0), $pop35
	i32.const	$push2=, 12
	i32.store8	$discard=, 40($0), $pop2
	i32.const	$push3=, 21
	i32.store8	$discard=, 37($0), $pop3
	i32.const	$push7=, 30
	i32.store8	$discard=, 34($0), $pop7
	i32.const	$push8=, 31
	i32.store8	$discard=, 38($0), $pop8
	i32.const	$push12=, 40
	i32.store8	$discard=, 35($0), $pop12
	i32.const	$push13=, 41
	i32.store8	$discard=, 39($0), $pop13
	i32.load	$push16=, 32($0)
	i32.store	$discard=, 28($0), $pop16
	i32.load	$push17=, 36($0)
	i32.store	$discard=, 24($0), $pop17
	i32.load	$push18=, 40($0)
	i32.store	$discard=, 20($0), $pop18
	i32.const	$push19=, 123
	i32.store	$discard=, 12($0), $pop19
	i32.const	$push28=, 20
	i32.add 	$push29=, $0, $pop28
	i32.store	$discard=, 8($0), $pop29
	i32.const	$push30=, 24
	i32.add 	$push31=, $0, $pop30
	i32.store	$discard=, 4($0), $pop31
	i32.const	$push32=, 28
	i32.add 	$push33=, $0, $pop32
	i32.store	$discard=, 0($0), $pop33
	i32.const	$push20=, 3
	i32.call	$discard=, f@FUNCTION, $pop20, $0
	i32.const	$push21=, 0
	call    	exit@FUNCTION, $pop21
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
