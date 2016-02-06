	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010129-1.c"
	.section	.text.baz1,"ax",@progbits
	.hidden	baz1
	.globl	baz1
	.type	baz1,@function
baz1:                                   # @baz1
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.load	$push1=, baz1.l($pop5)
	tee_local	$push4=, $1=, $pop1
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop4, $pop2
	i32.store	$discard=, baz1.l($pop0), $pop3
	return  	$1
	.endfunc
.Lfunc_end0:
	.size	baz1, .Lfunc_end0-baz1

	.section	.text.baz2,"ax",@progbits
	.hidden	baz2
	.globl	baz2
	.type	baz2,@function
baz2:                                   # @baz2
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	baz2, .Lfunc_end1-baz2

	.section	.text.baz3,"ax",@progbits
	.hidden	baz3
	.globl	baz3
	.type	baz3,@function
baz3:                                   # @baz3
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push1=, 0
	i32.eq  	$push2=, $0, $pop1
	br_if   	$pop2, 0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push0=, 1
	return  	$pop0
.LBB2_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	baz3, .Lfunc_end2-baz3

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push29=, 0
	i32.const	$push28=, 0
	i32.load	$push25=, baz1.l($pop28)
	tee_local	$push27=, $9=, $pop25
	i32.const	$push26=, 1
	i32.add 	$push4=, $pop27, $pop26
	i32.store	$discard=, baz1.l($pop29), $pop4
	block
	i32.ge_s	$push5=, $9, $1
	br_if   	$pop5, 0        # 0: down to label1
# BB#1:                                 # %if.then.lr.ph
	i32.const	$push6=, 16
	i32.and 	$3=, $2, $pop6
	i32.const	$push7=, 13834
	i32.and 	$push8=, $2, $pop7
	i32.const	$push38=, 0
	i32.ne  	$push16=, $pop8, $pop38
	i32.const	$push9=, 128
	i32.and 	$push10=, $2, $pop9
	i32.const	$push37=, 0
	i32.eq  	$push11=, $pop10, $pop37
	i32.const	$push36=, 0
	i32.load	$push12=, bar($pop36)
	i32.const	$push35=, 0
	i32.eq  	$push13=, $pop12, $pop35
	i32.or  	$push0=, $pop11, $pop13
	tee_local	$push34=, $10=, $pop0
	i32.or  	$4=, $pop16, $pop34
	i32.const	$push15=, 13832
	i32.and 	$push3=, $2, $pop15
	i32.const	$push33=, 0
	i32.ne  	$5=, $pop3, $pop33
	i32.const	$push32=, 2
	i32.and 	$push2=, $2, $pop32
	i32.const	$push31=, 0
	i32.ne  	$6=, $pop2, $pop31
	i32.const	$push14=, 16384
	i32.and 	$push1=, $2, $pop14
	i32.const	$push30=, 0
	i32.eq  	$7=, $pop1, $pop30
	i32.const	$2=, 0
.LBB3_2:                                # %if.then
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$8=, 0
	block
	i32.or  	$push17=, $2, $3
	i32.const	$push45=, 0
	i32.eq  	$push46=, $pop17, $pop45
	br_if   	$pop46, 0       # 0: down to label4
# BB#3:                                 # %if.end17
                                        #   in Loop: Header=BB3_2 Depth=1
	i32.const	$push42=, 1
	i32.select	$8=, $2, $pop42, $2
	block
	block
	br_if   	$3, 0           # 0: down to label6
# BB#4:                                 # %land.lhs.true25
                                        #   in Loop: Header=BB3_2 Depth=1
	br_if   	$4, 2           # 2: down to label4
	br      	1               # 1: down to label5
.LBB3_5:                                # %land.lhs.true20
                                        #   in Loop: Header=BB3_2 Depth=1
	end_block                       # label6:
	i32.const	$push43=, 0
	i32.ne  	$push18=, $2, $pop43
	i32.or  	$push19=, $7, $pop18
	i32.and 	$push20=, $6, $pop19
	i32.or  	$push21=, $5, $pop20
	i32.or  	$push22=, $10, $pop21
	br_if   	$pop22, 1       # 1: down to label4
.LBB3_6:                                # %for.body
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB3_7:                                # %while.cond.backedge
                                        #   in Loop: Header=BB3_2 Depth=1
	end_block                       # label4:
	i32.const	$push41=, 0
	i32.const	$push40=, 2
	i32.add 	$push23=, $9, $pop40
	i32.store	$discard=, baz1.l($pop41), $pop23
	i32.const	$push39=, 1
	i32.add 	$9=, $9, $pop39
	copy_local	$2=, $8
	i32.lt_s	$push24=, $9, $1
	br_if   	$pop24, 0       # 0: up to label2
.LBB3_8:                                # %while.end
	end_loop                        # label3:
	end_block                       # label1:
	i32.const	$push44=, 0
	return  	$pop44
	.endfunc
.Lfunc_end3:
	.size	foo, .Lfunc_end3-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$4=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	i32.const	$push0=, 0
	i32.store	$push1=, 12($4), $pop0
	tee_local	$push4=, $0=, $pop1
	i32.const	$3=, 12
	i32.add 	$3=, $4, $3
	i32.store	$discard=, bar($pop4), $3
	i32.const	$push3=, 1
	i32.const	$push2=, 51217
	i32.call	$discard=, foo@FUNCTION, $0, $pop3, $pop2
	call    	exit@FUNCTION, $0
	unreachable
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main

	.type	baz1.l,@object          # @baz1.l
	.lcomm	baz1.l,4,2
	.hidden	bar                     # @bar
	.type	bar,@object
	.section	.bss.bar,"aw",@nobits
	.globl	bar
	.p2align	2
bar:
	.int32	0
	.size	bar, 4


	.ident	"clang version 3.9.0 "
