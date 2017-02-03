C MEMBER STAT16
C  (from old member MCEX16)
C
      SUBROUTINE STAT16(PO,QS,QO,VA,VB,NA,NB,NM,XM,YM,XDM,XDMSQ,XDMABS,
     1XMD,VME,VMR,VMD,XM2,YM2,XYM,TSDA,TSDS,NLT,TSX,TSY,TXYD,TMSXYD,
     2XMSQ,YMSQ,XY,LD,LY,LM,VO,VS,ASIM,AOBS,KKL,NZ,QEX,SIM,OBS,ORD,
     3IMONTH,IYEAR,LMONTH,LYEAR)
C.......................................................................
C     THIS SUBROUTINE PERFORMS THE STATISTICS COMPUTATIONS FOR THE QME
C     STATISTICS OPERATION.
C.......................................................................
C     SUBROUTINE INITIALLY WRITTEN BY
C        LARRY BRAZIL -- HRL   APRIL 1980   VERSION 1
C.......................................................................
C
      DOUBLE PRECISION A,B,C,D,E
C
      DIMENSION PO(1),QS(1),QO(1),VA(1),VB(1),NA(1),NB(1),NM(1),XM(1),
     1YM(1),XDM(1),XDMSQ(1),MO(12)
      DIMENSION XDMABS(1),XMD(1),VME(1),VMR(1),VMD(1),XM2(1),YM2(1),
     1XYM(1),TSDA(1),TSDS(1)
      DIMENSION NLT(1),TSX(1),TSY(1),TXYD(1),TMSXYD(1),LD(1),LY(1),
     1LM(1),VO(1),VS(1)
      DIMENSION AOBS(1),ASIM(1),NZ(1),QEX(1),SIM(1),OBS(1),ORD(1),
     1MON(3,12),IMO(12)
      DIMENSION SX(7),SY(7),LN(7),SXYA(7),SXYE(7),SXYS(7),SSXYD(7)
      DIMENSION FLOINT(7)
C
      INCLUDE 'common/fdbug'
      INCLUDE 'common/ionum'
      INCLUDE 'common/fctime'
      INCLUDE 'common/fwyds'
      INCLUDE 'common/fwydat'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/calb/src/calb_statqme/RCS/stat16.f,v $
     . $',                                                             '
     .$Id: stat16.f,v 1.2 1996/07/11 19:45:52 dws Exp $
     . $' /
C    ===================================================================
C
C
      DATA MON/4HJANU,4HARY ,4H    ,4HFEBR,4HUARY,4H    ,4HMARC,4HH   ,
     14H    ,4HAPRI,4HL   ,4H    ,4HMAY ,4H    ,4H    ,4HJUNE,4H    ,
     24H    ,4HJULY,4H    ,4H    ,4HAUGU,4HST  ,4H    ,4HSEPT,4HEMBE,
     34HR   ,4HOCTO,4HBER ,4H    ,4HNOVE,4HMBER,4H    ,4HDECE,4HMBER,
     44H    /
      DATA IMO/31,28,31,30,31,30,31,31,30,31,30,31/
      DATA MS1,MS2/4HLE  ,4HGT  /
      DATA DOT,BLANK,ASTER,PLUS/1H.,1H ,1H*,1H+/
C.......................................................................
C     CHECK TRACE LEVEL -- TRACE LEVEL FOR THIS SUBROUTINE=1
      IF(ITRACE.GE.1) WRITE(IODBUG,900)
  900 FORMAT(1H0,17H** STAT16 ENTERED)
C.......................................................................
C     CHECK TO SEE IF DEBUG OUTPUT IS NEEDED FOR THIS OPERATION.
      IBUG=0
      IF(IDBALL.GT.0) GO TO 11
      IF(NDEBUG.EQ.0) GO TO 100
      DO 10 I=1,NDEBUG
      IF(IDEBUG(I).EQ.16) GO TO 11
   10 CONTINUE
      GO TO 100
   11 IBUG=1
  100 CONTINUE
C.......................................................................
C     DEBUG OUTPUT - PRINT PO()
      IF(IBUG.EQ.0) GO TO 102
      NPO=PO(28)
      WRITE(IODBUG,910) NPO
  910 FORMAT(1H0,21HCONTENTS OF PO ARRAY.,5X,
     117HNUMBER OF VALUES=,I3)
      WRITE(IODBUG,911) (PO(I),I=1,NPO)
  911 FORMAT(1H0,15F8.3)
  102 CONTINUE
C.......................................................................
C
C     DETERMINE CURRENT WATER YEAR
      CALL MDYH1(IDA,IHR,MONTH,ID,IY,IHOU,NLSTZ,NOUTDS,IZONE)
      JYEAR=IY
      IF(MONTH.GT.9) JYEAR=JYEAR+1
      IF(IMONTH.GT.9) IYEAR=IYEAR+1
      IF(LMONTH.GT.9) LYEAR=LYEAR+1
C
C.......................................................................
C
C     STORE CONTROL VARIABLES
      AREA=PO(7)
      IYR=PO(16)
      IQR=PO(17)
      IFR=PO(18)
      EXCED=PO(19)
      IWS=PO(20)
      IXWY=PO(21)
      FLOINT(1)=0.0
      DO 70 I=2,7
   70 FLOINT(I)=PO(20+I)
C
C     INITIALIZATION OF DATA
      DO 80 I=1,7
      SX(I)=0.0
      SY(I)=0.0
      LN(I)=0
      SXYA(I)=0.0
      SXYE(I)=0.0
      SXYS(I)=0.0
   80 SSXYD(I)=0.0
      KL=KKL
      A=0.0D0
      B=0.0D0
      C=0.0D0
      D=0.0D0
      E=0.0D0
      KK=0
      YD=0.0
      NY=0
      TXY=0.0
      TXSQ=0.0
      TYSQ=0.0
