	.text
	.file	"pr56205.c"
	.section	.text.f4,"ax",@progbits
	.hidden	f4                      # -- Begin function f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i32, i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push16=, 0
	i32.const	$push14=, 0
	i32.load	$push13=, __stack_pointer($pop14)
	i32.const	$push15=, 32
	i32.sub 	$push23=, $pop13, $pop15
	tee_local	$push22=, $5=, $pop23
	i32.store	__stack_pointer($pop16), $pop22
	i32.store	28($5), $2
	block   	
	br_if   	0, $0           # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push24=, 0
	i32.load8_u	$push0=, c($pop24)
	i32.const	$push1=, 255
	i32.and 	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#2:                                 # %if.then
	i32.const	$push3=, 0
	i32.const	$push25=, 0
	i32.load	$push4=, b($pop25)
	i32.const	$push5=, 1
	i32.add 	$push6=, $pop4, $pop5
	i32.store	b($pop3), $pop6
.LBB0_3:                                # %if.end
	end_block                       # label0:
	i32.const	$push30=, 0
	i32.const	$push29=, 0
	i32.load	$push7=, a($pop29)
	i32.const	$push8=, 1
	i32.add 	$push28=, $pop7, $pop8
	tee_local	$push27=, $2=, $pop28
	i32.store	a($pop30), $pop27
	i32.const	$push26=, .L.str.3
	i32.const	$push9=, .L.str.1
	i32.select	$0=, $pop26, $pop9, $0
	block   	
	block   	
	i32.eqz 	$push33=, $1
	br_if   	0, $pop33       # 0: down to label2
# BB#4:                                 # %land.rhs.i
	i32.load	$3=, 28($5)
	i32.load8_u	$4=, 0($1)
	i32.store	20($5), $2
	i32.store	16($5), $0
	i32.const	$push10=, .L.str.4
	i32.const	$push31=, .L.str.3
	i32.select	$push11=, $pop10, $pop31, $4
	i32.store	24($5), $pop11
	i32.const	$push20=, 16
	i32.add 	$push21=, $5, $pop20
	call    	f1@FUNCTION, $5, $pop21
	i32.load8_u	$push12=, 0($1)
	i32.eqz 	$push34=, $pop12
	br_if   	1, $pop34       # 1: down to label1
# BB#5:                                 # %if.then.i
	call    	f2@FUNCTION, $1, $3
	br      	1               # 1: down to label1
.LBB0_6:                                # %if.end.critedge.i
	end_block                       # label2:
	i32.const	$push32=, .L.str.3
	i32.store	8($5), $pop32
	i32.store	4($5), $2
	i32.store	0($5), $0
	call    	f1@FUNCTION, $5, $5
.LBB0_7:                                # %f3.exit
	end_block                       # label1:
	i32.const	$push19=, 0
	i32.const	$push17=, 32
	i32.add 	$push18=, $5, $pop17
	i32.store	__stack_pointer($pop19), $pop18
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	f4, .Lfunc_end0-f4
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push14=, 0
	i32.const	$push12=, 0
	i32.load	$push11=, __stack_pointer($pop12)
	i32.const	$push13=, 32
	i32.sub 	$push22=, $pop11, $pop13
	tee_local	$push21=, $0=, $pop22
	i32.store	__stack_pointer($pop14), $pop21
	#APP
	#NO_APP
	i32.const	$push1=, 16
	i32.add 	$push2=, $0, $pop1
	i32.const	$push3=, 26
	i32.store	0($pop2), $pop3
	i64.const	$push4=, 4622945017495814144
	i64.store	8($0), $pop4
	i32.const	$push5=, .L.str.1
	i32.store	0($0), $pop5
	i32.const	$push20=, 0
	i32.const	$push6=, .L.str
	call    	f4@FUNCTION, $pop20, $pop6, $0
	block   	
	i32.const	$push19=, 0
	i32.load	$push7=, a($pop19)
	i32.const	$push18=, 1
	i32.ne  	$push8=, $pop7, $pop18
	br_if   	0, $pop8        # 0: down to label3
