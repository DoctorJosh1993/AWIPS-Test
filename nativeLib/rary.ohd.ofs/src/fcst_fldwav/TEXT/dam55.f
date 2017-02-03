      SUBROUTINE DAM55(PO,CO,Z,ST1,LTST1,T1,LTT1,POLH,LTPOLH,ITWT,
     . LTITWT,D,C,QU,QD,YU,YD,HDD,HSPD,HGTD,CSD,CGD,ZBCH,CDOD,NFAILD,
     . BBP,YBP,SQS1,SQS2,SQO,QBCH,QOVTP,QOTHR,KRCH,QGH,CLL,SPL,RHI,RQI,
     . TIBQH,QDI,QN,DQNYU,DTT,IFL,ITRS,II,II2,L1,L2,L3,L4,ITQ,I,J,
     . K1,K2,K7,K8,K9,K15,K16,K19,K20,K21)
C
C   *jms*   UPDATED 01/29/03  to allow various lock&dam options
C
C  THIS SUBROUTINE PERFORMS DAM FLOW COMPUTATION
C  ITRS= 0, SET UP MATRIX COEFF. FOR UNSTEADY DYNAMIC/DIFFSION ROUTING
C  ITRS= 1, STEADY STATE, CUNGE ROUTING, NO MATRIX COEFF NEEDED
C  QW= BREACH FLOW
C  QOD= FLOW OVER NON-SPILLWAY DAM CREST
C  QG= GATE FLOW
C  QCV= FLOW THROUGH CULVERT
C  QS1= FLOW OVER SPILLWAY
C  QS2= RATING CURVE FLOW
C  QT= TURBINE FLOW
C  SQW,SQS1,SQS2,SQO ARE SUBMERGENCE CORRECTION COEF. FOR
C  BREACH, SLPILLWAY, RATING CURVE AND OVER TOPPING FLOW
C  SQW(1,KL,J) = SUBQWS(KL) IN DAMBRK DURING ITERATION (BREACH)
C  SQW(2,KL,J) = SUBQW(KL) IN DAMBRK AFTER CONVERGENCE (BREACH)
C  SQO(1,KL,J) = SUBQOS(KL) IN DAMBRK DURING ITERATION (OVERTOP)
C  SQO(2,KL,J) = SUBQO(KL) IN DAMBRK AFTER CONVERGENCE (OVERTOP)
C  SQS1(1,KL,J) = SUBQSS(KL) IN DAMBRK DURING ITERATION (SPILLWAY)
C  SQS1(2,KL,J) = SUBQS(KL) IN DAMBRK AFTER CONVERGENCE (SPILLWAY)
C  KRCH=10 TO 30, INTERNAL DAM BOUNDARY
C  KRCH=-10 TO -30, INTERNAL DAM BOUNDARY WITH LEVEL POOL ROUTING
C      KRA=10  DAM
C      KRA=11  DAM  +  Q=F(Y)
C      KRA=21  DAM  +  Y=F(Q)
C      KRA=12  DAM  +  Q=F(YY)
C      KRA=22  DAM  + YY=F(Q)
C      KRA=13  DAM  +  Q=F(Y-YY)
C      KRA=23  DAM  + Y-YY=F(Q)
C      KRA=14  DAM  +  MULGAT (MULTIPLE MOVEABLE GATES) C=F(Y,HG,FR)  **** N/A IN NWSRFS
C      KRA=15  DAM  +  AVGGAT (MOVEABLE GATE-CORPS ENGR. TYPE)        **** N/A IN NWSRFS
C      KRA=16  DAM  +  Q=F(Y), Y=F(T); OBSERVED POOL ELEV. AVAILABLE
C      KRA=17  DAM  +  Q=F(C,Y-YY)  C=F(Y)
C      KRA=18  DAM  +  CULVERT FLOW  Q=F(Y,YY)  POSSIBLE REVERSE FLOW
C      KRA=19  DAM  +  CULVERT W/TIDE GATE  Q=F(Y,YY)  ZERO FLOW IF YY>Y
C      KRA=20  DAM  +  RULE CURVE (Q=Q AT U/S GAGE) [APPOMATOX RIVER]  **** N/A IN NWSRFS
C      KRA=25  DAM  +  Y=F(T)    **** N/A IN NWSRFS
C      KRA=26  DAM  +  Q=F(T)    **** N/A IN NWSRFS
C      KRA=27  DAM  +  COE RESERVOIR CONTROL OPERATION
C      KRA=28  DAM  +  LOCK
C      KRA=35  BRIDGE
C
      COMMON/IT55/ITER
      COMMON/M155/NU,JN,JJ,KIT,G,DT,TT,TIMF,F1
      COMMON/M3255/IOBS,KTERM,KPL,JNK,TEH
      COMMON/IONUM/IN,IPR,IPU

      INCLUDE 'common/fdbug'
      INCLUDE 'common/ofs55'

      DIMENSION PO(*),CO(*),Z(*),ST1(*),LTST1(*),T1(*),LTT1(*),POLH(*)
      DIMENSION LTPOLH(*),ITWT(*),LTITWT(*),D(4,K15),C(K15),QU(K2,K1)
      DIMENSION QD(K2,K1),YU(K2,K1),YD(K2,K1),HDD(K16,K1),HSPD(K16,K1)
      DIMENSION HGTD(K16,K1),CSD(K16,K1),CGD(K16,K1),ZBCH(K16,K1)
      DIMENSION CDOD(K16,K1),NFAILD(K16,K1),BBP(K16,K1),YBP(K16,K1)
      DIMENSION SQS1(2,K16,K1),SQS2(2,K16,K1),SQO(2,K16,K1),QBCH(K16,K1)
      DIMENSION QOVTP(K16,K1),QOTHR(K16,K1),KRCH(K2,K1),QGH(K21,K16,K1)
      DIMENSION CLL(K16,K1),SPL(K16,K1),RHI(112,K16,K1),RQI(112,K16,K1)
      DIMENSION TIBQH(K16,K1),QDI(K2,K1)
      CHARACTER*8 SNAME
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcst_fldwav/RCS/dam55.f,v $
     . $',                                                             '
     .$Id: dam55.f,v 1.5 2004/09/23 19:42:23 wkwock Exp $
     . $' /
