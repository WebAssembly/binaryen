	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-10.c"
	.section	.text.to_hex,"ax",@progbits
	.hidden	to_hex
	.globl	to_hex
	.type	to_hex,@function
to_hex:                                 # @to_hex
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 16
	i32.ge_u	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	i32.load8_s	$push2=, .L.str($0)
	return  	$pop2
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	to_hex, .Lfunc_end0-to_hex

	.section	.text.fap,"ax",@progbits
	.hidden	fap
	.globl	fap
	.type	fap,@function
fap:                                    # @fap
	.param  	i32, i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push15=, 0
	i32.const	$push12=, 0
	i32.load	$push13=, __stack_pointer($pop12)
	i32.const	$push14=, 16
	i32.sub 	$push19=, $pop13, $pop14
	i32.store	$push22=, __stack_pointer($pop15), $pop19
	tee_local	$push21=, $3=, $pop22
	i32.store	$drop=, 12($pop21), $2
	i32.load	$push0=, 12($3)
	i32.store	$drop=, 8($3), $pop0
	block
	i32.call	$push2=, strlen@FUNCTION, $1
	i32.const	$push20=, 16
	i32.sub 	$push1=, $pop20, $0
	i32.ne  	$push3=, $pop2, $pop1
	br_if   	0, $pop3        # 0: down to label1
# BB#1:
	copy_local	$0=, $1
.LBB1_2:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label3:
	i32.load8_u	$push24=, 0($0)
	tee_local	$push23=, $2=, $pop24
	i32.eqz 	$push41=, $pop23
	br_if   	2, $pop41       # 2: down to label2
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.load	$push30=, 12($3)
	tee_local	$push29=, $4=, $pop30
	i32.const	$push28=, 4
	i32.add 	$push4=, $pop29, $pop28
	i32.store	$drop=, 12($3), $pop4
	i32.load	$push27=, 0($4)
	tee_local	$push26=, $4=, $pop27
	i32.const	$push25=, 16
	i32.ge_u	$push5=, $pop26, $pop25
	br_if   	3, $pop5        # 3: down to label1
# BB#4:                                 # %to_hex.exit
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push31=, 1
	i32.add 	$0=, $0, $pop31
	i32.load8_u	$push6=, .L.str($4)
	i32.eq  	$push7=, $2, $pop6
	br_if   	0, $pop7        # 0: up to label3
# BB#5:                                 # %if.then4
	end_loop                        # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_6:
	end_block                       # label2:
.LBB1_7:                                # %while.cond6
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label6:
	i32.load8_u	$push33=, 0($1)
	tee_local	$push32=, $0=, $pop33
	i32.eqz 	$push42=, $pop32
	br_if   	2, $pop42       # 2: down to label5
# BB#8:                                 # %while.body8
                                        #   in Loop: Header=BB1_7 Depth=1
	i32.load	$push39=, 8($3)
	tee_local	$push38=, $2=, $pop39
	i32.const	$push37=, 4
	i32.add 	$push8=, $pop38, $pop37
	i32.store	$drop=, 8($3), $pop8
	i32.load	$push36=, 0($2)
	tee_local	$push35=, $2=, $pop36
	i32.const	$push34=, 16
	i32.ge_u	$push9=, $pop35, $pop34
	br_if   	3, $pop9        # 3: down to label1
# BB#9:                                 # %to_hex.exit28
                                        #   in Loop: Header=BB1_7 Depth=1
	i32.const	$push40=, 1
	i32.add 	$1=, $1, $pop40
	i32.load8_u	$push10=, .L.str($2)
	i32.eq  	$push11=, $0, $pop10
	br_if   	0, $pop11       # 0: up to label6
# BB#10:                                # %if.then16
	end_loop                        # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_11:                               # %while.end18
	end_block                       # label5:
	i32.const	$push18=, 0
	i32.const	$push16=, 16
	i32.add 	$push17=, $3, $pop16
	i32.store	$drop=, __stack_pointer($pop18), $pop17
	return
.LBB1_12:                               # %if.then.i25
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	fap, .Lfunc_end1-fap

	.section	.text.f0,"ax",@progbits
	.hidden	f0
	.globl	f0
	.type	f0,@function
