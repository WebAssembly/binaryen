	.text
	.file	"20071219-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$3=, 0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	i32.add 	$2=, $0, $3
	i32.load8_u	$push0=, 0($2)
	br_if   	1, $pop0        # 1: down to label0
# %bb.2:                                # %if.else
                                        #   in Loop: Header=BB0_1 Depth=1
	block   	
	i32.eqz 	$push5=, $1
	br_if   	0, $pop5        # 0: down to label2
# %bb.3:                                # %if.then3
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.store8	0($2), $1
.LBB0_4:                                # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$push4=, 1
	i32.add 	$3=, $3, $pop4
	i32.const	$push3=, 25
	i32.lt_u	$push1=, $3, $pop3
	br_if   	0, $pop1        # 0: up to label1
# %bb.5:                                # %for.end
	end_loop
	i32.const	$push2=, 0
	i32.store	p($pop2), $0
	return
.LBB0_6:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.test1,"ax",@progbits
	.hidden	test1                   # -- Begin function test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.local  	i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push15=, 0
	i32.load	$push14=, __stack_pointer($pop15)
	i32.const	$push16=, 64
	i32.sub 	$6=, $pop14, $pop16
	i32.const	$push17=, 0
	i32.store	__stack_pointer($pop17), $6
	i32.const	$push21=, 32
	i32.add 	$push22=, $6, $pop21
	i32.const	$push0=, 24
	i32.add 	$0=, $pop22, $pop0
	i32.const	$push1=, 0
	i32.store8	0($0), $pop1
	i32.const	$push23=, 32
	i32.add 	$push24=, $6, $pop23
	i32.const	$push2=, 16
	i32.add 	$1=, $pop24, $pop2
	i64.const	$push3=, 0
	i64.store	0($1), $pop3
	i32.const	$push25=, 32
	i32.add 	$push26=, $6, $pop25
	i32.const	$push4=, 8
	i32.add 	$2=, $pop26, $pop4
	i64.const	$push35=, 0
	i64.store	0($2), $pop35
	i64.const	$push34=, 0
	i64.store	32($6), $pop34
	i32.const	$push27=, 32
	i32.add 	$push28=, $6, $pop27
	i32.const	$push33=, 0
	call    	foo@FUNCTION, $pop28, $pop33
	i32.const	$push32=, 24
	i32.add 	$3=, $6, $pop32
	i32.load8_u	$push5=, 0($0)
	i32.store8	0($3), $pop5
	i32.const	$push31=, 16
	i32.add 	$4=, $6, $pop31
	i64.load	$push6=, 0($1)
	i64.store	0($4), $pop6
	i32.const	$push30=, 8
	i32.add 	$5=, $6, $pop30
	i64.load	$push7=, 0($2)
	i64.store	0($5), $pop7
	i64.load	$push8=, 32($6)
	i64.store	0($6), $pop8
	i32.const	$push9=, 1
	call    	foo@FUNCTION, $6, $pop9
	i32.load8_u	$push10=, 0($0)
	i32.store8	0($3), $pop10
	i64.load	$push11=, 0($1)
	i64.store	0($4), $pop11
	i64.load	$push12=, 0($2)
	i64.store	0($5), $pop12
	i64.load	$push13=, 32($6)
	i64.store	0($6), $pop13
	i32.const	$push29=, 0
	call    	foo@FUNCTION, $6, $pop29
	i32.const	$push20=, 0
	i32.const	$push18=, 64
	i32.add 	$push19=, $6, $pop18
	i32.store	__stack_pointer($pop20), $pop19
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	test1, .Lfunc_end1-test1
                                        # -- End function
	.section	.text.test2,"ax",@progbits
	.hidden	test2                   # -- Begin function test2
	.globl	test2
	.type	test2,@function
test2:                                  # @test2
	.local  	i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push22=, 0
	i32.load	$push21=, __stack_pointer($pop22)
	i32.const	$push23=, 64
	i32.sub 	$6=, $pop21, $pop23
	i32.const	$push24=, 0
	i32.store	__stack_pointer($pop24), $6
	i32.const	$push28=, 32
	i32.add 	$push29=, $6, $pop28
	i32.const	$push0=, 24
	i32.add 	$5=, $pop29, $pop0
	i32.const	$push1=, 0
	i32.store8	0($5), $pop1
	i32.const	$push30=, 32
	i32.add 	$push31=, $6, $pop30
	i32.const	$push2=, 16
	i32.add 	$0=, $pop31, $pop2
	i64.const	$push3=, 0
	i64.store	0($0), $pop3
	i32.const	$push32=, 32
	i32.add 	$push33=, $6, $pop32
	i32.const	$push4=, 8
	i32.add 	$1=, $pop33, $pop4
	i64.const	$push46=, 0
	i64.store	0($1), $pop46
	i64.const	$push45=, 0
	i64.store	32($6), $pop45
	i32.const	$push34=, 32
	i32.add 	$push35=, $6, $pop34
	i32.const	$push44=, 0
	call    	foo@FUNCTION, $pop35, $pop44
	i32.const	$push43=, 24
	i32.add 	$2=, $6, $pop43
	i32.load8_u	$push5=, 0($5)
	i32.store8	0($2), $pop5
	i32.const	$push42=, 16
	i32.add 	$3=, $6, $pop42
	i64.load	$push6=, 0($0)
	i64.store	0($3), $pop6
	i32.const	$push41=, 8
	i32.add 	$4=, $6, $pop41
	i64.load	$push7=, 0($1)
	i64.store	0($4), $pop7
	i64.load	$push8=, 32($6)
	i64.store	0($6), $pop8
	i32.const	$push9=, 1
	call    	foo@FUNCTION, $6, $pop9
	i32.load8_u	$push10=, 0($5)
	i32.store8	0($2), $pop10
	i64.load	$push11=, 0($0)
	i64.store	0($3), $pop11
	i64.load	$push12=, 0($1)
	i64.store	0($4), $pop12
	i64.load	$push13=, 32($6)
	i64.store	0($6), $pop13
	i32.const	$push40=, 0
	i32.load	$5=, p($pop40)
	i32.const	$push39=, 8
	i32.add 	$push14=, $5, $pop39
	i64.load	$push15=, 0($pop14):p2align=0
	i64.store	0($4), $pop15
	i32.const	$push38=, 16
	i32.add 	$push16=, $5, $pop38
	i64.load	$push17=, 0($pop16):p2align=0
	i64.store	0($3), $pop17
	i32.const	$push37=, 24
	i32.add 	$push18=, $5, $pop37
	i32.load8_u	$push19=, 0($pop18)
	i32.store8	0($2), $pop19
	i64.load	$push20=, 0($5):p2align=0
	i64.store	0($6), $pop20
	i32.const	$push36=, 0
	call    	foo@FUNCTION, $6, $pop36
	i32.const	$push27=, 0
	i32.const	$push25=, 64
	i32.add 	$push26=, $6, $pop25
	i32.store	__stack_pointer($pop27), $pop26
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	test2, .Lfunc_end2-test2
                                        # -- End function
	.section	.text.test3,"ax",@progbits
	.hidden	test3                   # -- Begin function test3
	.globl	test3
	.type	test3,@function