C    ===================================================================
C

CC      DIMENSION IFR(K2,K1)
      DATA SNAME/ 'DAM55   '   /
C
      CALL FPRBUG(SNAME,1,55,IBUG)
C
cc      IF(JNK.GE.111) WRITE(IODBUG,11110)
cc11110 FORMAT(1X,'** ENTER DAM **')
      CALL IDDB55(I,J,PO(LONLAD),PO(LOLAD),KL,K1,K16)
      IR=I+1
      KR=KRCH(I,J)
      KRA=ABS(KR)

      IF (KRA.NE.28) GOTO 6
C  MATRICES LAD AND KRCH ARE ADDED DUE TO CHANGES MADE IN POOT55
C      CALL POOT55(J,I,KL,L1,L2,L3,L4,II,II2,C,D,QU,QD,YU,YD,PO(LOCHTW),
C     . POLH,LTPOLH,ITWT,LTITWT,T1,LTT1,CO(LXPLTI),CO(LXIWTI),
C     . PO(LONLAD),QN,NU,TT,RHI,RQI,K1,K2,K15,K16)
      CALL POOT55(J,I,KL,L1,L2,L3,L4,II,II2,C,D,QU,QD,YU,YD,PO(LOCHTW),
     . POLH,LTPOLH,ITWT,LTITWT,T1,LTT1,CO(LXPLTI),CO(LXIWTI),
     . PO(LONLAD),PO(LOLAD),KRCH,QN,NU,TT,RHI,RQI,K1,K2,K15,K16)
      QOTHR(KL,J)=QU(I,J)
      GOTO 999

    6 KR1=0
      IF(KL.GT.1) KR1=KRCH(I-1,J)
      QQ=QU(IR,J)
      QN=QQ
      DQNYU=0.
      DQNYD=0.
      YG=HGTD(KL,J)
      HDM=HDD(KL,J)
      HSP=HSPD(KL,J)
      CL=CLL(KL,J)
      SUBQS1=SQS1(2,KL,J)
      SUBQS2=SQS2(2,KL,J)
      SUBQOD=SQO(2,KL,J)
      DYQ=0.
      DYQD=0.
      QW=0.
      DQWU=0.
      DQWD=0.
      QOD=0.
      DQODU=0.
      DQODD=0.
      QG=0.
      DQGU=0.
      DQGD=0.
      QCV=0.
      DQCVU=0.
      DQCVD=0.
      QS1=0.
      DQS1U=0.
      DQS1D=0.
      QS2=0.
      DQS2U=0.
      DQS2D=0.
      QT=0.
      YB=HDM
      BO=0.
      IFL=0
      IBF=0
      LT1=LTT1(J)

