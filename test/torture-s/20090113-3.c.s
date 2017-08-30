	.text
	.file	"20090113-3.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push12=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, __stack_pointer($pop10)
	i32.const	$push11=, 48
	i32.sub 	$push26=, $pop9, $pop11
	tee_local	$push25=, $0=, $pop26
	i32.store	__stack_pointer($pop12), $pop25
	i32.const	$push2=, 40
	i32.add 	$push3=, $0, $pop2
	i32.const	$push0=, 0
	i32.load	$push1=, .Lmain.elem+16($pop0)
	i32.store	0($pop3), $pop1
	i32.const	$push5=, 32
	i32.add 	$push6=, $0, $pop5
	i32.const	$push24=, 0
	i64.load	$push4=, .Lmain.elem+8($pop24):p2align=2
	i64.store	0($pop6), $pop4
	i32.const	$push23=, 0
	i64.load	$push7=, .Lmain.elem($pop23):p2align=2
	i64.store	24($0), $pop7
	i64.const	$push8=, 0
	i64.store	16($0), $pop8
	i32.const	$push16=, 24
	i32.add 	$push17=, $0, $pop16
	i32.store	12($0), $pop17
	i32.const	$push18=, 24
	i32.add 	$push19=, $0, $pop18
	i32.store	8($0), $pop19
	i32.const	$push20=, 8
	i32.add 	$push21=, $0, $pop20
	call    	foobar@FUNCTION, $pop21
	i32.const	$push15=, 0
	i32.const	$push13=, 48
	i32.add 	$push14=, $0, $pop13
	i32.store	__stack_pointer($pop15), $pop14
	i32.const	$push22=, 0
                                        # fallthrough-return: $pop22
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.foobar,"ax",@progbits
	.type	foobar,@function        # -- Begin function foobar
foobar:                                 # @foobar
	.param  	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push11=, 0
	i32.const	$push9=, 0
	i32.load	$push8=, __stack_pointer($pop9)
	i32.const	$push10=, 32
	i32.sub 	$push22=, $pop8, $pop10
	tee_local	$push21=, $4=, $pop22
	i32.store	__stack_pointer($pop11), $pop21
	i32.const	$push15=, 16
	i32.add 	$push16=, $4, $pop15
	i32.const	$push17=, 12
	i32.add 	$push18=, $4, $pop17
	call    	bmp_iter_set_init@FUNCTION, $pop16, $0, $pop18
	i32.load	$1=, 16($4)
	i32.load	$2=, 24($4)
	block   	
	block   	
	i32.load	$push20=, 28($4)
	tee_local	$push19=, $0=, $pop20
	br_if   	0, $pop19       # 0: down to label1
# BB#1:
	i32.const	$5=, 2
	br      	1               # 1: down to label0
.LBB1_2:
	end_block                       # label1:
	i32.const	$5=, 0
.LBB1_3:                                # =>This Inner Loop Header: Depth=1
	end_block                       # label0:
	loop    	                # label2:
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	br_table 	$5, 1, 0, 3, 4, 5, 6, 9, 10, 7, 8, 11, 2, 2 # 1: down to label25
                                        # 0: down to label26
                                        # 3: down to label23
                                        # 4: down to label22
                                        # 5: down to label21
                                        # 6: down to label20
                                        # 9: down to label17
                                        # 10: down to label16
                                        # 7: down to label19
                                        # 8: down to label18
                                        # 11: down to label15
                                        # 2: down to label24
.LBB1_4:                                # %for.inc
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label26:
	i32.const	$push25=, 1
	i32.shr_u	$push24=, $0, $pop25
	tee_local	$push23=, $0=, $pop24
	i32.eqz 	$push49=, $pop23
	br_if   	11, $pop49      # 11: down to label14
# BB#5:                                 #   in Loop: Header=BB1_3 Depth=1
	i32.const	$5=, 0
	br      	23              # 23: up to label2
.LBB1_6:                                # %if.then.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label25:
	i32.const	$push26=, 1
	i32.and 	$push0=, $0, $pop26
	br_if   	13, $pop0       # 13: down to label11
# BB#7:                                 #   in Loop: Header=BB1_3 Depth=1
	i32.const	$5=, 11
	br      	22              # 22: up to label2
.LBB1_8:                                # %while.body.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label24:
	i32.const	$push30=, 1
	i32.shr_u	$push29=, $0, $pop30
	tee_local	$push28=, $0=, $pop29
	i32.const	$push27=, 1
	i32.and 	$push1=, $pop28, $pop27
	i32.eqz 	$push50=, $pop1
	br_if   	10, $pop50      # 10: down to label13
	br      	11              # 11: down to label12
.LBB1_9:                                # %if.end.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label23:
	i32.const	$push31=, 1
	i32.add 	$2=, $2, $pop31
# BB#10:                                #   in Loop: Header=BB1_3 Depth=1
	i32.const	$5=, 3
	br      	20              # 20: up to label2
.LBB1_11:                               # %while.body6.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label22:
	i32.const	$push32=, 2
	i32.eq  	$push2=, $2, $pop32
	br_if   	16, $pop2       # 16: down to label5
