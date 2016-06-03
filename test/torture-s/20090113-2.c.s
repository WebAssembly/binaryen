	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20090113-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push12=, 0
	i32.const	$push9=, 0
	i32.load	$push10=, __stack_pointer($pop9)
	i32.const	$push11=, 48
	i32.sub 	$push22=, $pop10, $pop11
	i32.store	$push27=, __stack_pointer($pop12), $pop22
	tee_local	$push26=, $1=, $pop27
	i32.const	$push3=, 40
	i32.add 	$push4=, $pop26, $pop3
	i32.const	$push1=, 0
	i32.load	$push2=, .Lmain.elem+16($pop1)
	i32.store	$drop=, 0($pop4), $pop2
	i32.const	$push6=, 32
	i32.add 	$push7=, $1, $pop6
	i32.const	$push25=, 0
	i64.load	$push5=, .Lmain.elem+8($pop25):p2align=2
	i64.store	$drop=, 0($pop7), $pop5
	i32.const	$push24=, 0
	i64.load	$push8=, .Lmain.elem($pop24):p2align=2
	i64.store	$drop=, 24($1), $pop8
	i32.const	$push23=, 0
	i32.store	$push0=, 16($1), $pop23
	i32.store	$0=, 20($1), $pop0
	i32.const	$push16=, 24
	i32.add 	$push17=, $1, $pop16
	i32.store	$drop=, 12($1), $pop17
	i32.const	$push18=, 24
	i32.add 	$push19=, $1, $pop18
	i32.store	$drop=, 8($1), $pop19
	i32.const	$push20=, 8
	i32.add 	$push21=, $1, $pop20
	call    	foobar@FUNCTION, $pop21
	i32.const	$push15=, 0
	i32.const	$push13=, 48
	i32.add 	$push14=, $1, $pop13
	i32.store	$drop=, __stack_pointer($pop15), $pop14
	copy_local	$push28=, $0
                                        # fallthrough-return: $pop28
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.foobar,"ax",@progbits
	.type	foobar,@function
foobar:                                 # @foobar
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push14=, 0
	i32.const	$push11=, 0
	i32.load	$push12=, __stack_pointer($pop11)
	i32.const	$push13=, 32
	i32.sub 	$push32=, $pop12, $pop13
	i32.store	$push35=, __stack_pointer($pop14), $pop32
	tee_local	$push34=, $1=, $pop35
	i32.const	$push18=, 16
	i32.add 	$push19=, $pop34, $pop18
	i32.const	$push20=, 12
	i32.add 	$push21=, $1, $pop20
	call    	bmp_iter_set_init@FUNCTION, $pop19, $0, $pop21
	i32.const	$push22=, 16
	i32.add 	$push23=, $1, $pop22
	i32.const	$push33=, 12
	i32.add 	$3=, $pop23, $pop33
	i32.const	$push3=, 24
	i32.add 	$4=, $1, $pop3
.LBB1_1:                                # %for.cond
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_3 Depth 2
                                        #     Child Loop BB1_6 Depth 2
                                        #       Child Loop BB1_8 Depth 3
	loop                            # label0:
	i32.load	$0=, 12($1)
	block
	block
	i32.load	$push37=, 0($3)
	tee_local	$push36=, $6=, $pop37
	i32.eqz 	$push71=, $pop36
	br_if   	0, $pop71       # 0: down to label3
# BB#2:                                 # %while.cond.preheader.i
                                        #   in Loop: Header=BB1_1 Depth=1
	block
	i32.const	$push38=, 1
	i32.and 	$push1=, $6, $pop38
	br_if   	0, $pop1        # 0: down to label4
.LBB1_3:                                # %while.body.i
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label5:
	i32.const	$push43=, 1
	i32.add 	$0=, $0, $pop43
	i32.const	$push42=, 1
	i32.shr_u	$push41=, $6, $pop42
	tee_local	$push40=, $6=, $pop41
	i32.const	$push39=, 1
	i32.and 	$push2=, $pop40, $pop39
	i32.eqz 	$push72=, $pop2
	br_if   	0, $pop72       # 0: up to label5
.LBB1_4:                                # %while.end.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label6:
	end_block                       # label4:
	i32.store	$drop=, 12($1), $0
	br      	1               # 1: down to label2