C  FREE FLOW THRU DAM ASSUMED INITIALLY
C  ITQ=0, NO SUMERGENCE CORRECTION
C     =1, SUBMERGENCE CORRECTION REQUIRED
C  ITQ USED ONLY DURING INITIAL FLOW COMPUTATION
      IF(KRA.LT.25) GO TO 9
      TX=TT
      CALL INTERP55(T1(LT1),NU,TX,IT1,IT2,TINP)
      IF(KRA.EQ.25.OR.KRA.EQ.26.OR.KRA.EQ.27)
     1 YQ=QGH(IT1,KL,J)+TINP*(QGH(IT2,KL,J)-QGH(IT1,KL,J))
C  COE(NASHVILLE) RESERVOIR OPERATION OPERATION OPTION --- KRA=27
      IF(KRA.NE.27) GO TO 8
      IF(TT.GE.TIBQH(KL,J)-0.00001) GO TO 7
      QN=YQ
      GO TO 38
    7 Y1=YQ
      IF(ABS(Y1).LT.0.01) Y1=YD(I,J)
      GO TO 43
    8 IF(KRA.EQ.25) Y1=YQ
      IF(KRA.EQ.25. AND.Y1.GT.HDM) IFL=1
      IF(KRA.EQ.25) GO TO 43
      IF(KRA.EQ.26) QN=YQ
      IF(KRA.EQ.26) GO TO 38
    9 Y=YU(I,J)
      YY=YU(IR,J)
      DY=Y-YY
      DYA=ABS(DY)
      IF(DYA.LT.0.001) GO TO 38
CC      IF(TT.LT.0.0001) GO TO 10
C

CC      CALL PRLOCS

C  FLOW THROUGH TURBINE
      IF(KRA.NE.20) THEN
        CALL QTURB55(KL,J,PO(LOQTD),PO(LOQTT),PO(LOTQT),K1,K16,NU,TT,QT)
CC      ELSE
CC        CALL QTRULE(KL,J,Z(LOIRUL),QU,QT)
      ENDIF

C  FLOW THROUGH BREACH OPENING
      CALL BRECH55(PO,KL,I,J,TT,QU,YU,ZBCH,PO(LOYMIN),PO(LOBBD),
     . PO(LOTFH),HDD,NFAILD,Z(LZTFDB),Z(LZTFDO),QW,DQWU,DQWD,Z(LZSQW),
     . YB,BO,QT,PO(LOBEXP),Z(LZIORF),HSPD,CSD,PO(LOCPIP),PO(LOHFDD),
     . K1,K2,K9,K16)

   10 SGN=1.
C  FLIP FLOP Y AND YY IF FLOW REVERSED
      IF(Y.LT.YY) THEN
        SGN=-1.
        YDUM=Y
        Y=YY
        YY=YDUM
      END IF
C
C  FLOW OVER TOP OF DAM
      IF(Y.LT.HDM.OR.HDM.GE.100000.) GO TO 36
      HUSO=Y-HDM
      HDMSO=YY-HDM
      DSQODU=0.
      DSQODD=0.
      IF(HDMSO.LT.0.67*HUSO) GO TO 35
      DUMY=1.-27.8*(HDMSO/HUSO-0.67)**3
      IF(DUMY.GT.SQO(2,KL,J)) GO TO 35
      SUBQOD=DUMY
      DSQODU=-27.8*3*(HDMSO/HUSO-0.67)**2*(-HDMSO/HUSO**2)
      DSQODD=-27.8*3*(HDMSO/HUSO-0.67)**2/HUSO
   35 IF(SUBQOD.LT.0.99) ITQ=1
      DCL=0.
      IF(CL.LT.0.01)
     1 CALL CRESTL55(PO(LOHCRL),PO(LOCRL),ACL,CL,DCL,KL,J,Y,K1,K16)
      IF(NFAILD(KL,J).EQ.3) THEN
        CL=CL-(BO+2.0*ZBCH(KL,J)*(HDM-YB))
        IF(CL.LT.0.0) CL=0.
      ENDIF
      CDO=CDOD(KL,J)*CL
      DCDO=CDOD(KL,J)*DCL
      QOD=CDO*(Y-HDM)**1.5*SUBQOD
