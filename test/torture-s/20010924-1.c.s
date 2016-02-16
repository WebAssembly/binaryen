	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010924-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
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
	i32.const	$push37=, 0
	i32.load8_u	$push0=, a1($pop37):p2align=2
	i32.const	$push1=, 52
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label12
# BB#1:                                 # %if.end
	i32.const	$push40=, 0
	i32.load	$push39=, a1+4($pop40)
	tee_local	$push38=, $0=, $pop39
	i32.load8_u	$push3=, 0($pop38)
	i32.const	$push4=, 54
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	1, $pop5        # 1: down to label11
# BB#2:                                 # %if.end6
	i32.load8_u	$push6=, 1($0)
	i32.const	$push7=, 50
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	2, $pop8        # 2: down to label10
# BB#3:                                 # %if.end12
	i32.load8_u	$push9=, 2($0)
	br_if   	3, $pop9        # 3: down to label9
# BB#4:                                 # %if.end18
	i32.const	$push41=, 0
	i32.load8_u	$push10=, a2($pop41)
	i32.const	$push11=, 118
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	4, $pop12       # 4: down to label8
# BB#5:                                 # %if.end23
	i32.const	$push42=, 0
	i32.load8_u	$push13=, a2+1($pop42)
	i32.const	$push14=, 99
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	5, $pop15       # 5: down to label7
# BB#6:                                 # %if.end28
	i32.const	$push43=, 0
	i32.load8_u	$push16=, a2+2($pop43)
	i32.const	$push17=, 113
	i32.ne  	$push18=, $pop16, $pop17
	br_if   	6, $pop18       # 6: down to label6
# BB#7:                                 # %if.end33
	i32.const	$push44=, 0
	i32.load8_u	$push19=, a3($pop44)
	i32.const	$push20=, 111
	i32.ne  	$push21=, $pop19, $pop20
	br_if   	7, $pop21       # 7: down to label5
# BB#8:                                 # %if.end38
	i32.const	$push45=, 0
	i32.load8_u	$push22=, a3+1($pop45)
	i32.const	$push23=, 119
	i32.ne  	$push24=, $pop22, $pop23
	br_if   	8, $pop24       # 8: down to label4
# BB#9:                                 # %if.end43
	i32.const	$push46=, 0
	i32.load8_u	$push25=, a3+2($pop46)
	i32.const	$push26=, 120
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	9, $pop27       # 9: down to label3
# BB#10:                                # %if.end48
	i32.const	$push47=, 0
	i32.load8_u	$push28=, a4($pop47)
	i32.const	$push29=, 57
	i32.ne  	$push30=, $pop28, $pop29
	br_if   	10, $pop30      # 10: down to label2
# BB#11:                                # %if.end53
	i32.const	$push48=, 0
	i32.load8_u	$push31=, a4+1($pop48)
	i32.const	$push32=, 101
	i32.ne  	$push33=, $pop31, $pop32
	br_if   	11, $pop33      # 11: down to label1
# BB#12:                                # %if.end58
	i32.const	$push49=, 0
	i32.load8_u	$push34=, a4+2($pop49)
	i32.const	$push35=, 98
	i32.ne  	$push36=, $pop34, $pop35
	br_if   	12, $pop36      # 12: down to label0
# BB#13:                                # %if.end63
	i32.const	$push50=, 0
	return  	$pop50
.LBB0_14:                               # %if.then
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
.LBB0_15:                               # %if.then5
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB0_16:                               # %if.then11
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB0_17:                               # %if.then17
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB0_18:                               # %if.then22
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB0_19:                               # %if.then27
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB0_20:                               # %if.then32
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB0_21:                               # %if.then37
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB0_22:                               # %if.then42
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_23:                               # %if.then47
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_24:                               # %if.then52
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_25:                               # %if.then57
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_26:                               # %if.then62
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"62"
	.size	.L.str, 3

	.hidden	a1                      # @a1
	.type	a1,@object
	.section	.data.a1,"aw",@progbits
	.globl	a1
	.p2align	2
a1:
	.int8	52                      # 0x34
	.skip	3
	.int32	.L.str
	.size	a1, 8

	.hidden	a2                      # @a2
	.type	a2,@object
	.section	.data.a2,"aw",@progbits
	.globl	a2
a2:
	.int8	118                     # 0x76
	.ascii	"cq"
	.size	a2, 3

	.hidden	a3                      # @a3
	.type	a3,@object
	.section	.data.a3,"aw",@progbits
	.globl	a3
a3:
	.int8	111                     # 0x6f
	.asciz	"wx"
	.size	a3, 4

	.hidden	a4                      # @a4
	.type	a4,@object
	.section	.data.a4,"aw",@progbits
	.globl	a4
a4:
	.int8	57                      # 0x39
	.ascii	"eb"
	.size	a4, 3


	.ident	"clang version 3.9.0 "