.LBB1_5:                                # %if.end.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label3:
	i32.load	$push4=, 0($4)
	i32.const	$push50=, 1
	i32.add 	$push49=, $pop4, $pop50
	tee_local	$push48=, $2=, $pop49
	i32.store	$drop=, 0($4), $pop48
	i32.const	$push47=, 63
	i32.add 	$push5=, $0, $pop47
	i32.const	$push46=, -64
	i32.and 	$push45=, $pop5, $pop46
	tee_local	$push44=, $0=, $pop45
	i32.store	$drop=, 12($1), $pop44
	i32.load	$5=, 16($1)
.LBB1_6:                                # %while.cond5.i
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB1_8 Depth 3
	loop                            # label7:
	block
	i32.const	$push55=, 2
	i32.eq  	$push6=, $2, $pop55
	br_if   	0, $pop6        # 0: down to label9
# BB#7:                                 # %while.body9.i.preheader
                                        #   in Loop: Header=BB1_6 Depth=2
	i32.const	$push59=, 1
	i32.add 	$6=, $2, $pop59
	i32.const	$push58=, 64
	i32.add 	$7=, $0, $pop58
	i32.const	$push57=, 2
	i32.shl 	$push7=, $2, $pop57
	i32.add 	$push8=, $5, $pop7
	i32.const	$push56=, 12
	i32.add 	$0=, $pop8, $pop56
.LBB1_8:                                # %while.body9.i
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_6 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label10:
	i32.load	$push61=, 0($0)
	tee_local	$push60=, $2=, $pop61
	br_if   	4, $pop60       # 4: down to label8
# BB#9:                                 # %if.end17.i
                                        #   in Loop: Header=BB1_8 Depth=3
	i32.store	$drop=, 0($4), $6
	i32.const	$push67=, 4
	i32.add 	$0=, $0, $pop67
	i32.store	$push0=, 12($1), $7
	i32.const	$push66=, 64
	i32.add 	$7=, $pop0, $pop66
	i32.const	$push65=, 1
	i32.add 	$push64=, $6, $pop65
	tee_local	$push63=, $6=, $pop64
	i32.const	$push62=, 3
	i32.ne  	$push9=, $pop63, $pop62
	br_if   	0, $pop9        # 0: up to label10
# BB#10:                                # %while.end21.i.loopexit
                                        #   in Loop: Header=BB1_6 Depth=2
	end_loop                        # label11:
	i32.const	$push68=, 0
	i32.store	$drop=, 0($3), $pop68
.LBB1_11:                               # %while.end21.i
                                        #   in Loop: Header=BB1_6 Depth=2
	end_block                       # label9:
	i32.load	$push70=, 0($5)
	tee_local	$push69=, $5=, $pop70
	i32.eqz 	$push73=, $pop69
	br_if   	4, $pop73       # 4: down to label1
# BB#12:                                # %if.end25.i
                                        #   in Loop: Header=BB1_6 Depth=2
	i32.const	$2=, 0
	i32.const	$push54=, 0
	i32.store	$drop=, 0($4), $pop54
	i32.load	$push10=, 8($5)
	i32.const	$push53=, 7
	i32.shl 	$push52=, $pop10, $pop53
	tee_local	$push51=, $0=, $pop52
	i32.store	$drop=, 12($1), $pop51
	br      	0               # 0: up to label7
.LBB1_13:                               # %if.then15.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label8:
	i32.store	$drop=, 0($3), $2
	i32.store	$drop=, 16($1), $5
	i32.const	$push24=, 16
	i32.add 	$push25=, $1, $pop24
	i32.const	$push26=, 12
	i32.add 	$push27=, $1, $pop26
	call    	bmp_iter_set_tail@FUNCTION, $pop25, $pop27
	i32.load	$0=, 12($1)
.LBB1_14:                               # %for.body
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	call    	catchme@FUNCTION, $0
	i32.const	$push28=, 16
	i32.add 	$push29=, $1, $pop28
	i32.const	$push30=, 12
	i32.add 	$push31=, $1, $pop30
	call    	bmp_iter_next@FUNCTION, $pop29, $pop31
	br      	0               # 0: up to label0
.LBB1_15:                               # %for.end
	end_loop                        # label1:
	i32.const	$push17=, 0
	i32.const	$push15=, 32
	i32.add 	$push16=, $1, $pop15
	i32.store	$drop=, __stack_pointer($pop17), $pop16
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	foobar, .Lfunc_end1-foobar

	.section	.text.bmp_iter_set_init,"ax",@progbits
	.type	bmp_iter_set_init,@function