CC      WRITE(IODBUG,9998) TT,CDO,CL,HDM,YB,(HDM-YB),BO,ZBCH(KL,J),KL
CC 9998 FORMAT(2X,'<<< TT,CDO,CL,HDM,YB,DIFF,BO,ZBCH,KL',8F12.4,I4,' >>>')
CC      WRITE(IODBUG,9999) QOD,CDO,Y,HDM,(Y-HDM),SUBQOD
CC 9999 FORMAT(2X,'<<<<< QOD,CDO,Y,HDM,DIFF,SUBQOD =',7F12.4,' >>>>>')
      DQODU=CDO*1.5*(Y-HDM)**0.5*SUBQOD+CDO*(Y-HDM)**1.5*DSQODU
     1 +DCDO*(Y-HDM)**1.5*SUBQOD
      DQODD=CDO*(Y-HDM)**1.5*DSQODD
   36 CONTINUE

C  RULE CURVE: FLOW AT U/S GAGE IS RELEASED THRU DAM UNTIL OVERTOPPING
C                    FLOW EXCEEDS GAGE FLOW
CC      IF(KRA.EQ.20) THEN
CC        IF(NFAILD(KL,J).EQ.3) GO TO 37
CC        QT=QU(IRULE,J)-QOD
CC        IF(QT.LT.0.) QT=0
CC        GO TO 37
CC      ENDIF
C
C  FLOW THROUGH GATES (INCLUDING MOVABLE GATES KRCH=14, 15)
C     MOVEABLE OPENNING
      IF(KRA.EQ.14) THEN
        CALL MULGAT55(KL,J,PO(LONG),PO(LOGSIL),PO(LOGWID),PO(LOTGHT),
     .      PO(LOGHT),Y,YY,QG,DQGU,DQGD,K1,K19,K20,K21)
        GOTO 30
      ELSEIF(KRA.EQ.15) THEN
        CALL AVGGAT55(KL,J,Z(LZFLAG),TT,Y,YY,YG,HDM,PO(LOCGCG),QGH,
     .      PO(LCTCG),Z(LZQDSN),Z(LZHDSN),Z(LZWDSN),QG,DQGU,DQGD,
     .      K1,K16,K21)
        GOTO 30
      ENDIF
      IF(YG.GE.10000.) GO TO 30
      IF(YG.GT.0.01.AND.YY.GT.YG) ITQ=1
      CG=CGD(KL,J)*8.02
      IF(CG.LT.0.01.OR.YG.LT.0.01) GO TO 30
      IF(YG.GT.0.01.AND.YY.GT.YG) YG=YY
      GHD=Y-YG
      IF(GHD.LT.0.001) GO TO 30
      QG=CG*SQRT(GHD)
      DQGU=0.5*CG/SQRT(GHD)
      IF(YY.GT.YG) DQGD=-DQGU
CC      IF(KRA.EQ.15) CALL AVGGAT55(KL,J,Z(LZFLAG),TT,Y,YY,YG,HDM,
CC     1 PO(LOCGCG),QGH,PO(LCTCG),Z(LZQDSN),Z(LZHDSN),Z(LZWDSN),QG,
CC     2 DQGU,DQGD,K1,K16,K21)
   30 CONTINUE
C
C  FLOW THROUGH CULVERTS
      IF(KRA.EQ.18) CALL CULVRT55(I,KL,J,KRA,QU,RHI,
     1 PO(LOQHT),HGTD,HSPD,CGD,Y,YY,QCV,DQCVU,DQCVD,K1,K2,K16)

C  FLOW OVER SPILLWAY
      IF(HSP.GE.100000.) GO TO 27
      HUS=Y-HSP
      HDS=YY-HSP