C
C.......................................................................
C
C     START COMPUTATIONS -- YEARLY LOOP
C
C     WRITE OUT YEARLY HEADINGS
C
      IF(IYR.EQ.0) GO TO 81
      WRITE(IPR,230) (PO(I),I=2,6),PO(7),JYEAR
C
C     START MONTHLY LOOP
C
   81 L=10
      DO 91 I=1,12
      MO(I)=L
      L=L+1
   91 IF(L.GT.12) L=1
      DO 92 JJ=1,12
      IF(IMONTH.EQ.MO(JJ)) IM=JJ
   92 IF(LMONTH.EQ.MO(JJ)) LMM=JJ
C
      MI=9
      DO 110 KI=1,12
      MI=MI+1
      IF(MI.GT.12) MI=1
      KK=KK+1
      IF(KI.LT.IM.AND.JYEAR.LE.IYEAR) GO TO 133
      IF(KI.GT.LMM.AND.JYEAR.GE.LYEAR) GO TO 133
C
C     READ DISCHARGE DATA FROM SCRATCH FILE.
C
      IXWY=PO(21)
      IF(KI.LT.7) GO TO 85
      MX=7
      IXWY=IXWY+1
      GO TO 86
   85 MX=1
   86 MN=(KI-MX)*62
      READ(IRWY,REC=IXWY) (WY(I),I=1,372)
      DO 90 K=1,31
      ILOC=MN+K
      QS(K)=WY(ILOC)
      LOC=ILOC+31
   90 QO(K)=WY(LOC)
C
C     DETERMINE NUMBER OF DAYS IN THE CURRENT MONTH
C
      IK=JYEAR/4-(JYEAR-1)/4
      N=IMO(MI)
      IF(MI.EQ.2) N=N+IK
C
      NR=0
      XS=0.0
      YS=0.0
      ERR=0.0
      XMY=0.0
      AXMY=0.0
      XMYSQ=0.0
C
C     START DAILY LOOP
C
      DO 120 J=1,N
C
C     INTERVAL DETERMINATION
C
      IF(QS(J).LT.0.0.OR.QO(J).LT.0.0) GO TO 120
      IF(QO(J).GE.0.0.AND.QO(J).LT.PO(22)) IC=1
      IF(QO(J).GE.PO(22).AND.QO(J).LT.PO(23)) IC=2
      IF(QO(J).GE.PO(23).AND.QO(J).LT.PO(24)) IC=3
      IF(QO(J).GE.PO(24).AND.QO(J).LT.PO(25)) IC=4
      IF(QO(J).GE.PO(25).AND.QO(J).LT.PO(26)) IC=5
      IF(QO(J).GE.PO(26).AND.QO(J).LE.PO(27)) IC=6
      IF(QO(J).GE.PO(27)) IC=7
      LN(IC)=LN(IC)+1
C
C     YEARLY ACCUMULATIONS
C
      NY=NY+1
      NR=NR+1
      K=LN(IC)
      QSQO=QS(J)*QO(J)
      IF(QS(J).LT.1.E-5) QS(J)=1.E-5
      IF(QO(J).LT.1.E-5) QO(J)=1.E-5
      QS2=QS(J)**2
      QO2=QO(J)**2
      QSMQO=QS(J)-QO(J)
      QSMQO2=0.0
      IF(ABS(QS(J)-QO(J)).GT.1.E-5) QSMQO2=(QS(J)-QO(J))**2
      XS=XS+QS(J)
      YS=YS+QO(J)
      XMY=XMY+QSMQO
      AXMY=AXMY+ABS(QSMQO)
      IF(IYR.EQ.0) GO TO 101
      TXY=TXY+QSQO
      TXSQ=TXSQ+QS2
      TYSQ=TYSQ+QO2
      IF(ABS(ERR).LT.ABS(QSMQO)) ERR=QSMQO
      IF(ABS(YD).LT.ABS(QSMQO)) YD=QSMQO
      XMYSQ=XMYSQ+QSMQO2
      SX(IC)=SX(IC)+QS(J)
      SY(IC)=SY(IC)+QO(J)
      IF(ABS(SXYE(IC)).LT.ABS(QSMQO))SXYE(IC)=QSMQO
      SXYA(IC)=SXYA(IC)+ABS(QSMQO)
      SXYS(IC)=SXYS(IC)+QSMQO2
      SSXYD(IC)=SSXYD(IC)+QSMQO
C
C     MULTI-YEAR ACCUMULATIONS
C
  101 NM(MI)=NM(MI)+1
      XM(MI)=XM(MI)+QS(J)
      YM(MI)=YM(MI)+QO(J)
      XM2(MI)=XM2(MI)+QS2
      YM2(MI)=YM2(MI)+QO2
      XYM(MI)=XYM(MI)+QSQO
      IF(ABS(XDM(MI)).LT.ABS(QSMQO))XDM(MI)=QSMQO
      XDMSQ(MI)=XDMSQ(MI)+QSMQO2
      XDMABS(MI)=XDMABS(MI)+ABS(QSMQO)
      XMSQ=XMSQ+QS2
      YMSQ=YMSQ+QO2
      XY=XY+QSQO
      XMD(MI)=XMD(MI)+QSMQO
      NLT(IC)=NLT(IC)+1
      TSDA(IC)=TSDA(IC)+ABS(QSMQO)
      TSDS(IC)=TSDS(IC)+QSMQO2
      TSX(IC)=TSX(IC)+QS(J)
      TSY(IC)=TSY(IC)+QO(J)
      TXYD(IC)=TXYD(IC)+QSMQO
      IF(ABS(TMSXYD(IC)).LT.ABS(QSMQO)) TMSXYD(IC)=QSMQO
