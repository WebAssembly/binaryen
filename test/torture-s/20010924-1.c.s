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
	i32.const	$push38=, 0
	i32.load8_u	$push1=, a1($pop38):p2align=2
	i32.const	$push2=, 52
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, 0        # 0: down to label0
# BB#1:                                 # %if.end
	block
	i32.const	$push40=, 0
	i32.load	$push0=, a1+4($pop40)
	tee_local	$push39=, $0=, $pop0
	i32.load8_u	$push4=, 0($pop39)
	i32.const	$push5=, 54
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	$pop6, 0        # 0: down to label1
# BB#2:                                 # %if.end6
	block
	i32.load8_u	$push7=, 1($0)
	i32.const	$push8=, 50
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	$pop9, 0        # 0: down to label2
# BB#3:                                 # %if.end12
	block
	i32.load8_u	$push10=, 2($0)
	br_if   	$pop10, 0       # 0: down to label3
# BB#4:                                 # %if.end18
	block
	i32.const	$push41=, 0
	i32.load8_u	$push11=, a2($pop41)
	i32.const	$push12=, 118
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	$pop13, 0       # 0: down to label4
# BB#5:                                 # %if.end23
	block
	i32.const	$push42=, 0
	i32.load8_u	$push14=, a2+1($pop42)
	i32.const	$push15=, 99
	i32.ne  	$push16=, $pop14, $pop15
	br_if   	$pop16, 0       # 0: down to label5
# BB#6:                                 # %if.end28
	block
	i32.const	$push43=, 0
	i32.load8_u	$push17=, a2+2($pop43)
	i32.const	$push18=, 113
	i32.ne  	$push19=, $pop17, $pop18
	br_if   	$pop19, 0       # 0: down to label6
# BB#7:                                 # %if.end33
	block
	i32.const	$push44=, 0
	i32.load8_u	$push20=, a3($pop44)
	i32.const	$push21=, 111
	i32.ne  	$push22=, $pop20, $pop21
	br_if   	$pop22, 0       # 0: down to label7
# BB#8:                                 # %if.end38
	block
	i32.const	$push45=, 0
	i32.load8_u	$push23=, a3+1($pop45)
	i32.const	$push24=, 119
	i32.ne  	$push25=, $pop23, $pop24
	br_if   	$pop25, 0       # 0: down to label8
# BB#9:                                 # %if.end43
	block
	i32.const	$push46=, 0
	i32.load8_u	$push26=, a3+2($pop46)
	i32.const	$push27=, 120
	i32.ne  	$push28=, $pop26, $pop27
	br_if   	$pop28, 0       # 0: down to label9
# BB#10:                                # %if.end48
	block
	i32.const	$push47=, 0
	i32.load8_u	$push29=, a4($pop47)
	i32.const	$push30=, 57
	i32.ne  	$push31=, $pop29, $pop30
	br_if   	$pop31, 0       # 0: down to label10
# BB#11:                                # %if.end53
	block
	i32.const	$push48=, 0
	i32.load8_u	$push32=, a4+1($pop48)
	i32.const	$push33=, 101
	i32.ne  	$push34=, $pop32, $pop33
	br_if   	$pop34, 0       # 0: down to label11
# BB#12:                                # %if.end58
	block
	i32.const	$push49=, 0
	i32.load8_u	$push35=, a4+2($pop49)
	i32.const	$push36=, 98
	i32.ne  	$push37=, $pop35, $pop36
	br_if   	$pop37, 0       # 0: down to label12
# BB#13:                                # %if.end63
	i32.const	$push50=, 0
	return  	$pop50
.LBB0_14:                               # %if.then62
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
.LBB0_15:                               # %if.then57
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB0_16:                               # %if.then52
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB0_17:                               # %if.then47
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB0_18:                               # %if.then42
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB0_19:                               # %if.then37
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB0_20:                               # %if.then32
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB0_21:                               # %if.then27
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB0_22:                               # %if.then22
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_23:                               # %if.then17
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_24:                               # %if.then11
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_25:                               # %if.then5
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_26:                               # %if.then
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