CCC      NQS1=1
C      NEGATIVE CSD(KL,J) MEANS SPILLWAY FAILURE
      NFSP=0
      SPLL=SPL(KL,J)
      IF(CSD(KL,J).LT.-0.01) NFSP=1
      IF(NFSP.EQ.0) GO TO 25
      IF(NFAILD(KL,J).LE.2) GO TO 25
      IF(HUS.LT.0.001) GO TO 27
      BCHW=BO+2.0*ZBCH(KL,J)*(HSP-YB)
      SPLL=SPL(KL,J)-BCHW
      IF(SPLL.LT.0.001) SPLL=0.0
   25 IF(SPLL.LE.0.0) GO TO 27
      IF(Y.LE.HSP) GO TO 27
      CS=ABS(CSD(KL,J))*SPLL
      DSQS1U=0.
      DSQS1D=0.
      IF(HDS.LT.0.67*HUS) GO TO 26
      DUMY=1.0-27.8*(HDS/HUS-0.67)**3
      IF(DUMY.GT.SQS1(2,KL,J)) GO TO 26
      SUBQS1=DUMY
      DSQS1U=-27.8*3*(HDS/HUS-0.67)**2*(-HDS/HUS**2)
      DSQS1D=-27.8*3*(HDS/HUS-0.67)**2/HUS
  26  IF(SUBQS1.LT.0.99) ITQ=1
      CS=CS*SUBQS1
      IF(HUS.GT.0.01) QS1=CS*HUS**1.5
CC      WRITE(IODBUG,9992) TT,QS1,HUS,HDS,(0.67/HUS),SUBQS1,CS
CC 9992 FORMAT(2X,'<<<<< TT QS1 HUS HDS RAT SUBQS1 CS =',F10.4,F12.3,
CC     . 4F10.4,F12.4' >>>>>')
      IF(HUS.GT.0.01) DQS1U=1.5*CS*HUS**0.5+CSD(KL,J)*HUS**1.5*DSQS1U
      IF(HUS.GT.0.01) DQS1D=CSD(KL,J)*HUS**1.5*DSQS1D
   27 CONTINUE
C
C  FLOW FROM COMPOSITE RATING CURVE
      IF(KRA.NE.17) GO TO 33
      CALL RTCDAM55(KL,J,Y,CG,DCG,RHI,RQI,PO(LCRCP),K1,K16)
      QS2=8.02*CG*SQRT(DY)
      IF(CG.LE.0.1.OR.DY.LE.0.1) GOTO 37
      DQS2U=QS2*(0.5/DY+DCG/CG)
      DQS2D=-QS2*0.5/DY
      GO TO 37
   33 CONTINUE
      IF(KRA.NE.16) GO TO 34
      GFTT=QGH(IT1,KL,J)+TINP*(QGH(IT2,KL,J)-QGH(IT1,KL,J))
      CALL RTCDAM55(KL,J,GFTT,QS2,DQ,RHI,RQI,PO(LCRCP),K1,K16)
      DQS2U=0.
      DQS2D=0.
      GO TO 37
   34 CONTINUE
      Y2=Y
      IF(KRA.EQ.11.OR.KRA.EQ.21) THEN
        IF(YG.GT.0.01.AND.CG.LT.0.01.AND.YG.LT.YY) Y2=Y-(YY-YG)
        CALL RTCDAM55(KL,J,Y2,QS2,DQS2,RHI,RQI,PO(LCRCP),K1,K16)
      ENDIF
      IF(KRA.EQ.12.OR.KRA.EQ.22) CALL RTCDAM55(KL,J,YY,QS2,DQS2,RHI,RQI,
     * PO(LCRCP),K1,K16)
      IF(KRA.EQ.13.OR.KRA.EQ.23) CALL RTCDAM55(KL,J,DYA,QS2,DQS2,RHI,
     * RQI,PO(LCRCP),K1,K16)
