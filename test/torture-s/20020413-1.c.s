	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020413-1.c"
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i64, i64, i32
	.local  	i64, i32, i32, i64, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$9=, __stack_pointer
	i32.load	$9=, 0($9)
	i32.const	$10=, 16
	i32.sub 	$11=, $9, $10
	i32.const	$10=, __stack_pointer
	i32.store	$11=, 0($10), $11
	i64.const	$3=, 0
	i32.call	$4=, __lttf2, $0, $1, $3, $3
	i32.const	$8=, 0
	i32.lt_s	$4=, $4, $8
	i64.const	$push0=, -9223372036854775808
	i32.const	$12=, 0
	i32.add 	$12=, $11, $12
	call    	__subtf3, $12, $3, $pop0, $0, $1
	i32.const	$5=, 8
	i32.const	$13=, 0
	i32.add 	$13=, $11, $13
	i32.add 	$push1=, $13, $5
	i64.load	$push2=, 0($pop1)
	i64.select	$1=, $4, $pop2, $1
	i64.load	$push3=, 0($11)
	i64.select	$0=, $4, $pop3, $0
	i64.const	$6=, 4611404543450677248
	block   	.LBB0_26
	block   	.LBB0_14
	i32.call	$push4=, __getf2, $0, $1, $3, $6
	i32.ge_s	$push5=, $pop4, $8
	br_if   	$pop5, .LBB0_14
# BB#1:                                 # %if.else
	i32.call	$push35=, __eqtf2, $0, $1, $3, $3
	i32.const	$push66=, 0
	i32.eq  	$push67=, $pop35, $pop66
	br_if   	$pop67, .LBB0_26
# BB#2:                                 # %if.else
	i32.call	$7=, __lttf2, $0, $1, $3, $6
	i32.const	$4=, -1
	i32.gt_s	$push36=, $7, $4
	br_if   	$pop36, .LBB0_26
# BB#3:                                 # %while.body12
	i64.const	$push37=, 4611123068473966592
	i32.call	$7=, __lttf2, $0, $1, $3, $pop37
	i32.const	$8=, 1
	i32.const	$push38=, 0
	i32.ge_s	$push39=, $7, $pop38
	br_if   	$pop39, .LBB0_26
# BB#4:                                 # %while.body12.1
	i32.const	$8=, 2
	i64.const	$push40=, 4610841593497255936
	i32.call	$push41=, __lttf2, $0, $1, $3, $pop40
	i32.gt_s	$push42=, $pop41, $4
	br_if   	$pop42, .LBB0_26
# BB#5:                                 # %while.body12.2
	i32.const	$8=, 3
	i64.const	$push43=, 4610560118520545280
	i32.call	$push44=, __lttf2, $0, $1, $3, $pop43
	i32.gt_s	$push45=, $pop44, $4
	br_if   	$pop45, .LBB0_26
# BB#6:                                 # %while.body12.3
	i32.const	$8=, 4
	i64.const	$push46=, 4610278643543834624
	i32.call	$push47=, __lttf2, $0, $1, $3, $pop46
	i32.gt_s	$push48=, $pop47, $4
	br_if   	$pop48, .LBB0_26
# BB#7:                                 # %while.body12.4
	i32.const	$8=, 5
	i64.const	$push49=, 4609997168567123968
	i32.call	$push50=, __lttf2, $0, $1, $3, $pop49
	i32.gt_s	$push51=, $pop50, $4
	br_if   	$pop51, .LBB0_26
# BB#8:                                 # %while.body12.5
	i32.const	$8=, 6
	i64.const	$push52=, 4609715693590413312
	i32.call	$push53=, __lttf2, $0, $1, $3, $pop52
	i32.gt_s	$push54=, $pop53, $4
	br_if   	$pop54, .LBB0_26
# BB#9:                                 # %while.body12.6
	i32.const	$8=, 7
	i64.const	$push55=, 4609434218613702656
	i32.call	$push56=, __lttf2, $0, $1, $3, $pop55
	i32.gt_s	$push57=, $pop56, $4
	br_if   	$pop57, .LBB0_26
# BB#10:                                # %while.body12.7
	i64.const	$push58=, 4609152743636992000
	i32.call	$7=, __lttf2, $0, $1, $3, $pop58
	copy_local	$8=, $5
	i32.gt_s	$push59=, $7, $4
	br_if   	$pop59, .LBB0_26
# BB#11:                                # %while.body12.8
	i32.const	$8=, 9
	i64.const	$push60=, 4608871268660281344
	i32.call	$push61=, __lttf2, $0, $1, $3, $pop60
	i32.gt_s	$push62=, $pop61, $4
	br_if   	$pop62, .LBB0_26