test3:                                  # @test3
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push19=, 0
	i32.load	$push18=, __stack_pointer($pop19)
	i32.const	$push20=, 64
	i32.sub 	$8=, $pop18, $pop20
	i32.const	$push21=, 0
	i32.store	__stack_pointer($pop21), $8
	i32.const	$push25=, 32
	i32.add 	$push26=, $8, $pop25
	i32.const	$push0=, 24
	i32.add 	$0=, $pop26, $pop0
	i32.const	$push1=, 0
	i32.store8	0($0), $pop1
	i32.const	$push27=, 32
	i32.add 	$push28=, $8, $pop27
	i32.const	$push2=, 16
	i32.add 	$1=, $pop28, $pop2
	i64.const	$push3=, 0
	i64.store	0($1), $pop3
	i32.const	$push29=, 32
	i32.add 	$push30=, $8, $pop29
	i32.const	$push4=, 8
	i32.add 	$2=, $pop30, $pop4
	i64.const	$push43=, 0
	i64.store	0($2), $pop43
	i64.const	$push42=, 0
	i64.store	32($8), $pop42
	i32.const	$push31=, 32
	i32.add 	$push32=, $8, $pop31
	i32.const	$push41=, 0
	call    	foo@FUNCTION, $pop32, $pop41
	i32.const	$push40=, 24
	i32.add 	$3=, $8, $pop40
	i32.load8_u	$push5=, 0($0)
	i32.store8	0($3), $pop5
	i32.const	$push39=, 16
	i32.add 	$4=, $8, $pop39
	i64.load	$push6=, 0($1)
	i64.store	0($4), $pop6
	i32.const	$push38=, 8
	i32.add 	$5=, $8, $pop38
	i64.load	$push7=, 0($2)
	i64.store	0($5), $pop7
	i64.load	$push8=, 32($8)
	i64.store	0($8), $pop8
	i32.const	$push9=, 1
	call    	foo@FUNCTION, $8, $pop9
	i32.const	$push37=, 0
	i32.load	$6=, p($pop37)
	i64.load	$push10=, 32($8)
	i64.store	0($6):p2align=0, $pop10
	i32.const	$push36=, 16
	i32.add 	$7=, $6, $pop36
	i64.load	$push11=, 0($1)
	i64.store	0($7):p2align=0, $pop11
	i32.const	$push35=, 8
	i32.add 	$1=, $6, $pop35
	i64.load	$push12=, 0($2)
	i64.store	0($1):p2align=0, $pop12
	i32.const	$push34=, 24
	i32.add 	$2=, $6, $pop34
	i32.load8_u	$push13=, 0($0)
	i32.store8	0($2), $pop13
	i64.load	$push14=, 0($8)
	i64.store	0($6):p2align=0, $pop14
	i32.load8_u	$push15=, 0($3)
	i32.store8	0($2), $pop15
	i64.load	$push16=, 0($4)
	i64.store	0($7):p2align=0, $pop16
	i64.load	$push17=, 0($5)
	i64.store	0($1):p2align=0, $pop17
	i32.const	$push33=, 0
	call    	foo@FUNCTION, $8, $pop33
	i32.const	$push24=, 0
	i32.const	$push22=, 64
	i32.add 	$push23=, $8, $pop22
	i32.store	__stack_pointer($pop24), $pop23
                                        # fallthrough-return
	.endfunc
.Lfunc_end3:
	.size	test3, .Lfunc_end3-test3
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	call    	test1@FUNCTION
	call    	test2@FUNCTION
	call    	test3@FUNCTION
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main
                                        # -- End function
	.hidden	p                       # @p
	.type	p,@object
	.section	.bss.p,"aw",@nobits
	.globl	p
	.p2align	2
p:
	.int32	0
	.size	p, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
