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
	i32.load	$push4=, baz1.l($pop5)
	tee_local	$push3=, $1=, $pop4
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop3, $pop1
	i32.store	$drop=, baz1.l($pop0), $pop2
	copy_local	$push6=, $1
                                        # fallthrough-return: $pop6
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
                                        # fallthrough-return: $pop0
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
	i32.eqz 	$push1=, $0
	br_if   	0, $pop1        # 0: down to label0
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
	i32.const	$push28=, 0
	i32.const	$push27=, 0
	i32.load	$push26=, baz1.l($pop27)
	tee_local	$push25=, $9=, $pop26
	i32.const	$push24=, 1
	i32.add 	$push3=, $pop25, $pop24
	i32.store	$drop=, baz1.l($pop28), $pop3
	block
	block
	i32.ge_s	$push4=, $9, $1
	br_if   	0, $pop4        # 0: down to label2
# BB#1:                                 # %if.then.lr.ph
	i32.const	$push5=, 13834
	i32.and 	$push6=, $2, $pop5
	i32.const	$push35=, 0
	i32.ne  	$push7=, $pop6, $pop35
	i32.const	$push8=, 128
	i32.and 	$push9=, $2, $pop8
	i32.eqz 	$push10=, $pop9
	i32.const	$push34=, 0
	i32.load	$push11=, bar($pop34)
	i32.eqz 	$push12=, $pop11
	i32.or  	$push33=, $pop10, $pop12
	tee_local	$push32=, $4=, $pop33
	i32.or  	$5=, $pop7, $pop32
	i32.const	$push15=, 16
	i32.and 	$3=, $2, $pop15
	i32.const	$push31=, 2
	i32.and 	$push1=, $2, $pop31
	i32.const	$push30=, 0
	i32.ne  	$6=, $pop1, $pop30
	i32.const	$push14=, 16384
	i32.and 	$push0=, $2, $pop14
	i32.eqz 	$7=, $pop0
	i32.const	$push13=, 13832
	i32.and 	$push2=, $2, $pop13
	i32.const	$push29=, 0
	i32.ne  	$8=, $pop2, $pop29
	i32.const	$10=, 0
.LBB3_2:                                # %if.then
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	copy_local	$2=, $10
	i32.const	$10=, 0
	block
	i32.or  	$push16=, $2, $3
	i32.eqz 	$push44=, $pop16
	br_if   	0, $pop44       # 0: down to label5
# BB#3:                                 # %if.end17
                                        #   in Loop: Header=BB3_2 Depth=1
	i32.const	$push36=, 1
	i32.select	$10=, $2, $pop36, $2
	block
	br_if   	0, $3           # 0: down to label6
# BB#4:                                 # %land.lhs.true25
                                        #   in Loop: Header=BB3_2 Depth=1
	br_if   	1, $5           # 1: down to label5
	br      	5               # 5: down to label1
.LBB3_5:                                # %land.lhs.true20
                                        #   in Loop: Header=BB3_2 Depth=1
	end_block                       # label6:
	i32.const	$push37=, 0
	i32.ne  	$push17=, $2, $pop37
	i32.or  	$push18=, $7, $pop17
	i32.and 	$push19=, $6, $pop18
	i32.or  	$push20=, $8, $pop19
	i32.or  	$push21=, $4, $pop20
	i32.eqz 	$push45=, $pop21
	br_if   	4, $pop45       # 4: down to label1
.LBB3_6:                                # %while.cond.backedge
                                        #   in Loop: Header=BB3_2 Depth=1
	end_block                       # label5:
	i32.const	$push42=, 0
	i32.const	$push41=, 2
	i32.add 	$push22=, $9, $pop41
	i32.store	$drop=, baz1.l($pop42), $pop22
	i32.const	$push40=, 1
	i32.add 	$push39=, $9, $pop40
	tee_local	$push38=, $9=, $pop39
	i32.lt_s	$push23=, $pop38, $1
	br_if   	0, $pop23       # 0: up to label3
.LBB3_7:                                # %while.end
	end_loop                        # label4:
	end_block                       # label2:
	i32.const	$push43=, 0
	return  	$pop43
.LBB3_8:                                # %for.body
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	foo, .Lfunc_end3-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push6=, 0
	i32.const	$push3=, 0
	i32.load	$push4=, __stack_pointer($pop3)
	i32.const	$push5=, 16
	i32.sub 	$push9=, $pop4, $pop5
	i32.store	$push12=, __stack_pointer($pop6), $pop9
	tee_local	$push11=, $0=, $pop12
	i32.const	$push7=, 12
	i32.add 	$push8=, $pop11, $pop7
	i32.store	$drop=, bar($pop0), $pop8
	i32.const	$push10=, 0
	i32.store	$0=, 12($0), $pop10
	i32.const	$push2=, 1
	i32.const	$push1=, 51217
	i32.call	$drop=, foo@FUNCTION, $0, $pop2, $pop1
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
	.functype	abort, void
	.functype	exit, void, i32