C
C     CUMMULATIVE FREQUENCY COMPUTATIONS
      IF(IFR.EQ.0) GO TO 117
      IF(QO(J).EQ.0.0) GO TO 117
      P=.02
      DO 118 LP=1,51
      X=ABS(QSMQO/QO(J))
      IF(X.GT.P) GO TO 119
      NZ(LP)=NZ(LP)+1
      GO TO 117
  119 IF(P.GE.2.49) GO TO 117
      IF(P.GE.0.99.AND.P.LT.2.49) P=P+0.1
      IF(P.GE.0.49.AND.P.LT.0.99) P=P+.05
      IF(P.LT.0.49) P=P+0.02
  118 CONTINUE
  117 CONTINUE
C
C     25 LARGEST DAILY ERROR COMPUTATIONS
C
      Y=0.0
      IF(ABS(VO(1)-VS(1)).GT.1.E-5) Y=(VO(1)-VS(1))**2
      IF(QSMQO2.LE.Y) GO TO 123
      DO 121 L=2,25
      Y=0.0
      IF(ABS(VO(L)-VS(L)).GT.1.E-5) Y=(VO(L)-VS(L))**2
      IF(QSMQO2.GT.Y.AND.L.NE.25) GO TO 121
      LK=L-2
      IF(QSMQO2.GT.Y.AND.L.EQ.25) LK=24
      IF(LK.EQ.0) GO TO 124
      DO 122 LP=1,LK
      LM(LP)=LM(LP+1)
      LD(LP)=LD(LP+1)
      LY(LP)=LY(LP+1)
      VO(LP)=VO(LP+1)
  122 VS(LP)=VS(LP+1)
  124 LM(LK+1)=MI
      LD(LK+1)=J
      LY(LK+1)=JYEAR
      VO(LK+1)=QO(J)
      VS(LK+1)=QS(J)
      IF(MI.GT.9) LY(LK+1)=JYEAR-1
      GO TO 123
  121 CONTINUE
  123 CONTINUE
C
C     DISCHARGE-EXCEEDENCE TABLE COMPUTATIONS
C
      IF(PO(19).LT.0.01) GO TO 160
      IF(QS(J).LE.0.0.OR.QO(J).LE.0.0) GO TO 160
      DO 151 K=1,20
      IF(QS(J).LE.QEX(K)) GO TO 152
      SIM(K)=SIM(K)+1.0
  151 CONTINUE
  152 DO 154 K=1,20
      IF(QO(J).LE.QEX(K)) GO TO 160
      OBS(K)=OBS(K)+1.0
  154 CONTINUE
  160 CONTINUE
C
  120 CONTINUE
C
C     END OF MAIN DAILY LOOP
C
C.......................................................................
C
C     QUARTERLY ACCUMULATIVE FLOW COMPUTATIONS
C
      IF(IQR.EQ.0) GO TO 142
      AOBS(KL)=AOBS(KL)+(YS/AREA)*86.4
      ASIM(KL)=ASIM(KL)+(XS/AREA)*86.4
  142 CONTINUE
C
C     MULTI-YEAR STATISTICS CALCULATIONS
C
      X=0.0
      IF(ABS(XS-YS).GT.1.E-5) X=((XS-YS)/AREA)*86.4
      VME(MI)=VME(MI)+ABS(X)
      VMR(MI)=VMR(MI)+X**2
      IF(ABS(VMD(MI)).LT.ABS(X)) VMD(MI)=X
C
C     12 LARGEST MONTHLY VOLUME ERRORS
C
      R=X**2
      Y=0.0
      IF(ABS(VA(1)-VB(1)).GT.1.E-5) Y=(VA(1)-VB(1))**2
      IF(R.LE.Y) GO TO 131
      DO 128 J=2,12
      Y=0.0
      IF(ABS(VA(J)-VB(J)).GT.1.E-5) Y=(VA(J)-VB(J))**2
      IF(R.GT.Y.AND.J.NE.12) GO TO 128
      LK=J-2
      IF(R.GT.Y.AND.J.EQ.12) LK=11
      IF(LK.EQ.0) GO TO 130
      DO 129 K=1,LK
      VA(K)=VA(K+1)
      VB(K)=VB(K+1)
      NA(K)=NA(K+1)
  129 NB(K)=NB(K+1)
  130 VA(LK+1)=(YS/AREA)*86.4
      VB(LK+1)=(XS/AREA)*86.4
      NA(LK+1)=MI
      NB(LK+1)=JYEAR
      IF(MI.GT.9) NB(LK+1)=JYEAR-1
      GO TO 131
  128 CONTINUE
  131 CONTINUE
C
C     PRINT MONTHLY STATISTICS FOR YEARLY COMPUTATIONS
C
      IF(IYR.EQ.0) GO TO 161
      IF(NR.LE.0) GO TO 133
      FMEAN=XS/NR
      OMEAN=YS/NR
      BIA=(XMY/AREA)*86.4
      IF(OMEAN.EQ.0.0.AND.FMEAN.EQ.0.0) GO TO 136
      IF(OMEAN.EQ.0.0) GO TO 132
      AERR=(XMY/NR)/OMEAN*100.0
      PAVG=(AXMY/NR)/OMEAN*100.0
      PRMS=SQRT(XMYSQ/NR)/OMEAN*100.0
      IF(PRMS.GT.9000.0) GO TO 132
      GO TO 126
  132 WRITE(IPR,237) (MON(K,MI),K=1,3),FMEAN,OMEAN,BIA,ERR
      GO TO 161
  136 AERR=0.0
      PAVG=0.0
      PRMS=0.0
  126 WRITE(IPR,235) (MON(K,MI),K=1,3),FMEAN,OMEAN,AERR,BIA,ERR,PAVG,
     1PRMS
C
  161 CONTINUE
C
C     YEARLY SUMS
C
      A=A+DBLE(XS)
      B=B+DBLE(YS)
      C=C+DBLE(XMY)
      D=D+DBLE(AXMY)
      E=E+DBLE(XMYSQ)
      GO TO 127
  133 IF(IYR.EQ.1) WRITE(IPR,236) (MON(K,MI),K=1,3)
  127 IF(KI.EQ.12.AND.IYR.EQ.1) WRITE(IPR,250)
