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
	i32.const	$push31=, 0
	i32.const	$push28=, 0
	i32.load	$push29=, __stack_pointer($pop28)
	i32.const	$push30=, 16
	i32.sub 	$push35=, $pop29, $pop30
	i32.store	$push38=, __stack_pointer($pop31), $pop35
	tee_local	$push37=, $3=, $pop38
	i32.store	$4=, 12($pop37), $1
	block
	block
	block
	i32.const	$push36=, 1
	i32.lt_s	$push4=, $0, $pop36
	br_if   	0, $pop4        # 0: down to label2
# BB#1:                                 # %for.body.preheader
	i32.const	$push39=, 8
	i32.add 	$2=, $4, $pop39
	i32.const	$4=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.const	$push43=, 10
	i32.add 	$push5=, $4, $pop43
	i32.store	$push42=, 12($3), $2
	tee_local	$push41=, $2=, $pop42
	i32.const	$push40=, -8
	i32.add 	$push6=, $pop41, $pop40
	i32.load8_s	$push7=, 0($pop6)
	i32.ne  	$push8=, $pop5, $pop7
	br_if   	3, $pop8        # 3: down to label1
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push45=, 20
	i32.add 	$push12=, $4, $pop45
	i32.const	$push44=, -7
	i32.add 	$push13=, $2, $pop44
	i32.load8_s	$push14=, 0($pop13)
	i32.ne  	$push15=, $pop12, $pop14
	br_if   	3, $pop15       # 3: down to label1
# BB#4:                                 # %if.end9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push47=, 30
	i32.add 	$push16=, $4, $pop47
	i32.const	$push46=, -6
	i32.add 	$push11=, $2, $pop46
	i32.load8_s	$push1=, 0($pop11)
	i32.ne  	$push17=, $pop16, $pop1
	br_if   	3, $pop17       # 3: down to label1
# BB#5:                                 # %if.end15
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push49=, 40
	i32.add 	$push18=, $4, $pop49
	i32.const	$push48=, -5
	i32.add 	$push10=, $2, $pop48
	i32.load8_s	$push2=, 0($pop10)
	i32.ne  	$push19=, $pop18, $pop2
	br_if   	3, $pop19       # 3: down to label1
# BB#6:                                 # %if.end21
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push51=, 50
	i32.add 	$push20=, $4, $pop51
	i32.const	$push50=, -4
	i32.add 	$push9=, $2, $pop50
	i32.load8_s	$push3=, 0($pop9)
	i32.ne  	$push21=, $pop20, $pop3
	br_if   	4, $pop21       # 4: down to label0
# BB#7:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	copy_local	$1=, $2
	i32.const	$push55=, 8
	i32.add 	$push0=, $2, $pop55
	copy_local	$2=, $pop0
	i32.const	$push54=, 1
	i32.add 	$push53=, $4, $pop54
	tee_local	$push52=, $4=, $pop53
	i32.lt_s	$push22=, $pop52, $0
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
	i32.const	$push34=, 0
	i32.const	$push32=, 16
	i32.add 	$push33=, $3, $pop32
	i32.store	$drop=, __stack_pointer($pop34), $pop33
	return  	$4
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
	i32.const	$push39=, 0
	i32.const	$push36=, 0
	i32.load	$push37=, __stack_pointer($pop36)
	i32.const	$push38=, 64
	i32.sub 	$push56=, $pop37, $pop38
	i32.store	$push64=, __stack_pointer($pop39), $pop56
	tee_local	$push63=, $1=, $pop64
	i32.const	$push40=, 48
	i32.add 	$push41=, $pop63, $pop40
	i32.const	$push1=, 11
	i32.store8	$push0=, 53($1), $pop1
	i32.add 	$push2=, $pop41, $pop0
	i32.const	$push3=, 22
	i32.store8	$drop=, 0($pop2), $pop3
	i32.const	$push4=, 5130
	i32.store16	$drop=, 48($1), $pop4
	i32.const	$push5=, 21
	i32.store8	$drop=, 54($1), $pop5
	i32.const	$push6=, 30
	i32.store8	$drop=, 50($1), $pop6
	i32.const	$push7=, 12
	i32.store8	$0=, 58($1), $pop7
	i32.const	$push8=, 31
	i32.store8	$drop=, 55($1), $pop8
	i32.const	$push42=, 48
	i32.add 	$push43=, $1, $pop42
	i32.add 	$push9=, $0, $pop43
	i32.const	$push10=, 32
	i32.store8	$drop=, 0($pop9), $pop10
	i32.const	$push11=, 40
	i32.store8	$drop=, 51($1), $pop11
	i32.const	$push12=, 56
	i32.add 	$push13=, $1, $pop12
	i32.const	$push14=, 41
	i32.store8	$drop=, 0($pop13), $pop14
	i32.const	$push15=, 61
	i32.add 	$push16=, $1, $pop15
	i32.const	$push17=, 42
	i32.store8	$drop=, 0($pop16), $pop17
	i32.const	$push18=, 50
	i32.store8	$drop=, 52($1), $pop18
	i32.const	$push19=, 57
	i32.add 	$push62=, $1, $pop19
	tee_local	$push61=, $0=, $pop62
	i32.const	$push20=, 51
	i32.store8	$drop=, 0($pop61), $pop20
	i32.const	$push44=, 40
	i32.add 	$push45=, $1, $pop44
	i32.const	$push21=, 4
	i32.add 	$push22=, $pop45, $pop21
	i32.load8_u	$push23=, 52($1)
	i32.store8	$drop=, 0($pop22), $pop23
	i32.const	$push24=, 62
	i32.add 	$push60=, $1, $pop24
	tee_local	$push59=, $2=, $pop60
	i32.const	$push25=, 52
	i32.store8	$drop=, 0($pop59), $pop25
	i32.const	$push46=, 32
	i32.add 	$push47=, $1, $pop46
	i32.const	$push58=, 4
	i32.add 	$push26=, $pop47, $pop58
	i32.load8_u	$push27=, 0($0)
	i32.store8	$drop=, 0($pop26), $pop27
	i32.load	$push28=, 48($1)
	i32.store	$drop=, 40($1), $pop28
	i32.load	$push29=, 53($1):p2align=0
	i32.store	$drop=, 32($1), $pop29
	i32.const	$push48=, 24
	i32.add 	$push49=, $1, $pop48
	i32.const	$push57=, 4
	i32.add 	$push30=, $pop49, $pop57
	i32.load8_u	$push31=, 0($2)
	i32.store8	$drop=, 0($pop30), $pop31
	i32.load	$push32=, 58($1):p2align=1
	i32.store	$drop=, 24($1), $pop32
	i32.const	$push33=, 123
	i32.store	$drop=, 12($1), $pop33
	i32.const	$push50=, 24
	i32.add 	$push51=, $1, $pop50
	i32.store	$drop=, 8($1), $pop51
	i32.const	$push52=, 32
	i32.add 	$push53=, $1, $pop52
	i32.store	$drop=, 4($1), $pop53
	i32.const	$push54=, 40
	i32.add 	$push55=, $1, $pop54
	i32.store	$drop=, 0($1), $pop55
	i32.const	$push34=, 3
	i32.call	$drop=, f@FUNCTION, $pop34, $1
	i32.const	$push35=, 0
	call    	exit@FUNCTION, $pop35
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
