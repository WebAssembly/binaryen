	.text
	.file	"20021120-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64
# %bb.0:                                # %entry
	i32.const	$push97=, 0
	f64.load	$160=, gd($pop97)
	i32.const	$push96=, 0
	f64.load	$159=, gd+8($pop96)
	i32.const	$push95=, 0
	f64.load	$158=, gd+16($pop95)
	i32.const	$push94=, 0
	f64.load	$157=, gd+24($pop94)
	i32.const	$push93=, 0
	f64.load	$156=, gd+32($pop93)
	i32.const	$push92=, 0
	f64.load	$155=, gd+40($pop92)
	i32.const	$push91=, 0
	f64.load	$154=, gd+48($pop91)
	i32.const	$push90=, 0
	f64.load	$153=, gd+56($pop90)
	i32.const	$push89=, 0
	f64.load	$152=, gd+64($pop89)
	i32.const	$push88=, 0
	f64.load	$151=, gd+72($pop88)
	i32.const	$push87=, 0
	f64.load	$150=, gd+80($pop87)
	i32.const	$push86=, 0
	f64.load	$149=, gd+88($pop86)
	i32.const	$push85=, 0
	f64.load	$148=, gd+96($pop85)
	i32.const	$push84=, 0
	f64.load	$147=, gd+104($pop84)
	i32.const	$push83=, 0
	f64.load	$146=, gd+112($pop83)
	i32.const	$push82=, 0
	f64.load	$145=, gd+120($pop82)
	i32.const	$push81=, 0
	f64.load	$144=, gd+128($pop81)
	i32.const	$push80=, 0
	f64.load	$143=, gd+136($pop80)
	i32.const	$push79=, 0
	f64.load	$142=, gd+144($pop79)
	i32.const	$push78=, 0
	f64.load	$141=, gd+152($pop78)
	i32.const	$push77=, 0
	f64.load	$140=, gd+160($pop77)
	i32.const	$push76=, 0
	f64.load	$139=, gd+168($pop76)
	i32.const	$push75=, 0
	f64.load	$138=, gd+176($pop75)
	i32.const	$push74=, 0
	f64.load	$137=, gd+184($pop74)
	i32.const	$push73=, 0
	f64.load	$136=, gd+192($pop73)
	i32.const	$push72=, 0
	f64.load	$135=, gd+200($pop72)
	i32.const	$push71=, 0
	f64.load	$134=, gd+208($pop71)
	i32.const	$push70=, 0
	f64.load	$133=, gd+216($pop70)
	i32.const	$push69=, 0
	f64.load	$132=, gd+224($pop69)
	i32.const	$push68=, 0
	f64.load	$131=, gd+232($pop68)
	i32.const	$push67=, 0
	f64.load	$130=, gd+240($pop67)
	i32.const	$push66=, 0
	f64.load	$129=, gd+248($pop66)
	block   	
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %for.body.preheader
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push258=, 0
	f32.load	$1=, gf($pop258)
	i32.const	$push257=, 0
	f32.load	$2=, gf+4($pop257)
	i32.const	$push256=, 0
	f32.load	$3=, gf+8($pop256)
	i32.const	$push255=, 0
	f32.load	$4=, gf+12($pop255)
	i32.const	$push254=, 0
	f32.load	$5=, gf+16($pop254)
	i32.const	$push253=, 0
	f32.load	$6=, gf+20($pop253)
	i32.const	$push252=, 0
	f32.load	$7=, gf+24($pop252)
	i32.const	$push251=, 0
	f32.load	$8=, gf+28($pop251)
	i32.const	$push250=, 0
	f32.load	$9=, gf+32($pop250)
	i32.const	$push249=, 0
	f32.load	$10=, gf+36($pop249)
	i32.const	$push248=, 0
	f32.load	$11=, gf+40($pop248)
	i32.const	$push247=, 0
	f32.load	$12=, gf+44($pop247)
	i32.const	$push246=, 0
	f32.load	$13=, gf+48($pop246)
	i32.const	$push245=, 0
	f32.load	$14=, gf+52($pop245)
	i32.const	$push244=, 0
	f32.load	$15=, gf+56($pop244)
	i32.const	$push243=, 0
	f32.load	$16=, gf+60($pop243)
	i32.const	$push242=, 0
	f32.load	$17=, gf+64($pop242)
	i32.const	$push241=, 0
	f32.load	$18=, gf+68($pop241)
	i32.const	$push240=, 0
	f32.load	$19=, gf+72($pop240)
	i32.const	$push239=, 0
	f32.load	$20=, gf+76($pop239)
	i32.const	$push238=, 0
	f32.load	$21=, gf+80($pop238)
	i32.const	$push237=, 0
	f32.load	$22=, gf+84($pop237)
	i32.const	$push236=, 0
	f32.load	$23=, gf+88($pop236)
	i32.const	$push235=, 0
	f32.load	$24=, gf+92($pop235)
	i32.const	$push234=, 0
	f32.load	$25=, gf+96($pop234)
	i32.const	$push233=, 0
	f32.load	$26=, gf+100($pop233)
	i32.const	$push232=, 0
	f32.load	$27=, gf+104($pop232)
	i32.const	$push231=, 0
	f32.load	$28=, gf+108($pop231)
	i32.const	$push230=, 0
	f32.load	$29=, gf+112($pop230)
	i32.const	$push229=, 0
	f32.load	$30=, gf+116($pop229)
	i32.const	$push228=, 0
	f32.load	$31=, gf+120($pop228)
	i32.const	$push227=, 0
	f32.load	$32=, gf+124($pop227)
	i32.const	$push226=, 0
	f64.load	$33=, gd($pop226)
	i32.const	$push225=, 0
	f64.load	$34=, gd+8($pop225)
	i32.const	$push224=, 0
	f64.load	$35=, gd+16($pop224)
	i32.const	$push223=, 0
	f64.load	$36=, gd+24($pop223)
	i32.const	$push222=, 0
	f64.load	$37=, gd+32($pop222)
	i32.const	$push221=, 0
	f64.load	$38=, gd+40($pop221)
	i32.const	$push220=, 0
	f64.load	$39=, gd+48($pop220)
	i32.const	$push219=, 0
	f64.load	$40=, gd+56($pop219)
	i32.const	$push218=, 0
	f64.load	$41=, gd+64($pop218)
	i32.const	$push217=, 0
	f64.load	$42=, gd+72($pop217)
	i32.const	$push216=, 0
	f64.load	$43=, gd+80($pop216)
	i32.const	$push215=, 0
	f64.load	$44=, gd+88($pop215)
	i32.const	$push214=, 0
	f64.load	$45=, gd+96($pop214)
	i32.const	$push213=, 0
	f64.load	$46=, gd+104($pop213)
	i32.const	$push212=, 0
	f64.load	$47=, gd+112($pop212)
	i32.const	$push211=, 0
	f64.load	$48=, gd+120($pop211)
	i32.const	$push210=, 0
	f64.load	$49=, gd+128($pop210)
	i32.const	$push209=, 0
	f64.load	$50=, gd+136($pop209)
	i32.const	$push208=, 0
	f64.load	$51=, gd+144($pop208)
	i32.const	$push207=, 0
	f64.load	$52=, gd+152($pop207)
	i32.const	$push206=, 0
	f64.load	$53=, gd+160($pop206)
	i32.const	$push205=, 0
	f64.load	$54=, gd+168($pop205)
	i32.const	$push204=, 0
	f64.load	$55=, gd+176($pop204)
	i32.const	$push203=, 0
	f64.load	$56=, gd+184($pop203)
	i32.const	$push202=, 0
	f64.load	$57=, gd+192($pop202)
	i32.const	$push201=, 0
	f64.load	$58=, gd+200($pop201)
	i32.const	$push200=, 0
	f64.load	$59=, gd+208($pop200)
	i32.const	$push199=, 0
	f64.load	$60=, gd+216($pop199)
	i32.const	$push198=, 0
	f64.load	$61=, gd+224($pop198)
	i32.const	$push197=, 0
	f64.load	$62=, gd+232($pop197)
	i32.const	$push196=, 0
	f64.load	$63=, gd+240($pop196)
	i32.const	$push195=, 0
	f64.load	$64=, gd+248($pop195)
	i32.const	$push194=, 0
	f64.load	$65=, gd($pop194)
	i32.const	$push193=, 0
	f64.load	$66=, gd+8($pop193)
	i32.const	$push192=, 0
	f64.load	$67=, gd+16($pop192)
	i32.const	$push191=, 0
	f64.load	$68=, gd+24($pop191)
	i32.const	$push190=, 0
	f64.load	$69=, gd+32($pop190)
	i32.const	$push189=, 0
	f64.load	$70=, gd+40($pop189)
	i32.const	$push188=, 0
	f64.load	$71=, gd+48($pop188)
	i32.const	$push187=, 0
	f64.load	$72=, gd+56($pop187)
	i32.const	$push186=, 0
	f64.load	$73=, gd+64($pop186)
	i32.const	$push185=, 0
	f64.load	$74=, gd+72($pop185)
	i32.const	$push184=, 0
	f64.load	$75=, gd+80($pop184)
	i32.const	$push183=, 0
	f64.load	$76=, gd+88($pop183)
	i32.const	$push182=, 0
	f64.load	$77=, gd+96($pop182)
	i32.const	$push181=, 0
	f64.load	$78=, gd+104($pop181)
	i32.const	$push180=, 0
	f64.load	$79=, gd+112($pop180)
	i32.const	$push179=, 0
	f64.load	$80=, gd+120($pop179)
	i32.const	$push178=, 0
	f64.load	$81=, gd+128($pop178)
	i32.const	$push177=, 0
	f64.load	$82=, gd+136($pop177)
	i32.const	$push176=, 0
	f64.load	$83=, gd+144($pop176)
	i32.const	$push175=, 0
	f64.load	$84=, gd+152($pop175)
	i32.const	$push174=, 0
	f64.load	$85=, gd+160($pop174)
	i32.const	$push173=, 0
	f64.load	$86=, gd+168($pop173)
	i32.const	$push172=, 0
	f64.load	$87=, gd+176($pop172)
	i32.const	$push171=, 0
	f64.load	$88=, gd+184($pop171)
	i32.const	$push170=, 0
	f64.load	$89=, gd+192($pop170)
	i32.const	$push169=, 0
	f64.load	$90=, gd+200($pop169)
	i32.const	$push168=, 0
	f64.load	$91=, gd+208($pop168)
	i32.const	$push167=, 0
	f64.load	$92=, gd+216($pop167)
	i32.const	$push166=, 0
	f64.load	$93=, gd+224($pop166)
	i32.const	$push165=, 0
	f64.load	$94=, gd+232($pop165)
	i32.const	$push164=, 0
	f64.load	$95=, gd+240($pop164)
	i32.const	$push163=, 0
	f64.load	$96=, gd+248($pop163)
	i32.const	$push162=, 0
	f64.load	$97=, gd($pop162)
	i32.const	$push161=, 0
	f64.load	$98=, gd+8($pop161)
	i32.const	$push160=, 0
	f64.load	$99=, gd+16($pop160)
	i32.const	$push159=, 0
	f64.load	$100=, gd+24($pop159)
	i32.const	$push158=, 0
	f64.load	$101=, gd+32($pop158)
	i32.const	$push157=, 0
	f64.load	$102=, gd+40($pop157)
	i32.const	$push156=, 0
	f64.load	$103=, gd+48($pop156)
	i32.const	$push155=, 0
	f64.load	$104=, gd+56($pop155)
	i32.const	$push154=, 0
	f64.load	$105=, gd+64($pop154)
	i32.const	$push153=, 0
	f64.load	$106=, gd+72($pop153)
	i32.const	$push152=, 0
	f64.load	$107=, gd+80($pop152)
	i32.const	$push151=, 0
	f64.load	$108=, gd+88($pop151)
	i32.const	$push150=, 0
	f64.load	$109=, gd+96($pop150)
	i32.const	$push149=, 0
	f64.load	$110=, gd+104($pop149)
	i32.const	$push148=, 0
	f64.load	$111=, gd+112($pop148)
	i32.const	$push147=, 0
	f64.load	$112=, gd+120($pop147)
	i32.const	$push146=, 0
	f64.load	$113=, gd+128($pop146)
	i32.const	$push145=, 0
	f64.load	$114=, gd+136($pop145)
	i32.const	$push144=, 0
	f64.load	$115=, gd+144($pop144)
	i32.const	$push143=, 0
	f64.load	$116=, gd+152($pop143)
	i32.const	$push142=, 0
	f64.load	$117=, gd+160($pop142)
	i32.const	$push141=, 0
	f64.load	$118=, gd+168($pop141)
	i32.const	$push140=, 0
	f64.load	$119=, gd+176($pop140)
	i32.const	$push139=, 0
	f64.load	$120=, gd+184($pop139)
	i32.const	$push138=, 0
	f64.load	$121=, gd+192($pop138)
	i32.const	$push137=, 0
	f64.load	$122=, gd+200($pop137)
	i32.const	$push136=, 0
	f64.load	$123=, gd+208($pop136)
	i32.const	$push135=, 0
	f64.load	$124=, gd+216($pop135)
	i32.const	$push134=, 0
	f64.load	$125=, gd+224($pop134)
	i32.const	$push133=, 0
	f64.load	$126=, gd+232($pop133)
	i32.const	$push132=, 0
	f64.load	$127=, gd+240($pop132)
	i32.const	$push131=, 0
	f64.load	$128=, gd+248($pop131)
	i32.const	$push130=, 0
	f32.store	gf($pop130), $1
	i32.const	$push129=, 0
	f32.store	gf+4($pop129), $2
	i32.const	$push128=, 0
	f32.store	gf+8($pop128), $3
	i32.const	$push127=, 0
	f32.store	gf+12($pop127), $4
	i32.const	$push126=, 0
	f32.store	gf+16($pop126), $5
	i32.const	$push125=, 0
	f32.store	gf+20($pop125), $6
	i32.const	$push124=, 0
	f32.store	gf+24($pop124), $7
	i32.const	$push123=, 0
	f32.store	gf+28($pop123), $8
	i32.const	$push122=, 0
	f32.store	gf+32($pop122), $9
	i32.const	$push121=, 0
	f32.store	gf+36($pop121), $10
	i32.const	$push120=, 0
	f32.store	gf+40($pop120), $11
	i32.const	$push119=, 0
	f32.store	gf+44($pop119), $12
	i32.const	$push118=, 0
	f32.store	gf+48($pop118), $13
	i32.const	$push117=, 0
	f32.store	gf+52($pop117), $14
	i32.const	$push116=, 0
	f32.store	gf+56($pop116), $15
	i32.const	$push115=, 0
	f32.store	gf+60($pop115), $16
	i32.const	$push114=, 0
	f32.store	gf+64($pop114), $17
	i32.const	$push113=, 0
	f32.store	gf+68($pop113), $18
	i32.const	$push112=, 0
	f32.store	gf+72($pop112), $19
	i32.const	$push111=, 0
	f32.store	gf+76($pop111), $20
	i32.const	$push110=, 0
	f32.store	gf+80($pop110), $21
	i32.const	$push109=, 0
	f32.store	gf+84($pop109), $22
	i32.const	$push108=, 0
	f32.store	gf+88($pop108), $23
	i32.const	$push107=, 0
	f32.store	gf+92($pop107), $24
	i32.const	$push106=, 0
	f32.store	gf+96($pop106), $25
	i32.const	$push105=, 0
	f32.store	gf+100($pop105), $26
	i32.const	$push104=, 0
	f32.store	gf+104($pop104), $27
	i32.const	$push103=, 0
	f32.store	gf+108($pop103), $28
	i32.const	$push102=, 0
	f32.store	gf+112($pop102), $29
	i32.const	$push101=, 0
	f32.store	gf+116($pop101), $30
	i32.const	$push100=, 0
	f32.store	gf+120($pop100), $31
	i32.const	$push99=, 0
	f32.store	gf+124($pop99), $32
	i32.const	$push98=, -1
	i32.add 	$0=, $0, $pop98
	f64.add 	$push2=, $160, $33
	f64.add 	$push3=, $65, $pop2
	f64.add 	$160=, $97, $pop3
	f64.add 	$push4=, $159, $34
	f64.add 	$push5=, $66, $pop4
	f64.add 	$159=, $98, $pop5
	f64.add 	$push6=, $158, $35
	f64.add 	$push7=, $67, $pop6
	f64.add 	$158=, $99, $pop7
	f64.add 	$push8=, $157, $36
	f64.add 	$push9=, $68, $pop8
	f64.add 	$157=, $100, $pop9
	f64.add 	$push10=, $156, $37
	f64.add 	$push11=, $69, $pop10
	f64.add 	$156=, $101, $pop11
	f64.add 	$push12=, $155, $38
	f64.add 	$push13=, $70, $pop12
	f64.add 	$155=, $102, $pop13
	f64.add 	$push14=, $154, $39
	f64.add 	$push15=, $71, $pop14
	f64.add 	$154=, $103, $pop15
	f64.add 	$push16=, $153, $40
	f64.add 	$push17=, $72, $pop16
	f64.add 	$153=, $104, $pop17
	f64.add 	$push18=, $152, $41
	f64.add 	$push19=, $73, $pop18
	f64.add 	$152=, $105, $pop19
	f64.add 	$push20=, $151, $42
	f64.add 	$push21=, $74, $pop20
	f64.add 	$151=, $106, $pop21
	f64.add 	$push22=, $150, $43
	f64.add 	$push23=, $75, $pop22
	f64.add 	$150=, $107, $pop23
	f64.add 	$push24=, $149, $44
	f64.add 	$push25=, $76, $pop24
	f64.add 	$149=, $108, $pop25
	f64.add 	$push26=, $148, $45
	f64.add 	$push27=, $77, $pop26
	f64.add 	$148=, $109, $pop27
	f64.add 	$push28=, $147, $46
	f64.add 	$push29=, $78, $pop28
	f64.add 	$147=, $110, $pop29
	f64.add 	$push30=, $146, $47
	f64.add 	$push31=, $79, $pop30
	f64.add 	$146=, $111, $pop31
	f64.add 	$push32=, $145, $48
	f64.add 	$push33=, $80, $pop32
	f64.add 	$145=, $112, $pop33
	f64.add 	$push34=, $144, $49
	f64.add 	$push35=, $81, $pop34
	f64.add 	$144=, $113, $pop35
	f64.add 	$push36=, $143, $50
	f64.add 	$push37=, $82, $pop36
	f64.add 	$143=, $114, $pop37
	f64.add 	$push38=, $142, $51
	f64.add 	$push39=, $83, $pop38
	f64.add 	$142=, $115, $pop39
	f64.add 	$push40=, $141, $52
	f64.add 	$push41=, $84, $pop40
	f64.add 	$141=, $116, $pop41
	f64.add 	$push42=, $140, $53
	f64.add 	$push43=, $85, $pop42
	f64.add 	$140=, $117, $pop43
	f64.add 	$push44=, $139, $54
	f64.add 	$push45=, $86, $pop44
	f64.add 	$139=, $118, $pop45
	f64.add 	$push46=, $138, $55
	f64.add 	$push47=, $87, $pop46
	f64.add 	$138=, $119, $pop47
	f64.add 	$push48=, $137, $56
	f64.add 	$push49=, $88, $pop48
	f64.add 	$137=, $120, $pop49
	f64.add 	$push50=, $136, $57
	f64.add 	$push51=, $89, $pop50
	f64.add 	$136=, $121, $pop51
	f64.add 	$push52=, $135, $58
	f64.add 	$push53=, $90, $pop52
	f64.add 	$135=, $122, $pop53
	f64.add 	$push54=, $134, $59
	f64.add 	$push55=, $91, $pop54
	f64.add 	$134=, $123, $pop55
	f64.add 	$push56=, $133, $60
	f64.add 	$push57=, $92, $pop56
	f64.add 	$133=, $124, $pop57
	f64.add 	$push58=, $132, $61
	f64.add 	$push59=, $93, $pop58
	f64.add 	$132=, $125, $pop59
	f64.add 	$push60=, $131, $62
	f64.add 	$push61=, $94, $pop60
	f64.add 	$131=, $126, $pop61
	f64.add 	$push62=, $130, $63
	f64.add 	$push63=, $95, $pop62
	f64.add 	$130=, $127, $pop63
	f64.add 	$push64=, $129, $64
	f64.add 	$push65=, $96, $pop64
	f64.add 	$129=, $128, $pop65
	br_if   	0, $0           # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop
	end_block                       # label0:
	i32.const	$push290=, 0
	f64.store	gd($pop290), $160
	i32.const	$push289=, 0
	f64.store	gd+8($pop289), $159
	i32.const	$push288=, 0
	f64.store	gd+16($pop288), $158
	i32.const	$push287=, 0
	f64.store	gd+24($pop287), $157
	i32.const	$push286=, 0
	f64.store	gd+32($pop286), $156
	i32.const	$push285=, 0
	f64.store	gd+40($pop285), $155
	i32.const	$push284=, 0
	f64.store	gd+48($pop284), $154
	i32.const	$push283=, 0
	f64.store	gd+56($pop283), $153
	i32.const	$push282=, 0
	f64.store	gd+64($pop282), $152
	i32.const	$push281=, 0
	f64.store	gd+72($pop281), $151
	i32.const	$push280=, 0
	f64.store	gd+80($pop280), $150
	i32.const	$push279=, 0
	f64.store	gd+88($pop279), $149
	i32.const	$push278=, 0
	f64.store	gd+96($pop278), $148
	i32.const	$push277=, 0
	f64.store	gd+104($pop277), $147
	i32.const	$push276=, 0
	f64.store	gd+112($pop276), $146
	i32.const	$push275=, 0
	f64.store	gd+120($pop275), $145
	i32.const	$push274=, 0
	f64.store	gd+128($pop274), $144
	i32.const	$push273=, 0
	f64.store	gd+136($pop273), $143
	i32.const	$push272=, 0
	f64.store	gd+144($pop272), $142
	i32.const	$push271=, 0
	f64.store	gd+152($pop271), $141
	i32.const	$push270=, 0
	f64.store	gd+160($pop270), $140
	i32.const	$push269=, 0
	f64.store	gd+168($pop269), $139
	i32.const	$push268=, 0
	f64.store	gd+176($pop268), $138
	i32.const	$push267=, 0
	f64.store	gd+184($pop267), $137
	i32.const	$push266=, 0
	f64.store	gd+192($pop266), $136
	i32.const	$push265=, 0
	f64.store	gd+200($pop265), $135
	i32.const	$push264=, 0
	f64.store	gd+208($pop264), $134
	i32.const	$push263=, 0
	f64.store	gd+216($pop263), $133
	i32.const	$push262=, 0
	f64.store	gd+224($pop262), $132
	i32.const	$push261=, 0
	f64.store	gd+232($pop261), $131
	i32.const	$push260=, 0
	f64.store	gd+240($pop260), $130
	i32.const	$push259=, 0
	f64.store	gd+248($pop259), $129
                                        # fallthrough-return
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
	.local  	f64, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$1=, 0
	f64.const	$0=, 0x0p0
	i32.const	$3=, gd
	i32.const	$2=, gf
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	f64.store	0($3), $0
	f32.convert_s/i32	$push0=, $1
	f32.store	0($2), $pop0
	i32.const	$push15=, 4
	i32.add 	$2=, $2, $pop15
	i32.const	$push14=, 8
	i32.add 	$3=, $3, $pop14
	f64.const	$push13=, 0x1p0
	f64.add 	$0=, $0, $pop13
	i32.const	$push12=, 1
	i32.add 	$1=, $1, $pop12
	i32.const	$push11=, 32
	i32.ne  	$push1=, $1, $pop11
	br_if   	0, $pop1        # 0: up to label2
