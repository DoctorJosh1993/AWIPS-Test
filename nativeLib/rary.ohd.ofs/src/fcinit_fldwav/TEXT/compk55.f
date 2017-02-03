C  GENERATING CONVEYANCE CURVE

      SUBROUTINE COMPK55(PO,JNK,JN,NB,HS,HKC,QKC,BEV,NKC,SNM,NBT,NN,
     . K1,K2,K7,K8,K9,K23)
      COMMON/SS55/NCS,A,B,DB,R,DR,AT,BT,P,DP,ZH
      COMMON/FLP55/KFLP
      COMMON/FDBUG/IODBUG,ITRACE,IDBALL,NDEBUG,IDEBUG(20)
      COMMON/IONUM/IN,IPR,IPU

      INCLUDE 'common/ofs55'

      DIMENSION PO(*)
      DIMENSION NB(K1),HS(K9,K2,K1)
      DIMENSION HKC(30,K2,K1),QKC(30,K2,K1),BEV(30,K2,K1),NKC(K2,K1)
      DIMENSION SNM(K9,K2,K1),NBT(K1),NN(K23,K1)
      DIMENSION SNMIT(501),QKT(501),BKT(501),ERQMX(500)
      CHARACTER*8 SNAME
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcinit_fldwav/RCS/compk55.f,v $
     . $',                                                             '
     .$Id: compk55.f,v 1.3 2004/02/02 20:34:33 jgofus Exp $
     . $' /
