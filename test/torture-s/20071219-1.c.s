	.text
	.file	"20071219-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	i32.add 	$push4=, $0, $3
	tee_local	$push3=, $2=, $pop4
	i32.load8_u	$push0=, 0($pop3)
	br_if   	1, $pop0        # 1: down to label0
# BB#2:                                 # %if.else
                                        #   in Loop: Header=BB0_1 Depth=1
	block   	
	i32.eqz 	$push9=, $1
	br_if   	0, $pop9        # 0: down to label2
# BB#3:                                 # %if.then3
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.store8	0($2), $1
.LBB0_4:                                # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$push8=, 1
	i32.add 	$push7=, $3, $pop8
	tee_local	$push6=, $3=, $pop7
	i32.const	$push5=, 25
	i32.lt_u	$push1=, $pop6, $pop5
	br_if   	0, $pop1        # 0: up to label1
# BB#5:                                 # %for.end
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
# BB#0:                                 # %entry
	i32.const	$push17=, 0
	i32.const	$push15=, 0
	i32.load	$push14=, __stack_pointer($pop15)
	i32.const	$push16=, 64
	i32.sub 	$push49=, $pop14, $pop16
	tee_local	$push48=, $6=, $pop49
	i32.store	__stack_pointer($pop17), $pop48
	i32.const	$push21=, 32
	i32.add 	$push22=, $6, $pop21
	i32.const	$push0=, 24
	i32.add 	$push47=, $pop22, $pop0
	tee_local	$push46=, $0=, $pop47
	i32.const	$push1=, 0
	i32.store8	0($pop46), $pop1
	i32.const	$push23=, 32
	i32.add 	$push24=, $6, $pop23
	i32.const	$push2=, 16
	i32.add 	$push45=, $pop24, $pop2
	tee_local	$push44=, $1=, $pop45
	i64.const	$push3=, 0
	i64.store	0($pop44), $pop3
	i32.const	$push25=, 32
	i32.add 	$push26=, $6, $pop25
	i32.const	$push4=, 8
	i32.add 	$push43=, $pop26, $pop4
	tee_local	$push42=, $2=, $pop43
	i64.const	$push41=, 0
	i64.store	0($pop42), $pop41
	i64.const	$push40=, 0
	i64.store	32($6), $pop40
	i32.const	$push27=, 32
	i32.add 	$push28=, $6, $pop27
	i32.const	$push39=, 0
	call    	foo@FUNCTION, $pop28, $pop39
	i32.const	$push38=, 24
	i32.add 	$push37=, $6, $pop38
	tee_local	$push36=, $3=, $pop37
	i32.load8_u	$push5=, 0($0)
	i32.store8	0($pop36), $pop5
	i32.const	$push35=, 16
	i32.add 	$push34=, $6, $pop35
	tee_local	$push33=, $4=, $pop34
	i64.load	$push6=, 0($1)
	i64.store	0($pop33), $pop6
	i32.const	$push32=, 8
	i32.add 	$push31=, $6, $pop32
	tee_local	$push30=, $5=, $pop31
	i64.load	$push7=, 0($2)
	i64.store	0($pop30), $pop7
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
# BB#0:                                 # %entry
	i32.const	$push24=, 0
	i32.const	$push22=, 0
	i32.load	$push21=, __stack_pointer($pop22)
	i32.const	$push23=, 64
	i32.sub 	$push62=, $pop21, $pop23
	tee_local	$push61=, $6=, $pop62
	i32.store	__stack_pointer($pop24), $pop61
	i32.const	$push28=, 32
	i32.add 	$push29=, $6, $pop28
	i32.const	$push0=, 24
	i32.add 	$push60=, $pop29, $pop0
	tee_local	$push59=, $5=, $pop60
	i32.const	$push1=, 0
	i32.store8	0($pop59), $pop1
	i32.const	$push30=, 32
	i32.add 	$push31=, $6, $pop30
	i32.const	$push2=, 16
	i32.add 	$push58=, $pop31, $pop2
	tee_local	$push57=, $0=, $pop58
	i64.const	$push3=, 0
	i64.store	0($pop57), $pop3
	i32.const	$push32=, 32
	i32.add 	$push33=, $6, $pop32
	i32.const	$push4=, 8
	i32.add 	$push56=, $pop33, $pop4
	tee_local	$push55=, $1=, $pop56
	i64.const	$push54=, 0
	i64.store	0($pop55), $pop54
	i64.const	$push53=, 0
	i64.store	32($6), $pop53
	i32.const	$push34=, 32
	i32.add 	$push35=, $6, $pop34
	i32.const	$push52=, 0
	call    	foo@FUNCTION, $pop35, $pop52
	i32.const	$push51=, 24
	i32.add 	$push50=, $6, $pop51
	tee_local	$push49=, $2=, $pop50
	i32.load8_u	$push5=, 0($5)
	i32.store8	0($pop49), $pop5
	i32.const	$push48=, 16
	i32.add 	$push47=, $6, $pop48
	tee_local	$push46=, $3=, $pop47
	i64.load	$push6=, 0($0)
	i64.store	0($pop46), $pop6
	i32.const	$push45=, 8
	i32.add 	$push44=, $6, $pop45
	tee_local	$push43=, $4=, $pop44
	i64.load	$push7=, 0($1)
	i64.store	0($pop43), $pop7
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
	i32.const	$push42=, 0
	i32.load	$push41=, p($pop42)
	tee_local	$push40=, $5=, $pop41
	i32.const	$push39=, 8
	i32.add 	$push14=, $pop40, $pop39
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
# BB#0:                                 # %entry
	i32.const	$push21=, 0
	i32.const	$push19=, 0
	i32.load	$push18=, __stack_pointer($pop19)
	i32.const	$push20=, 64
	i32.sub 	$push65=, $pop18, $pop20
	tee_local	$push64=, $8=, $pop65
	i32.store	__stack_pointer($pop21), $pop64
	i32.const	$push25=, 32
	i32.add 	$push26=, $8, $pop25
	i32.const	$push0=, 24
	i32.add 	$push63=, $pop26, $pop0
	tee_local	$push62=, $0=, $pop63
	i32.const	$push1=, 0
	i32.store8	0($pop62), $pop1
	i32.const	$push27=, 32
	i32.add 	$push28=, $8, $pop27
	i32.const	$push2=, 16
	i32.add 	$push61=, $pop28, $pop2
	tee_local	$push60=, $1=, $pop61
	i64.const	$push3=, 0
	i64.store	0($pop60), $pop3
	i32.const	$push29=, 32
	i32.add 	$push30=, $8, $pop29
	i32.const	$push4=, 8
	i32.add 	$push59=, $pop30, $pop4
	tee_local	$push58=, $2=, $pop59
	i64.const	$push57=, 0
	i64.store	0($pop58), $pop57
	i64.const	$push56=, 0
	i64.store	32($8), $pop56
	i32.const	$push31=, 32
	i32.add 	$push32=, $8, $pop31
	i32.const	$push55=, 0
	call    	foo@FUNCTION, $pop32, $pop55
	i32.const	$push54=, 24
	i32.add 	$push53=, $8, $pop54
	tee_local	$push52=, $3=, $pop53
	i32.load8_u	$push5=, 0($0)
	i32.store8	0($pop52), $pop5
	i32.const	$push51=, 16
	i32.add 	$push50=, $8, $pop51
	tee_local	$push49=, $4=, $pop50
	i64.load	$push6=, 0($1)
	i64.store	0($pop49), $pop6
	i32.const	$push48=, 8
	i32.add 	$push47=, $8, $pop48
	tee_local	$push46=, $5=, $pop47
	i64.load	$push7=, 0($2)
	i64.store	0($pop46), $pop7
	i64.load	$push8=, 32($8)
	i64.store	0($8), $pop8
	i32.const	$push9=, 1
	call    	foo@FUNCTION, $8, $pop9
	i32.const	$push45=, 0
	i32.load	$push44=, p($pop45)
	tee_local	$push43=, $6=, $pop44
	i64.load	$push10=, 32($8)
	i64.store	0($pop43):p2align=0, $pop10
	i32.const	$push42=, 16
	i32.add 	$push41=, $6, $pop42
	tee_local	$push40=, $7=, $pop41
	i64.load	$push11=, 0($1)
	i64.store	0($pop40):p2align=0, $pop11
	i32.const	$push39=, 8
	i32.add 	$push38=, $6, $pop39
	tee_local	$push37=, $1=, $pop38
	i64.load	$push12=, 0($2)
	i64.store	0($pop37):p2align=0, $pop12
	i32.const	$push36=, 24
	i32.add 	$push35=, $6, $pop36
	tee_local	$push34=, $2=, $pop35
	i32.load8_u	$push13=, 0($0)
	i32.store8	0($pop34), $pop13
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
# BB#0:                                 # %entry
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