# BB#1:                                 # %entry
	i32.const	$push24=, 0
	i32.load	$push0=, b($pop24)
	i32.const	$push23=, 1
	i32.ne  	$push9=, $pop0, $pop23
	br_if   	0, $pop9        # 0: down to label3
# BB#2:                                 # %if.end
	i32.const	$push17=, 0
	i32.const	$push15=, 32
	i32.add 	$push16=, $0, $pop15
	i32.store	__stack_pointer($pop17), $pop16
	i32.const	$push10=, 0
	return  	$pop10
.LBB1_3:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.section	.text.f1,"ax",@progbits
	.type	f1,@function            # -- Begin function f1
f1:                                     # @f1
	.param  	i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push16=, 0
	i32.const	$push14=, 0
	i32.load	$push13=, __stack_pointer($pop14)
	i32.const	$push15=, 16
	i32.sub 	$push23=, $pop13, $pop15
	tee_local	$push22=, $4=, $pop23
	i32.store	__stack_pointer($pop16), $pop22
	#APP
	#NO_APP
	i32.const	$push0=, 4
	i32.add 	$push21=, $1, $pop0
	tee_local	$push20=, $2=, $pop21
	i32.store	12($4), $pop20
	block   	
	i32.load	$push1=, 0($1)
	i32.const	$push2=, .L.str.1
	i32.call	$push3=, strcmp@FUNCTION, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label4
# BB#1:                                 # %lor.lhs.false
	i32.const	$push4=, 8
	i32.add 	$push25=, $1, $pop4
	tee_local	$push24=, $3=, $pop25
	i32.store	12($4), $pop24
	i32.load	$push5=, 0($2)
	i32.const	$push6=, 1
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label4
# BB#2:                                 # %lor.lhs.false7
	i32.const	$push8=, 12
	i32.add 	$push9=, $1, $pop8
	i32.store	12($4), $pop9
	i32.load	$push10=, 0($3)
	i32.const	$push11=, .L.str.4
	i32.call	$push12=, strcmp@FUNCTION, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label4
# BB#3:                                 # %if.end13
	i32.const	$push19=, 0
	i32.const	$push17=, 16
	i32.add 	$push18=, $4, $pop17
	i32.store	__stack_pointer($pop19), $pop18
	return
.LBB2_4:                                # %if.then12
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	f1, .Lfunc_end2-f1
                                        # -- End function
	.section	.text.f2,"ax",@progbits
	.type	f2,@function            # -- Begin function f2
f2:                                     # @f2
	.param  	i32, i32
# BB#0:                                 # %entry
	#APP
	#NO_APP
	block   	
	i32.const	$push0=, .L.str
	i32.call	$push1=, strcmp@FUNCTION, $0, $pop0
	br_if   	0, $pop1        # 0: down to label5
# BB#1:                                 # %lor.lhs.false
	i32.load	$push2=, 0($1)
	i32.const	$push3=, .L.str.1
	i32.call	$push4=, strcmp@FUNCTION, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label5
# BB#2:                                 # %lor.lhs.false3
	i32.const	$push5=, 11
	i32.add 	$push6=, $1, $pop5
	i32.const	$push7=, -8
	i32.and 	$push15=, $pop6, $pop7
	tee_local	$push14=, $1=, $pop15
	f64.load	$push8=, 0($pop14)
	f64.const	$push9=, 0x1.8p3
	f64.ne  	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label5
# BB#3:                                 # %lor.lhs.false7
	i32.load	$push11=, 8($1)
	i32.const	$push12=, 26
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label5
# BB#4:                                 # %if.end
	return
.LBB3_5:                                # %if.then
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	f2, .Lfunc_end3-f2
                                        # -- End function
	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	4
c:
	.skip	128
	.size	c, 128

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"baz"
	.size	.L.str, 4

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"foo"
	.size	.L.str.1, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.type	.L.str.3,@object        # @.str.3
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.3:
	.skip	1
	.size	.L.str.3, 1

	.type	.L.str.4,@object        # @.str.4
.L.str.4:
	.asciz	"bar"
	.size	.L.str.4, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	strcmp, i32, i32, i32