C    ===================================================================
C
      DATA SNAME/ 'COMPK55 ' /

      CALL FPRBUG(SNAME, 1, 55, IBUG)

      IF(IBUG.EQ.1) WRITE(IODBUG,108)

      IF (KFLP.EQ.1) GOTO 500
      DO 480 J=1,JN
      DO 450 I=NBT(J),1,-1
      NK=NN(I,J)
      DO 450 K=1,KFLP
      HKC(K,NK,J)=HKC(K,I,J)
      QKC(K,NK,J)=QKC(K,I,J)
  450 CONTINUE
      DO 460 I=2,NB(J)-1
         DO 452 K=2,NBT(J)
         I2=NN(K,J)
         IF (I.LT.I2) GOTO 455
  452    CONTINUE
  455 I1=NN(K-1,J)
      DD1=(I-I1)*1.0
      DD2=(I2-I1)*1.0
      DD=DD1/DD2
      DO 460 KK=1,KFLP
      DHKC=HKC(KK,I2,J)-HKC(KK,I1,J)
      DQKC=QKC(KK,I2,J)-QKC(KK,I1,J)
      HKC(KK,I,J)=HKC(KK,I1,J)+DHKC*DD
      QKC(KK,I,J)=QKC(KK,I1,J)+DQKC*DD
  460 CONTINUE
      DO 470 I=1,NB(J)
      NKC(I,J)=KFLP
      DO 470 K=1,KFLP
      BEV(K,I,J)=1.06
  470 CONTINUE
  480 CONTINUE
      GOTO 999

  500 ERQKI=0.5
      LMX=30
      E23=2./3.
      DO 101 J=1,JN
      NCML=NCS
      N=NB(J)
      DO 100 I=1,N
      ERQK=ERQKI
      IT=1
      QKT(1)=0.0
      SNMIT(1)=SNM(1,I,J)
      BKT(1)=1.06
      UP=0.0
      QKLF0=0.0
      QKCH0=0.0
      QKRF0=0.0
      YMX=HS(NCS,I,J)
      DYY=YMX-HS(1,I,J)
      DY=DYY/195.
      Y=HS(1,I,J)
      YY=HS(1,I,J)
      IF(I.NE.N) YY=HS(1,I+1,J)
   10 Y=Y+DY
      YY=YY+DY
      YN=0.5*(Y+YY)
      CALL SECT55(PO(LCPR),PO(LOAS),PO(LOBS),HS,PO(LOASS),PO(LOBSS),
     . J,I,Y,PO(LCHCAV),PO(LCIFCV),K1,K2,K9)
      CALL SECTF55(NCS,J,I,Y,BL,AL,BR,AR,HS,PO(LOBSL),PO(LOBSR),
     * PO(LOASL),PO(LOASR),K1,K2,K9)
      CALL FRICT55(NCML,PO(LOCM),PO(LOYQCM),J,I,YN,CMN,DCM,K1,K7,K8)
      CALL FRICTL55(NCML,PO(LOCML),PO(LOYQCM),J,I,YN,CMNL,DCML,K1,K7,K8)
      CALL FRICTR55(NCML,PO(LOCMR),PO(LOYQCM),J,I,YN,CMNR,DCMR,K1,K7,K8)
      IP=I+1
      IF(IP.GE.N) IP=N
      CALL SINC55(YN,J,I,IP,NCS,HS,PO(LOSNC),SC,DSC,SNM,SM,DSM,K1,K2,K9)
      DEN=SQRT(SM)
      QKCH=1.49/CMN*A*(A/B)**E23
      DQKCH=QKCH-QKCH0
      QKCH0=QKCH
      DQKLF=0.0
      QKLF=0.
      IF(BL.LT.0.2) AL=0.01
      IF(BL.LT.0.2) GO TO 14
      QKLF=1.49/CMNL*AL*(AL/BL)**E23
      DQKLF=QKLF-QKLF0
      QKLF0=QKLF
   14 QKRF=0.
      DQKRF=0.0
      IF(BR.LT.0.2) AR=0.01
      IF(BR.LT.0.2) GO TO 15
      QKRF=1.49/CMNR*AR*(AR/BR)**E23
      DQKRF=QKRF-QKRF0
      QKRF0=QKRF
   15 IT=IT+1
      IF(IT.GT.500) THEN
        WRITE(IPR,9000)
 9000   FORMAT(/10X,'***** ERROR ***** ARRAY IN SUBROUTINE COMPK HAS ',
     .    'BEEN EXCEEDED.  CONTACT HRL TO INCREASE ARRAY SIZE (500)')
        CALL ERROR
        GO TO 999
      ENDIF
      ITM=IT-1
      UP=UP+DQKLF+DQKCH*SM+DQKRF
      DN=QKLF+QKCH+QKRF
      SNMIT(IT)=UP/DN
      IF(SNMIT(IT).LE.1.0) SNMIT(IT)=1.0
      QKT(IT)=QKT(ITM)+DQKLF+DQKCH/DEN+DQKRF
      IF(QKT(IT).GT.0.) THEN
        BKT(IT)=1.06*(QKLF*QKLF/AL+QKCH*QKCH/A+QKRF*QKRF/AR)*(AL+A+AR)/
     *    QKT(IT)**2.
      ELSE
        BKT(IT)=1.06
      ENDIF
      IF(BKT(IT).LT.1.06) BKT(IT)=1.06
      IF(Y.LE.YMX) GO TO 10
      IT=IT-1
      Y=HS(1,I,J)
      YY=HS(1,I,J)
      IF(I.NE.N) YY=HS(1,I+1,J)
      YIT=0.5*(Y+YY)
      Y=HS(2,I,J)
      YY=HS(2,I,J)
      IF(I.NE.N) YY=HS(2,I+1,J)
      YHS=0.5*(Y+YY)
      KK=2
      DO 18 K=2,IT
      KM=K-1
      YIT=YIT+DY
      IF(YHS.GE.YIT) GO TO 18
      FRAC=(YHS-(YIT-DY))/DY
      SNM(KK,I,J)=SNMIT(KM)+(SNMIT(K)-SNMIT(KM))*FRAC
      IF(KK.GE.NCS) GO TO 19
      KK=KK+1
      Y=HS(KK,I,J)
      YY=HS(KK,I,J)
      IF(I.NE.N) YY=HS(KK,I+1,J)
      YHS=0.5*(Y+YY)
   18 CONTINUE
      SNM(NCS,I,J)=SNMIT(IT)
   19   IF(JNK.GT.9.AND.I.EQ.1) THEN
        IF(IBUG.EQ.1) WRITE(IODBUG,109)
        IF(IBUG.EQ.1) WRITE(IODBUG,110) (QKT(K),K=1,IT)
        ENDIF
      DO 20 K=2,IT
      IF(QKT(K+1).LT.QKT(K)) GO TO 25
   20 CONTINUE
      GO TO 50
   25 KI=K
      KU=K+1
      DO 30 K=KU,IT
      IF(QKT(K).GT.1.05*QKT(KI)) GO TO 35
   30 CONTINUE
      K=IT
   35 KUP=K
      DQ=(QKT(KUP)-QKT(KI))/(KUP-KI)
      KM=KUP-1
      DO 40 K=KU,KM
      QKT(K)=QKT(K-1)+DQ
   40 CONTINUE
      IF(JNK.GT.9.AND.I.EQ.1) THEN
        IF(IBUG.EQ.1) WRITE(IODBUG,109)
        IF(IBUG.EQ.1) WRITE(IODBUG,110) (QKT(K),K=1,IT)
      ENDIF
   50 CONTINUE
      MM=0
      IF(JNK.GT.9 .AND. I.EQ.1) THEN
        IF(IBUG.EQ.1) WRITE(IODBUG,109)
        IF(IBUG.EQ.1) WRITE(IODBUG,115) (BKT(K),K=1,IT)
      ENDIF
   60 L=1
      QKC(1,I,J)=QKT(1)
      BEV(1,I,J)=BKT(1)
      HKC(1,I,J)=HS(1,I,J)
      ERQMX(I)=0.0
      IST=1
      IST1=IST+1
      IEND=IST1+1
   64 DEN=IEND-IST
      DQK=(QKT(IEND)-QKT(IST))/DEN
      IENDM=IEND-1
      IF(IENDM.LT.IST1) GO TO 70
      DO 65 IK=IST1,IENDM
      QKIK=QKT(IST)+(IK-IST)*DQK
      DQ=ABS(QKT(IK)-QKIK)/QKT(IK)*100.
      IF(DQ.GE.ERQK) GO TO 70
      IF(DQ.GE.ERQMX(I)) ERQMX(I)=DQ
   65 CONTINUE
      IEND=IEND+1
      IF(IEND.GT.IT) GO TO 70
      GO TO 64
   70 IEND=IEND-1
      L=L+1
      IF(L.GT.LMX) GO TO 72
      QKC(L,I,J)=QKT(IEND)
      BEV(L,I,J)=BKT(IEND)
      HKC(L,I,J)=HKC(L-1,I,J)+(IEND-IST)*DY
      IST=IEND
      IST1=IST+1
      IEND=IST1+1
      IF(IEND.GE.IT) GO TO 80
      GO TO 64
   72 ERQK=1.2*ERQK
      MM=MM+1
      IF(MM.LT.20) GO TO 60
      IF(IBUG.EQ.1) WRITE(IODBUG,111)
      STOP
   80 CONTINUE
      NKC(I,J)=L
      IF(JNK.GT.4.AND.I.EQ.1) GO TO 90
      IF(JNK.EQ.201.AND.I.GE.2) GO TO 90
      GO TO 100
  90  IF(IBUG.EQ.1) WRITE(IODBUG,114) J,I,L,ERQK,NKC(I,J)
      IF(IBUG.EQ.1) WRITE(IODBUG,109)
      IF(IBUG.EQ.1) WRITE(IODBUG,113) (HKC(KK,I,J),KK=1,L)
      IF(IBUG.EQ.1) WRITE(IODBUG,109)
      IF(IBUG.EQ.1) WRITE(IODBUG,112) (QKC(KK,I,J),KK=1,L)
      IF(IBUG.EQ.1) WRITE(IODBUG,109)
      IF(IBUG.EQ.1) WRITE(IODBUG,116) (BEV(KK,I,J),KK=1,L)
      PO(257)=ERQK
  100 CONTINUE

      IF(JNK.LT.4) GO TO 101
      IF(IBUG.EQ.1) WRITE(IODBUG,125)
  125 FORMAT(/)
      DO 4342 I=1,N
 4342 IF(IBUG.EQ.1) WRITE(IODBUG,4225) I,J,(SNM(K,I,J),K=1,NCS)
 4225 FORMAT(5X,'SNM(K,',I3,1H,,I2,')=',8F10.2)
