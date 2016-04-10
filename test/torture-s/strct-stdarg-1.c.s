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
	i32.const	$push41=, __stack_pointer
	i32.load	$push42=, 0($pop41)
	i32.const	$push43=, 16
	i32.sub 	$4=, $pop42, $pop43
	i32.const	$push44=, __stack_pointer
	i32.store	$discard=, 0($pop44), $4
	i32.store	$2=, 12($4), $1
	block
	block
	block
	i32.const	$push27=, 1
	i32.lt_s	$push3=, $0, $pop27
	br_if   	0, $pop3        # 0: down to label2
# BB#1:                                 # %for.body.preheader
	i32.const	$push28=, 8
	i32.add 	$3=, $2, $pop28
	i32.const	$1=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.store	$2=, 12($4), $3
	i32.const	$push32=, 10
	i32.add 	$push9=, $1, $pop32
	i32.const	$push31=, -8
	i32.add 	$push4=, $2, $pop31
	i32.load8_s	$push8=, 0($pop4)
	i32.ne  	$push10=, $pop9, $pop8
	br_if   	3, $pop10       # 3: down to label1
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push34=, 20
	i32.add 	$push13=, $1, $pop34
	i32.const	$push33=, -7
	i32.add 	$push11=, $2, $pop33
	i32.load8_s	$push12=, 0($pop11)
	i32.ne  	$push14=, $pop13, $pop12
	br_if   	3, $pop14       # 3: down to label1
# BB#4:                                 # %if.end9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push36=, 30
	i32.add 	$push15=, $1, $pop36
	i32.const	$push35=, -6
	i32.add 	$push5=, $2, $pop35
	i32.load8_s	$push0=, 0($pop5)
	i32.ne  	$push16=, $pop15, $pop0
	br_if   	3, $pop16       # 3: down to label1
# BB#5:                                 # %if.end15
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push38=, 40
	i32.add 	$push17=, $1, $pop38
	i32.const	$push37=, -5
	i32.add 	$push6=, $2, $pop37
	i32.load8_s	$push1=, 0($pop6)
	i32.ne  	$push18=, $pop17, $pop1
	br_if   	3, $pop18       # 3: down to label1
# BB#6:                                 # %if.end21
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push40=, 50
	i32.add 	$push19=, $1, $pop40
	i32.const	$push39=, -4
	i32.add 	$push7=, $2, $pop39
	i32.load8_s	$push2=, 0($pop7)
	i32.ne  	$push20=, $pop19, $pop2
	br_if   	4, $pop20       # 4: down to label0
# BB#7:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push30=, 1
	i32.add 	$1=, $1, $pop30
	i32.const	$push29=, 8
	i32.add 	$3=, $2, $pop29
	i32.lt_s	$push21=, $1, $0
	br_if   	0, $pop21       # 0: up to label3
