	.text
	.file	"20090113-3.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push10=, 0
	i32.load	$push9=, __stack_pointer($pop10)
	i32.const	$push11=, 48
	i32.sub 	$0=, $pop9, $pop11
	i32.const	$push12=, 0
	i32.store	__stack_pointer($pop12), $0
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
	.local  	i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push7=, 0
	i32.load	$push6=, __stack_pointer($pop7)
	i32.const	$push8=, 32
	i32.sub 	$5=, $pop6, $pop8
	i32.const	$push9=, 0
	i32.store	__stack_pointer($pop9), $5
	i32.const	$push13=, 16
	i32.add 	$push14=, $5, $pop13
	i32.const	$push15=, 12
	i32.add 	$push16=, $5, $pop15
	call    	bmp_iter_set_init@FUNCTION, $pop14, $0, $pop16
	i32.load	$1=, 16($5)
	i32.load	$2=, 24($5)
	i32.load	$0=, 28($5)
	block   	
	block   	
	br_if   	0, $0           # 0: down to label1
# %bb.1:
	i32.const	$6=, 2
	br      	1               # 1: down to label0
.LBB1_2:
	end_block                       # label1:
	i32.const	$6=, 0
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
	block   	
	block   	
	block   	
	br_table 	$6, 1, 0, 4, 5, 6, 7, 10, 11, 12, 8, 9, 13, 2, 3, 3 # 1: down to label28
                                        # 0: down to label29
                                        # 4: down to label25
                                        # 5: down to label24
                                        # 6: down to label23
                                        # 7: down to label22
                                        # 10: down to label19
                                        # 11: down to label18
                                        # 12: down to label17
                                        # 8: down to label21
                                        # 9: down to label20
                                        # 13: down to label16
                                        # 2: down to label27
                                        # 3: down to label26
.LBB1_4:                                # %for.inc
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label29:
	i32.const	$push17=, 1
	i32.shr_u	$0=, $0, $pop17
	i32.eqz 	$push33=, $0
	br_if   	13, $pop33      # 13: down to label15
# %bb.5:                                #   in Loop: Header=BB1_3 Depth=1
	i32.const	$6=, 0
	br      	26              # 26: up to label2
.LBB1_6:                                # %if.then.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label28:
	i32.const	$push18=, 1
	i32.and 	$push0=, $0, $pop18
	br_if   	14, $pop0       # 14: down to label13
# %bb.7:                                #   in Loop: Header=BB1_3 Depth=1
	i32.const	$6=, 12
	br      	25              # 25: up to label2
.LBB1_8:                                # %while.body.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label27:
	i32.const	$push20=, 1
	i32.shr_u	$4=, $0, $pop20
	i32.const	$push19=, 2
	i32.and 	$3=, $0, $pop19
	copy_local	$0=, $4
	i32.eqz 	$push34=, $3
	br_if   	23, $pop34      # 23: down to label3
# %bb.9:                                #   in Loop: Header=BB1_3 Depth=1
	i32.const	$6=, 13
	br      	24              # 24: up to label2
.LBB1_10:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label26:
	copy_local	$0=, $4
	br      	11              # 11: down to label14
.LBB1_11:                               # %if.end.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label25:
	i32.const	$push21=, 1
	i32.add 	$2=, $2, $pop21
# %bb.12:                               #   in Loop: Header=BB1_3 Depth=1
	i32.const	$6=, 3
	br      	22              # 22: up to label2
.LBB1_13:                               # %while.body6.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label24:
	i32.const	$push22=, 2
	i32.eq  	$push1=, $2, $pop22
	br_if   	16, $pop1       # 16: down to label7
# %bb.14:                               #   in Loop: Header=BB1_3 Depth=1
	i32.const	$6=, 4
	br      	21              # 21: up to label2
.LBB1_15:                               # %while.body9.i.preheader
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label23:
	i32.const	$push24=, 2
	i32.shl 	$push2=, $2, $pop24
	i32.add 	$push3=, $1, $pop2
	i32.const	$push23=, 12
	i32.add 	$4=, $pop3, $pop23
# %bb.16:                               #   in Loop: Header=BB1_3 Depth=1
	i32.const	$6=, 5
	br      	20              # 20: up to label2
.LBB1_17:                               # %while.body9.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label22:
	i32.load	$0=, 0($4)
	br_if   	16, $0          # 16: down to label5
