	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/postmod-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32, i32, i32, i32, i32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	tee_local	$push47=, $24=, $pop1
	i32.const	$push2=, array0
	i32.add 	$23=, $pop47, $pop2
	i32.const	$push3=, array1
	i32.add 	$22=, $24, $pop3
	i32.const	$push4=, array2
	i32.add 	$21=, $24, $pop4
	i32.const	$push5=, array3
	i32.add 	$20=, $24, $pop5
	i32.const	$push6=, array4
	i32.add 	$19=, $24, $pop6
	i32.const	$push7=, array5
	i32.add 	$18=, $24, $pop7
.LBB0_1:                                # %do.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
	loop                            # label0:
	f32.load	$6=, 0($23)
	f32.load	$7=, 0($22)
	i32.const	$push76=, 0
	f32.load	$8=, counter1($pop76)
	f32.load	$9=, 0($21)
	i32.const	$push75=, 0
	f32.load	$10=, counter2($pop75)
	f32.load	$11=, 0($20)
	i32.const	$push74=, 0
	f32.load	$12=, counter3($pop74)
	f32.load	$13=, 0($19)
	i32.const	$push73=, 0
	f32.load	$14=, counter4($pop73)
	f32.load	$15=, 0($18)
	i32.const	$push72=, 0
	f32.load	$16=, counter5($pop72)
	i32.const	$push71=, 12
	i32.add 	$23=, $23, $pop71
	i32.const	$push70=, 12
	i32.add 	$22=, $22, $pop70
	i32.add 	$push24=, $22, $24
	f32.load	$17=, 0($pop24)
	i32.const	$push69=, 0
	i32.add 	$push21=, $23, $24
	f32.load	$push22=, 0($pop21)
	i32.const	$push68=, 0
	i32.const	$push67=, 0
	f32.load	$push8=, counter0($pop67)
	f32.add 	$push9=, $6, $pop8
	f32.store	$push10=, counter0($pop68), $pop9
	f32.add 	$push23=, $pop22, $pop10
	f32.store	$discard=, counter0($pop69), $pop23
	i32.const	$push66=, 0
	i32.const	$push65=, 0
	f32.add 	$push11=, $7, $8
	f32.store	$push12=, counter1($pop65), $pop11
	f32.add 	$push25=, $17, $pop12
	f32.store	$discard=, counter1($pop66), $pop25
	i32.const	$push64=, 12
	i32.add 	$21=, $21, $pop64
	i32.const	$push63=, 12
	i32.add 	$20=, $20, $pop63
	i32.add 	$push29=, $20, $24
	f32.load	$6=, 0($pop29)
	i32.const	$push62=, 0
	i32.add 	$push26=, $21, $24
	f32.load	$push27=, 0($pop26)
	i32.const	$push61=, 0
	f32.add 	$push13=, $9, $10
	f32.store	$push14=, counter2($pop61), $pop13
	f32.add 	$push28=, $pop27, $pop14
	f32.store	$discard=, counter2($pop62), $pop28
	i32.const	$push60=, 0
	i32.const	$push59=, 0
	f32.add 	$push15=, $11, $12
	f32.store	$push16=, counter3($pop59), $pop15
	f32.add 	$push30=, $6, $pop16
	f32.store	$discard=, counter3($pop60), $pop30
	i32.const	$push58=, 12
	i32.add 	$19=, $19, $pop58
	i32.const	$push57=, 12
	i32.add 	$18=, $18, $pop57
	i32.add 	$push34=, $18, $24
	f32.load	$6=, 0($pop34)
	i32.const	$push56=, 0
	i32.add 	$push31=, $19, $24
	f32.load	$push32=, 0($pop31)
	i32.const	$push55=, 0
	f32.add 	$push17=, $13, $14
	f32.store	$push18=, counter4($pop55), $pop17
	f32.add 	$push33=, $pop32, $pop18
	f32.store	$discard=, counter4($pop56), $pop33
	i32.const	$push54=, 0
	i32.const	$push53=, 0
	f32.add 	$push19=, $15, $16
	f32.store	$push20=, counter5($pop53), $pop19
	f32.add 	$push35=, $6, $pop20
	f32.store	$discard=, counter5($pop54), $pop35
	i32.const	$push52=, 0
	i32.load	$1=, vol($pop52)
	i32.const	$push51=, 0
	i32.load	$2=, vol($pop51)
	i32.const	$push50=, 0
	i32.load	$3=, vol($pop50)
	i32.const	$push49=, 0
	i32.load	$4=, vol($pop49)
	i32.const	$push48=, 0
	i32.load	$5=, vol($pop48)
	i32.const	$0=, 10
.LBB0_2:                                # %for.body
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label2:
	i32.const	$push87=, 0
	i32.const	$push86=, 0
	i32.load	$push36=, vol($pop86)
	i32.add 	$push37=, $pop36, $1
	i32.store	$discard=, vol($pop87), $pop37
	i32.const	$push85=, 0
	i32.const	$push84=, 0
	i32.load	$push38=, vol($pop84)
	i32.add 	$push39=, $pop38, $2
	i32.store	$discard=, vol($pop85), $pop39
	i32.const	$push83=, 0
	i32.const	$push82=, 0
	i32.load	$push40=, vol($pop82)
	i32.add 	$push41=, $pop40, $3
	i32.store	$discard=, vol($pop83), $pop41
	i32.const	$push81=, 0
	i32.const	$push80=, 0
	i32.load	$push42=, vol($pop80)
	i32.add 	$push43=, $pop42, $4
	i32.store	$discard=, vol($pop81), $pop43
	i32.const	$push79=, 0
	i32.const	$push78=, 0
	i32.load	$push44=, vol($pop78)
	i32.add 	$push45=, $pop44, $5
	i32.store	$discard=, vol($pop79), $pop45
	i32.const	$push77=, -1
	i32.add 	$0=, $0, $pop77
	br_if   	0, $0           # 0: up to label2
# BB#3:                                 # %for.end
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label3:
	i32.const	$push88=, 0
	i32.load	$push46=, stop($pop88)
	i32.const	$push89=, 0
	i32.eq  	$push90=, $pop46, $pop89
	br_if   	0, $pop90       # 0: up to label0
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