C
C     COUNTER FOR QUARTERLY ACCUM. FLOWS
C
      IF(KK.LT.3.OR.IQR.EQ.0) GO TO 140
      KKL=KKL+1
      KL=KKL
      KK=0
  140 CONTINUE
  110 CONTINUE
C
C     END OF MAIN MONTHLY LOOP
C
C.......................................................................
C
C     YEARLY COMPUTATIONS OF AVERAGES
      IF(IYR.EQ.0) GO TO 113
      IF(NY.LE.0) GO TO 141
      FMEAN=SNGL(A)/NY
      OMEAN=SNGL(B)/NY
      BIA=(SNGL(C)/AREA)*86.4
      IF(OMEAN.EQ.0.0.AND.FMEAN.EQ.0.0) GO TO 137
      IF(OMEAN.EQ.0.0) GO TO 134
      AERR=(SNGL(C)/NY)/OMEAN*100.0
      PAVG=(SNGL(D)/NY)/OMEAN*100.0
      PRMS=SQRT(SNGL(E)/NY)/OMEAN*100.0
      IF(PRMS.GT.9000.0) GO TO 134
      GO TO 135
  134 WRITE(IPR,252) FMEAN,OMEAN,BIA,YD
      GO TO 138
  137 AERR=0.0
      PAVG=0.0
      PRMS=0.0
  135 CONTINUE
      ERR=YD
      WRITE(IPR,251)FMEAN,OMEAN,AERR,BIA,ERR,PAVG,PRMS
      GO TO 138
  141 WRITE(IPR,253)
      GO TO 113
C
C     YEARLY CORRELATIONS
C
  138 WRITE(IPR,250)
      PAVG=PAVG*OMEAN/100.0
      PRMS=PRMS*OMEAN/100.0
      IF(TXSQ/NY.NE.FMEAN) GO TO 170
      GO TO 171
  170 IF(TYSQ/NY.NE.OMEAN) GO TO 139
  171 WRITE(IPR,290) PRMS,PAVG
      GO TO 172
  139 R=(TXY/NY-FMEAN*OMEAN)/(SQRT(TXSQ/NY-FMEAN**2)*SQRT(TYSQ/NY-OMEAN*
     **2))
      BB=(TXY/NY-FMEAN*OMEAN)/(TXSQ/NY-FMEAN**2)
      AA=OMEAN-BB*FMEAN
      WRITE(IPR,241)PRMS,PAVG,R,AA,BB
C
C     YEARLY FLOW INTERVALS
C
  172 WRITE(IPR,260)
      DO 115 I=1,7
      IF(LN(I).EQ.0.AND.I.EQ.7) GO TO 111
      IF(LN(I).EQ.0) GO TO 112
      FMEAN=SX(I)/LN(I)
      OMEAN=SY(I)/LN(I)
      BIA=((SSXYD(I)/LN(I))/AREA)*86.4
      N=LN(I)
      ERR=SXYE(I)
      IF(OMEAN.EQ.0.0) GO TO 116
      AERR=(SSXYD(I)/LN(I))/OMEAN*100.0
      PRMS=SQRT(SXYS(I)/N)/OMEAN*100.0
      PAVG=(SXYA(I)/N)/OMEAN*100.0
      IF(I.EQ.7) GO TO 114
      WRITE(IPR,255) FLOINT(I),FLOINT(I+1),N,FMEAN,OMEAN,AERR,BIA,ERR,PA
     1VG,PRMS
      GO TO 115
  114 WRITE(IPR,256) FLOINT(I),N,FMEAN,OMEAN,AERR,BIA,ERR,PAVG,PRMS
      GO TO 115
  111 WRITE(IPR,257) FLOINT(I)
      GO TO 115
  112 WRITE(IPR,258) FLOINT(I),FLOINT(I+1)
      GO TO 115
  116 WRITE(IPR,259) FLOINT(I),FLOINT(I+1),N,FMEAN,OMEAN,BIA,ERR
  115 CONTINUE
      WRITE(IPR,274)
  113 IF(JYEAR.EQ.LYEAR) GO TO 276
      GO TO 150
C
C     END OF MAIN YEARLY LOOP
C
C.......................................................................
C
C     START MULTI-YEAR CALCULATIONS
C
C     CALCULATE AND PRINT MULTI-YEAR VALUES
C
  276 CONTINUE
      WRITE(IPR,240) (PO(I),I=2,6),PO(7),IYEAR,LYEAR
      ABIAS=0.0
      I=9
      DO 305 KI=1,12
      I=I+1
      IF(I.GT.12)I=1
C
      IF(NM(I).GT.0) GO TO 300
      WRITE(IPR,275) (MON(K,I),K=1,3)
      GO TO 305
  300 CONTINUE
      FNM=NM(I)
      FI=IMO(I)
      FMO=FNM/FI
C
      FMEAN=XM(I)/NM(I)
      OMEAN=YM(I)/NM(I)
      BIA=((XMD(I)/AREA)*86.4)/FMO
      ABIAS=ABIAS+BIA
      ERR=XDM(I)
      VMAX=VMD(I)
      IF(XM(I).EQ.0.0.AND.YM(I).EQ.0.0) GO TO 400
      IF(YM(I).EQ.0.0) GO TO 402
      AERR=XMD(I)/NM(I)/OMEAN*100.0
      PAVG=XDMABS(I)/NM(I)/OMEAN*100.0
      PRMS=SQRT(XDMSQ(I)/NM(I))/OMEAN*100.0
      VERR=VME(I)/(YM(I)/AREA*86.4)*100.0
      VRMS=SQRT(VMR(I)/FMO)/((YM(I)/FMO)/AREA*86.4)*100.0
      IF(PRMS.GT.9000.) GO TO 402
      GO TO 404
  402 WRITE(IPR,292) (MON(K,I),K=1,3),FMEAN,OMEAN,BIA,ERR,VMAX
      GO TO 305
  400 AERR=0.0
      PAVG=0.0
      PRMS=0.0
      VERR=0.0
      VRMS=0.0
  404 CONTINUE
  304 WRITE(IPR,243) (MON(K,I),K=1,3),FMEAN,OMEAN,AERR,BIA,ERR,PAVG,
     1PRMS,VMAX,VERR,VRMS
  305 CONTINUE
      WRITE(IPR,244)
