	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr27285.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.load8_u	$6=, 1($0)
	block
	i32.const	$push7=, 0
	i32.eq  	$push8=, $6, $pop7
	br_if   	$pop8, 0        # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$4=, 3
	i32.add 	$5=, $0, $4
	i32.add 	$4=, $1, $4
	i32.const	$2=, 8
	i32.sub 	$0=, $2, $6
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$1=, 255
	i32.load8_u	$push5=, 0($5)
	i32.const	$push0=, 7
	i32.gt_s	$push1=, $6, $pop0
	i32.shl 	$push3=, $1, $0
	i32.select	$push4=, $pop1, $1, $pop3
	i32.and 	$push6=, $pop5, $pop4
	i32.store8	$discard=, 0($4), $pop6
	i32.const	$push9=, 0
	i32.eq  	$push10=, $0, $pop9
	br_if   	$pop10, 1       # 1: down to label2
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$1=, 1
	i32.add 	$5=, $5, $1
	i32.add 	$4=, $4, $1
	i32.const	$push2=, -8
	i32.add 	$1=, $6, $pop2
	i32.lt_s	$3=, $6, $2
	i32.add 	$0=, $0, $2
	copy_local	$6=, $1
	i32.const	$push11=, 0
	i32.eq  	$push12=, $3, $pop11
	br_if   	$pop12, 0       # 0: up to label1
.LBB0_4:                                # %while.end
	end_loop                        # label2:
	end_block                       # label0:
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i64, i32, i32, i32, i64, i64, i32, i32, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$16=, __stack_pointer
	i32.load	$16=, 0($16)
	i32.const	$17=, 48
	i32.sub 	$31=, $16, $17
	i32.const	$17=, __stack_pointer
	i32.store	$31=, 0($17), $31
	i32.const	$2=, 1
	i32.const	$0=, 0
	i32.const	$1=, 18
	i32.const	$19=, 24
	i32.add 	$19=, $31, $19
	i32.add 	$push1=, $19, $1
	i32.load8_u	$push0=, .Lmain.x+18($0)
	i32.store8	$discard=, 0($pop1), $pop0
	i32.const	$3=, 8
	i32.const	$4=, 16
	i32.const	$20=, 24
	i32.add 	$20=, $31, $20
	i32.add 	$push8=, $20, $4
	i32.const	$push2=, .Lmain.x+16
	i32.add 	$push3=, $pop2, $2
	i32.load8_u	$push4=, 0($pop3)
	i32.shl 	$push5=, $pop4, $3
	i32.load8_u	$push6=, .Lmain.x+16($0)
	i32.or  	$push7=, $pop5, $pop6
	i32.store16	$discard=, 0($pop8), $pop7
	i32.const	$5=, 5
	i32.const	$6=, .Lmain.x+8
	i32.const	$8=, 4
	i32.const	$9=, 7
	i32.const	$10=, 6
	i32.const	$13=, 3
	i32.const	$14=, 2
	i64.const	$7=, 8
	i64.const	$11=, 16
	i64.const	$12=, 32
	i32.const	$21=, 24
	i32.add 	$21=, $31, $21
	i32.add 	$push38=, $21, $3
	i32.add 	$push15=, $6, $9
	i64.load8_u	$push16=, 0($pop15)
	i64.shl 	$push17=, $pop16, $7
	i32.add 	$push18=, $6, $10
	i64.load8_u	$push19=, 0($pop18)
	i64.or  	$push20=, $pop17, $pop19
	i64.shl 	$push21=, $pop20, $11
	i32.add 	$push9=, $6, $5
	i64.load8_u	$push10=, 0($pop9)
	i64.shl 	$push11=, $pop10, $7
	i32.add 	$push12=, $6, $8
	i64.load8_u	$push13=, 0($pop12)
	i64.or  	$push14=, $pop11, $pop13
	i64.or  	$push22=, $pop21, $pop14
	i64.shl 	$push23=, $pop22, $12
	i32.add 	$push24=, $6, $13
	i64.load8_u	$push25=, 0($pop24)
	i64.shl 	$push26=, $pop25, $7
	i32.add 	$push27=, $6, $14
	i64.load8_u	$push28=, 0($pop27)
	i64.or  	$push29=, $pop26, $pop28
	i64.shl 	$push30=, $pop29, $11
	i32.add 	$push31=, $6, $2
	i64.load8_u	$push32=, 0($pop31)
	i64.shl 	$push33=, $pop32, $7
	i64.load8_u	$push34=, .Lmain.x+8($0)
	i64.or  	$push35=, $pop33, $pop34
	i64.or  	$push36=, $pop30, $pop35
	i64.or  	$push37=, $pop23, $pop36
	i64.store	$discard=, 0($pop38), $pop37
	i32.const	$6=, .Lmain.x
	i32.const	$22=, 0
	i32.add 	$22=, $31, $22
	i32.add 	$push68=, $22, $1
	i32.store8	$1=, 0($pop68), $0
	i32.const	$23=, 0
	i32.add 	$23=, $31, $23
	i32.add 	$push69=, $23, $4
	i32.store16	$discard=, 0($pop69), $1
	i32.const	$24=, 0
	i32.add 	$24=, $31, $24
	i32.add 	$push70=, $24, $3
	i64.const	$push71=, 0
	i64.store	$15=, 0($pop70), $pop71
	i32.add 	$push45=, $6, $9
	i64.load8_u	$push46=, 0($pop45)
	i64.shl 	$push47=, $pop46, $7
	i32.add 	$push48=, $6, $10
	i64.load8_u	$push49=, 0($pop48)
	i64.or  	$push50=, $pop47, $pop49
	i64.shl 	$push51=, $pop50, $11
	i32.add 	$push39=, $6, $5
	i64.load8_u	$push40=, 0($pop39)
	i64.shl 	$push41=, $pop40, $7
	i32.add 	$push42=, $6, $8
	i64.load8_u	$push43=, 0($pop42)
	i64.or  	$push44=, $pop41, $pop43
	i64.or  	$push52=, $pop51, $pop44
	i64.shl 	$push53=, $pop52, $12
	i32.add 	$push54=, $6, $13
	i64.load8_u	$push55=, 0($pop54)
	i64.shl 	$push56=, $pop55, $7
	i32.add 	$push57=, $6, $14
	i64.load8_u	$push58=, 0($pop57)
	i64.or  	$push59=, $pop56, $pop58
	i64.shl 	$push60=, $pop59, $11
	i32.add 	$push61=, $6, $2
	i64.load8_u	$push62=, 0($pop61)
	i64.shl 	$push63=, $pop62, $7
	i64.load8_u	$push64=, .Lmain.x($0)
	i64.or  	$push65=, $pop63, $pop64
	i64.or  	$push66=, $pop60, $pop65
	i64.or  	$push67=, $pop53, $pop66
	i64.store	$discard=, 24($31), $pop67
	i64.store	$discard=, 0($31), $15
	i32.const	$25=, 24
	i32.add 	$25=, $31, $25
	i32.const	$26=, 0
	i32.add 	$26=, $31, $26
	call    	foo@FUNCTION, $25, $26
	i32.const	$27=, 0
	i32.add 	$27=, $31, $27
	block
	i32.or  	$push72=, $27, $13
	i32.load8_u	$push73=, 0($pop72)
	i32.const	$push74=, 170
	i32.ne  	$push75=, $pop73, $pop74
	br_if   	$pop75, 0       # 0: down to label3