C  MODIFYING RATING CURVE FLOW (QS2) BY SUBMERGENCY
      IF(QS2.LE.1.0) GO TO 37
      HUS=Y2-RHI(1,KL,J)
      HDS=YY-RHI(1,KL,J)
      DSQS2U=0.
      DSQS2D=0.
      IF(HDS.LT.0.67*HUS) GO TO 126
      DUMY=1.0-27.8*(HDS/HUS-0.67)**3
      IF(DUMY.GT.SQS2(2,KL,J)) GO TO 126
      SUBQS2=DUMY
      DSQS2U=-27.8*3*(HDS/HUS-0.67)**2*(-HDS/HUS**2)
      DSQS2D=-27.8*3*(HDS/HUS-0.67)**2/HUS
 126  IF(SUBQS2.LT.0.99) ITQ=1
CC      WRITE(IODBUG,9991) TT,QS2,Y,Y2,YG,SUBQS2,QS2*SUBQS2
CC 9991 FORMAT(2X,'<<<<< TT QS2 Y Y2 YG SUBQS2 NEWQS2 =',F10.4,F12.3,
CC     . 3F10.3,F10.4,F12.3,' >>>>>')
      QS2=QS2*SUBQS2
      DQS2U=DQS2*SUBQS2+DSQS2U*QS2
      DQS2D=QS2*DSQS2D
   37 QN=QW+QOD+QG+QCV+QS1+QS2+QT
      DQNYU=DQWU+DQODU+DQGU+DQCVU+DQS1U+DQS2U
CC      WRITE(IODBUG,9993) TT,QN,QW,QOD,QG,QCV,QS1,QS2,QT
CC 9993 FORMAT(5X,'<<< TT QN QW QOD QG QCV QS1 QS2 QT=',F10.4,8F12.3)
      DQNYD=DQWD+DQODD+DQGD+DQCVD+DQS1D+DQS2D
      IF(ABS(DQNYU).LT.0.001) DQNYU=0.0001
      QN=SGN*QN
      DQNYU=SGN*DQNYU
      DQNYD=SGN*DQNYD
   38 IF(ITRS.EQ.1) GO TO 60
      IF(IBF.EQ.1) GO TO 47
      C(II)=-(QU(I,J)-QN)
      D(L1,II)=-DQNYU
      D(L2,II)=1.-DYQ
      D(L3,II)=-DQNYD
      D(L4,II)=-DYQD
      C(II2)=-(QU(I,J)-QU(I+1,J))
      D(L1,II2)=0.
      D(L2,II2)=1.
      D(L3,II2)=0.
      D(L4,II2)=-1.
CC      IF(KR.GE.0) GO TO 50
C  LEVEL POOL ROUTING USED!
C  REESTABLISH COEFFIEIENTS FOR THE REACH IMMEDIATELY UPSTREAM OF A DAM
      IS=I
      IIS=II
        I=IS-1
        IR=I+1
        IF(I.EQ.0) I=1
        II=IIS-2
        II2=II+1
      IF(KR1.EQ.4) THEN
        C(II)=-(YU(I,J)-YU(IR,J))
        D(L1,II)=1.
        D(L2,II)=0.
        D(L3,II)=-1.
        D(L4,II)=0.
        YUIJ=YU(I,J)
        YDIJ=YD(I,J)
        QUIJ=QU(I,J)
        QDIJ=QD(I,J)
        QUIRJ=QU(IR,J)
        QDIRJ=QD(IR,J)
      ELSEIF(KL.EQ.1.AND.IS.EQ.1) THEN
        II=1
CC        II2=II+1
        YUIJ=YU(1,J)
        YDIJ=YD(1,J)
        TX=TT
        LJ=LTST1(J)-1
        CALL INTERP55(T1(LT1),NU,TX,IT1,IT2,TINP)
        IF(TX.GE.T1(LT1)) THEN
          QUIJ=ST1(IT1+LJ)+(ST1(IT2+LJ)-ST1(IT1+LJ))*TINP
        ELSE
          QUIJ=QDI(1,J)+(ST1(1+LJ)-QDI(1,J))*TX/T1(LT1)
        ENDIF
        TX=TT-DTT/3600.
        IF(TX.LT.0.000001) TX=0.00
        CALL INTERP55(T1(LT1),NU,TX,IT1,IT2,TINP)
        IF(TX.GE.T1(LT1)) THEN
          QDIJ=ST1(IT1+LJ)+(ST1(IT2+LJ)-ST1(IT1+LJ))*TINP
        ELSE
          QDIJ=QDI(1,J)+(ST1(1+LJ)-QDI(1,J))*TX/T1(LT1)
        ENDIF
