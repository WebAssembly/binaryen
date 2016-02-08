	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920501-8.c"
	.section	.text.va,"ax",@progbits
	.hidden	va
	.globl	va
	.type	va,@function
va:                                     # @va
	.param  	i32, f64, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$20=, __stack_pointer
	i32.load	$20=, 0($20)
	i32.const	$21=, 80
	i32.sub 	$23=, $20, $21
	copy_local	$24=, $23
	i32.const	$21=, __stack_pointer
	i32.store	$23=, 0($21), $23
	i32.store	$push0=, 76($23), $24
	i32.const	$push1=, 3
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -4
	i32.and 	$push4=, $pop2, $pop3
	tee_local	$push108=, $15=, $pop4
	i32.const	$push5=, 4
	i32.add 	$push6=, $pop108, $pop5
	i32.store	$discard=, 76($23), $pop6
	i32.load	$3=, 0($15)
	i32.const	$push7=, 7
	i32.add 	$push8=, $15, $pop7
	i32.const	$push107=, -4
	i32.and 	$push9=, $pop8, $pop107
	tee_local	$push106=, $15=, $pop9
	i32.const	$push105=, 4
	i32.add 	$push10=, $pop106, $pop105
	i32.store	$discard=, 76($23), $pop10
	i32.load	$4=, 0($15)
	i32.const	$push104=, 7
	i32.add 	$push11=, $15, $pop104
	i32.const	$push103=, -4
	i32.and 	$push12=, $pop11, $pop103
	tee_local	$push102=, $15=, $pop12
	i32.const	$push101=, 4
	i32.add 	$push13=, $pop102, $pop101
	i32.store	$discard=, 76($23), $pop13
	i32.load	$5=, 0($15)
	i32.const	$push100=, 7
	i32.add 	$push14=, $15, $pop100
	i32.const	$push99=, -4
	i32.and 	$push15=, $pop14, $pop99
	tee_local	$push98=, $15=, $pop15
	i32.const	$push97=, 4
	i32.add 	$push16=, $pop98, $pop97
	i32.store	$discard=, 76($23), $pop16
	i32.load	$6=, 0($15)
	i32.const	$push96=, 7
	i32.add 	$push17=, $15, $pop96
	i32.const	$push95=, -4
	i32.and 	$push18=, $pop17, $pop95
	tee_local	$push94=, $15=, $pop18
	i32.const	$push93=, 4
	i32.add 	$push19=, $pop94, $pop93
	i32.store	$discard=, 76($23), $pop19
	i32.load	$7=, 0($15)
	i32.const	$push92=, 7
	i32.add 	$push20=, $15, $pop92
	i32.const	$push91=, -4
	i32.and 	$push21=, $pop20, $pop91
	tee_local	$push90=, $15=, $pop21
	i32.const	$push89=, 4
	i32.add 	$push22=, $pop90, $pop89
	i32.store	$discard=, 76($23), $pop22
	i32.load	$8=, 0($15)
	i32.const	$push88=, 7
	i32.add 	$push23=, $15, $pop88
	i32.const	$push87=, -4
	i32.and 	$push24=, $pop23, $pop87
	tee_local	$push86=, $15=, $pop24
	i32.const	$push85=, 4
	i32.add 	$push25=, $pop86, $pop85
	i32.store	$discard=, 76($23), $pop25
	i32.load	$9=, 0($15)
	i32.const	$push84=, 7
	i32.add 	$push26=, $15, $pop84
	i32.const	$push83=, -4
	i32.and 	$push27=, $pop26, $pop83
	tee_local	$push82=, $15=, $pop27
	i32.const	$push81=, 4
	i32.add 	$push28=, $pop82, $pop81
	i32.store	$discard=, 76($23), $pop28
	i32.load	$10=, 0($15)
	i32.const	$push80=, 7
	i32.add 	$push29=, $15, $pop80
	i32.const	$push79=, -4
	i32.and 	$push30=, $pop29, $pop79
	tee_local	$push78=, $15=, $pop30
	i32.const	$push77=, 4
	i32.add 	$push31=, $pop78, $pop77
	i32.store	$discard=, 76($23), $pop31
	i32.load	$11=, 0($15)
	i32.const	$push76=, 7
	i32.add 	$push32=, $15, $pop76
	i32.const	$push75=, -4
	i32.and 	$push33=, $pop32, $pop75
	tee_local	$push74=, $15=, $pop33
	i32.const	$push73=, 4
	i32.add 	$push34=, $pop74, $pop73
	i32.store	$discard=, 76($23), $pop34
	i32.load	$12=, 0($15)
	i32.const	$push72=, 7
	i32.add 	$push35=, $15, $pop72
	i32.const	$push71=, -4
	i32.and 	$push36=, $pop35, $pop71
	tee_local	$push70=, $15=, $pop36
	i32.const	$push69=, 4
	i32.add 	$push37=, $pop70, $pop69
	i32.store	$discard=, 76($23), $pop37
	i32.load	$13=, 0($15)
	i32.const	$push68=, 7
	i32.add 	$push38=, $15, $pop68
	i32.const	$push67=, -4
	i32.and 	$push39=, $pop38, $pop67
	tee_local	$push66=, $15=, $pop39
	i32.const	$push65=, 4
	i32.add 	$push40=, $pop66, $pop65
	i32.store	$discard=, 76($23), $pop40
	i32.load	$14=, 0($15)
	i32.const	$push64=, 7
	i32.add 	$push41=, $15, $pop64
	i32.const	$push63=, -4
	i32.and 	$push42=, $pop41, $pop63
	tee_local	$push62=, $15=, $pop42
	i32.const	$push61=, 4
	i32.add 	$push43=, $pop62, $pop61
	i32.store	$discard=, 76($23), $pop43
	i32.load	$15=, 0($15)
	i32.const	$16=, __stack_pointer
	i32.load	$16=, 0($16)
	i32.const	$17=, 72
	i32.sub 	$23=, $16, $17
	i32.const	$17=, __stack_pointer
	i32.store	$23=, 0($17), $23
	i32.store	$discard=, 0($23), $0
	i32.const	$push44=, 68
	i32.add 	$0=, $23, $pop44
	i32.store	$discard=, 0($0), $15
	i32.const	$push45=, 64
	i32.add 	$15=, $23, $pop45
	i32.store	$discard=, 0($15), $14
	i32.const	$push46=, 60
	i32.add 	$15=, $23, $pop46
	i32.store	$discard=, 0($15), $13
	i32.const	$push47=, 56
	i32.add 	$15=, $23, $pop47
	i32.store	$discard=, 0($15), $12
	i32.const	$push48=, 52
	i32.add 	$15=, $23, $pop48
	i32.store	$discard=, 0($15), $11
	i32.const	$push49=, 48
	i32.add 	$15=, $23, $pop49
	i32.store	$discard=, 0($15), $10
	i32.const	$push50=, 44
	i32.add 	$15=, $23, $pop50
	i32.store	$discard=, 0($15), $9
	i32.const	$push51=, 40
	i32.add 	$15=, $23, $pop51
	i32.store	$discard=, 0($15), $8
	i32.const	$push52=, 36
	i32.add 	$15=, $23, $pop52
	i32.store	$discard=, 0($15), $7
	i32.const	$push53=, 32
	i32.add 	$15=, $23, $pop53
	i32.store	$discard=, 0($15), $6
	i32.const	$push54=, 28
	i32.add 	$15=, $23, $pop54
	i32.store	$discard=, 0($15), $5
	i32.const	$push55=, 24
	i32.add 	$15=, $23, $pop55
	i32.store	$discard=, 0($15), $4
	i32.const	$push56=, 20
	i32.add 	$15=, $23, $pop56
	i32.store	$discard=, 0($15), $3
	i32.const	$push57=, 16
	i32.add 	$15=, $23, $pop57
	i32.store	$discard=, 0($15), $2
	i32.const	$push58=, 8
	i32.add 	$15=, $23, $pop58
	f64.store	$discard=, 0($15), $1
	i32.const	$push60=, buf
	i32.const	$push59=, .L.str
	i32.call	$discard=, sprintf@FUNCTION, $pop60, $pop59
	i32.const	$18=, __stack_pointer
	i32.load	$18=, 0($18)
	i32.const	$19=, 72
	i32.add 	$23=, $18, $19
	i32.const	$19=, __stack_pointer
	i32.store	$23=, 0($19), $23
	i32.const	$22=, 80
	i32.add 	$23=, $24, $22
	i32.const	$22=, __stack_pointer
	i32.store	$23=, 0($22), $23
	return  	$15
	.endfunc