C
C     CALCULATE YEARLY AVERAGE FOR MULTI-YEAR STATISTICS
C
      A=0.0D0
      B=0.0D0
      C=0.0D0
      D=0.0D0
      E=0.0D0
      NR=0
      ERR=0.0
      VERR=0.0
      VMAX=0.0
      VRMS=0.0
      DO 315 I=1,12
      NR=NR+NM(I)
      A=A+DBLE(XM(I))
      B=B+DBLE(YM(I))
      C=C+DBLE(XDMSQ(I))
      D=D+DBLE(XDMABS(I))
      E=E+DBLE(XMD(I))
      IF(ABS(ERR).LT.ABS(XDM(I))) ERR=XDM(I)
      IF(ABS(VMAX).LT.ABS(VMD(I))) VMAX=VMD(I)
      VERR=VERR+VME(I)
  315 VRMS=VRMS+VMR(I)
      IF(NR.GT.0) GO TO 316
      WRITE(IPR,254)
      GO TO 150
  316 Z=VRMS
      TM=VERR
      NP=NR
      FMEAN=SNGL(A)/NR
      OMEAN=SNGL(B)/NR
      FNM=NR
      FMO=(FNM/365.25)*12.0
      BIA=ABIAS
      AERR=(SNGL(E)/NR)/OMEAN*100.0
      PAVG=(SNGL(D)/NR)/OMEAN*100.0
      PRMS=SQRT(SNGL(C)/NR)/OMEAN*100.0
      VERR=VERR/(SNGL(B)/AREA*86.4)*100.0
      VRMS=SQRT(VRMS/FMO)/((SNGL(B)/FMO)/AREA*86.4)*100.0
      WRITE(IPR,247) FMEAN,OMEAN,AERR,BIA,ERR,PAVG,PRMS,VMAX,VERR,VRMS
      WRITE(IPR,244)
C
C     CALCULATE DAILY R, REGRESS. LINE, RMS, AVG ERR, VOL RMS, VOL ERR
C
      VRMS=SQRT(Z/FMO)
      VERR=TM/FMO
      PRMS=SQRT(SNGL(C)/NR)
      PRMSA=PRMS
      PAVG=SNGL(D)/NR
      IF(XMSQ/NR.NE.FMEAN) GO TO 180
      GO TO 181
  180 IF(YMSQ/NR.NE.OMEAN) GO TO 182
  181 WRITE(IPR,291) PRMS,PAVG,VERR,VRMS
      GO TO 183
  182 R=(XY/NR-FMEAN*OMEAN)/(SQRT(XMSQ/NR-FMEAN**2)*SQRT(YMSQ/NR-OMEAN**
     *2))
      BB=(XY/NR-FMEAN*OMEAN)/(XMSQ/NR-FMEAN**2)
      AA=OMEAN-BB*FMEAN
      WRITE(IPR,245) PRMS,PAVG,VERR,VRMS,R,AA,BB
C
C     CALCULATE MULTI-YEAR FLOW INTERVAL STATISTICS
C
  183 WRITE(IPR,260)
      DO 321 K=1,7
      N=NLT(K)
      IF(N.EQ.0.AND.K.EQ.7) GO TO 323
      IF(N.EQ.0) GO TO 324
      FMEAN=TSX(K)/NLT(K)
      OMEAN=TSY(K)/NLT(K)
      BIA=((TXYD(K)/NLT(K))/AREA)*86.4
      ERR=TMSXYD(K)
      IF(OMEAN.EQ.0.0) GO TO 325
      AERR=(TXYD(K)/NLT(K))/OMEAN*100.0
      PAVG=(TSDA(K)/NLT(K))/OMEAN*100.0
      PRMS=SQRT(TSDS(K)/NLT(K))/OMEAN*100.0
      IF(K.EQ.7) GO TO 322
      WRITE(IPR,255) FLOINT(K),FLOINT(K+1),N,FMEAN,OMEAN,AERR,BIA,ERR,PA
     1VG,PRMS
      GO TO 321
  322 WRITE(IPR,256) FLOINT(K),N,FMEAN,OMEAN,AERR,BIA,ERR,PAVG,PRMS
      GO TO 321
  323 WRITE(IPR,257) FLOINT(K)
      GO TO 321
  324 WRITE(IPR,258) FLOINT(K),FLOINT(K+1)
      GO TO 321
  325 WRITE(IPR,259) FLOINT(K),FLOINT(K+1),N,FMEAN,OMEAN,BIA,ERR
  321 CONTINUE
      WRITE(IPR,274)
C
C     PRINT OUT 25 LARGEST DAILY ERRORS
C
  328 WRITE(IPR,261)
      NR=NP
      DO 335 J=1,25
      I=26-J
      K=LM(I)
      IF(K.EQ.0) GO TO 336
      ERR=VS(I)-VO(I)
      PRMS2=(ERR**2/SNGL(C))*100.0
      D=C-DBLE(ERR**2)
      PRMS=0.0
      IF(ABS(PRMSA).GT.1.E-5) PRMS=(PRMSA-SQRT(SNGL(D)/NR))/PRMSA*100.0
      PAVG=0.0
      IF(ABS(VO(I)).GT.1.E-5) PAVG=ERR/VO(I)*100.0
  335 WRITE(IPR,262) (MON(L,K),L=1,3),LD(I),LY(I),VO(I),VS(I),ERR,PAVG,
     1PRMS2,PRMS
      GO TO 337
  336 WRITE(IPR,266)
