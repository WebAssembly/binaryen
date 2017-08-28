	.text
	.file	"pr51933.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
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
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
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
.LBB1_2:                                # %if.end
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
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push16=, 0
	i32.const	$push14=, 0
	i32.load	$push13=, __stack_pointer($pop14)
	i32.const	$push15=, 80
	i32.sub 	$push25=, $pop13, $pop15
	tee_local	$push24=, $2=, $pop25
	i32.store	__stack_pointer($pop16), $pop24
	i32.const	$1=, 0
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.const	$push31=, v3
	i32.add 	$push0=, $1, $pop31
	i32.const	$push30=, 1
	i32.add 	$push29=, $1, $pop30
	tee_local	$push28=, $0=, $pop29
	i32.store8	0($pop0), $pop28
	i32.const	$push27=, v2
	i32.add 	$push1=, $1, $pop27
	i32.store8	0($pop1), $1
	copy_local	$1=, $0
	i32.const	$push26=, 256
	i32.ne  	$push2=, $0, $pop26
	br_if   	0, $pop2        # 0: up to label3
# BB#2:                                 # %for.end
	end_loop
	i64.const	$push3=, 28147922879250529
	i64.store	0($2), $pop3
	i32.const	$push4=, 113
	i32.store	32($2), $pop4
	i64.const	$push5=, 29279337625026661
	i64.store	8($2), $pop5
	i64.const	$push6=, 2336242766266892393
	i64.store	16($2), $pop6
	i64.const	$push7=, 391813644329812077
	i64.store	24($2), $pop7
	call    	foo@FUNCTION
	i32.const	$push8=, 17
	i32.const	$push20=, 48
	i32.add 	$push21=, $2, $pop20
	i32.call	$drop=, bar@FUNCTION, $pop8, $2, $pop21
	block   	
	i32.const	$push22=, 48
	i32.add 	$push23=, $2, $pop22
	i32.const	$push10=, .L.str
	i32.const	$push9=, 18
	i32.call	$push11=, memcmp@FUNCTION, $pop23, $pop10, $pop9
	br_if   	0, $pop11       # 0: down to label4
# BB#3:                                 # %if.end
	i32.const	$push19=, 0
	i32.const	$push17=, 80
	i32.add 	$push18=, $2, $pop17
	i32.store	__stack_pointer($pop19), $pop18
	i32.const	$push12=, 0
	return  	$pop12
.LBB2_4:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	memcmp, i32, i32, i32, i32
	.functype	abort, void