f0:                                     # @f0
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push9=, $pop3, $pop4
	i32.store	$push11=, __stack_pointer($pop5), $pop9
	tee_local	$push10=, $2=, $pop11
	i32.store	$push0=, 12($pop10), $1
	call    	fap@FUNCTION, $pop1, $0, $pop0
	i32.const	$push8=, 0
	i32.const	$push6=, 16
	i32.add 	$push7=, $2, $pop6
	i32.store	$drop=, __stack_pointer($pop8), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	f0, .Lfunc_end2-f0

	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 1
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push9=, $pop3, $pop4
	i32.store	$push11=, __stack_pointer($pop5), $pop9
	tee_local	$push10=, $3=, $pop11
	i32.store	$push0=, 12($pop10), $2
	call    	fap@FUNCTION, $pop1, $1, $pop0
	i32.const	$push8=, 0
	i32.const	$push6=, 16
	i32.add 	$push7=, $3, $pop6
	i32.store	$drop=, __stack_pointer($pop8), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end3:
	.size	f1, .Lfunc_end3-f1

	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32, i32, i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 2
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push9=, $pop3, $pop4
	i32.store	$push11=, __stack_pointer($pop5), $pop9
	tee_local	$push10=, $4=, $pop11
	i32.store	$push0=, 12($pop10), $3
	call    	fap@FUNCTION, $pop1, $2, $pop0
	i32.const	$push8=, 0
	i32.const	$push6=, 16
	i32.add 	$push7=, $4, $pop6
	i32.store	$drop=, __stack_pointer($pop8), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end4:
	.size	f2, .Lfunc_end4-f2

	.section	.text.f3,"ax",@progbits
	.hidden	f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i32, i32, i32, i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 3
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push9=, $pop3, $pop4
	i32.store	$push11=, __stack_pointer($pop5), $pop9
	tee_local	$push10=, $5=, $pop11
	i32.store	$push0=, 12($pop10), $4
	call    	fap@FUNCTION, $pop1, $3, $pop0
	i32.const	$push8=, 0
	i32.const	$push6=, 16
	i32.add 	$push7=, $5, $pop6
	i32.store	$drop=, __stack_pointer($pop8), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end5:
	.size	f3, .Lfunc_end5-f3

	.section	.text.f4,"ax",@progbits
	.hidden	f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i32, i32, i32, i32, i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 4
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push9=, $pop3, $pop4
	i32.store	$push11=, __stack_pointer($pop5), $pop9
	tee_local	$push10=, $6=, $pop11
	i32.store	$push0=, 12($pop10), $5
	call    	fap@FUNCTION, $pop1, $4, $pop0
	i32.const	$push8=, 0
	i32.const	$push6=, 16
	i32.add 	$push7=, $6, $pop6
	i32.store	$drop=, __stack_pointer($pop8), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end6:
	.size	f4, .Lfunc_end6-f4

	.section	.text.f5,"ax",@progbits
	.hidden	f5
	.globl	f5
	.type	f5,@function
f5:                                     # @f5
	.param  	i32, i32, i32, i32, i32, i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 5
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push9=, $pop3, $pop4
	i32.store	$push11=, __stack_pointer($pop5), $pop9
	tee_local	$push10=, $7=, $pop11
	i32.store	$push0=, 12($pop10), $6
	call    	fap@FUNCTION, $pop1, $5, $pop0
	i32.const	$push8=, 0
	i32.const	$push6=, 16
	i32.add 	$push7=, $7, $pop6
	i32.store	$drop=, __stack_pointer($pop8), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end7:
	.size	f5, .Lfunc_end7-f5

	.section	.text.f6,"ax",@progbits
	.hidden	f6
	.globl	f6
	.type	f6,@function
f6:                                     # @f6
	.param  	i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 6
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push9=, $pop3, $pop4
	i32.store	$push11=, __stack_pointer($pop5), $pop9
	tee_local	$push10=, $8=, $pop11
	i32.store	$push0=, 12($pop10), $7
	call    	fap@FUNCTION, $pop1, $6, $pop0
	i32.const	$push8=, 0
	i32.const	$push6=, 16
	i32.add 	$push7=, $8, $pop6
	i32.store	$drop=, __stack_pointer($pop8), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end8:
	.size	f6, .Lfunc_end8-f6

	.section	.text.f7,"ax",@progbits
	.hidden	f7
	.globl	f7
	.type	f7,@function
