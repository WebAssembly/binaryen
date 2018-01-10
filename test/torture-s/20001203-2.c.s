	.text
	.file	"20001203-2.c"
	.section	.text.create_array_type,"ax",@progbits
	.hidden	create_array_type       # -- Begin function create_array_type
	.globl	create_array_type
	.type	create_array_type,@function
create_array_type:                      # @create_array_type
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	block   	
	block   	
	i32.eqz 	$push29=, $0
	br_if   	0, $pop29       # 0: down to label1
# %bb.1:                                # %if.end
	i32.const	$push0=, 1
	i32.store16	8($0), $pop0
	i32.load	$push1=, 0($1)
	i32.const	$push2=, 3
	i32.mul 	$push3=, $pop1, $pop2
	i32.store	0($0), $pop3
	i32.load	$1=, 4($0)
	block   	
	i32.eqz 	$push30=, $1
	br_if   	0, $pop30       # 0: down to label2
# %bb.2:                                # %cond.true
	i32.const	$push27=, 16
	i32.add 	$4=, $1, $pop27
	i32.load	$3=, 0($4)
	i32.const	$push4=, 20
	i32.add 	$push5=, $1, $pop4
	i32.load	$2=, 0($pop5)
	i32.sub 	$push6=, $2, $3
	i32.const	$push7=, 15
	i32.le_s	$push8=, $pop6, $pop7
	br_if   	2, $pop8        # 2: down to label0
# %bb.3:                                # %if.end9
	i32.const	$push28=, 16
	i32.add 	$3=, $3, $pop28
	i32.store	0($4), $3
	i32.const	$push9=, 12
	i32.add 	$4=, $1, $pop9
	i32.load	$6=, 0($4)
	block   	
	i32.ne  	$push10=, $3, $6
	br_if   	0, $pop10       # 0: down to label3
# %bb.4:                                # %if.then14
	i32.const	$push11=, 28
	i32.add 	$push12=, $1, $pop11
	i32.const	$push13=, 1
	i32.store	0($pop12), $pop13
.LBB0_5:                                # %if.end15
	end_block                       # label3:
	i32.const	$push14=, 24
	i32.add 	$push15=, $1, $pop14
	i32.load	$5=, 0($pop15)
	i32.add 	$push18=, $5, $3
	i32.const	$push16=, -1
	i32.xor 	$push17=, $5, $pop16
	i32.and 	$3=, $pop18, $pop17
	i32.const	$push19=, 8
	i32.add 	$push20=, $1, $pop19
	i32.load	$5=, 0($pop20)
	i32.sub 	$push21=, $3, $5
	i32.sub 	$push22=, $2, $5
	i32.gt_s	$push23=, $pop21, $pop22
	i32.select	$2=, $2, $3, $pop23
	i32.const	$push24=, 16
	i32.add 	$push25=, $1, $pop24
	i32.store	0($pop25), $2
	i32.store	0($4), $2
	i32.store	12($0), $6
	return  	$0
.LBB0_6:
	end_block                       # label2:
	i32.const	$push26=, 0
	i32.store	12($0), $pop26
	return  	$0
.LBB0_7:                                # %if.then
	end_block                       # label1:
	i32.call	$drop=, alloc_type@FUNCTION
	unreachable
.LBB0_8:                                # %if.then8
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	create_array_type, .Lfunc_end0-create_array_type
                                        # -- End function
	.section	.text.alloc_type,"ax",@progbits
	.hidden	alloc_type              # -- Begin function alloc_type
	.globl	alloc_type
	.type	alloc_type,@function
alloc_type:                             # @alloc_type
	.result 	i32
# %bb.0:                                # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	alloc_type, .Lfunc_end1-alloc_type
                                        # -- End function
	.section	.text.get_discrete_bounds,"ax",@progbits
	.hidden	get_discrete_bounds     # -- Begin function get_discrete_bounds
	.globl	get_discrete_bounds
	.type	get_discrete_bounds,@function
get_discrete_bounds:                    # @get_discrete_bounds
	.param  	i32, i32
# %bb.0:                                # %entry
	i64.const	$push0=, 0
	i64.store	0($0), $pop0
	i64.const	$push1=, 2
	i64.store	0($1), $pop1
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	get_discrete_bounds, .Lfunc_end2-get_discrete_bounds
                                        # -- End function
	.section	.text._obstack_newchunk,"ax",@progbits
	.hidden	_obstack_newchunk       # -- Begin function _obstack_newchunk
	.globl	_obstack_newchunk
	.type	_obstack_newchunk,@function
_obstack_newchunk:                      # @_obstack_newchunk
	.param  	i32, i32
# %bb.0:                                # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	_obstack_newchunk, .Lfunc_end3-_obstack_newchunk
                                        # -- End function
	.section	.text.xmalloc,"ax",@progbits
	.hidden	xmalloc                 # -- Begin function xmalloc
	.globl	xmalloc
	.type	xmalloc,@function
xmalloc:                                # @xmalloc
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end4:
	.size	xmalloc, .Lfunc_end4-xmalloc
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end5:
	.size	main, .Lfunc_end5-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
