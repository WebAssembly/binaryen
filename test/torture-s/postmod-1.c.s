	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/postmod-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32, i32, i32, i32, i32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push6=, 2
	i32.shl 	$push43=, $0, $pop6
	tee_local	$push42=, $26=, $pop43
	i32.const	$push7=, array0
	i32.add 	$25=, $pop42, $pop7
	i32.const	$push8=, array1
	i32.add 	$24=, $26, $pop8
	i32.const	$push9=, array2
	i32.add 	$23=, $26, $pop9
	i32.const	$push10=, array3
	i32.add 	$22=, $26, $pop10
	i32.const	$push11=, array4
	i32.add 	$21=, $26, $pop11
	i32.const	$push41=, 0
	f32.load	$19=, counter0($pop41)
	i32.const	$push40=, 0
	f32.load	$18=, counter1($pop40)
	i32.const	$push39=, 0
	f32.load	$17=, counter2($pop39)
	i32.const	$push38=, 0
	f32.load	$16=, counter3($pop38)
	i32.const	$push37=, 0
	f32.load	$15=, counter4($pop37)
	i32.const	$push36=, 0
	f32.load	$14=, counter5($pop36)
	i32.const	$push12=, array5
	i32.add 	$20=, $26, $pop12
.LBB0_1:                                # %do.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
	loop                            # label0:
	f32.load	$6=, 0($25)
	f32.load	$7=, 0($24)
	f32.load	$8=, 0($23)
	f32.load	$9=, 0($22)
	f32.load	$10=, 0($21)
	f32.load	$11=, 0($20)
	i32.const	$push66=, 12
	i32.add 	$25=, $25, $pop66
	i32.const	$push65=, 12
	i32.add 	$24=, $24, $pop65
	i32.add 	$push19=, $25, $26
	f32.load	$12=, 0($pop19)
	i32.add 	$push20=, $24, $26
	f32.load	$13=, 0($pop20)
	i32.const	$push64=, 0
	f32.add 	$push13=, $6, $19
	f32.store	$19=, counter0($pop64), $pop13
	i32.const	$push63=, 0
	f32.add 	$push14=, $7, $18
	f32.store	$18=, counter1($pop63), $pop14
	i32.const	$push62=, 12
	i32.add 	$23=, $23, $pop62
	i32.const	$push61=, 12
	i32.add 	$22=, $22, $pop61
	i32.add 	$push21=, $23, $26
	f32.load	$6=, 0($pop21)
	i32.add 	$push22=, $22, $26
	f32.load	$7=, 0($pop22)
	i32.const	$push60=, 0
	f32.add 	$push15=, $8, $17
	f32.store	$17=, counter2($pop60), $pop15
	i32.const	$push59=, 0
	f32.add 	$push16=, $9, $16
	f32.store	$16=, counter3($pop59), $pop16
	i32.const	$push58=, 12
	i32.add 	$21=, $21, $pop58
	i32.const	$push57=, 12
	i32.add 	$20=, $20, $pop57
	i32.add 	$push23=, $21, $26
	f32.load	$8=, 0($pop23)
	i32.add 	$push24=, $20, $26
	f32.load	$9=, 0($pop24)
	i32.const	$push56=, 0
	f32.add 	$push17=, $10, $15
	f32.store	$15=, counter4($pop56), $pop17
	i32.const	$push55=, 0
	f32.add 	$push18=, $11, $14
	f32.store	$14=, counter5($pop55), $pop18
	i32.const	$push54=, 0
	f32.add 	$push0=, $12, $19
	f32.store	$19=, counter0($pop54), $pop0
	i32.const	$push53=, 0
	f32.add 	$push1=, $13, $18
	f32.store	$18=, counter1($pop53), $pop1
	i32.const	$push52=, 0
	f32.add 	$push2=, $6, $17
	f32.store	$17=, counter2($pop52), $pop2
	i32.const	$push51=, 0
	f32.add 	$push3=, $7, $16
	f32.store	$16=, counter3($pop51), $pop3
	i32.const	$push50=, 0
	f32.add 	$push4=, $8, $15
	f32.store	$15=, counter4($pop50), $pop4
	i32.const	$push49=, 0
	f32.add 	$push5=, $9, $14
	f32.store	$14=, counter5($pop49), $pop5
	i32.const	$push48=, 0
	i32.load	$1=, vol($pop48)
	i32.const	$push47=, 0
	i32.load	$2=, vol($pop47)
	i32.const	$push46=, 0
	i32.load	$3=, vol($pop46)
	i32.const	$push45=, 0
	i32.load	$4=, vol($pop45)
	i32.const	$push44=, 0
	i32.load	$5=, vol($pop44)
	i32.const	$0=, 10