C  101 CONTINUE
      IF(IBUG.EQ.1) WRITE(IODBUG,109)
      IF(IBUG.EQ.1) WRITE(IODBUG,118) (ERQMX(I),I=1,N)
101   CONTINUE
C
  108 FORMAT(/2X,'GENERATING CONVEYANCE CURVE')
  109 FORMAT(1X)
  110 FORMAT(5X,7HQKT(K)=,8F15.0)
  111 FORMAT(/5X,43HDID NOT FIT K VALUES WITH 30 OR LESS POINTS)
  112 FORMAT(5X,'QKC(L,I,J)=',8F13.0)
  113 FORMAT(5X,'HKC(L,I,J)=',8F13.2)
  114 FORMAT(/5X,2HJ=,I3,5X,2HI=,I5,5X,2HL=,I5,5X,5HERQK=,F6.2,5X,
     . 'NKC(I,J)=',I3)
  115 FORMAT(5X,7HBKT(K)=,8F15.3)
  116 FORMAT(5X,'BEV(L,I,J)=',8F13.3)
  118 FORMAT(5X,'ERQMX= ',10F5.2,'*',10F5.2)
C      IF(IBUG.EQ.1) WRITE(IODBUG,11111)
11111 FORMAT(1X,'** EXIT COMPK **')
  999 RETURN
      END