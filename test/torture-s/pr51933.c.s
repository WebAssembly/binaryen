	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr51933.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	#APP
	#NO_APP
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 0
	i32.load8_u	$push1=, v1($pop0)
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.then
	call    	foo@FUNCTION
.LBB1_2:                                # %for.cond.preheader
	end_block                       # label0:
	block   	
	i32.const	$push11=, 1
	i32.lt_s	$push2=, $0, $pop11
	br_if   	0, $pop2        # 0: down to label1
# BB#3:                                 # %for.body.preheader
	copy_local	$4=, $0
	copy_local	$5=, $2
.LBB1_4:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.load16_u	$push22=, 0($1)
	tee_local	$push21=, $3=, $pop22
	i32.const	$push20=, v2
	i32.add 	$push4=, $pop21, $pop20
	i32.const	$push19=, 255
	i32.and 	$push5=, $3, $pop19
	i32.const	$push18=, v3
	i32.add 	$push6=, $pop5, $pop18
	i32.const	$push17=, 256
	i32.lt_u	$push3=, $3, $pop17
	i32.select	$push7=, $pop4, $pop6, $pop3
	i32.load8_u	$push8=, 0($pop7)
	i32.store8	0($5), $pop8
	i32.const	$push16=, 1
	i32.add 	$5=, $5, $pop16
	i32.const	$push15=, 2
	i32.add 	$1=, $1, $pop15
	i32.const	$push14=, -1
	i32.add 	$push13=, $4, $pop14
	tee_local	$push12=, $4=, $pop13
	br_if   	0, $pop12       # 0: up to label2
.LBB1_5:                                # %for.end
	end_loop
	end_block                       # label1:
	i32.add 	$push9=, $2, $0
	i32.const	$push10=, 0
	i32.store8	0($pop9), $pop10
	copy_local	$push23=, $0
                                        # fallthrough-return: $pop23
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push24=, 0
	i32.const	$push21=, 0
	i32.load	$push22=, __stack_pointer($pop21)
	i32.const	$push23=, 80
	i32.sub 	$push33=, $pop22, $pop23
	tee_local	$push32=, $2=, $pop33
	i32.store	__stack_pointer($pop24), $pop32
	i32.const	$1=, 0
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.const	$push39=, v3
	i32.add 	$push0=, $1, $pop39
	i32.const	$push38=, 1
	i32.add 	$push37=, $1, $pop38
	tee_local	$push36=, $0=, $pop37
	i32.store8	0($pop0), $pop36
	i32.const	$push35=, v2
	i32.add 	$push1=, $1, $pop35
	i32.store8	0($pop1), $1
	copy_local	$1=, $0
	i32.const	$push34=, 256
	i32.ne  	$push2=, $0, $pop34
	br_if   	0, $pop2        # 0: up to label3
# BB#2:                                 # %for.body6.preheader
	end_loop
	i32.const	$push3=, 101
	i32.store16	8($2), $pop3
	i64.const	$push4=, 28147922879250529
	i64.store	0($2), $pop4
	i32.const	$push5=, 104
	i32.store16	14($2), $pop5
	i32.const	$push6=, 105
	i32.store16	16($2), $pop6
	i32.const	$push7=, 106
	i32.store16	18($2), $pop7
	i32.const	$push8=, 107
	i32.store16	20($2), $pop8
	i32.const	$push9=, 109
	i32.store16	24($2), $pop9
	i32.const	$push10=, 110
	i32.store16	26($2), $pop10
	i32.const	$push11=, 111
	i32.store16	28($2), $pop11
	i32.const	$push12=, 113
	i32.store16	32($2), $pop12
	i32.const	$push40=, 0
	i32.store16	34($2), $pop40
	i32.const	$push13=, 1638
	i32.store16	10($2), $pop13
	i32.const	$push14=, 1383
	i32.store16	12($2), $pop14
	i32.const	$push15=, 8300
	i32.store16	22($2), $pop15
	i32.const	$push16=, 1392
	i32.store16	30($2), $pop16
	call    	foo@FUNCTION
	i32.const	$push17=, 17
	i32.const	$push28=, 48
	i32.add 	$push29=, $2, $pop28
	i32.call	$drop=, bar@FUNCTION, $pop17, $2, $pop29
	block   	
	i32.const	$push30=, 48
	i32.add 	$push31=, $2, $pop30
	i32.const	$push19=, .L.str
	i32.const	$push18=, 18
	i32.call	$push20=, memcmp@FUNCTION, $pop31, $pop19, $pop18
	br_if   	0, $pop20       # 0: down to label4
# BB#3:                                 # %if.end
	i32.const	$push27=, 0
	i32.const	$push25=, 80
	i32.add 	$push26=, $2, $pop25
	i32.store	__stack_pointer($pop27), $pop26
	i32.const	$push41=, 0
	return  	$pop41
.LBB2_4:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	v1,@object              # @v1
	.section	.bss.v1,"aw",@nobits
v1:
	.int8	0                       # 0x0
	.size	v1, 1

	.type	v2,@object              # @v2
	.section	.bss.v2,"aw",@nobits
	.p2align	4
v2:
	.skip	256
	.size	v2, 256

	.type	v3,@object              # @v3
	.section	.bss.v3,"aw",@nobits
	.p2align	4
v3:
	.skip	256
	.size	v3, 256

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"abcdeghhijkmmnoqq"
	.size	.L.str, 18


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	memcmp, i32, i32, i32, i32
	.functype	abort, void
