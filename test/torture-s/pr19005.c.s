	.text
	.file	"pr19005.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push20=, v($pop0)
	tee_local	$push19=, $2=, $pop20
	i32.const	$push18=, 255
	i32.and 	$4=, $pop19, $pop18
	block   	
	block   	
	block   	
	i32.const	$push17=, 0
	i32.load	$push16=, s($pop17)
	tee_local	$push15=, $3=, $pop16
	i32.eqz 	$push22=, $pop15
	br_if   	0, $pop22       # 0: down to label2
# BB#1:                                 # %if.else
	i32.ne  	$push4=, $4, $1
	br_if   	2, $pop4        # 2: down to label0
# BB#2:                                 # %if.else
	i32.const	$push2=, 1
	i32.add 	$push3=, $2, $pop2
	i32.const	$push21=, 255
	i32.and 	$push1=, $pop3, $pop21
	i32.eq  	$push5=, $pop1, $0
	br_if   	1, $pop5        # 1: down to label1
	br      	2               # 2: down to label0
.LBB0_3:                                # %if.then
	end_block                       # label2:
	i32.ne  	$push6=, $4, $0
	br_if   	1, $pop6        # 1: down to label0
# BB#4:                                 # %lor.lhs.false
	i32.const	$push7=, 1
	i32.add 	$push8=, $2, $pop7
	i32.const	$push9=, 255
	i32.and 	$push10=, $pop8, $pop9
	i32.ne  	$push11=, $pop10, $1
	br_if   	1, $pop11       # 1: down to label0
.LBB0_5:                                # %if.end21
	end_block                       # label1:
	i32.const	$push14=, 0
	i32.const	$push12=, 1
	i32.xor 	$push13=, $3, $pop12
	i32.store	s($pop14), $pop13
	return
.LBB0_6:                                # %if.then8
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push23=, 255
	i32.and 	$1=, $0, $pop23
	i32.const	$push0=, 0
	i32.load	$push22=, v($pop0)
	tee_local	$push21=, $2=, $pop22
	i32.const	$push20=, 255
	i32.and 	$4=, $pop21, $pop20
	i32.const	$push19=, 1
	i32.add 	$push1=, $0, $pop19
	i32.const	$push18=, 255
	i32.and 	$0=, $pop1, $pop18
	block   	
	block   	
	block   	
	block   	
	i32.const	$push17=, 0
	i32.load	$push16=, s($pop17)
	tee_local	$push15=, $3=, $pop16
	i32.eqz 	$push35=, $pop15
	br_if   	0, $pop35       # 0: down to label6
# BB#1:                                 # %if.else.i
	i32.ne  	$push3=, $4, $0
	br_if   	3, $pop3        # 3: down to label3
# BB#2:                                 # %if.else.i
	i32.const	$push27=, 1
	i32.add 	$push2=, $2, $pop27
	i32.const	$push26=, 255
	i32.and 	$push25=, $pop2, $pop26
	tee_local	$push24=, $2=, $pop25
	i32.ne  	$push4=, $pop24, $1
	br_if   	3, $pop4        # 3: down to label3
# BB#3:                                 # %bar.exit
	i32.const	$push6=, 0
	i32.const	$push5=, 1
	i32.xor 	$push29=, $3, $pop5
	tee_local	$push28=, $5=, $pop29
	i32.store	s($pop6), $pop28
	br_if   	1, $5           # 1: down to label5
	br      	2               # 2: down to label4
.LBB1_4:                                # %if.then.i
	end_block                       # label6:
	i32.ne  	$push7=, $4, $1
	br_if   	2, $pop7        # 2: down to label3
# BB#5:                                 # %lor.lhs.false.i
	i32.const	$push32=, 1
	i32.add 	$push8=, $2, $pop32
	i32.const	$push9=, 255
	i32.and 	$push31=, $pop8, $pop9
	tee_local	$push30=, $2=, $pop31
	i32.ne  	$push10=, $pop30, $0
	br_if   	2, $pop10       # 2: down to label3
# BB#6:                                 # %bar.exit.thread
	i32.const	$push11=, 0
	i32.const	$push33=, 1
	i32.store	s($pop11), $pop33
.LBB1_7:                                # %if.else.i40
	end_block                       # label5:
	i32.ne  	$push12=, $4, $1
	br_if   	1, $pop12       # 1: down to label3
# BB#8:                                 # %if.else.i40
	i32.ne  	$push13=, $2, $0
	br_if   	1, $pop13       # 1: down to label3
.LBB1_9:                                # %bar.exit43
	end_block                       # label4:
	i32.const	$push14=, 0
	i32.store	s($pop14), $3
	i32.const	$push34=, 0
	return  	$pop34
.LBB1_10:                               # %if.then8.i
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push6=, 0
	i32.const	$push0=, -10
	i32.store	v($pop6), $pop0
	i32.const	$push5=, 0
	i32.load	$0=, s($pop5)
	i32.const	$2=, -11
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label8:
	i32.const	$push8=, 2
	i32.add 	$1=, $2, $pop8
	i32.const	$push7=, 1
	i32.add 	$2=, $2, $pop7
	block   	
	i32.eqz 	$push12=, $0
	br_if   	0, $pop12       # 0: down to label9
# BB#2:                                 # %if.else.i.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.xor 	$push1=, $1, $2
	i32.const	$push9=, 255
	i32.and 	$push2=, $pop1, $pop9
	br_if   	2, $pop2        # 2: down to label7
.LBB2_3:                                # %foo.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label9:
	i32.const	$push11=, 0
	i32.store	v($pop11), $1
	i32.const	$push10=, 265
	i32.lt_s	$push3=, $2, $pop10
	br_if   	0, $pop3        # 0: up to label8
# BB#4:                                 # %for.end
	end_loop
	i32.const	$push4=, 0
	return  	$pop4
.LBB2_5:                                # %if.then19.i.i
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	v                       # @v
	.type	v,@object
	.section	.bss.v,"aw",@nobits
	.globl	v
	.p2align	2
v:
	.int32	0                       # 0x0
	.size	v, 4

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.p2align	2
s:
	.int32	0                       # 0x0
	.size	s, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