# BB#1:                                 # %lor.lhs.false
	i32.const	$28=, 0
	i32.add 	$28=, $31, $28
	i32.or  	$push76=, $28, $8
	i32.load8_u	$push77=, 0($pop76)
	i32.const	$push78=, 187
	i32.ne  	$push79=, $pop77, $pop78
	br_if   	$pop79, 0       # 0: down to label3
# BB#2:                                 # %lor.lhs.false13
	i32.const	$29=, 0
	i32.add 	$29=, $31, $29
	i32.or  	$push80=, $29, $5
	i32.load8_u	$push81=, 0($pop80)
	i32.const	$push82=, 204
	i32.ne  	$push83=, $pop81, $pop82
	br_if   	$pop83, 0       # 0: down to label3
# BB#3:                                 # %lor.lhs.false22
	i32.const	$30=, 0
	i32.add 	$30=, $31, $30
	i32.or  	$push84=, $30, $10
	i32.load8_u	$push85=, 0($pop84)
	i32.const	$push86=, 128
	i32.ne  	$push87=, $pop85, $pop86
	br_if   	$pop87, 0       # 0: down to label3
# BB#4:                                 # %if.end
	i32.const	$18=, 48
	i32.add 	$31=, $31, $18
	i32.const	$18=, __stack_pointer
	i32.store	$31=, 0($18), $31
	return  	$1
.LBB1_5:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.Lmain.x,@object        # @main.x
	.section	.rodata..Lmain.x,"a",@progbits
.Lmain.x:
	.int8	0                       # 0x0
	.int8	25                      # 0x19
	.int8	0                       # 0x0
	.asciz	"\252\273\314\335\000\000\000\000\000\000\000\000\000\000\000"
	.size	.Lmain.x, 19


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
