	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/postmod-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	i32.shl 	$6=, $0, $pop0
	i32.const	$push1=, array0
	i32.add 	$24=, $pop1, $6
	i32.const	$push2=, array1
	i32.add 	$23=, $pop2, $6
	i32.const	$push3=, array2
	i32.add 	$22=, $pop3, $6
	i32.const	$push4=, array3
	i32.add 	$21=, $pop4, $6
	i32.const	$push5=, array4
	i32.add 	$20=, $pop5, $6
	i32.const	$push6=, array5
	i32.add 	$19=, $pop6, $6
.LBB0_1:                                # %do.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
	loop    	.LBB0_4
	i32.const	$0=, 0
	f32.load	$8=, 0($23)
	f32.load	$9=, counter1($0)
	f32.load	$10=, 0($22)
	f32.load	$11=, counter2($0)
	f32.load	$12=, 0($21)
	f32.load	$13=, counter3($0)
	f32.load	$14=, 0($20)
	f32.load	$15=, counter4($0)
	f32.load	$16=, 0($19)
	f32.load	$17=, counter5($0)
	f32.load	$push7=, 0($24)
	f32.load	$push8=, counter0($0)
	f32.add 	$push9=, $pop7, $pop8
	f32.store	$7=, counter0($0), $pop9
	i32.const	$25=, 12
	i32.add 	$24=, $24, $25
	i32.add 	$23=, $23, $25
	i32.add 	$push21=, $23, $6
	f32.load	$18=, 0($pop21)
	i32.add 	$push18=, $24, $6
	f32.load	$push19=, 0($pop18)
	f32.add 	$push20=, $pop19, $7
	f32.store	$discard=, counter0($0), $pop20
	f32.add 	$push10=, $8, $9
	f32.store	$push11=, counter1($0), $pop10
	f32.add 	$push22=, $18, $pop11
	f32.store	$discard=, counter1($0), $pop22
	f32.add 	$push12=, $10, $11
	f32.store	$8=, counter2($0), $pop12
	i32.add 	$22=, $22, $25
	i32.add 	$21=, $21, $25
	i32.add 	$push26=, $21, $6
	f32.load	$9=, 0($pop26)
	i32.add 	$push23=, $22, $6
	f32.load	$push24=, 0($pop23)
	f32.add 	$push25=, $pop24, $8
	f32.store	$discard=, counter2($0), $pop25
	f32.add 	$push13=, $12, $13
	f32.store	$push14=, counter3($0), $pop13
	f32.add 	$push27=, $9, $pop14
	f32.store	$discard=, counter3($0), $pop27
	i32.add 	$20=, $20, $25
	i32.add 	$19=, $19, $25
	i32.add 	$push28=, $20, $6
	f32.load	$8=, 0($pop28)
	f32.add 	$push15=, $14, $15
	f32.store	$9=, counter4($0), $pop15
	i32.add 	$push30=, $19, $6
	f32.load	$10=, 0($pop30)
	f32.add 	$push29=, $8, $9
	f32.store	$discard=, counter4($0), $pop29
	f32.add 	$push16=, $16, $17
	f32.store	$push17=, counter5($0), $pop16
	f32.add 	$push31=, $10, $pop17
	f32.store	$discard=, counter5($0), $pop31
	i32.load	$1=, vol($0)
	i32.load	$2=, vol($0)
	i32.load	$3=, vol($0)
	i32.load	$4=, vol($0)
	i32.load	$5=, vol($0)
	i32.const	$25=, 10
.LBB0_2:                                # %for.body
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB0_3
	i32.load	$push32=, vol($0)
	i32.add 	$push33=, $pop32, $1
	i32.store	$discard=, vol($0), $pop33
	i32.load	$push34=, vol($0)
	i32.add 	$push35=, $pop34, $2
	i32.store	$discard=, vol($0), $pop35
	i32.load	$push36=, vol($0)
	i32.add 	$push37=, $pop36, $3
	i32.store	$discard=, vol($0), $pop37
	i32.load	$push38=, vol($0)
	i32.add 	$push39=, $pop38, $4
	i32.store	$discard=, vol($0), $pop39
	i32.load	$push40=, vol($0)
	i32.add 	$push41=, $pop40, $5
	i32.store	$discard=, vol($0), $pop41
	i32.const	$push42=, -1
	i32.add 	$25=, $25, $pop42
	br_if   	$25, .LBB0_2
.LBB0_3:                                # %for.end
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.load	$push43=, stop($0)
	i32.const	$push44=, 0
	i32.eq  	$push45=, $pop43, $pop44
	br_if   	$pop45, .LBB0_1
