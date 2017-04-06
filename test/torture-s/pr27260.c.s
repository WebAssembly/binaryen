	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr27260.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push3=, buf
	i32.const	$push0=, 2
	i32.ne  	$push1=, $0, $pop0
	i32.const	$push2=, 64
	i32.call	$drop=, memset@FUNCTION, $pop3, $pop1, $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push3=, 0
	i32.const	$push2=, 2
	i32.store8	buf+64($pop3), $pop2
	i32.const	$2=, -1
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	block   	
	loop    	                # label2:
	i32.const	$push20=, buf+1
	i32.add 	$push4=, $2, $pop20
	i32.load8_u	$push5=, 0($pop4)
	br_if   	1, $pop5        # 1: down to label1
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push24=, 1
	i32.add 	$push23=, $2, $pop24
	tee_local	$push22=, $2=, $pop23
	i32.const	$push21=, 62
	i32.le_s	$push6=, $pop22, $pop21
	br_if   	0, $pop6        # 0: up to label2
# BB#3:                                 # %for.end
	end_loop
	i32.const	$push8=, buf
	i32.const	$push25=, 1
	i32.const	$push7=, 64
	i32.call	$0=, memset@FUNCTION, $pop8, $pop25, $pop7
	i32.const	$2=, 1
.LBB1_4:                                # %for.cond3
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label4:
	i32.const	$push27=, -1
	i32.add 	$push9=, $2, $pop27
	i32.const	$push26=, 62
	i32.gt_s	$push10=, $pop9, $pop26
	br_if   	1, $pop10       # 1: down to label3
# BB#5:                                 # %for.cond3.for.body6_crit_edge
                                        #   in Loop: Header=BB1_4 Depth=1
	i32.add 	$1=, $2, $0
	i32.const	$push29=, 1
	i32.add 	$push0=, $2, $pop29
	copy_local	$2=, $pop0
	i32.load8_u	$push18=, 0($1)
	i32.const	$push28=, 1
	i32.eq  	$push19=, $pop18, $pop28
	br_if   	0, $pop19       # 0: up to label4
	br      	2               # 2: down to label1
.LBB1_6:                                # %for.end15
	end_loop
	end_block                       # label3:
	i32.const	$push13=, buf
	i32.const	$push12=, 0
	i32.const	$push11=, 64
	i32.call	$0=, memset@FUNCTION, $pop13, $pop12, $pop11
	i32.const	$2=, 1
.LBB1_7:                                # %for.cond16
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label5:
	i32.const	$push31=, -1
	i32.add 	$push14=, $2, $pop31
	i32.const	$push30=, 62
	i32.gt_s	$push15=, $pop14, $pop30
	br_if   	2, $pop15       # 2: down to label0
# BB#8:                                 # %for.cond16.for.body19_crit_edge
                                        #   in Loop: Header=BB1_7 Depth=1
	i32.add 	$1=, $2, $0
	i32.const	$push32=, 1
	i32.add 	$push1=, $2, $pop32
	copy_local	$2=, $pop1
	i32.load8_u	$push17=, 0($1)
	i32.eqz 	$push33=, $pop17
	br_if   	0, $pop33       # 0: up to label5
.LBB1_9:                                # %if.then
	end_loop
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB1_10:                               # %if.end33
	end_block                       # label0:
	i32.const	$push16=, 0
                                        # fallthrough-return: $pop16
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	buf                     # @buf
	.type	buf,@object
	.section	.bss.buf,"aw",@nobits
	.globl	buf
	.p2align	4
buf:
	.skip	65
	.size	buf, 65


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
