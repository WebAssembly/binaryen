	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr19005.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
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

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push24=, 255
	i32.and 	$1=, $0, $pop24
	i32.const	$push0=, 0
	i32.load	$push23=, v($pop0)
	tee_local	$push22=, $2=, $pop23
	i32.const	$push21=, 255
	i32.and 	$4=, $pop22, $pop21
	i32.const	$push20=, 1
	i32.add 	$push1=, $0, $pop20
	i32.const	$push19=, 255
	i32.and 	$0=, $pop1, $pop19
	block   	
	block   	
	block   	
	block   	
	i32.const	$push18=, 0
	i32.load	$push17=, s($pop18)
	tee_local	$push16=, $3=, $pop17
	i32.eqz 	$push36=, $pop16
	br_if   	0, $pop36       # 0: down to label6
# BB#1:                                 # %if.else.i
	i32.ne  	$push3=, $4, $0
	br_if   	3, $pop3        # 3: down to label3
# BB#2:                                 # %if.else.i
	i32.const	$push28=, 1
	i32.add 	$push2=, $2, $pop28
	i32.const	$push27=, 255
	i32.and 	$push26=, $pop2, $pop27
	tee_local	$push25=, $2=, $pop26
	i32.ne  	$push4=, $pop25, $1
	br_if   	3, $pop4        # 3: down to label3
# BB#3:                                 # %bar.exit
	i32.const	$push6=, 0
	i32.const	$push5=, 1
	i32.xor 	$push30=, $3, $pop5
	tee_local	$push29=, $5=, $pop30
	i32.store	s($pop6), $pop29
	i32.eqz 	$push37=, $5
	br_if   	2, $pop37       # 2: down to label4
# BB#4:                                 # %if.else.i40
	i32.ne  	$push13=, $4, $1
	br_if   	3, $pop13       # 3: down to label3
	br      	1               # 1: down to label5
.LBB1_5:                                # %if.then.i
	end_block                       # label6:
	i32.ne  	$push7=, $4, $1
	br_if   	2, $pop7        # 2: down to label3
# BB#6:                                 # %lor.lhs.false.i
	i32.const	$push34=, 1
	i32.add 	$push8=, $2, $pop34
	i32.const	$push9=, 255
	i32.and 	$push33=, $pop8, $pop9
	tee_local	$push32=, $2=, $pop33
	i32.ne  	$push10=, $pop32, $0
	br_if   	2, $pop10       # 2: down to label3
# BB#7:                                 # %bar.exit.thread
	i32.const	$push11=, 0
	i32.const	$push35=, 1
	i32.store	s($pop11), $pop35
	i32.ne  	$push12=, $4, $1
	br_if   	2, $pop12       # 2: down to label3
.LBB1_8:                                # %if.else.i40
	end_block                       # label5:
	i32.ne  	$push14=, $2, $0
	br_if   	1, $pop14       # 1: down to label3
.LBB1_9:                                # %bar.exit43
	end_block                       # label4:
	i32.const	$push15=, 0
	i32.store	s($pop15), $3
	i32.const	$push31=, 0
	return  	$pop31
.LBB1_10:                               # %if.then8.i
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
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


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