C
C     PRINT OUT 12 MONTHLY LARGEST VOLUME ERRORS
C
  337 WRITE(IPR,264)
      DO 340 J=1,12
      I=13-J
      K=NA(I)
      IF(K.EQ.0) GO TO 345
      ERR=VB(I)-VA(I)
      PRMS2=(ERR**2/Z)*100.0
      D=DBLE(Z-ERR**2)
      IF(D.LT.0.0D0) D=0.0D0
      PRMS=(VRMS-SQRT(SNGL(D)/FMO))/VRMS*100.0
      IF(VA(I).LT.0.0001) GO TO 338
      PAVG=ERR/VA(I)*100.0
      IF(PAVG.GT.99999.) GO TO 338
      GO TO 339
  338 WRITE(IPR,265) (MON(L,K),L=1,3),NB(I),VA(I),VB(I),ERR,PRMS2,PRMS
      GO TO 340
  339 WRITE(IPR,263) (MON(L,K),L=1,3),NB(I),VA(I),VB(I),ERR,PAVG,PRMS2,
     1PRMS
  340 CONTINUE
C
      GO TO 350
  345 CONTINUE
      WRITE(IPR,280)
  350 CONTINUE
C
C     PRINT QUARTERLY ACCUMULATIVE FLOWS IF REQUESTED
C
      IF(IQR.EQ.0) GO TO 331
      WRITE(IPR,270)
      N=(LYEAR-IYEAR+1)*4
      K=IYEAR-1
      J=10
      X=0.0
      Y=0.0
      AA=0.0
      DO 327 I=1,N
      ERR=ASIM(I)-AOBS(I)
      X=X+ASIM(I)
      Y=Y+AOBS(I)
      AA=AA+ERR
      NR=J
      LK=J+2
      WRITE(IPR,271) (MON(L,NR),L=1,3),(MON(L,LK),L=1,3),K,Y,X,AA,ERR
      J=J+3
      IF(J.GE.12) J=1
  327 IF(LK.EQ.12) K=K+1
C
C     PRINT OUT CUMMULATIVE FREQUENCY TABLE IF REQUESTED
C
  331 IF(IFR.EQ.0) GO TO 360
      X=0.0
      Y=0.0
      LK=MS1
      DO 329 I=1,7
  329 Y=Y+NLT(I)
      IY=Y
      WRITE(IPR,272) IY
      P=0.02
      DO 330 I=1,51
      IF(X.GE.Y) GO TO 330
      X=X+NZ(I)
      A=DBLE(X/Y)
      IF(I.EQ.51) A=DBLE((Y-X)/Y)
      D=P*100.0
      C=A*100.0
      IX=X
      IF(I.EQ.51) IX=Y-X
      WRITE(IPR,273) IX,LK,D,C
      IF(P.GE.2.49) LK=MS2
      IF(P.GE.0.99. AND. P.LT.2.49) P=P+0.1
      IF(P.GE.0.49.AND.P.LT.0.99) P=P+0.05
      IF(P.LT.0.49) P=P+0.02
  330 CONTINUE
C
C     PLOT DISCHARGE EXCEEDENCE GRAPH IF REQUESTED
C
  360 IF(PO(19).LT.0.01) GO TO 150
      NML=0
      DO 361 NMI=1,12
  361 NML=NML+NM(NMI)
      DO 362 I=1,20
      SIM(I)=SIM(I)/NML*100.
  362 OBS(I)=OBS(I)/NML*100.
      WRITE(IPR,282) (PO(I),I=2,6)
      WRITE(IPR,283)
C
C     SET ORDS TO BLANKS
      DO 364 I=1,100
  364 ORD(I)=BLANK
C
C     PLOT GRAPH
      ISWCH=1
      DO 372 K=1,20
      J=21-K
C
C     FIND PLACE ON SCALE FOR OBSERVED POINT
      L=OBS(J)
      IF((OBS(J)-L).GE.0.5.AND.L.LT.100) L=L+1
      ORD(L)=PLUS
C
C     FIND PLACE ON SCALE FOR SIMULATED POINT
      M=SIM(J)
      IF((SIM(J)-M).GE.0.5.AND.M.LT.100) M=M+1
      ORD(M)=ASTER
      IF(ISWCH.EQ.2) GO TO 366
      WRITE(IPR,284) QEX(J),(ORD(I),I=1,100)
      ISWCH=2
      GO TO 370
  366 WRITE(IPR,285)
      WRITE(IPR,286) (ORD(I),I=1,100)
      WRITE(IPR,285)
      ISWCH=1
  370 ORD(L)=BLANK
      ORD(M)=BLANK
  372 CONTINUE
C
C     PRINT BOTTOM LINE OF PLOT
      DO 374 I=10,100,10
      ORD(I)=PLUS
      IF(I.EQ.100) GO TO 374
      DO 376 JJ=1,9
  376 ORD(I+JJ)=DOT
  374 CONTINUE
      A=0.0D0
      WRITE(IPR,287) A,(ORD(I),I=10,100)
      WRITE(IPR,288)
C
C.......................................................................
C
  230 FORMAT(1H1,///45X,19HSTATISTICAL SUMMARY,////13X,5A4,12X,15HAREA (
     1SQ KM) = ,F10.2,10X,11HWATER YEAR ,I4,/////59X,7HMONTHLY,4X,
     27HMAXIMUM,6X,7HPERCENT,/25X,20HSIMULATED   OBSERVED,16X,4HBIAS,6X,
     35HERROR,7X,17HAVERAGE   PERCENT,/27X,4HMEAN,8X,4HMEAN,6X,49HPERCEN
     4T  (SIM-OBS)  (SIM-OBS)    ABSOLUTE     RMS,/12X,5HMONTH,9X,
     56H(CMSD),6X,6H(CMSD),6X,4HBIAS,7X,4H(MM),6X,6H(CMSD),7X,5HERROR,
     65X,5HERROR,/11X,90(1H.),/)