.LBB0_2:                                # %for.body
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label2:
	i32.const	$push77=, 0
	i32.const	$push76=, 0
	i32.load	$push25=, vol($pop76)
	i32.add 	$push26=, $pop25, $1
	i32.store	$discard=, vol($pop77), $pop26
	i32.const	$push75=, 0
	i32.const	$push74=, 0
	i32.load	$push27=, vol($pop74)
	i32.add 	$push28=, $pop27, $2
	i32.store	$discard=, vol($pop75), $pop28
	i32.const	$push73=, 0
	i32.const	$push72=, 0
	i32.load	$push29=, vol($pop72)
	i32.add 	$push30=, $pop29, $3
	i32.store	$discard=, vol($pop73), $pop30
	i32.const	$push71=, 0
	i32.const	$push70=, 0
	i32.load	$push31=, vol($pop70)
	i32.add 	$push32=, $pop31, $4
	i32.store	$discard=, vol($pop71), $pop32
	i32.const	$push69=, 0
	i32.const	$push68=, 0
	i32.load	$push33=, vol($pop68)
	i32.add 	$push34=, $pop33, $5
	i32.store	$discard=, vol($pop69), $pop34
	i32.const	$push67=, -1
	i32.add 	$0=, $0, $pop67
	br_if   	0, $0           # 0: up to label2
# BB#3:                                 # %for.end
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label3:
	i32.const	$push78=, 0
	i32.load	$push35=, stop($pop78)
	i32.const	$push79=, 0
	i32.eq  	$push80=, $pop35, $pop79
	br_if   	0, $pop80       # 0: up to label0
# BB#4:                                 # %do.end
	end_loop                        # label1:
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
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push53=, 0
	i32.const	$push52=, 0
	i32.const	$push51=, 0
	i32.const	$push50=, 0
	i32.const	$push49=, 0
	i32.const	$push1=, 1065353216
	i32.store	$push2=, array0+4($pop49), $pop1
	i32.store	$push5=, array1+4($pop50), $pop2
	i32.store	$push7=, array2+4($pop51), $pop5
	i32.store	$push9=, array3+4($pop52), $pop7
	i32.store	$push11=, array4+4($pop53), $pop9
	i32.store	$discard=, array5+4($pop0), $pop11
	i32.const	$push48=, 0
	i32.const	$push47=, 0
	i32.const	$push46=, 0
	i32.const	$push45=, 0
	i32.const	$push44=, 0
	i32.const	$push43=, 0
	i32.const	$push3=, 1073741824
	i32.store	$push4=, array0+20($pop43), $pop3
	i32.store	$push6=, array1+20($pop44), $pop4
	i32.store	$push8=, array2+20($pop45), $pop6
	i32.store	$push10=, array3+20($pop46), $pop8
	i32.store	$push12=, array4+20($pop47), $pop10
	i32.store	$discard=, array5+20($pop48), $pop12
	i32.const	$push13=, 1
	call    	foo@FUNCTION, $pop13
	i32.const	$push42=, 0
	f32.load	$push14=, counter0($pop42)
	f32.const	$push15=, 0x1.8p1
	f32.ne  	$push16=, $pop14, $pop15
	i32.const	$push41=, 0
	f32.load	$push17=, counter1($pop41)
	f32.const	$push40=, 0x1.8p1
	f32.ne  	$push18=, $pop17, $pop40
	i32.or  	$push19=, $pop16, $pop18
	i32.const	$push39=, 0
	f32.load	$push20=, counter2($pop39)
	f32.const	$push38=, 0x1.8p1
	f32.ne  	$push21=, $pop20, $pop38
	i32.or  	$push22=, $pop19, $pop21
	i32.const	$push37=, 0
	f32.load	$push23=, counter3($pop37)
	f32.const	$push36=, 0x1.8p1
	f32.ne  	$push24=, $pop23, $pop36
	i32.or  	$push25=, $pop22, $pop24
	i32.const	$push35=, 0
	f32.load	$push26=, counter4($pop35)
	f32.const	$push34=, 0x1.8p1
	f32.ne  	$push27=, $pop26, $pop34
	i32.or  	$push28=, $pop25, $pop27
	i32.const	$push33=, 0
	f32.load	$push29=, counter5($pop33)
	f32.const	$push32=, 0x1.8p1
	f32.ne  	$push30=, $pop29, $pop32
	i32.or  	$push31=, $pop28, $pop30
	return  	$pop31
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	counter0                # @counter0
	.type	counter0,@object
	.section	.bss.counter0,"aw",@nobits
	.globl	counter0
	.p2align	2
