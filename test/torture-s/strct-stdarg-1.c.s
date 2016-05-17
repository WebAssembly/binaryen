	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/strct-stdarg-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push31=, __stack_pointer
	i32.const	$push28=, __stack_pointer
	i32.load	$push29=, 0($pop28)
	i32.const	$push30=, 16
	i32.sub 	$push35=, $pop29, $pop30
	i32.store	$push38=, 0($pop31), $pop35
	tee_local	$push37=, $3=, $pop38
	i32.store	$2=, 12($pop37), $1
	block
	block
	block
	i32.const	$push36=, 1
	i32.lt_s	$push4=, $0, $pop36
	br_if   	0, $pop4        # 0: down to label2
# BB#1:                                 # %for.body.preheader
	i32.const	$push39=, 8
	i32.add 	$4=, $2, $pop39
	i32.const	$2=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.const	$push43=, 10
	i32.add 	$push10=, $2, $pop43
	i32.store	$push42=, 12($3), $4
	tee_local	$push41=, $4=, $pop42
	i32.const	$push40=, -8
	i32.add 	$push5=, $pop41, $pop40
	i32.load8_s	$push9=, 0($pop5)
	i32.ne  	$push11=, $pop10, $pop9
	br_if   	3, $pop11       # 3: down to label1
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push45=, 20
	i32.add 	$push14=, $2, $pop45
	i32.const	$push44=, -7
	i32.add 	$push12=, $4, $pop44
	i32.load8_s	$push13=, 0($pop12)
	i32.ne  	$push15=, $pop14, $pop13
	br_if   	3, $pop15       # 3: down to label1
# BB#4:                                 # %if.end9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push47=, 30
	i32.add 	$push16=, $2, $pop47
	i32.const	$push46=, -6
	i32.add 	$push6=, $4, $pop46
	i32.load8_s	$push1=, 0($pop6)
	i32.ne  	$push17=, $pop16, $pop1
	br_if   	3, $pop17       # 3: down to label1
# BB#5:                                 # %if.end15
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push49=, 40
	i32.add 	$push18=, $2, $pop49
	i32.const	$push48=, -5
	i32.add 	$push7=, $4, $pop48
	i32.load8_s	$push2=, 0($pop7)
	i32.ne  	$push19=, $pop18, $pop2
	br_if   	3, $pop19       # 3: down to label1
# BB#6:                                 # %if.end21
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push51=, 50
	i32.add 	$push20=, $2, $pop51
	i32.const	$push50=, -4
	i32.add 	$push8=, $4, $pop50
	i32.load8_s	$push3=, 0($pop8)
	i32.ne  	$push21=, $pop20, $pop3
	br_if   	4, $pop21       # 4: down to label0
# BB#7:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	copy_local	$1=, $4
	i32.const	$push53=, 1
	i32.add 	$2=, $2, $pop53
	i32.const	$push52=, 8
	i32.add 	$push0=, $4, $pop52
	copy_local	$4=, $pop0
	i32.lt_s	$push22=, $2, $0
	br_if   	0, $pop22       # 0: up to label3
.LBB0_8:                                # %for.end
	end_loop                        # label4:
	end_block                       # label2:
	i32.const	$push23=, 4
	i32.add 	$push24=, $1, $pop23
	i32.store	$drop=, 12($3), $pop24
	i32.load	$push25=, 0($1)
	i32.const	$push26=, 123
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	0, $pop27       # 0: down to label1
# BB#9:                                 # %if.end34
	i32.const	$push34=, __stack_pointer
	i32.const	$push32=, 16
	i32.add 	$push33=, $3, $pop32
	i32.store	$drop=, 0($pop34), $pop33
	return  	$2