.LBB0_4:                                # %do.end
	return
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, f32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$push0=, 1065353216
	i32.store	$push1=, array0+4($0), $pop0
	i32.store	$push4=, array1+4($0), $pop1
	i32.store	$push6=, array2+4($0), $pop4
	i32.store	$push8=, array3+4($0), $pop6
	i32.store	$push10=, array4+4($0), $pop8
	i32.store	$discard=, array5+4($0), $pop10
	i32.const	$push2=, 1073741824
	i32.store	$push3=, array0+20($0), $pop2
	i32.store	$push5=, array1+20($0), $pop3
	i32.store	$push7=, array2+20($0), $pop5
	i32.store	$push9=, array3+20($0), $pop7
	i32.store	$push11=, array4+20($0), $pop9
	i32.store	$discard=, array5+20($0), $pop11
	i32.const	$push12=, 1
	call    	foo, $pop12
	f32.const	$1=, 0x1.8p1
	f32.load	$push13=, counter0($0)
	f32.ne  	$push14=, $pop13, $1
	f32.load	$push15=, counter1($0)
	f32.ne  	$push16=, $pop15, $1
	i32.or  	$push17=, $pop14, $pop16
	f32.load	$push18=, counter2($0)
	f32.ne  	$push19=, $pop18, $1
	i32.or  	$push20=, $pop17, $pop19
	f32.load	$push21=, counter3($0)
	f32.ne  	$push22=, $pop21, $1
	i32.or  	$push23=, $pop20, $pop22
	f32.load	$push24=, counter4($0)
	f32.ne  	$push25=, $pop24, $1
	i32.or  	$push26=, $pop23, $pop25
	f32.load	$push27=, counter5($0)
	f32.ne  	$push28=, $pop27, $1
	i32.or  	$push29=, $pop26, $pop28
	return  	$pop29
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	counter0                # @counter0
	.type	counter0,@object
	.section	.bss.counter0,"aw",@nobits
	.globl	counter0
	.align	2
counter0:
	.int32	0                       # float 0
	.size	counter0, 4

	.hidden	counter1                # @counter1
	.type	counter1,@object
	.section	.bss.counter1,"aw",@nobits
	.globl	counter1
	.align	2
counter1:
	.int32	0                       # float 0
	.size	counter1, 4

	.hidden	counter2                # @counter2
	.type	counter2,@object
	.section	.bss.counter2,"aw",@nobits
	.globl	counter2
	.align	2
counter2:
	.int32	0                       # float 0
	.size	counter2, 4

	.hidden	counter3                # @counter3
	.type	counter3,@object
	.section	.bss.counter3,"aw",@nobits
	.globl	counter3
	.align	2
counter3:
	.int32	0                       # float 0
	.size	counter3, 4

	.hidden	counter4                # @counter4
	.type	counter4,@object
	.section	.bss.counter4,"aw",@nobits
	.globl	counter4
	.align	2
counter4:
	.int32	0                       # float 0
	.size	counter4, 4

	.hidden	counter5                # @counter5
	.type	counter5,@object
	.section	.bss.counter5,"aw",@nobits
	.globl	counter5
	.align	2
counter5:
	.int32	0                       # float 0
	.size	counter5, 4

	.hidden	stop                    # @stop
	.type	stop,@object
	.section	.data.stop,"aw",@progbits
	.globl	stop
	.align	2
stop:
	.int32	1                       # 0x1
	.size	stop, 4

	.hidden	array0                  # @array0
	.type	array0,@object
	.section	.bss.array0,"aw",@nobits
	.globl	array0
	.align	4
array0:
	.skip	64
	.size	array0, 64

	.hidden	array1                  # @array1
	.type	array1,@object
	.section	.bss.array1,"aw",@nobits
	.globl	array1
	.align	4
array1:
	.skip	64
	.size	array1, 64

	.hidden	array2                  # @array2
	.type	array2,@object
	.section	.bss.array2,"aw",@nobits
	.globl	array2
	.align	4
array2:
	.skip	64
	.size	array2, 64

	.hidden	array3                  # @array3
	.type	array3,@object
	.section	.bss.array3,"aw",@nobits
	.globl	array3
	.align	4
array3:
	.skip	64
	.size	array3, 64

	.hidden	array4                  # @array4
	.type	array4,@object
	.section	.bss.array4,"aw",@nobits
	.globl	array4
	.align	4
array4:
	.skip	64
	.size	array4, 64

	.hidden	array5                  # @array5
	.type	array5,@object
	.section	.bss.array5,"aw",@nobits
	.globl	array5
	.align	4
array5:
	.skip	64
	.size	array5, 64

	.hidden	vol                     # @vol
	.type	vol,@object
	.section	.bss.vol,"aw",@nobits
	.globl	vol
	.align	2
vol:
	.int32	0                       # 0x0
	.size	vol, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