counter0:
	.int32	0                       # float 0
	.size	counter0, 4

	.hidden	counter1                # @counter1
	.type	counter1,@object
	.section	.bss.counter1,"aw",@nobits
	.globl	counter1
	.p2align	2
counter1:
	.int32	0                       # float 0
	.size	counter1, 4

	.hidden	counter2                # @counter2
	.type	counter2,@object
	.section	.bss.counter2,"aw",@nobits
	.globl	counter2
	.p2align	2
counter2:
	.int32	0                       # float 0
	.size	counter2, 4

	.hidden	counter3                # @counter3
	.type	counter3,@object
	.section	.bss.counter3,"aw",@nobits
	.globl	counter3
	.p2align	2
counter3:
	.int32	0                       # float 0
	.size	counter3, 4

	.hidden	counter4                # @counter4
	.type	counter4,@object
	.section	.bss.counter4,"aw",@nobits
	.globl	counter4
	.p2align	2
counter4:
	.int32	0                       # float 0
	.size	counter4, 4

	.hidden	counter5                # @counter5
	.type	counter5,@object
	.section	.bss.counter5,"aw",@nobits
	.globl	counter5
	.p2align	2
counter5:
	.int32	0                       # float 0
	.size	counter5, 4

	.hidden	stop                    # @stop
	.type	stop,@object
	.section	.data.stop,"aw",@progbits
	.globl	stop
	.p2align	2
stop:
	.int32	1                       # 0x1
	.size	stop, 4

	.hidden	array0                  # @array0
	.type	array0,@object
	.section	.bss.array0,"aw",@nobits
	.globl	array0
	.p2align	4
array0:
	.skip	64
	.size	array0, 64

	.hidden	array1                  # @array1
	.type	array1,@object
	.section	.bss.array1,"aw",@nobits
	.globl	array1
	.p2align	4
array1:
	.skip	64
	.size	array1, 64

	.hidden	array2                  # @array2
	.type	array2,@object
	.section	.bss.array2,"aw",@nobits
	.globl	array2
	.p2align	4
array2:
	.skip	64
	.size	array2, 64

	.hidden	array3                  # @array3
	.type	array3,@object
	.section	.bss.array3,"aw",@nobits
	.globl	array3
	.p2align	4
array3:
	.skip	64
	.size	array3, 64

	.hidden	array4                  # @array4
	.type	array4,@object
	.section	.bss.array4,"aw",@nobits
	.globl	array4
	.p2align	4
array4:
	.skip	64
	.size	array4, 64

	.hidden	array5                  # @array5
	.type	array5,@object
	.section	.bss.array5,"aw",@nobits
	.globl	array5
	.p2align	4
array5:
	.skip	64
	.size	array5, 64

	.hidden	vol                     # @vol
	.type	vol,@object
	.section	.bss.vol,"aw",@nobits
	.globl	vol
	.p2align	2
vol:
	.int32	0                       # 0x0
	.size	vol, 4


	.ident	"clang version 3.9.0 "