.Lfunc_end0:
	.size	va, .Lfunc_end0-va

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 64
	i32.sub 	$7=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$7=, 0($6), $7
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 52
	i32.sub 	$7=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$7=, 0($2), $7
	i64.const	$push0=, 17179869187
	i64.store	$discard=, 0($7):p2align=2, $pop0
	i32.const	$push1=, 48
	i32.add 	$0=, $7, $pop1
	i32.const	$push2=, 15
	i32.store	$discard=, 0($0), $pop2
	i32.const	$push3=, 40
	i32.add 	$0=, $7, $pop3
	i64.const	$push4=, 60129542157
	i64.store	$discard=, 0($0):p2align=2, $pop4
	i32.const	$push5=, 32
	i32.add 	$0=, $7, $pop5
	i64.const	$push6=, 51539607563
	i64.store	$discard=, 0($0):p2align=2, $pop6
	i32.const	$push7=, 24
	i32.add 	$0=, $7, $pop7
	i64.const	$push8=, 42949672969
	i64.store	$discard=, 0($0):p2align=2, $pop8
	i32.const	$push9=, 16
	i32.add 	$0=, $7, $pop9
	i64.const	$push10=, 34359738375
	i64.store	$discard=, 0($0):p2align=2, $pop10
	i32.const	$push11=, 8
	i32.add 	$0=, $7, $pop11
	i64.const	$push12=, 25769803781
	i64.store	$discard=, 0($0):p2align=2, $pop12
	i32.const	$push15=, 1
	f64.const	$push14=, 0x1p0
	i32.const	$push13=, 2
	i32.call	$discard=, va@FUNCTION, $pop15, $pop14, $pop13
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 52
	i32.add 	$7=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$7=, 0($4), $7
	i32.const	$push17=, .L.str.1
	i32.const	$push16=, buf
	i32.call	$0=, strcmp@FUNCTION, $pop17, $pop16
	block
	br_if   	0, $0           # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push18=, 0
	call    	exit@FUNCTION, $pop18
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	buf                     # @buf
	.type	buf,@object
	.section	.bss.buf,"aw",@nobits
	.globl	buf
	.p2align	4
buf:
	.skip	50
	.size	buf, 50

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%d,%f,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d"
	.size	.L.str, 48

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"1,1.000000,2,3,4,5,6,7,8,9,10,11,12,13,14,15"
	.size	.L.str.1, 45


	.ident	"clang version 3.9.0 "
