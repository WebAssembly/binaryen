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
	i32.const	$push29=, 0
	i32.const	$push28=, 0
	i32.load	$push27=, baz1.l($pop28)
	tee_local	$push26=, $9=, $pop27
	i32.const	$push25=, 1
	i32.add 	$push4=, $pop26, $pop25
	i32.store	$drop=, baz1.l($pop29), $pop4
	block
	block
	i32.ge_s	$push5=, $9, $1
	br_if   	0, $pop5        # 0: down to label2
# BB#1:                                 # %if.then.lr.ph
	i32.const	$push6=, 13834
	i32.and 	$push7=, $2, $pop6
	i32.const	$push36=, 0
	i32.ne  	$push8=, $pop7, $pop36
	i32.const	$push9=, 128
	i32.and 	$push10=, $2, $pop9
	i32.eqz 	$push11=, $pop10
	i32.const	$push35=, 0
	i32.load	$push12=, bar($pop35)
	i32.eqz 	$push13=, $pop12
	i32.or  	$push34=, $pop11, $pop13
	tee_local	$push33=, $4=, $pop34
	i32.or  	$5=, $pop8, $pop33
	i32.const	$push16=, 16
	i32.and 	$3=, $2, $pop16
	i32.const	$push32=, 2
	i32.and 	$push1=, $2, $pop32
	i32.const	$push31=, 0
	i32.ne  	$6=, $pop1, $pop31
	i32.const	$push15=, 16384
	i32.and 	$push0=, $2, $pop15
	i32.eqz 	$7=, $pop0
	i32.const	$push14=, 13832
	i32.and 	$push2=, $2, $pop14
	i32.const	$push30=, 0
	i32.ne  	$8=, $pop2, $pop30
	i32.const	$10=, 0
.LBB3_2:                                # %if.then
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	copy_local	$2=, $10
	i32.const	$10=, 0
	block
	i32.or  	$push17=, $2, $3
	i32.eqz 	$push45=, $pop17
	br_if   	0, $pop45       # 0: down to label5
# BB#3:                                 # %if.end17
                                        #   in Loop: Header=BB3_2 Depth=1
	i32.const	$push37=, 1
	i32.select	$10=, $2, $pop37, $2
	block
	br_if   	0, $3           # 0: down to label6
# BB#4:                                 # %land.lhs.true25
                                        #   in Loop: Header=BB3_2 Depth=1
	br_if   	1, $5           # 1: down to label5
	br      	5               # 5: down to label1
.LBB3_5:                                # %land.lhs.true20
                                        #   in Loop: Header=BB3_2 Depth=1
	end_block                       # label6:
	i32.eqz 	$push3=, $2
	i32.const	$push38=, 1
	i32.xor 	$push18=, $pop3, $pop38
	i32.or  	$push19=, $7, $pop18
	i32.and 	$push20=, $6, $pop19
	i32.or  	$push21=, $8, $pop20
	i32.or  	$push22=, $4, $pop21
	i32.eqz 	$push46=, $pop22
	br_if   	4, $pop46       # 4: down to label1
.LBB3_6:                                # %while.cond.backedge
                                        #   in Loop: Header=BB3_2 Depth=1
	end_block                       # label5:
	i32.const	$push43=, 0
	i32.const	$push42=, 2
	i32.add 	$push23=, $9, $pop42
	i32.store	$drop=, baz1.l($pop43), $pop23
	i32.const	$push41=, 1
	i32.add 	$push40=, $9, $pop41
	tee_local	$push39=, $9=, $pop40
	i32.lt_s	$push24=, $pop39, $1
	br_if   	0, $pop24       # 0: up to label3
.LBB3_7:                                # %while.end
	end_loop                        # label4:
	end_block                       # label2:
	i32.const	$push44=, 0
	return  	$pop44
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
	i32.const	$push6=, 0
	i32.const	$push3=, 0
	i32.load	$push4=, __stack_pointer($pop3)
	i32.const	$push5=, 16
	i32.sub 	$push12=, $pop4, $pop5
	tee_local	$push11=, $0=, $pop12
	i32.store	$drop=, __stack_pointer($pop6), $pop11
	i32.const	$push0=, 0
	i32.const	$push7=, 12
	i32.add 	$push8=, $0, $pop7
	i32.store	$drop=, bar($pop0), $pop8
	i32.const	$push10=, 0
	i32.store	$drop=, 12($0), $pop10
	i32.const	$push2=, 1
	i32.const	$push1=, 51217
	i32.call	$drop=, foo@FUNCTION, $0, $pop2, $pop1
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main

	.type	baz1.l,@object          # @baz1.l
	.section	.bss.baz1.l,"aw",@nobits
	.p2align	2
baz1.l:
	.int32	0                       # 0x0
	.size	baz1.l, 4

	.hidden	bar                     # @bar
	.type	bar,@object
	.section	.bss.bar,"aw",@nobits
	.globl	bar
	.p2align	2
bar:
	.int32	0
	.size	bar, 4


	.ident	"clang version 4.0.0 "
	.functype	abort, void
	.functype	exit, void, i32