# %bb.2:                                # %for.end
	end_loop
	i32.const	$push16=, 1
	call    	foo@FUNCTION, $pop16
	i32.const	$2=, gd
	i32.const	$1=, 0
	i32.const	$3=, 0
.LBB1_3:                                # %for.body6
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label4:
	f64.load	$push3=, 0($2)
	f64.convert_s/i32	$push2=, $1
	f64.ne  	$push4=, $pop3, $pop2
	br_if   	1, $pop4        # 1: down to label3
# %bb.4:                                # %lor.lhs.false
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.const	$push17=, gf
	i32.add 	$push5=, $1, $pop17
	f32.load	$push6=, 0($pop5)
	f32.convert_s/i32	$push7=, $3
	f32.ne  	$push8=, $pop6, $pop7
	br_if   	1, $pop8        # 1: down to label3
# %bb.5:                                # %for.cond3
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.const	$push21=, 1
	i32.add 	$3=, $3, $pop21
	i32.const	$push20=, 4
	i32.add 	$1=, $1, $pop20
	i32.const	$push19=, 8
	i32.add 	$2=, $2, $pop19
	i32.const	$push18=, 31
	i32.le_u	$push9=, $3, $pop18
	br_if   	0, $pop9        # 0: up to label4
# %bb.6:                                # %for.end17
	end_loop
	i32.const	$push10=, 0
	call    	exit@FUNCTION, $pop10
	unreachable
.LBB1_7:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	gd                      # @gd
	.type	gd,@object
	.section	.bss.gd,"aw",@nobits
	.globl	gd
	.p2align	4
gd:
	.skip	256
	.size	gd, 256

	.hidden	gf                      # @gf
	.type	gf,@object
	.section	.bss.gf,"aw",@nobits
	.globl	gf
	.p2align	4
gf:
	.skip	128
	.size	gf, 128


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