.LBB0_8:                                # %for.end
	end_loop                        # label4:
	end_block                       # label2:
	i32.const	$push22=, 4
	i32.add 	$push23=, $2, $pop22
	i32.store	$discard=, 12($4), $pop23
	i32.load	$push24=, 0($2)
	i32.const	$push25=, 123
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	0, $pop26       # 0: down to label1
# BB#9:                                 # %if.end34
	i32.const	$push47=, __stack_pointer
	i32.const	$push45=, 16
	i32.add 	$push46=, $4, $pop45
	i32.store	$discard=, 0($pop47), $pop46
	return  	$1
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
	i32.const	$push43=, __stack_pointer
	i32.load	$push44=, 0($pop43)
	i32.const	$push45=, 64
	i32.sub 	$2=, $pop44, $pop45
	i32.const	$push46=, __stack_pointer
	i32.store	$discard=, 0($pop46), $2
	i32.const	$push47=, 48
	i32.add 	$push48=, $2, $pop47
	i32.const	$push1=, 11
	i32.store8	$push2=, 53($2), $pop1
	i32.add 	$push6=, $pop48, $pop2
	i32.const	$push7=, 22
	i32.store8	$discard=, 0($pop6), $pop7
	i32.const	$push49=, 48
	i32.add 	$push50=, $2, $pop49
	i32.const	$push3=, 12
	i32.store8	$push4=, 58($2):p2align=1, $pop3
	i32.add 	$push10=, $pop50, $pop4
	i32.const	$push11=, 32
	i32.store8	$discard=, 0($pop10):p2align=2, $pop11
	i32.const	$push51=, 48
	i32.add 	$push52=, $2, $pop51
	i32.const	$push13=, 8
	i32.add 	$push14=, $pop52, $pop13
	i32.const	$push15=, 41
	i32.store8	$discard=, 0($pop14):p2align=3, $pop15
	i32.const	$push53=, 48
	i32.add 	$push54=, $2, $pop53
	i32.const	$push16=, 13
	i32.add 	$push17=, $pop54, $pop16
	i32.const	$push18=, 42
	i32.store8	$discard=, 0($pop17), $pop18
	i32.const	$push0=, 5130
	i32.store16	$discard=, 48($2):p2align=3, $pop0
	i32.const	$push5=, 21
	i32.store8	$discard=, 54($2):p2align=1, $pop5
	i32.const	$push8=, 30
	i32.store8	$discard=, 50($2):p2align=1, $pop8
	i32.const	$push9=, 31
	i32.store8	$discard=, 55($2), $pop9
	i32.const	$push12=, 40
	i32.store8	$discard=, 51($2), $pop12
	i32.const	$push19=, 50
	i32.store8	$discard=, 52($2):p2align=2, $pop19
	i32.const	$push55=, 48
	i32.add 	$push56=, $2, $pop55
	i32.const	$push20=, 9
	i32.add 	$push42=, $pop56, $pop20
	tee_local	$push41=, $1=, $pop42
	i32.const	$push21=, 51
	i32.store8	$discard=, 0($pop41), $pop21
	i32.const	$push57=, 48
	i32.add 	$push58=, $2, $pop57
	i32.const	$push22=, 14
	i32.add 	$push40=, $pop58, $pop22
	tee_local	$push39=, $0=, $pop40
	i32.const	$push23=, 52
	i32.store8	$discard=, 0($pop39):p2align=1, $pop23
	i32.const	$push59=, 40
	i32.add 	$push60=, $2, $pop59
	i32.const	$push24=, 4
	i32.add 	$push25=, $pop60, $pop24
	i32.load8_u	$push26=, 52($2):p2align=2
	i32.store8	$discard=, 0($pop25):p2align=2, $pop26
	i32.const	$push61=, 32
	i32.add 	$push62=, $2, $pop61
	i32.const	$push38=, 4
	i32.add 	$push27=, $pop62, $pop38
	i32.load8_u	$push28=, 0($1)
	i32.store8	$discard=, 0($pop27):p2align=2, $pop28
	i32.load	$push29=, 48($2):p2align=3
	i32.store	$discard=, 40($2), $pop29
	i32.load	$push30=, 53($2):p2align=0
	i32.store	$discard=, 32($2), $pop30
	i32.const	$push63=, 24
	i32.add 	$push64=, $2, $pop63
	i32.const	$push37=, 4
	i32.add 	$push31=, $pop64, $pop37
	i32.load8_u	$push32=, 0($0):p2align=1
	i32.store8	$discard=, 0($pop31):p2align=2, $pop32
	i32.load	$push33=, 58($2):p2align=1
	i32.store	$discard=, 24($2), $pop33
	i32.const	$push34=, 123
	i32.store	$discard=, 12($2), $pop34
	i32.const	$push65=, 24
	i32.add 	$push66=, $2, $pop65
	i32.store	$discard=, 8($2):p2align=3, $pop66
	i32.const	$push67=, 32
	i32.add 	$push68=, $2, $pop67
	i32.store	$discard=, 4($2), $pop68
	i32.const	$push69=, 40
	i32.add 	$push70=, $2, $pop69
	i32.store	$discard=, 0($2):p2align=4, $pop70
	i32.const	$push35=, 3
	i32.call	$discard=, f@FUNCTION, $pop35, $2
	i32.const	$push36=, 0
	call    	exit@FUNCTION, $pop36
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