# BB#12:                                #   in Loop: Header=BB1_3 Depth=1
	i32.const	$5=, 4
	br      	19              # 19: up to label2
.LBB1_13:                               # %while.body9.i.preheader
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label21:
	i32.const	$push34=, 2
	i32.shl 	$push3=, $2, $pop34
	i32.add 	$push4=, $1, $pop3
	i32.const	$push33=, 12
	i32.add 	$3=, $pop4, $pop33
# BB#14:                                #   in Loop: Header=BB1_3 Depth=1
	i32.const	$5=, 5
	br      	18              # 18: up to label2
.LBB1_15:                               # %while.body9.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label20:
	i32.load	$push36=, 0($3)
	tee_local	$push35=, $0=, $pop36
	br_if   	16, $pop35      # 16: down to label3
# BB#16:                                #   in Loop: Header=BB1_3 Depth=1
	i32.const	$5=, 8
	br      	17              # 17: up to label2
.LBB1_17:                               # %if.end26.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label19:
	i32.const	$push41=, 4
	i32.add 	$3=, $3, $pop41
	i32.const	$push40=, 1
	i32.add 	$push39=, $2, $pop40
	tee_local	$push38=, $2=, $pop39
	i32.const	$push37=, 2
	i32.ne  	$push7=, $pop38, $pop37
	br_if   	14, $pop7       # 14: down to label4
# BB#18:                                #   in Loop: Header=BB1_3 Depth=1
	i32.const	$5=, 9
	br      	16              # 16: up to label2
.LBB1_19:                               # %while.end30.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label18:
	i32.const	$2=, 0
	i32.load	$push43=, 0($1)
	tee_local	$push42=, $1=, $pop43
	br_if   	11, $pop42      # 11: down to label6
	br      	10              # 10: down to label7
.LBB1_20:                               # %if.then15.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label17:
	i32.const	$push44=, 1
	i32.and 	$push5=, $0, $pop44
	br_if   	6, $pop5        # 6: down to label10
# BB#21:                                #   in Loop: Header=BB1_3 Depth=1
	i32.const	$5=, 7
	br      	14              # 14: up to label2
.LBB1_22:                               # %while.body21.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label16:
	i32.const	$push48=, 1
	i32.shr_u	$push47=, $0, $pop48
	tee_local	$push46=, $0=, $pop47
	i32.const	$push45=, 1
	i32.and 	$push6=, $pop46, $pop45
	i32.eqz 	$push51=, $pop6
	br_if   	6, $pop51       # 6: down to label9
	br      	7               # 7: down to label8
.LBB1_23:                               # %for.end
	end_block                       # label15:
	i32.const	$push14=, 0
	i32.const	$push12=, 32
	i32.add 	$push13=, $4, $pop12
	i32.store	__stack_pointer($pop14), $pop13
	return
.LBB1_24:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label14:
	i32.const	$5=, 2
	br      	11              # 11: up to label2
.LBB1_25:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label13:
	i32.const	$5=, 11
	br      	10              # 10: up to label2
.LBB1_26:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label12:
	i32.const	$5=, 1
	br      	9               # 9: up to label2
.LBB1_27:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label11:
	i32.const	$5=, 1
	br      	8               # 8: up to label2
.LBB1_28:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label10:
	i32.const	$5=, 1
	br      	7               # 7: up to label2
.LBB1_29:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label9:
	i32.const	$5=, 7
	br      	6               # 6: up to label2
.LBB1_30:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label8:
	i32.const	$5=, 1
	br      	5               # 5: up to label2
.LBB1_31:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label7:
	i32.const	$5=, 10
	br      	4               # 4: up to label2
.LBB1_32:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label6:
	i32.const	$5=, 3
	br      	3               # 3: up to label2
.LBB1_33:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label5:
	i32.const	$5=, 9
	br      	2               # 2: up to label2
.LBB1_34:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label4:
	i32.const	$5=, 5
	br      	1               # 1: up to label2
.LBB1_35:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label3:
	i32.const	$5=, 6
	br      	0               # 0: up to label2
.LBB1_36:
	end_loop
	.endfunc
.Lfunc_end1:
	.size	foobar, .Lfunc_end1-foobar
                                        # -- End function
	.section	.text.bmp_iter_set_init,"ax",@progbits
	.type	bmp_iter_set_init,@function # -- Begin function bmp_iter_set_init
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
	br_if   	0, $1           # 0: down to label27
# BB#1:                                 # %if.then
	i32.const	$1=, bitmap_zero_bits
	i32.const	$push8=, bitmap_zero_bits
	i32.store	0($0), $pop8
.LBB2_2:                                # %while.end
	end_block                       # label27:
	i32.const	$push11=, 0
	i32.store	8($0), $pop11
	i32.load	$push10=, 12($1)
	tee_local	$push9=, $3=, $pop10
	i32.store	12($0), $pop9
	i32.load	$push0=, 8($1)
	i32.const	$push1=, 7
	i32.shl 	$push2=, $pop0, $pop1
	i32.eqz 	$push3=, $3
	i32.or  	$push4=, $pop2, $pop3
	i32.store	0($2), $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	bmp_iter_set_init, .Lfunc_end2-bmp_iter_set_init
                                        # -- End function
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
