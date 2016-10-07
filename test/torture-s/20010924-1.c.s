	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010924-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push37=, 0
	i32.load8_u	$push0=, a1($pop37)
	i32.const	$push1=, 52
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push40=, 0
	i32.load	$push39=, a1+4($pop40)
	tee_local	$push38=, $0=, $pop39
	i32.load8_u	$push3=, 0($pop38)
	i32.const	$push4=, 54
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#2:                                 # %if.end6
	i32.load8_u	$push6=, 1($0)
	i32.const	$push7=, 50
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#3:                                 # %if.end12
	i32.load8_u	$push9=, 2($0)
	br_if   	0, $pop9        # 0: down to label0
# BB#4:                                 # %if.end18
	i32.const	$push41=, 0
	i32.load8_u	$push10=, a2($pop41)
	i32.const	$push11=, 118
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label0
# BB#5:                                 # %if.end23
	i32.const	$push42=, 0
	i32.load8_u	$push13=, a2+1($pop42)
	i32.const	$push14=, 99
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	0, $pop15       # 0: down to label0
# BB#6:                                 # %if.end28
	i32.const	$push43=, 0
	i32.load8_u	$push16=, a2+2($pop43)
	i32.const	$push17=, 113
	i32.ne  	$push18=, $pop16, $pop17
	br_if   	0, $pop18       # 0: down to label0
# BB#7:                                 # %if.end33
	i32.const	$push44=, 0
	i32.load8_u	$push19=, a3($pop44)
	i32.const	$push20=, 111
	i32.ne  	$push21=, $pop19, $pop20
	br_if   	0, $pop21       # 0: down to label0
# BB#8:                                 # %if.end38
	i32.const	$push45=, 0
	i32.load8_u	$push22=, a3+1($pop45)
	i32.const	$push23=, 119
	i32.ne  	$push24=, $pop22, $pop23
	br_if   	0, $pop24       # 0: down to label0
# BB#9:                                 # %if.end43
	i32.const	$push46=, 0
	i32.load8_u	$push25=, a3+2($pop46)
	i32.const	$push26=, 120
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	0, $pop27       # 0: down to label0
# BB#10:                                # %if.end48
	i32.const	$push47=, 0
	i32.load8_u	$push28=, a4($pop47)
	i32.const	$push29=, 57
	i32.ne  	$push30=, $pop28, $pop29
	br_if   	0, $pop30       # 0: down to label0
# BB#11:                                # %if.end53
	i32.const	$push48=, 0
	i32.load8_u	$push31=, a4+1($pop48)
	i32.const	$push32=, 101
	i32.ne  	$push33=, $pop31, $pop32
	br_if   	0, $pop33       # 0: down to label0
# BB#12:                                # %if.end58
	i32.const	$push49=, 0
	i32.load8_u	$push34=, a4+2($pop49)
	i32.const	$push35=, 98
	i32.ne  	$push36=, $pop34, $pop35
	br_if   	0, $pop36       # 0: down to label0
# BB#13:                                # %if.end63
	i32.const	$push50=, 0
	return  	$pop50
.LBB0_14:                               # %if.then62
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