bmp_iter_set_init:                      # @bmp_iter_set_init
	.param  	i32, i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load	$1=, 0($1)
	i32.const	$push2=, 0
	i32.store	$3=, 4($0), $pop2
	block
	i32.store	$push0=, 0($0), $1
	br_if   	0, $pop0        # 0: down to label12
# BB#1:                                 # %if.then
	i32.const	$1=, bitmap_zero_bits
	i32.const	$push9=, bitmap_zero_bits
	i32.store	$drop=, 0($0), $pop9
.LBB2_2:                                # %while.end
	end_block                       # label12:
	i32.store	$drop=, 8($0), $3
	i32.load	$push3=, 12($1)
	i32.store	$push1=, 12($0), $pop3
	i32.eqz 	$push7=, $pop1
	i32.load	$push4=, 8($1)
	i32.const	$push5=, 7
	i32.shl 	$push6=, $pop4, $pop5
	i32.or  	$push8=, $pop7, $pop6
	i32.store	$drop=, 0($2), $pop8
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	bmp_iter_set_init, .Lfunc_end2-bmp_iter_set_init

	.section	.text.catchme,"ax",@progbits
	.type	catchme,@function
catchme:                                # @catchme
	.param  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 64
	i32.or  	$push1=, $0, $pop0
	i32.const	$push3=, 64
	i32.ne  	$push2=, $pop1, $pop3
	br_if   	0, $pop2        # 0: down to label13
# BB#1:                                 # %if.end
	return
.LBB3_2:                                # %if.then
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	catchme, .Lfunc_end3-catchme

	.section	.text.bmp_iter_next,"ax",@progbits
	.type	bmp_iter_next,@function
bmp_iter_next:                          # @bmp_iter_next
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.load	$push0=, 12($0)
	i32.const	$push1=, 1
	i32.shr_u	$push2=, $pop0, $pop1
	i32.store	$drop=, 12($0), $pop2
	i32.load	$push3=, 0($1)
	i32.const	$push5=, 1
	i32.add 	$push4=, $pop3, $pop5
	i32.store	$drop=, 0($1), $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end4:
	.size	bmp_iter_next, .Lfunc_end4-bmp_iter_next

	.section	.text.bmp_iter_set_tail,"ax",@progbits
	.type	bmp_iter_set_tail,@function
bmp_iter_set_tail:                      # @bmp_iter_set_tail
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block
	i32.load	$push6=, 12($0)
	tee_local	$push5=, $3=, $pop6
	i32.const	$push4=, 1
	i32.and 	$push0=, $pop5, $pop4
	br_if   	0, $pop0        # 0: down to label14
# BB#1:                                 # %while.body.lr.ph
	i32.load	$2=, 0($1)
.LBB5_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label15:
	i32.const	$push11=, 1
	i32.add 	$2=, $2, $pop11
	i32.const	$push10=, 1
	i32.shr_u	$push9=, $3, $pop10
	tee_local	$push8=, $3=, $pop9
	i32.const	$push7=, 1
	i32.and 	$push1=, $pop8, $pop7
	i32.eqz 	$push12=, $pop1
	br_if   	0, $pop12       # 0: up to label15
# BB#3:                                 # %while.cond.while.end_crit_edge
	end_loop                        # label16:
	i32.store	$drop=, 0($1), $2
	i32.const	$push2=, 12
	i32.add 	$push3=, $0, $pop2
	i32.store	$drop=, 0($pop3), $3
.LBB5_4:                                # %while.end
	end_block                       # label14:
                                        # fallthrough-return
	.endfunc
.Lfunc_end5:
	.size	bmp_iter_set_tail, .Lfunc_end5-bmp_iter_set_tail

	.type	.Lmain.elem,@object     # @main.elem
	.section	.rodata..Lmain.elem,"a",@progbits
	.p2align	2
.Lmain.elem:
	.int32	0
	.int32	0
	.int32	0                       # 0x0
	.int32	1                       # 0x1
	.int32	1                       # 0x1
	.size	.Lmain.elem, 20

	.hidden	bitmap_zero_bits        # @bitmap_zero_bits
	.type	bitmap_zero_bits,@object
	.section	.bss.bitmap_zero_bits,"aw",@nobits
	.globl	bitmap_zero_bits
	.p2align	2
bitmap_zero_bits:
	.skip	20
	.size	bitmap_zero_bits, 20


	.ident	"clang version 3.9.0 "
	.functype	abort, void