# %bb.18:                               #   in Loop: Header=BB1_3 Depth=1
	i32.const	$6=, 9
	br      	19              # 19: up to label2
.LBB1_19:                               # %if.end26.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label21:
	i32.const	$push27=, 4
	i32.add 	$4=, $4, $pop27
	i32.const	$push26=, 1
	i32.add 	$2=, $2, $pop26
	i32.const	$push25=, 2
	i32.ne  	$push5=, $2, $pop25
	br_if   	14, $pop5       # 14: down to label6
# %bb.20:                               #   in Loop: Header=BB1_3 Depth=1
	i32.const	$6=, 10
	br      	18              # 18: up to label2
.LBB1_21:                               # %while.end30.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label20:
	i32.load	$1=, 0($1)
	i32.const	$2=, 0
	br_if   	11, $1          # 11: down to label8
	br      	10              # 10: down to label9
.LBB1_22:                               # %if.then15.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label19:
	i32.const	$push28=, 1
	i32.and 	$push4=, $0, $pop28
	br_if   	8, $pop4        # 8: down to label10
# %bb.23:                               #   in Loop: Header=BB1_3 Depth=1
	i32.const	$6=, 7
	br      	16              # 16: up to label2
.LBB1_24:                               # %while.body21.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label18:
	i32.const	$push30=, 1
	i32.shr_u	$4=, $0, $pop30
	i32.const	$push29=, 2
	i32.and 	$3=, $0, $pop29
	copy_local	$0=, $4
	i32.eqz 	$push35=, $3
	br_if   	13, $pop35      # 13: down to label4
# %bb.25:                               #   in Loop: Header=BB1_3 Depth=1
	i32.const	$6=, 8
	br      	15              # 15: up to label2
.LBB1_26:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label17:
	copy_local	$push32=, $4
	i32.const	$push31=, 1
	i32.shr_u	$0=, $pop32, $pop31
	br_if   	5, $0           # 5: down to label11
	br      	4               # 4: down to label12
.LBB1_27:                               # %for.end
	end_block                       # label16:
	i32.const	$push12=, 0
	i32.const	$push10=, 32
	i32.add 	$push11=, $5, $pop10
	i32.store	__stack_pointer($pop12), $pop11
	return
.LBB1_28:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label15:
	i32.const	$6=, 2
	br      	12              # 12: up to label2
.LBB1_29:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label14:
	i32.const	$6=, 1
	br      	11              # 11: up to label2
.LBB1_30:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label13:
	i32.const	$6=, 1
	br      	10              # 10: up to label2
.LBB1_31:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label12:
	i32.const	$6=, 2
	br      	9               # 9: up to label2
.LBB1_32:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label11:
	i32.const	$6=, 0
	br      	8               # 8: up to label2
.LBB1_33:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label10:
	i32.const	$6=, 1
	br      	7               # 7: up to label2
.LBB1_34:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label9:
	i32.const	$6=, 11
	br      	6               # 6: up to label2
.LBB1_35:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label8:
	i32.const	$6=, 3
	br      	5               # 5: up to label2
.LBB1_36:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label7:
	i32.const	$6=, 10
	br      	4               # 4: up to label2
.LBB1_37:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label6:
	i32.const	$6=, 5
	br      	3               # 3: up to label2
.LBB1_38:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label5:
	i32.const	$6=, 6
	br      	2               # 2: up to label2
.LBB1_39:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label4:
	i32.const	$6=, 7
	br      	1               # 1: up to label2
.LBB1_40:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label3:
	i32.const	$6=, 12
	br      	0               # 0: up to label2
.LBB1_41:
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
# %bb.0:                                # %entry
	i32.const	$push5=, 0
	i32.store	4($0), $pop5
	i32.load	$1=, 0($1)
	i32.store	0($0), $1
	block   	
	br_if   	0, $1           # 0: down to label30
# %bb.1:                                # %if.then
	i32.const	$1=, bitmap_zero_bits
	i32.const	$push6=, bitmap_zero_bits
	i32.store	0($0), $pop6
.LBB2_2:                                # %while.end
	end_block                       # label30:
	i32.const	$push7=, 0
	i32.store	8($0), $pop7
	i32.load	$3=, 12($1)
	i32.store	12($0), $3
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
