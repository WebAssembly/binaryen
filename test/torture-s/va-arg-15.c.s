	.text
	.file	"va-arg-15.c"
	.section	.text.vafunction,"ax",@progbits
	.hidden	vafunction              # -- Begin function vafunction
	.globl	vafunction
	.type	vafunction,@function
vafunction:                             # @vafunction
	.param  	i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push10=, 0
	i32.const	$push8=, 0
	i32.load	$push7=, __stack_pointer($pop8)
	i32.const	$push9=, 16
	i32.sub 	$push15=, $pop7, $pop9
	tee_local	$push14=, $5=, $pop15
	i32.store	__stack_pointer($pop10), $pop14
	i32.store	12($5), $1
	i32.const	$4=, 0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	i32.const	$push17=, 1
	i32.add 	$2=, $4, $pop17
	block   	
	block   	
	i32.const	$push16=, 1
	i32.and 	$push0=, $4, $pop16
	br_if   	0, $pop0        # 0: down to label3
# BB#2:                                 # %if.else
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push20=, 4
	i32.add 	$push19=, $1, $pop20
	tee_local	$push18=, $4=, $pop19
	i32.store	12($5), $pop18
	i32.load	$3=, 0($1)
	copy_local	$1=, $4
	i32.eq  	$push5=, $2, $3
	br_if   	1, $pop5        # 1: down to label2
	br      	3               # 3: down to label0
.LBB0_3:                                # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.const	$push27=, 7
	i32.add 	$push1=, $1, $pop27
	i32.const	$push26=, -8
	i32.and 	$push25=, $pop1, $pop26
	tee_local	$push24=, $4=, $pop25
	i32.const	$push23=, 8
	i32.add 	$push22=, $pop24, $pop23
	tee_local	$push21=, $1=, $pop22
	i32.store	12($5), $pop21
	f64.load	$push2=, 0($4)
	f64.convert_s/i32	$push3=, $2
	f64.ne  	$push4=, $pop2, $pop3
	br_if   	2, $pop4        # 2: down to label0
.LBB0_4:                                # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	copy_local	$4=, $2
	i32.const	$push28=, 18
	i32.lt_u	$push6=, $2, $pop28
	br_if   	0, $pop6        # 0: up to label1
# BB#5:                                 # %for.end
	end_loop
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $5, $pop11
	i32.store	__stack_pointer($pop13), $pop12
	return
.LBB0_6:                                # %if.then4
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	vafunction, .Lfunc_end0-vafunction
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push54=, 0
	i32.const	$push52=, 0
	i32.load	$push51=, __stack_pointer($pop52)
	i32.const	$push53=, 144
	i32.sub 	$push56=, $pop51, $pop53
	tee_local	$push55=, $0=, $pop56
	i32.store	__stack_pointer($pop54), $pop55
	i32.const	$push0=, 136
	i32.add 	$push1=, $0, $pop0
	i64.const	$push2=, 4625759767262920704
	i64.store	0($pop1), $pop2
	i32.const	$push3=, 128
	i32.add 	$push4=, $0, $pop3
	i32.const	$push5=, 17
	i32.store	0($pop4), $pop5
	i32.const	$push6=, 120
	i32.add 	$push7=, $0, $pop6
	i64.const	$push8=, 4625196817309499392
	i64.store	0($pop7), $pop8
	i32.const	$push9=, 112
	i32.add 	$push10=, $0, $pop9
	i32.const	$push11=, 15
	i32.store	0($pop10), $pop11
	i32.const	$push12=, 104
	i32.add 	$push13=, $0, $pop12
	i64.const	$push14=, 4624070917402656768
	i64.store	0($pop13), $pop14
	i32.const	$push15=, 96
	i32.add 	$push16=, $0, $pop15
	i32.const	$push17=, 13
	i32.store	0($pop16), $pop17
	i32.const	$push18=, 88
	i32.add 	$push19=, $0, $pop18
	i64.const	$push20=, 4622945017495814144
	i64.store	0($pop19), $pop20
	i32.const	$push21=, 80
	i32.add 	$push22=, $0, $pop21
	i32.const	$push23=, 11
	i32.store	0($pop22), $pop23
	i32.const	$push24=, 72
	i32.add 	$push25=, $0, $pop24
	i64.const	$push26=, 4621819117588971520
	i64.store	0($pop25), $pop26
	i32.const	$push27=, 64
	i32.add 	$push28=, $0, $pop27
	i32.const	$push29=, 9
	i32.store	0($pop28), $pop29
	i32.const	$push30=, 56
	i32.add 	$push31=, $0, $pop30
	i64.const	$push32=, 4620693217682128896
	i64.store	0($pop31), $pop32
	i32.const	$push33=, 48
	i32.add 	$push34=, $0, $pop33
	i32.const	$push35=, 7
	i32.store	0($pop34), $pop35
	i32.const	$push36=, 40
	i32.add 	$push37=, $0, $pop36
	i64.const	$push38=, 4618441417868443648
	i64.store	0($pop37), $pop38
	i32.const	$push39=, 32
	i32.add 	$push40=, $0, $pop39
	i32.const	$push41=, 5
	i32.store	0($pop40), $pop41
	i32.const	$push42=, 24
	i32.add 	$push43=, $0, $pop42
	i64.const	$push44=, 4616189618054758400
	i64.store	0($pop43), $pop44
	i32.const	$push45=, 16
	i32.add 	$push46=, $0, $pop45
	i32.const	$push47=, 3
	i32.store	0($pop46), $pop47
	i64.const	$push48=, 4611686018427387904
	i64.store	8($0), $pop48
	i32.const	$push49=, 1
	i32.store	0($0), $pop49
	call    	vafunction@FUNCTION, $0, $0
	i32.const	$push50=, 0
	call    	exit@FUNCTION, $pop50
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
