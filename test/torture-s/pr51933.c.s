	.text
	.file	"pr51933.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# %bb.0:                                # %entry
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
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 0
	i32.load8_u	$push1=, v1($pop0)
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %if.then
	call    	foo@FUNCTION
.LBB1_2:                                # %if.end
	end_block                       # label0:
	block   	
	i32.const	$push11=, 1
	i32.lt_s	$push2=, $0, $pop11
	br_if   	0, $pop2        # 0: down to label1
# %bb.3:                                # %for.body.preheader
	copy_local	$4=, $0
	copy_local	$5=, $2
.LBB1_4:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.load16_u	$3=, 0($1)
	i32.const	$push18=, v2
	i32.add 	$push4=, $3, $pop18
	i32.const	$push17=, 255
	i32.and 	$push5=, $3, $pop17
	i32.const	$push16=, v3
	i32.add 	$push6=, $pop5, $pop16
	i32.const	$push15=, 256
	i32.lt_u	$push3=, $3, $pop15
	i32.select	$push7=, $pop4, $pop6, $pop3
	i32.load8_u	$push8=, 0($pop7)
	i32.store8	0($5), $pop8
	i32.const	$push14=, -1
	i32.add 	$4=, $4, $pop14
	i32.const	$push13=, 1
	i32.add 	$5=, $5, $pop13
	i32.const	$push12=, 2
	i32.add 	$1=, $1, $pop12
	br_if   	0, $4           # 0: up to label2
.LBB1_5:                                # %for.end
	end_loop
	end_block                       # label1:
	i32.add 	$push9=, $2, $0
	i32.const	$push10=, 0
	i32.store8	0($pop9), $pop10
	copy_local	$push19=, $0
                                        # fallthrough-return: $pop19
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
# %bb.0:                                # %entry
	i32.const	$push14=, 0
	i32.load	$push13=, __stack_pointer($pop14)
	i32.const	$push15=, 80
	i32.sub 	$2=, $pop13, $pop15
	i32.const	$push16=, 0
	i32.store	__stack_pointer($pop16), $2
	i32.const	$1=, 0
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.const	$push27=, 1
	i32.add 	$0=, $1, $pop27
	i32.const	$push26=, v3
	i32.add 	$push0=, $1, $pop26
	i32.store8	0($pop0), $0
	i32.const	$push25=, v2
	i32.add 	$push1=, $1, $pop25
	i32.store8	0($pop1), $1
	copy_local	$1=, $0
	i32.const	$push24=, 256
	i32.ne  	$push2=, $0, $pop24
	br_if   	0, $pop2        # 0: up to label3
# %bb.2:                                # %for.end
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
# %bb.3:                                # %if.end
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	memcmp, i32, i32, i32, i32
	.functype	abort, void
