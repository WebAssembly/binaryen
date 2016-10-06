	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20090113-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 48
	i32.sub 	$push27=, $pop9, $pop10
	tee_local	$push26=, $0=, $pop27
	i32.store	__stack_pointer($pop11), $pop26
	i32.const	$push2=, 40
	i32.add 	$push3=, $0, $pop2
	i32.const	$push0=, 0
	i32.load	$push1=, .Lmain.elem+16($pop0)
	i32.store	0($pop3), $pop1
	i32.const	$push5=, 32
	i32.add 	$push6=, $0, $pop5
	i32.const	$push25=, 0
	i64.load	$push4=, .Lmain.elem+8($pop25):p2align=2
	i64.store	0($pop6), $pop4
	i32.const	$push24=, 0
	i64.load	$push7=, .Lmain.elem($pop24):p2align=2
	i64.store	24($0), $pop7
	i32.const	$push23=, 0
	i32.store	16($0), $pop23
	i32.const	$push22=, 0
	i32.store	20($0), $pop22
	i32.const	$push15=, 24
	i32.add 	$push16=, $0, $pop15
	i32.store	12($0), $pop16
	i32.const	$push17=, 24
	i32.add 	$push18=, $0, $pop17
	i32.store	8($0), $pop18
	i32.const	$push19=, 8
	i32.add 	$push20=, $0, $pop19
	call    	foobar@FUNCTION, $pop20
	i32.const	$push14=, 0
	i32.const	$push12=, 48
	i32.add 	$push13=, $0, $pop12
	i32.store	__stack_pointer($pop14), $pop13
	i32.const	$push21=, 0
                                        # fallthrough-return: $pop21
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.foobar,"ax",@progbits
	.type	foobar,@function
foobar:                                 # @foobar
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, 0
	i32.const	$push10=, 0
	i32.load	$push11=, __stack_pointer($pop10)
	i32.const	$push12=, 32
	i32.sub 	$push33=, $pop11, $pop12
	tee_local	$push32=, $7=, $pop33
	i32.store	__stack_pointer($pop13), $pop32
	i32.const	$push17=, 16
	i32.add 	$push18=, $7, $pop17
	i32.const	$push19=, 12
	i32.add 	$push20=, $7, $pop19
	call    	bmp_iter_set_init@FUNCTION, $pop18, $0, $pop20
	i32.const	$push21=, 16
	i32.add 	$push22=, $7, $pop21
	i32.const	$push31=, 12
	i32.add 	$2=, $pop22, $pop31
	i32.const	$push2=, 24
	i32.add 	$3=, $7, $pop2
.LBB1_1:                                # %for.cond
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_3 Depth 2
                                        #     Child Loop BB1_6 Depth 2
                                        #       Child Loop BB1_8 Depth 3
	block   	
	loop    	                # label1:
	i32.load	$0=, 12($7)
	block   	
	block   	
	i32.load	$push35=, 0($2)
	tee_local	$push34=, $5=, $pop35
	i32.eqz 	$push69=, $pop34
	br_if   	0, $pop69       # 0: down to label3
# BB#2:                                 # %while.cond.preheader.i
                                        #   in Loop: Header=BB1_1 Depth=1
	block   	
	i32.const	$push36=, 1
	i32.and 	$push0=, $5, $pop36
	br_if   	0, $pop0        # 0: down to label4
.LBB1_3:                                # %while.body.i
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label5:
	i32.const	$push41=, 1
	i32.add 	$0=, $0, $pop41
	i32.const	$push40=, 1
	i32.shr_u	$push39=, $5, $pop40
	tee_local	$push38=, $5=, $pop39
	i32.const	$push37=, 1
	i32.and 	$push1=, $pop38, $pop37
	i32.eqz 	$push70=, $pop1
	br_if   	0, $pop70       # 0: up to label5
.LBB1_4:                                # %while.end.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop
	end_block                       # label4:
	i32.store	12($7), $0
	br      	1               # 1: down to label2
.LBB1_5:                                # %if.end.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label3:
	i32.load	$push3=, 0($3)
	i32.const	$push48=, 1
	i32.add 	$push47=, $pop3, $pop48
	tee_local	$push46=, $1=, $pop47
	i32.store	0($3), $pop46
	i32.const	$push45=, 63
	i32.add 	$push4=, $0, $pop45
	i32.const	$push44=, -64
	i32.and 	$push43=, $pop4, $pop44
	tee_local	$push42=, $0=, $pop43
	i32.store	12($7), $pop42
	i32.load	$4=, 16($7)
.LBB1_6:                                # %while.cond5.i
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB1_8 Depth 3
	block   	
	loop    	                # label7:
	block   	
	i32.const	$push53=, 2
	i32.eq  	$push5=, $1, $pop53
	br_if   	0, $pop5        # 0: down to label8
# BB#7:                                 # %while.body9.i.preheader
                                        #   in Loop: Header=BB1_6 Depth=2
	i32.const	$push57=, 1
	i32.add 	$5=, $1, $pop57
	i32.const	$push56=, 64
	i32.add 	$6=, $0, $pop56
	i32.const	$push55=, 2
	i32.shl 	$push6=, $1, $pop55
	i32.add 	$push7=, $4, $pop6
	i32.const	$push54=, 12
	i32.add 	$0=, $pop7, $pop54