f7:                                     # @f7
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 7
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push9=, $pop3, $pop4
	i32.store	$push11=, __stack_pointer($pop5), $pop9
	tee_local	$push10=, $9=, $pop11
	i32.store	$push0=, 12($pop10), $8
	call    	fap@FUNCTION, $pop1, $7, $pop0
	i32.const	$push8=, 0
	i32.const	$push6=, 16
	i32.add 	$push7=, $9, $pop6
	i32.store	$drop=, __stack_pointer($pop8), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end9:
	.size	f7, .Lfunc_end9-f7

	.section	.text.f8,"ax",@progbits
	.hidden	f8
	.globl	f8
	.type	f8,@function
f8:                                     # @f8
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 8
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push9=, $pop3, $pop4
	i32.store	$push11=, __stack_pointer($pop5), $pop9
	tee_local	$push10=, $10=, $pop11
	i32.store	$push0=, 12($pop10), $9
	call    	fap@FUNCTION, $pop1, $8, $pop0
	i32.const	$push8=, 0
	i32.const	$push6=, 16
	i32.add 	$push7=, $10, $pop6
	i32.store	$drop=, __stack_pointer($pop8), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end10:
	.size	f8, .Lfunc_end10-f8

	.section	.text.f9,"ax",@progbits
	.hidden	f9
	.globl	f9
	.type	f9,@function
f9:                                     # @f9
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 9
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push9=, $pop3, $pop4
	i32.store	$push11=, __stack_pointer($pop5), $pop9
	tee_local	$push10=, $11=, $pop11
	i32.store	$push0=, 12($pop10), $10
	call    	fap@FUNCTION, $pop1, $9, $pop0
	i32.const	$push8=, 0
	i32.const	$push6=, 16
	i32.add 	$push7=, $11, $pop6
	i32.store	$drop=, __stack_pointer($pop8), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end11:
	.size	f9, .Lfunc_end11-f9

	.section	.text.f10,"ax",@progbits
	.hidden	f10
	.globl	f10
	.type	f10,@function
f10:                                    # @f10
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 10
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push9=, $pop3, $pop4
	i32.store	$push11=, __stack_pointer($pop5), $pop9
	tee_local	$push10=, $12=, $pop11
	i32.store	$push0=, 12($pop10), $11
	call    	fap@FUNCTION, $pop1, $10, $pop0
	i32.const	$push8=, 0
	i32.const	$push6=, 16
	i32.add 	$push7=, $12, $pop6
	i32.store	$drop=, __stack_pointer($pop8), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end12:
	.size	f10, .Lfunc_end12-f10

	.section	.text.f11,"ax",@progbits
	.hidden	f11
	.globl	f11
	.type	f11,@function
f11:                                    # @f11
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 11
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push9=, $pop3, $pop4
	i32.store	$push11=, __stack_pointer($pop5), $pop9
	tee_local	$push10=, $13=, $pop11
	i32.store	$push0=, 12($pop10), $12
	call    	fap@FUNCTION, $pop1, $11, $pop0
	i32.const	$push8=, 0
	i32.const	$push6=, 16
	i32.add 	$push7=, $13, $pop6
	i32.store	$drop=, __stack_pointer($pop8), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end13:
	.size	f11, .Lfunc_end13-f11

	.section	.text.f12,"ax",@progbits
	.hidden	f12
	.globl	f12
	.type	f12,@function
f12:                                    # @f12
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 12
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push9=, $pop3, $pop4
	i32.store	$push11=, __stack_pointer($pop5), $pop9
	tee_local	$push10=, $14=, $pop11
	i32.store	$push0=, 12($pop10), $13
	call    	fap@FUNCTION, $pop1, $12, $pop0
	i32.const	$push8=, 0
	i32.const	$push6=, 16
	i32.add 	$push7=, $14, $pop6
	i32.store	$drop=, __stack_pointer($pop8), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end14:
	.size	f12, .Lfunc_end14-f12

	.section	.text.f13,"ax",@progbits
	.hidden	f13
	.globl	f13
	.type	f13,@function
f13:                                    # @f13
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 13
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push9=, $pop3, $pop4
	i32.store	$push11=, __stack_pointer($pop5), $pop9
	tee_local	$push10=, $15=, $pop11
	i32.store	$push0=, 12($pop10), $14
	call    	fap@FUNCTION, $pop1, $13, $pop0
	i32.const	$push8=, 0
	i32.const	$push6=, 16
	i32.add 	$push7=, $15, $pop6
	i32.store	$drop=, __stack_pointer($pop8), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end15:
	.size	f13, .Lfunc_end15-f13

	.section	.text.f14,"ax",@progbits
	.hidden	f14
	.globl	f14
	.type	f14,@function