C
  235 FORMAT(11X,2A4,A1,1X,2F12.3,1X,F9.2,1X,F11.3,1X,F10.3,2X,2F10.2)
C
  236 FORMAT(11X,2A4,A1,3X,20HMONTHLY DATA MISSING)
C
  237 FORMAT(11X,2A4,A1,1X,2F12.3,6X,3HN/A,2X,F11.3,1X,F10.3,8X,3HN/A,
     17X,3HN/A)
C
  240 FORMAT(1H1,//41X,29HMULTIYEAR STATISTICAL SUMMARY,///14X,5A4,12X,
     115HAREA (SQ KM) = ,F10.2,10X,12HWATER YEARS ,I4,4H TO ,I4,////47X,
     27HMONTHLY,3X,7HMAXIMUM,5X,16HPERCENT  PERCENT,2X,
     320HMAX MONTHLY  PERCENT,/15X,20HSIMULATED   OBSERVED,13X,4HBIAS,
     46X,5HERROR,6X,15HAVERAGE   DAILY,5X,29HVOLUME    AVG  ABS    PERCE
     5NT,/18X,4HMEAN,7X,54HMEAN    PERCENT  (SIM-OBS) (SIM-OBS)   ABSOLU
     6TE    RMS,6X,5HERROR,6X,20HMONTHLY  MONTHLY VOL,/5X,7HMONTHLY,5X,
     76H(CMSD),5X,6H(CMSD),5X,4HBIAS,5X,4H(MM),6X,6H(CMSD),6X,5HERROR,
     84X,5HERROR,5X,4H(MM),6X,20HVOL ERROR  RMS ERROR,/4X,118(1H.),/)
C
C
  241 FORMAT(////31X,08H DAILY  ,32X,07HLINE OF,/15X,05HDAILY,8X,12H AVE
     *RAGE ABS,7X,11HCORRELATION,12X,09HBEST  FIT,/12X,10H RMS ERROR,10X
     *,05HERROR,10X,11HCOEFFICIENT,9X,15HOBS = A + B*SIM,/14X,06H(CMSD),
     *12X,06H(CMSD),9X,11HDAILY FLOWS,10X,01HA,11X,01HB,/11X,12(1H.),4X,
     *15(1H.),4X,13(1H.),7X,17(1H.),//11X,F11.3,6X,F11.3,9X,F8.4,7X,2(F9
     *.4,3X))
C
C
  243 FORMAT(4X,2A4,A1,F10.3,1X,F10.3,2X,F8.2,1X,F9.3,1X,F10.3,3X,F8.2,1
     *X,F8.2,2X,F10.3,2X,F8.2,3X,F8.2)
C
  244 FORMAT(4X,118(1H.),/)