.LBB0_10:                               # %if.then33
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_11:                               # %if.then26
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push38=, __stack_pointer
	i32.const	$push35=, __stack_pointer
	i32.load	$push36=, 0($pop35)
	i32.const	$push37=, 64
	i32.sub 	$push55=, $pop36, $pop37
	i32.store	$push65=, 0($pop38), $pop55
	tee_local	$push64=, $2=, $pop65
	i32.const	$push39=, 48
	i32.add 	$push40=, $pop64, $pop39
	i32.const	$push1=, 11
	i32.add 	$push4=, $pop40, $pop1
	i32.const	$push5=, 22
	i32.store8	$drop=, 0($pop4), $pop5
	i32.const	$push41=, 48
	i32.add 	$push42=, $2, $pop41
	i32.const	$push2=, 12
	i32.add 	$push8=, $pop42, $pop2
	i32.const	$push9=, 32
	i32.store8	$drop=, 0($pop8), $pop9
	i32.const	$push11=, 56
	i32.add 	$push12=, $2, $pop11
	i32.const	$push13=, 41
	i32.store8	$drop=, 0($pop12), $pop13
	i32.const	$push14=, 61
	i32.add 	$push15=, $2, $pop14
	i32.const	$push16=, 42
	i32.store8	$drop=, 0($pop15), $pop16
	i32.const	$push0=, 5130
	i32.store16	$drop=, 48($2), $pop0
	i32.const	$push63=, 11
	i32.store8	$drop=, 53($2), $pop63
	i32.const	$push62=, 12
	i32.store8	$drop=, 58($2), $pop62
	i32.const	$push3=, 21
	i32.store8	$drop=, 54($2), $pop3
	i32.const	$push6=, 30
	i32.store8	$drop=, 50($2), $pop6
	i32.const	$push7=, 31
	i32.store8	$drop=, 55($2), $pop7
	i32.const	$push10=, 40
	i32.store8	$drop=, 51($2), $pop10
	i32.const	$push17=, 50
	i32.store8	$drop=, 52($2), $pop17
	i32.const	$push18=, 57
	i32.add 	$push61=, $2, $pop18
	tee_local	$push60=, $1=, $pop61
	i32.const	$push19=, 51
	i32.store8	$drop=, 0($pop60), $pop19
	i32.const	$push20=, 62
	i32.add 	$push59=, $2, $pop20
	tee_local	$push58=, $0=, $pop59
	i32.const	$push21=, 52
	i32.store8	$drop=, 0($pop58), $pop21
	i32.const	$push43=, 40
	i32.add 	$push44=, $2, $pop43
	i32.const	$push22=, 4
	i32.add 	$push23=, $pop44, $pop22
	i32.load8_u	$push24=, 52($2)
	i32.store8	$drop=, 0($pop23), $pop24
	i32.const	$push45=, 32
	i32.add 	$push46=, $2, $pop45
	i32.const	$push57=, 4
	i32.add 	$push25=, $pop46, $pop57
	i32.load8_u	$push26=, 0($1)
	i32.store8	$drop=, 0($pop25), $pop26
	i32.load	$push27=, 48($2)
	i32.store	$drop=, 40($2), $pop27
	i32.load	$push28=, 53($2):p2align=0
	i32.store	$drop=, 32($2), $pop28
	i32.const	$push47=, 24
	i32.add 	$push48=, $2, $pop47
	i32.const	$push56=, 4
	i32.add 	$push29=, $pop48, $pop56
	i32.load8_u	$push30=, 0($0)
	i32.store8	$drop=, 0($pop29), $pop30
	i32.load	$push31=, 58($2):p2align=1
	i32.store	$drop=, 24($2), $pop31
	i32.const	$push32=, 123
	i32.store	$drop=, 12($2), $pop32
	i32.const	$push49=, 24
	i32.add 	$push50=, $2, $pop49
	i32.store	$drop=, 8($2), $pop50
	i32.const	$push51=, 32
	i32.add 	$push52=, $2, $pop51
	i32.store	$drop=, 4($2), $pop52
	i32.const	$push53=, 40
	i32.add 	$push54=, $2, $pop53
	i32.store	$drop=, 0($2), $pop54
	i32.const	$push33=, 3
	i32.call	$drop=, f@FUNCTION, $pop33, $2
	i32.const	$push34=, 0
	call    	exit@FUNCTION, $pop34
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