.LBB1_8:                                # %while.body9.i
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_6 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label9:
	i32.load	$push59=, 0($0)
	tee_local	$push58=, $1=, $pop59
	br_if   	3, $pop58       # 3: down to label6
# BB#9:                                 # %if.end17.i
                                        #   in Loop: Header=BB1_8 Depth=3
	i32.store	0($3), $5
	i32.const	$push65=, 4
	i32.add 	$0=, $0, $pop65
	i32.store	12($7), $6
	i32.const	$push64=, 64
	i32.add 	$6=, $6, $pop64
	i32.const	$push63=, 1
	i32.add 	$push62=, $5, $pop63
	tee_local	$push61=, $5=, $pop62
	i32.const	$push60=, 3
	i32.ne  	$push8=, $pop61, $pop60
	br_if   	0, $pop8        # 0: up to label9
# BB#10:                                # %while.end21.i.loopexit
                                        #   in Loop: Header=BB1_6 Depth=2
	end_loop
	i32.const	$push66=, 0
	i32.store	0($2), $pop66
.LBB1_11:                               # %while.end21.i
                                        #   in Loop: Header=BB1_6 Depth=2
	end_block                       # label8:
	i32.load	$push68=, 0($4)
	tee_local	$push67=, $4=, $pop68
	i32.eqz 	$push71=, $pop67
	br_if   	4, $pop71       # 4: down to label0
# BB#12:                                # %if.end25.i
                                        #   in Loop: Header=BB1_6 Depth=2
	i32.const	$1=, 0
	i32.const	$push52=, 0
	i32.store	0($3), $pop52
	i32.load	$push9=, 8($4)
	i32.const	$push51=, 7
	i32.shl 	$push50=, $pop9, $pop51
	tee_local	$push49=, $0=, $pop50
	i32.store	12($7), $pop49
	br      	0               # 0: up to label7
.LBB1_13:                               # %if.then15.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop
	end_block                       # label6:
	i32.store	0($2), $1
	i32.store	16($7), $4
	i32.const	$push23=, 16
	i32.add 	$push24=, $7, $pop23
	i32.const	$push25=, 12
	i32.add 	$push26=, $7, $pop25
	call    	bmp_iter_set_tail@FUNCTION, $pop24, $pop26
	i32.load	$0=, 12($7)
.LBB1_14:                               # %for.body
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	call    	catchme@FUNCTION, $0
	i32.const	$push27=, 16
	i32.add 	$push28=, $7, $pop27
	i32.const	$push29=, 12
	i32.add 	$push30=, $7, $pop29
	call    	bmp_iter_next@FUNCTION, $pop28, $pop30
	br      	0               # 0: up to label1
.LBB1_15:                               # %for.end
	end_loop
	end_block                       # label0:
	i32.const	$push16=, 0
	i32.const	$push14=, 32
	i32.add 	$push15=, $7, $pop14
	i32.store	__stack_pointer($pop16), $pop15
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
	i32.const	$push7=, 0
	i32.store	4($0), $pop7
	i32.load	$push6=, 0($1)
	tee_local	$push5=, $1=, $pop6
	i32.store	0($0), $pop5
	block   	
	br_if   	0, $1           # 0: down to label10
# BB#1:                                 # %if.then
	i32.const	$1=, bitmap_zero_bits
	i32.const	$push8=, bitmap_zero_bits
	i32.store	0($0), $pop8
.LBB2_2:                                # %while.end
	end_block                       # label10:
	i32.const	$push11=, 0
	i32.store	8($0), $pop11
	i32.load	$push10=, 12($1)
	tee_local	$push9=, $3=, $pop10
	i32.store	12($0), $pop9
	i32.eqz 	$push3=, $3
	i32.load	$push0=, 8($1)
	i32.const	$push1=, 7
	i32.shl 	$push2=, $pop0, $pop1
	i32.or  	$push4=, $pop3, $pop2
	i32.store	0($2), $pop4
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
	br_if   	0, $pop2        # 0: down to label11
# BB#1:                                 # %if.end
	return
.LBB3_2:                                # %if.then
	end_block                       # label11:
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
	i32.store	12($0), $pop2
	i32.load	$push3=, 0($1)
	i32.const	$push5=, 1
	i32.add 	$push4=, $pop3, $pop5
	i32.store	0($1), $pop4
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
	br_if   	0, $pop0        # 0: down to label12
# BB#1:                                 # %while.body.lr.ph
	i32.load	$2=, 0($1)
.LBB5_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label13:
	i32.const	$push11=, 1
	i32.add 	$2=, $2, $pop11
	i32.const	$push10=, 1
	i32.shr_u	$push9=, $3, $pop10
	tee_local	$push8=, $3=, $pop9
	i32.const	$push7=, 1
	i32.and 	$push1=, $pop8, $pop7
	i32.eqz 	$push12=, $pop1
	br_if   	0, $pop12       # 0: up to label13
# BB#3:                                 # %while.cond.while.end_crit_edge
	end_loop
	i32.store	0($1), $2
	i32.const	$push2=, 12
	i32.add 	$push3=, $0, $pop2
	i32.store	0($pop3), $3
.LBB5_4:                                # %while.end
	end_block                       # label12:
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
