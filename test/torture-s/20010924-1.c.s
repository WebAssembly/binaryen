	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010924-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block
	i32.load8_u	$push0=, a1($1)
	i32.const	$push1=, 52
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, 0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.load	$0=, a1+4($1)
	block
	i32.load8_u	$push3=, 0($0)
	i32.const	$push4=, 54
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	$pop5, 0        # 0: down to label1
# BB#2:                                 # %if.end6
	block
	i32.load8_u	$push6=, 1($0)
	i32.const	$push7=, 50
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	$pop8, 0        # 0: down to label2
# BB#3:                                 # %if.end12
	block
	i32.load8_u	$push9=, 2($0)
	br_if   	$pop9, 0        # 0: down to label3
# BB#4:                                 # %if.end18
	block
	i32.load8_u	$push10=, a2($1)
	i32.const	$push11=, 118
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	$pop12, 0       # 0: down to label4
# BB#5:                                 # %if.end23
	block
	i32.load8_u	$push13=, a2+1($1)
	i32.const	$push14=, 99
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	$pop15, 0       # 0: down to label5
# BB#6:                                 # %if.end28
	block
	i32.load8_u	$push16=, a2+2($1)
	i32.const	$push17=, 113
	i32.ne  	$push18=, $pop16, $pop17
	br_if   	$pop18, 0       # 0: down to label6
# BB#7:                                 # %if.end33
	block
	i32.load8_u	$push19=, a3($1)
	i32.const	$push20=, 111
	i32.ne  	$push21=, $pop19, $pop20
	br_if   	$pop21, 0       # 0: down to label7
# BB#8:                                 # %if.end38
	block
	i32.load8_u	$push22=, a3+1($1)
	i32.const	$push23=, 119
	i32.ne  	$push24=, $pop22, $pop23
	br_if   	$pop24, 0       # 0: down to label8
# BB#9:                                 # %if.end43
	block
	i32.load8_u	$push25=, a3+2($1)
	i32.const	$push26=, 120
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	$pop27, 0       # 0: down to label9
# BB#10:                                # %if.end48
	block
	i32.load8_u	$push28=, a4($1)
	i32.const	$push29=, 57
	i32.ne  	$push30=, $pop28, $pop29
	br_if   	$pop30, 0       # 0: down to label10
# BB#11:                                # %if.end53
	block
	i32.load8_u	$push31=, a4+1($1)
	i32.const	$push32=, 101
	i32.ne  	$push33=, $pop31, $pop32
	br_if   	$pop33, 0       # 0: down to label11
# BB#12:                                # %if.end58
	block
	i32.load8_u	$push34=, a4+2($1)
	i32.const	$push35=, 98
	i32.ne  	$push36=, $pop34, $pop35
	br_if   	$pop36, 0       # 0: down to label12
# BB#13:                                # %if.end63
	return  	$1
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
	.align	2
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