f14:                                    # @f14
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 14
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push9=, $pop3, $pop4
	i32.store	$push11=, __stack_pointer($pop5), $pop9
	tee_local	$push10=, $16=, $pop11
	i32.store	$push0=, 12($pop10), $15
	call    	fap@FUNCTION, $pop1, $14, $pop0
	i32.const	$push8=, 0
	i32.const	$push6=, 16
	i32.add 	$push7=, $16, $pop6
	i32.store	$drop=, __stack_pointer($pop8), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end16:
	.size	f14, .Lfunc_end16-f14

	.section	.text.f15,"ax",@progbits
	.hidden	f15
	.globl	f15
	.type	f15,@function
f15:                                    # @f15
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 15
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push9=, $pop3, $pop4
	i32.store	$push11=, __stack_pointer($pop5), $pop9
	tee_local	$push10=, $17=, $pop11
	i32.store	$push0=, 12($pop10), $16
	call    	fap@FUNCTION, $pop1, $15, $pop0
	i32.const	$push8=, 0
	i32.const	$push6=, 16
	i32.add 	$push7=, $17, $pop6
	i32.store	$drop=, __stack_pointer($pop8), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end17:
	.size	f15, .Lfunc_end17-f15

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64, i64, i64, i64, i64, i64, i32, i64, i64, i64, i64, i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$push84=, 0
	i32.const	$push81=, 0
	i32.load	$push82=, __stack_pointer($pop81)
	i32.const	$push83=, 640
	i32.sub 	$push199=, $pop82, $pop83
	i32.store	$push237=, __stack_pointer($pop84), $pop199
	tee_local	$push236=, $14=, $pop237
	i32.const	$push85=, 576
	i32.add 	$push86=, $pop236, $pop85
	i32.const	$push0=, 56
	i32.add 	$push1=, $pop86, $pop0
	i64.const	$push2=, 64424509454
	i64.store	$0=, 0($pop1), $pop2
	i32.const	$push87=, 576
	i32.add 	$push88=, $14, $pop87
	i32.const	$push3=, 48
	i32.add 	$push4=, $pop88, $pop3
	i64.const	$push5=, 55834574860
	i64.store	$1=, 0($pop4), $pop5
	i32.const	$push89=, 576
	i32.add 	$push90=, $14, $pop89
	i32.const	$push6=, 40
	i32.add 	$push7=, $pop90, $pop6
	i64.const	$push8=, 47244640266
	i64.store	$2=, 0($pop7), $pop8
	i32.const	$push91=, 576
	i32.add 	$push92=, $14, $pop91
	i32.const	$push9=, 32
	i32.add 	$push10=, $pop92, $pop9
	i64.const	$push11=, 38654705672
	i64.store	$3=, 0($pop10), $pop11
	i32.const	$push93=, 576
	i32.add 	$push94=, $14, $pop93
	i32.const	$push12=, 24
	i32.add 	$push13=, $pop94, $pop12
	i64.const	$push14=, 30064771078
	i64.store	$4=, 0($pop13), $pop14
	i32.const	$push95=, 576
	i32.add 	$push96=, $14, $pop95
	i32.const	$push15=, 16
	i32.add 	$push16=, $pop96, $pop15
	i64.const	$push17=, 21474836484
	i64.store	$5=, 0($pop16), $pop17
	i64.const	$push18=, 12884901890
	i64.store	$6=, 584($14), $pop18
	i64.const	$push19=, 4294967296
	i64.store	$drop=, 576($14), $pop19
	i32.const	$push20=, .L.str
	i32.const	$push97=, 576
	i32.add 	$push98=, $14, $pop97
	call    	f0@FUNCTION, $pop20, $pop98
	i32.const	$push99=, 512
	i32.add 	$push100=, $14, $pop99
	i32.const	$push235=, 56
	i32.add 	$push21=, $pop100, $pop235
	i32.const	$push22=, 15
	i32.store	$7=, 0($pop21), $pop22
	i32.const	$push101=, 512
	i32.add 	$push102=, $14, $pop101
	i32.const	$push234=, 48
	i32.add 	$push23=, $pop102, $pop234
	i64.const	$push24=, 60129542157
	i64.store	$8=, 0($pop23), $pop24
	i32.const	$push103=, 512
	i32.add 	$push104=, $14, $pop103
	i32.const	$push233=, 40
	i32.add 	$push25=, $pop104, $pop233
	i64.const	$push26=, 51539607563
	i64.store	$9=, 0($pop25), $pop26
	i32.const	$push105=, 512
	i32.add 	$push106=, $14, $pop105
	i32.const	$push232=, 32
	i32.add 	$push27=, $pop106, $pop232
	i64.const	$push28=, 42949672969
	i64.store	$10=, 0($pop27), $pop28
	i32.const	$push107=, 512
	i32.add 	$push108=, $14, $pop107
	i32.const	$push231=, 24
	i32.add 	$push29=, $pop108, $pop231
	i64.const	$push30=, 34359738375
	i64.store	$11=, 0($pop29), $pop30
	i32.const	$push109=, 512
	i32.add 	$push110=, $14, $pop109
	i32.const	$push230=, 16
	i32.add 	$push31=, $pop110, $pop230
	i64.const	$push32=, 25769803781
	i64.store	$12=, 0($pop31), $pop32
	i64.const	$push33=, 17179869187
	i64.store	$13=, 520($14), $pop33
	i64.const	$push34=, 8589934593
	i64.store	$drop=, 512($14), $pop34
	i32.const	$push35=, .L.str+1
	i32.const	$push111=, 512
	i32.add 	$push112=, $14, $pop111
	call    	f1@FUNCTION, $14, $pop35, $pop112
	i32.const	$push113=, 448
	i32.add 	$push114=, $14, $pop113
	i32.const	$push229=, 48
	i32.add 	$push36=, $pop114, $pop229
	i64.store	$drop=, 0($pop36), $0
	i32.const	$push115=, 448
	i32.add 	$push116=, $14, $pop115
	i32.const	$push228=, 40
	i32.add 	$push37=, $pop116, $pop228
	i64.store	$drop=, 0($pop37), $1
	i32.const	$push117=, 448
	i32.add 	$push118=, $14, $pop117
	i32.const	$push227=, 32
	i32.add 	$push38=, $pop118, $pop227
	i64.store	$drop=, 0($pop38), $2
	i32.const	$push119=, 448
	i32.add 	$push120=, $14, $pop119
	i32.const	$push226=, 24
	i32.add 	$push39=, $pop120, $pop226
	i64.store	$drop=, 0($pop39), $3
	i32.const	$push121=, 448
	i32.add 	$push122=, $14, $pop121
	i32.const	$push225=, 16
	i32.add 	$push40=, $pop122, $pop225
	i64.store	$drop=, 0($pop40), $4
	i64.store	$drop=, 456($14), $5
	i64.store	$drop=, 448($14), $6
	i32.const	$push41=, .L.str+2
	i32.const	$push123=, 448
	i32.add 	$push124=, $14, $pop123
	call    	f2@FUNCTION, $14, $14, $pop41, $pop124
	i32.const	$push125=, 384
	i32.add 	$push126=, $14, $pop125
	i32.const	$push224=, 48
	i32.add 	$push42=, $pop126, $pop224
	i32.store	$drop=, 0($pop42), $7
	i32.const	$push127=, 384
	i32.add 	$push128=, $14, $pop127
	i32.const	$push223=, 40
	i32.add 	$push43=, $pop128, $pop223
	i64.store	$6=, 0($pop43), $8
	i32.const	$push129=, 384
	i32.add 	$push130=, $14, $pop129
	i32.const	$push222=, 32
	i32.add 	$push44=, $pop130, $pop222
	i64.store	$8=, 0($pop44), $9
	i32.const	$push131=, 384
	i32.add 	$push132=, $14, $pop131
	i32.const	$push221=, 24
	i32.add 	$push45=, $pop132, $pop221
	i64.store	$9=, 0($pop45), $10
	i32.const	$push133=, 384
	i32.add 	$push134=, $14, $pop133
	i32.const	$push220=, 16
	i32.add 	$push46=, $pop134, $pop220
	i64.store	$10=, 0($pop46), $11
	i64.store	$11=, 392($14), $12
	i64.store	$drop=, 384($14), $13
	i32.const	$push47=, .L.str+3
	i32.const	$push135=, 384
	i32.add 	$push136=, $14, $pop135
	call    	f3@FUNCTION, $14, $14, $14, $pop47, $pop136
	i32.const	$push137=, 336
	i32.add 	$push138=, $14, $pop137
	i32.const	$push219=, 40
	i32.add 	$push48=, $pop138, $pop219
	i64.store	$drop=, 0($pop48), $0
	i32.const	$push139=, 336
	i32.add 	$push140=, $14, $pop139
	i32.const	$push218=, 32
	i32.add 	$push49=, $pop140, $pop218
	i64.store	$drop=, 0($pop49), $1
	i32.const	$push141=, 336
	i32.add 	$push142=, $14, $pop141
	i32.const	$push217=, 24
	i32.add 	$push50=, $pop142, $pop217
	i64.store	$drop=, 0($pop50), $2
	i32.const	$push143=, 336
	i32.add 	$push144=, $14, $pop143
	i32.const	$push216=, 16
	i32.add 	$push51=, $pop144, $pop216
	i64.store	$drop=, 0($pop51), $3
	i64.store	$drop=, 344($14), $4
	i64.store	$drop=, 336($14), $5
	i32.const	$push52=, .L.str+4
	i32.const	$push145=, 336
	i32.add 	$push146=, $14, $pop145
	call    	f4@FUNCTION, $14, $14, $14, $14, $pop52, $pop146
	i32.const	$push147=, 288
	i32.add 	$push148=, $14, $pop147
	i32.const	$push215=, 40
	i32.add 	$push53=, $pop148, $pop215
	i32.store	$drop=, 0($pop53), $7
	i32.const	$push149=, 288
	i32.add 	$push150=, $14, $pop149
	i32.const	$push214=, 32
	i32.add 	$push54=, $pop150, $pop214
	i64.store	$5=, 0($pop54), $6
	i32.const	$push151=, 288
	i32.add 	$push152=, $14, $pop151
	i32.const	$push213=, 24
	i32.add 	$push55=, $pop152, $pop213
	i64.store	$6=, 0($pop55), $8
	i32.const	$push153=, 288
	i32.add 	$push154=, $14, $pop153
	i32.const	$push212=, 16
	i32.add 	$push56=, $pop154, $pop212
	i64.store	$8=, 0($pop56), $9
	i64.store	$9=, 296($14), $10
	i64.store	$drop=, 288($14), $11
	i32.const	$push57=, .L.str+5
	i32.const	$push155=, 288
	i32.add 	$push156=, $14, $pop155
	call    	f5@FUNCTION, $14, $14, $14, $14, $14, $pop57, $pop156
	i32.const	$push157=, 240
	i32.add 	$push158=, $14, $pop157
	i32.const	$push211=, 32
	i32.add 	$push58=, $pop158, $pop211
	i64.store	$drop=, 0($pop58), $0
	i32.const	$push159=, 240
	i32.add 	$push160=, $14, $pop159
	i32.const	$push210=, 24
	i32.add 	$push59=, $pop160, $pop210
	i64.store	$drop=, 0($pop59), $1
	i32.const	$push161=, 240
	i32.add 	$push162=, $14, $pop161
	i32.const	$push209=, 16
	i32.add 	$push60=, $pop162, $pop209
	i64.store	$drop=, 0($pop60), $2
	i64.store	$drop=, 248($14), $3
	i64.store	$drop=, 240($14), $4
	i32.const	$push61=, .L.str+6
	i32.const	$push163=, 240
	i32.add 	$push164=, $14, $pop163
	call    	f6@FUNCTION, $14, $14, $14, $14, $14, $14, $pop61, $pop164
	i32.const	$push165=, 192
	i32.add 	$push166=, $14, $pop165
	i32.const	$push208=, 32
	i32.add 	$push62=, $pop166, $pop208
	i32.store	$drop=, 0($pop62), $7
	i32.const	$push167=, 192
	i32.add 	$push168=, $14, $pop167
	i32.const	$push207=, 24
	i32.add 	$push63=, $pop168, $pop207
	i64.store	$4=, 0($pop63), $5
	i32.const	$push169=, 192
	i32.add 	$push170=, $14, $pop169
	i32.const	$push206=, 16
	i32.add 	$push64=, $pop170, $pop206
	i64.store	$5=, 0($pop64), $6
	i64.store	$6=, 200($14), $8
	i64.store	$drop=, 192($14), $9
	i32.const	$push65=, .L.str+7
	i32.const	$push171=, 192
	i32.add 	$push172=, $14, $pop171
	call    	f7@FUNCTION, $14, $14, $14, $14, $14, $14, $14, $pop65, $pop172
	i32.const	$push173=, 160
	i32.add 	$push174=, $14, $pop173
	i32.const	$push205=, 24
	i32.add 	$push66=, $pop174, $pop205
	i64.store	$drop=, 0($pop66), $0
	i32.const	$push175=, 160
	i32.add 	$push176=, $14, $pop175
	i32.const	$push204=, 16
	i32.add 	$push67=, $pop176, $pop204
	i64.store	$drop=, 0($pop67), $1
	i64.store	$drop=, 168($14), $2
	i64.store	$drop=, 160($14), $3
	i32.const	$push68=, .L.str+8
	i32.const	$push177=, 160
	i32.add 	$push178=, $14, $pop177
	call    	f8@FUNCTION, $14, $14, $14, $14, $14, $14, $14, $14, $pop68, $pop178
	i32.const	$push179=, 128
	i32.add 	$push180=, $14, $pop179
	i32.const	$push203=, 24
	i32.add 	$push69=, $pop180, $pop203
	i32.store	$drop=, 0($pop69), $7
	i32.const	$push181=, 128
	i32.add 	$push182=, $14, $pop181
	i32.const	$push202=, 16
	i32.add 	$push70=, $pop182, $pop202
	i64.store	$3=, 0($pop70), $4
	i64.store	$4=, 136($14), $5
	i64.store	$drop=, 128($14), $6
	i32.const	$push71=, .L.str+9
	i32.const	$push183=, 128
	i32.add 	$push184=, $14, $pop183
	call    	f9@FUNCTION, $14, $14, $14, $14, $14, $14, $14, $14, $14, $pop71, $pop184
	i32.const	$push185=, 96
	i32.add 	$push186=, $14, $pop185
	i32.const	$push201=, 16
	i32.add 	$push72=, $pop186, $pop201
	i64.store	$drop=, 0($pop72), $0
	i64.store	$drop=, 104($14), $1
	i64.store	$drop=, 96($14), $2
	i32.const	$push73=, .L.str+10
	i32.const	$push187=, 96
	i32.add 	$push188=, $14, $pop187
	call    	f10@FUNCTION, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $pop73, $pop188
	i32.const	$push189=, 64
	i32.add 	$push190=, $14, $pop189
	i32.const	$push200=, 16
	i32.add 	$push74=, $pop190, $pop200
	i32.store	$drop=, 0($pop74), $7
	i64.store	$2=, 72($14), $3
	i64.store	$drop=, 64($14), $4
	i32.const	$push75=, .L.str+11
	i32.const	$push191=, 64
	i32.add 	$push192=, $14, $pop191
	call    	f11@FUNCTION, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $pop75, $pop192
	i64.store	$drop=, 56($14), $0
	i64.store	$drop=, 48($14), $1
	i32.const	$push76=, .L.str+12
	i32.const	$push193=, 48
	i32.add 	$push194=, $14, $pop193
	call    	f12@FUNCTION, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $pop76, $pop194
	i32.store	$drop=, 40($14), $7
	i64.store	$drop=, 32($14), $2
	i32.const	$push77=, .L.str+13
	i32.const	$push195=, 32
	i32.add 	$push196=, $14, $pop195
	call    	f13@FUNCTION, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $pop77, $pop196
	i64.store	$drop=, 16($14), $0
	i32.const	$push78=, .L.str+14
	i32.const	$push197=, 16
	i32.add 	$push198=, $14, $pop197
	call    	f14@FUNCTION, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $pop78, $pop198
	i32.store	$drop=, 0($14), $7
	i32.const	$push79=, .L.str+15
	call    	f15@FUNCTION, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $pop79, $14
	i32.const	$push80=, 0
	call    	exit@FUNCTION, $pop80
	unreachable
	.endfunc
.Lfunc_end18:
	.size	main, .Lfunc_end18-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.16,"aMS",@progbits,1
	.p2align	4
.L.str:
	.asciz	"0123456789abcdef"
	.size	.L.str, 17


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	strlen, i32, i32
	.functype	exit, void, i32