CC        QUIRJ=QU(1,J)
CC        QDIRJ=QD(1,J)
        D(L3,1)=0.
        D(L4,1)=0.
      ELSE
        GO TO 40
      ENDIF
      CALL RESSAR55(J,KL,YUIJ,PO(LOSAR),PO(LOHSAR),SAU,DSAU,K1,K16)
      YU(1,J)=YUIJ
      CALL RESSAR55(J,KL,YDIJ,PO(LOSAR),PO(LOHSAR),SAD,DSAD,K1,K16)
      YD(1,J)=YDIJ
      CDT=43560./DTT
CC      FCNC=QD(I,J)+QU(I,J)-QD(IR,J)-QU(IR,J)-
CC     &     CDT*(SAU+SAD)*(YUIJ-YDIJ)
      FCNC=QDIJ+QUIJ-QD(IR,J)-QU(IR,J)-CDT*(SAU+SAD)*(YUIJ-YDIJ)
      DYUI=-CDT*((SAU+SAD)+(YUIJ-YDIJ)*DSAU)
      C(II2)=-FCNC
C    D(L1,II2)=DYUI, D(L2,II2)=DQUI, D(L3,II2)=DYUIR, D(L4,II2)=DQUIR
      D(L1,II2)=DYUI
      D(L2,II2)=1.
      D(L3,II2)=0.
      D(L4,II2)=-1.
      IF(JNK.LT.100.AND.IBUG.EQ.0) GO TO 40
      WRITE(IODBUG,888)
     &I,II,C(II),D(L1,II),D(L2,II),D(L3,II),D(L4,II)
      WRITE(IODBUG,888)
     &I,II2,C(II2),D(L1,II2),D(L2,II2),D(L3,II2),D(L4,II2)
   40 I=IS
      IR=I+1
      II=IIS
      II2=II+1
      GO TO 50
   43 C(II)=-(YU(I,J)-Y1)
      D(L1,II)=1.
      D(L2,II)=-DYQ
      D(L3,II)=0.
      D(L4,II)=-DYQD
      C(II2)=-(QU(I,J)-QU(I+1,J))
      D(L1,II2)=0.
      D(L2,II2)=1.
      D(L3,II2)=0.
      D(L4,II2)=-1.
      GO TO 50
   47 C(II)=-(QU(I+1,J)-QU(I,J))
      D(L1,II)=0.
      D(L2,II)=-1.
      D(L3,II)=0.
      D(L4,II)=1.
      C(II2)=-(QU(I+1,J)-QN)
      D(L1,II2)=-DQNYU
      D(L2,II2)=-DYQD
      D(L3,II2)=-DQNYD
      D(L4,II2)=1.-DYQ
   50 IF(JNK.LT.100.OR.IBUG.EQ.0) GO TO 60
      WRITE(IODBUG,888)
     &I,II,C(II),D(L1,II),D(L2,II),D(L3,II),D(L4,II)
      WRITE(IODBUG,888)
     &I,II2,C(II2),D(L1,II2),D(L2,II2),D(L3,II2),D(L4,II2)
  888 FORMAT(5X,'DAM: I,II,C,D= ',2I5,5F15.5)
   60 BBP(KL,J)=BO
      YBP(KL,J)=YB
      SQO(1,KL,J)=SUBQOD
      SQS1(1,KL,J)=SUBQS1
      SQS2(1,KL,J)=SUBQS2
      QBCH(KL,J)=SGN*QW
      QOVTP(KL,J)=SGN*QOD
      QOTHR(KL,J)=SGN*(QS1+QS2+QG+QT+QCV)
      IF(JNK.GE.111.AND.IBUG.GE.1) WRITE(IODBUG,11111)
11111 FORMAT(1X,'** EXIT DAM **')
CC      WRITE(IODBUG,8888) TT,QS1,QS2,QG,QT,QCV,Y,HDM,YY
CC 8888 FORMAT(5X,'TT,QS1,QS2,QG,QT,QCV,Y,HDM,YY=',15X,F10.5,8F12.3)
  999 RETURN
      END
