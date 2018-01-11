	.text
	.file	"20050224-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 245
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %entry
	i32.const	$push2=, 36
	i32.ne  	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.2:                                # %entry
	i32.const	$push4=, 444
	i32.ne  	$push5=, $2, $pop4
	br_if   	0, $pop5        # 0: down to label0
# %bb.3:                                # %if.end
	return
.LBB0_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$8=, 0
	i32.const	$push14=, 0
	i32.load	$0=, b($pop14)
	i32.const	$push13=, 0
	i32.load	$5=, a($pop13)
	block   	
	i32.ge_u	$push0=, $5, $0
	br_if   	0, $pop0        # 0: down to label1
# %bb.1:                                # %for.body.lr.ph
	i32.const	$push18=, 0
	i32.load	$4=, f($pop18)
	i32.const	$push17=, 0
	i32.load	$3=, e($pop17)
	i32.const	$push16=, 0
	i32.load	$2=, d($pop16)
	i32.const	$push15=, 0
	i32.load	$1=, c($pop15)
	i32.const	$7=, 0
	i32.const	$6=, 0
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	block   	
	block   	
	i32.ge_u	$push1=, $5, $1
	br_if   	0, $pop1        # 0: down to label4
# %bb.3:                                # %if.then
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push19=, 1
	i32.add 	$6=, $6, $pop19
	br      	1               # 1: down to label3
.LBB1_4:                                # %if.else
                                        #   in Loop: Header=BB1_2 Depth=1
	end_block                       # label4:
	block   	
	i32.lt_u	$push2=, $5, $2
	br_if   	0, $pop2        # 0: down to label5
# %bb.5:                                # %if.else
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.ge_u	$push3=, $5, $3
	br_if   	0, $pop3        # 0: down to label5
# %bb.6:                                # %if.then4
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push20=, 1
	i32.add 	$8=, $8, $pop20
	br      	1               # 1: down to label3
.LBB1_7:                                # %if.else6
                                        #   in Loop: Header=BB1_2 Depth=1
	end_block                       # label5:
	i32.lt_u	$push4=, $5, $4
	i32.add 	$7=, $7, $pop4
.LBB1_8:                                # %for.inc
                                        #   in Loop: Header=BB1_2 Depth=1
	end_block                       # label3:
	i32.const	$push21=, 4096
	i32.add 	$5=, $5, $pop21
	i32.lt_u	$push5=, $5, $0
	br_if   	0, $pop5        # 0: up to label2
# %bb.9:                                # %for.end
	end_loop
	i32.const	$push6=, 444
	i32.ne  	$push7=, $6, $pop6
	br_if   	0, $pop7        # 0: down to label1
# %bb.10:                               # %for.end
	i32.const	$push8=, 245
	i32.ne  	$push9=, $7, $pop8
	br_if   	0, $pop9        # 0: down to label1
# %bb.11:                               # %for.end
	i32.const	$push10=, 36
	i32.ne  	$push11=, $8, $pop10
	br_if   	0, $pop11       # 0: down to label1
# %bb.12:                               # %foo.exit
	i32.const	$push12=, 0
	return  	$pop12
.LBB1_13:                               # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	2
a:
	.int32	3221225472              # 0xc0000000
	.size	a, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.data.b,"aw",@progbits
	.globl	b
	.p2align	2
b:
	.int32	3489660928              # 0xd0000000
	.size	b, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.data.c,"aw",@progbits
	.globl	c
	.p2align	2
c:
	.int32	3223042392              # 0xc01bb958
	.size	c, 4

	.hidden	d                       # @d
	.type	d,@object
	.section	.data.d,"aw",@progbits
	.globl	d
	.p2align	2
d:
	.int32	3223732224              # 0xc0264000
	.size	d, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.data.e,"aw",@progbits
	.globl	e
	.p2align	2
e:
	.int32	3223879680              # 0xc0288000
	.size	e, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.data.f,"aw",@progbits
	.globl	f
	.p2align	2
f:
	.int32	3224191864              # 0xc02d4378
	.size	f, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