# BB#12:                                # %while.body12.9
	i32.const	$8=, 10
	i64.const	$push63=, 4608589793683570688
	i32.call	$push64=, __lttf2, $0, $1, $3, $pop63
	i32.gt_s	$push65=, $pop64, $4
	br_if   	$pop65, .LBB0_26
# BB#13:                                # %while.body12.10
	call    	abort
	unreachable
.LBB0_14:                                 # %while.cond.preheader
	i32.call	$7=, __gttf2, $0, $1, $3, $6
	i32.const	$4=, 1
	i32.lt_s	$push6=, $7, $4
	br_if   	$pop6, .LBB0_26
# BB#15:                                # %while.body
	i64.const	$push7=, 4611686018427387904
	i32.call	$7=, __gttf2, $0, $1, $3, $pop7
	copy_local	$8=, $4
	i32.const	$push8=, 0
	i32.le_s	$push9=, $7, $pop8
	br_if   	$pop9, .LBB0_26
# BB#16:                                # %while.body.1
	i32.const	$8=, 2
	i64.const	$push10=, 4611967493404098560
	i32.call	$7=, __gttf2, $0, $1, $3, $pop10
	i32.const	$4=, 1
	i32.lt_s	$push11=, $7, $4
	br_if   	$pop11, .LBB0_26
# BB#17:                                # %while.body.2
	i32.const	$8=, 3
	i64.const	$push12=, 4612248968380809216
	i32.call	$push13=, __gttf2, $0, $1, $3, $pop12
	i32.lt_s	$push14=, $pop13, $4
	br_if   	$pop14, .LBB0_26
# BB#18:                                # %while.body.3
	i32.const	$8=, 4
	i64.const	$push15=, 4612530443357519872
	i32.call	$push16=, __gttf2, $0, $1, $3, $pop15
	i32.lt_s	$push17=, $pop16, $4
	br_if   	$pop17, .LBB0_26
# BB#19:                                # %while.body.4
	i32.const	$8=, 5
	i64.const	$push18=, 4612811918334230528
	i32.call	$push19=, __gttf2, $0, $1, $3, $pop18
	i32.lt_s	$push20=, $pop19, $4
	br_if   	$pop20, .LBB0_26
# BB#20:                                # %while.body.5
	i32.const	$8=, 6
	i64.const	$push21=, 4613093393310941184
	i32.call	$push22=, __gttf2, $0, $1, $3, $pop21
	i32.lt_s	$push23=, $pop22, $4
	br_if   	$pop23, .LBB0_26
# BB#21:                                # %while.body.6
	i32.const	$8=, 7
	i64.const	$push24=, 4613374868287651840
	i32.call	$push25=, __gttf2, $0, $1, $3, $pop24
	i32.lt_s	$push26=, $pop25, $4
	br_if   	$pop26, .LBB0_26
# BB#22:                                # %while.body.7
	i64.const	$push27=, 4613656343264362496
	i32.call	$7=, __gttf2, $0, $1, $3, $pop27
	copy_local	$8=, $5
	i32.lt_s	$push28=, $7, $4
	br_if   	$pop28, .LBB0_26
# BB#23:                                # %while.body.8
	i32.const	$8=, 9
	i64.const	$push29=, 4613937818241073152
	i32.call	$push30=, __gttf2, $0, $1, $3, $pop29
	i32.lt_s	$push31=, $pop30, $4
	br_if   	$pop31, .LBB0_26
# BB#24:                                # %while.body.9
	i32.const	$8=, 10
	i64.const	$push32=, 4614219293217783808
	i32.call	$push33=, __gttf2, $0, $1, $3, $pop32
	i32.lt_s	$push34=, $pop33, $4
	br_if   	$pop34, .LBB0_26
# BB#25:                                # %while.body.10
	call    	abort
	unreachable
.LBB0_26:                                 # %if.end19
	i32.store	$discard=, 0($2), $8
	i32.const	$11=, 16
	i32.add 	$11=, $11, $11
	i32.const	$11=, __stack_pointer
	i32.store	$11=, 0($11), $11
	return
.Lfunc_end0:
	.size	test, .Lfunc_end0-test

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$7=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$7=, 0($2), $7
	i64.const	$0=, 0
	i64.const	$push0=, 4611826755915743232
	i32.const	$3=, 12
	i32.add 	$3=, $7, $3
	call    	test, $0, $pop0, $3
	i64.const	$push1=, 4611897124659920896
	i32.const	$4=, 12
	i32.add 	$4=, $7, $4
	call    	test, $0, $pop1, $4
	i64.const	$push2=, 4611967493404098560
	i32.const	$5=, 12
	i32.add 	$5=, $7, $5
	call    	test, $0, $pop2, $5
	i64.const	$push3=, 4612037862148276224
	i32.const	$6=, 12
	i32.add 	$6=, $7, $6
	call    	test, $0, $pop3, $6
	i32.const	$push4=, 0
	call    	exit, $pop4
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