C
  245 FORMAT(////37X,11HAVERAGE ABS,6X,07HMONTHLY,29X,07HLINE OF,/5X,09H
     *DAILY RMS,6X,40HDAILY AVERAGE    MONTHLY VOL      VOLUME,7X,11HCOR
     *RELATION,11X,09HBEST  FIT,/7X,05HERROR,10X,09HABS ERROR,9X,05HERRO
     *R,8X,09HRMS ERROR,5X,11HCOEFFICIENT,8X,15HOBS = A + B*SIM,/7X,06H(
     *CMSD),10X,06H(CMSD),11X,04H(MM),11X,04H(MM),8X,11HDAILY FLOWS,9X,
     *1HA,11X,01HB,/5X,10(1H.),5X,13(1H.),2(4X,11(1H.)),4X,11(1H.),6X,19
     *(1H.),//4X,F10.3,2(6X,F10.3),5X,F10.3,6X,F9.4,6X,F9.4,3X,F9.4)
C
C
  247 FORMAT(4X,08HYEAR AVG,1X,F10.3,1X,F10.3,2X,F8.2,1X,F9.3,1X,F10.3,3
     *X,F8.2,1X,F8.2,2X,F10.3,2X,F8.2,3X,F8.2)
  250 FORMAT(11X,90(1H.),/)
C
  251 FORMAT(11X,10HYEAR AVG  ,2F12.3,1X,F9.2,1X,F11.3,1X,F10.3,2X,2F10.
     *2)
C
  252 FORMAT(11X,10HYEAR AVG  ,2F12.3,6X,03HN/A,2X,F11.3,1X,F10.3,8X,03H
     *N/A,7X,03HN/A)
  253 FORMAT (11X,08HYEAR AVG,4X,19HYEARLY DATA MISSING)
  254 FORMAT (4X,08HYEAR AVG,4X,44HNO OBSERVED DATA DURING THE PERIOD OF
     * RECORD)
  255 FORMAT(2X,F10.2,03H - ,F10.2,3X,I5,1X,2F11.3,   F10.2,1X,F11.4,2X,
     *F11.3,1X,F9.2,1X,F10.2)
  256 FORMAT(2X,F10.2,10H AND ABOVE,6X,I5,1X,2F11.3,   F10.2,1X,F11.4,2X
     *,F11.3,1X,F9.2,1X,F10.2)
C
  257 FORMAT(2X,F10.2,10H AND ABOVE,6X,08HNO CASES)
  258 FORMAT(2X,F10.2,03H - ,F10.2,3X,08HNO CASES)
C
  259 FORMAT(2X,F10.2,3H - ,F10.2,3X,I5,1X,2F11.3,6X,3HN/A,2X,F11.4,2X,
     *F11.3,6X,3HN/A,8X,3HN/A)
C
  260 FORMAT(/////28X,28HNUMBER  SIMULATED   OBSERVED,16X,04HBIAS,8X,28H
     *MAXIMUM   PERCENT    PERCENT,/30X,02HOF,7X,04HMEAN,7X,60HMEAN
     *PERCENT    (SIM-OBS)      ERROR    AVG ABS      RMS,/7X,14HFLOW  I
     *NTERVAL,7X,37HCASES     (CMSD)     (CMSD)      BIAS,7X,04H(MM),9X,
     *26H(CMSD)    ERROR      ERROR,/3X,110(1H.),/)
C
C
  261 FORMAT(1H1,////10X,37H25 LARGEST DAILY ERROR VALUES IN CMSD,////92
     *X,28HPERCENT    PERCENT REDUCTION,/65X,05HERROR,8X,41HPERCENT
     * TOTAL  SQ    OF DAILY RMS IF,/10X,109HMONTH     DAY  YEAR      OB
     *SERVED     SIMULATED      (SIM-OBS)       ERROR       DEVIATION
     *ERROR EQUAL ZERO,/10X,110(1H.),/)
C
  262 FORMAT(10X,2A4,A1,I4,2X,I4,2(4X,F10.3),5X,F9.3,2(6X,F8.2),7X,F8.2)
  263 FORMAT(10X,2A4,A1,2X,I4,2(4X,F10.3),5X,F9.3,2(6X,F8.2),7X,F8.2)
C
  264 FORMAT(//////10X,            38H12 LARGEST MONTHLY VOLUME ERRORS I
     *N MM,////88X,28HPERCENT    PERCENT REDUCTION,/61X,55HERROR
     *PERCENT      TOTAL  SQ   OF MONTHLY RMS IF,/10X,105HMONTH      YEA
     *R      OBSERVED     SIMULATED      (SIM-OBS)       ERROR       DEV
     *IATION   ERROR EQUAL ZERO,/10X,106(1H.),/)
C
  265 FORMAT(10X,2A4,A1,2X,I4,2(4X,F10.3),5X,F9.3,10X,3HN/A,7X,F8.2,
     *7X,F8.2)
C
  266 FORMAT(10X,29HLESS THAN 25 DAYS WITH ERRORS)
C
  270 FORMAT(1H1,///10X,            22HACCUMULATED FLOW IN MM,////85X,07
     *H       ,/17X,06HPERIOD,11X,70HYEAR      OBSERVED     SIMULATED
     *     ACC ERROR    ERROR THIS PERIOD/10X,95(1H.),/)
C
  271 FORMAT(10X,2A4,A1,04H TO ,2A4,A1,2X,I4,4(2X,F12.2),5X,F7.2)
C
  272 FORMAT(1H1,////10X,            27HCUMMULATIVE FREQUENCY TABLE,///1
     *0X,24HTOTAL NUMBER OF CASES = ,I8,////34X,07HPERCENT,/12X,30HNUMBE
     *R     PERCENT   OF  TOTAL,/11X,29HOF CASES     ERROR      CASES,/1
     *0X,33(1H.),//)
C
  273 FORMAT(10X,  I7,3X,A2,2X,F5.1,5X,F6.2)
  274 FORMAT(/3X,110(1H.))
C
C
  275 FORMAT(4X,2A4,A1,3X,20HMONTHLY DATA MISSING)
C
  280 FORMAT(10X,42HLESS THAN TWELVE MONTHS WITH VOLUME ERRORS)
C
  282 FORMAT(1H1,///5X,30HDISCHARGE EXCEEDENCE PLOT FOR ,5A4/////5X,
     116HDISCHARGE (CMSD),25X,12H*  SIMULATED,10X,11H+  OBSERVED)
C
  283 FORMAT(1H0/)
C
  284 FORMAT(1H ,5X,F10.0,1X,1H+,100A1)
C
  285 FORMAT(1H ,16X,1H.)
C
  286 FORMAT(1H ,16X,1H.,100A1)
C
  287 FORMAT(1H ,5X,F10.0,1X,10H+.........,100A1)
C
  288 FORMAT(1H0,16X,1H0,8X,2H10,8X,2H20,8X,2H30,8X,2H40,8X,2H50,8X,
     12H60,8X,2H70,8X,2H80,8X,2H90,7X,3H100,//41X,45HPERCENTAGE OF DAYS
     2WHEN DISCHARGE IS EXCEEDED)
C
  290 FORMAT(////31X,08H DAILY  ,32X,07HLINE OF,/15X,05HDAILY,8X,12H AVE
     *RAGE ABS,7X,11HCORRELATION,12X,09HBEST  FIT,/12X,10H RMS ERROR,10X
     *,05HERROR,10X,11HCOEFFICIENT,9X,15HOBS = A + B*SIM,/14X,06H(CMSD),
     *12X,06H(CMSD),9X,11HDAILY FLOWS,10X,01HA,11X,01HB,/11X,12(1H.),4X,
     *15(1H.),4X,13(1H.),7X,17(1H.),//11X,F11.3,6X,F11.3,9X,9HUNDEFINED,
     *13X,9HUNDEFINED)
C
  291 FORMAT(////37X,11HAVERAGE ABS,6X,07HMONTHLY,29X,07HLINE OF,/5X,09H
     *DAILY RMS,6X,40HDAILY AVERAGE    MONTHLY VOL      VOLUME,7X,11HCOR
     *RELATION,11X,09HBEST  FIT,/7X,05HERROR,10X,09HABS ERROR,9X,05HERRO
     *R,8X,09HRMS ERROR,5X,11HCOEFFICIENT,8X,15HOBS = A + B*SIM,/7X,06H(
     *CMSD),10X,06H(CMSD),11X,04H(MM),11X,04H(MM),8X,11HDAILY FLOWS,9X,
     *1HA,11X,01HB,/5X,10(1H.),5X,13(1H.),2(4X,11(1H.)),4X,11(1H.),6X,19
     *(1H.),//4X,F10.3,2(6X,F10.3),5X,F10.3,7X,9HUNDEFINED,12X,9HUNDEFIN
     *ED)
C
  292 FORMAT(4X,2A4,A1,F10.3,1X,F10.3,6X,3HN/A,2X,F9.3,1X,F10.3,
     *7X,3HN/A,6X,3HN/A,3X,F10.3,6X,3HN/A,8X,3HN/A)
  150 RETURN
      END
