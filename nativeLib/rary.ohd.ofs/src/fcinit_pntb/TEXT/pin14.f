C MEMBER PIN14
C  (from old member FCPIN14)
C.......................................................................
      SUBROUTINE PIN14(PADJ,LEFTP,IUSEP,CADJ,LEFTC,IUSEC)
C
C     SUBROUTINE READS FROM CARDS OR GENERATES ALL OF THE INFORMATION
C     NECESSARY TO EXECUTE THE ADJUST OPERATION.
C
C.......................................................................
C     PROGRAMMED BY KAY KROUSE   JANUARY 1980
C.......................................................................
      REAL IDQM,IDQI,IDSQ,IDADJ
      DIMENSION PADJ(1),CADJ(1),ANAME(5),IDQM(2),IDQI(2),IDSQ(2),DIM(2),
     1IDADJ(2),P14(2)
C
      INCLUDE 'common/fdbug'
      INCLUDE 'common/ionum'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcinit_pntb/RCS/pin14.f,v $
     . $',                                                             '
     .$Id: pin14.f,v 1.2 1996/12/10 16:12:24 dws Exp $
     . $' /
C    ===================================================================
C
C
      DATA P14/4HPIN1,4H4   /
      DATA DIM/4HL3/T,4HL3  /
      DATA PARM,CARY/4HPADJ,4HCADJ/
C.......................................................................
C     CHECK DEBUG REQUEST AND TRACE LEVEL
      CALL FPRBUG(P14,1,14,IBUG)
C     IF IBUG=1,PRINT DEBUG INFORMATION
C.......................................................................
C     INPUT VARIABLES FOR PADJ ARRAY.  CHECK TO SEE IF PADJ HAS ENOUGH
C     POSITIONS AVAILABLE - A MINIMUM OF 19 IS REQUIRED FOR THE ADJUST
C     OPERATION.
C
      NOOBS=0
      IUSEP=0
      NOROOM=0
      IF(LEFTP.GE.19) GO TO 15
      WRITE(IPR,905) PARM
  905 FORMAT(1H0,10X,67H**ERROR** THIS OPERATION NEEDS MORE SPACE THAN I
     1S AVAILABLE IN THE ,A4,7H ARRAY.)
      CALL ERROR
      NOROOM=1
   15 CONTINUE
C
C     READ IN FLOW POINT PARAMETERS AND TIME SERIES IDENTIFIERS
      READ(IN,910) (ANAME(I),I=1,5),IOI,IOM,ICRY
  910 FORMAT(5A4,3I5)
      IF (IOI.NE.1) IOI=0
      IF (IOM.NE.1) IOM=0
      IF (ICRY.NE.1) ICRY=0
      IF(IOI.EQ.0) GO TO 20
      READ(IN,915)IDQI(1),IDQI(2),QITYPE,ITQI
  915 FORMAT(2A4,3X,A4,I5)
      NOOBS=1
C
   20 IF(IOM.EQ.0) GO TO 25
      READ(IN,915) IDQM(1),IDQM(2),QMTYPE
      ITQM=24
      NOOBS=1
   25 IF(NOOBS.EQ.1) GO TO 30
      WRITE(IPR,920)
  920 FORMAT(1H0,10X,75H**ERROR** NO OBSERVED DISCHARGE, INSTANTANEOUS O
     1R MEAN DAILY, IS AVAILABLE./20X,39H THEREFORE, NO ADJUSTMENTS CAN
     2BE MADE.)
      CALL ERROR
C
   30 READ(IN,915)IDSQ(1),IDSQ(2),QSTYPE,ITSQ
      READ(IN,915)IDADJ(1),IDADJ(2),QATYPE
      ITADJ=ITSQ
C.......................................................................
C     CHECK TO SEE IF REQUESTED TIME SERIES HAVE BEEN DEFINED AND IF
C     DIMENSIONS ARE CORRECT.
      IF(IOI.EQ.1)CALL CHEKTS(IDQI,QITYPE,ITQI,1,DIM(1),1,1,IFLAG)
      IF(IOM.EQ.1)CALL CHEKTS(IDQM,QMTYPE,ITQM,1,DIM(2),1,1,IFLAG)
      CALL CHEKTS(IDSQ,QSTYPE,ITSQ,1,DIM(1),0,1,IFLAG)
      CALL CHEKTS(IDADJ,QATYPE,ITADJ,1,DIM(1),0,1,IFLAG)
      IF(IOI.EQ.0)GO TO 31
      NOMX=0
      MX=24/ITSQ
      DO 300 J=1,MX
      JX=J*ITSQ
      IF(ITQI.EQ.JX)NOMX=1
 300  CONTINUE
      IF(NOMX.EQ.1)GO TO 31
      WRITE(IPR,922)
 922  FORMAT(1H0,10X,97H**ERROR** THE TIME INTERVAL OF THE OBSERVED INST
     1ANTANEOUS TIME SERIES MUST BE AN INTEGER MULTIPLE/ 21X,64HOF THE T
     2IME INTERVAL OF THE SIMULATED INSTANTANEOUS TIME SERIES.)
      CALL ERROR
 31   CONTINUE
C.......................................................................
C     CONTINUE CHECKING INPUT FOR ERRORS, EVEN IF TIME SERIES ERROR
C     FOUND AND OPERATION WILL NOT BE EXECUTED.  READ IN NUMBER OF STEPS
C     FOR BLEND AND, IF IOM=1, ERROR TOLERANCE(%) AND ADJUST OPTION FOR
C     INSTANTANEOUS DATA IF IOI=1.
      IF(IOM.EQ.0)GO TO 32
      READ(IN,925)NSTEPS,TOL
      IF(TOL.LT.0001)TOL=.025
      GO TO 33
 32   READ(IN,925)NSTEPS
 33   IF(NSTEPS.GT.0)GO TO 3000
      WRITE(IPR,923)
 923  FORMAT(1H0,10X,71H**ERROR** THE NUMBER OF BLENDING STEPS(NSTEPS) C
     1ANNOT BE EQUAL TO ZERO.)
      CALL ERROR
 3000 IF (IOI .EQ. 1) THEN
         READ(IN,925)IOPT
  925    FORMAT(I5,F10.3)
c  added check on IOPT as per MR #12 - erb 11/5/96
         IF (IOPT.NE.0 .AND. IOPT.NE.1) THEN
	    WRITE (IPR,924) IOPT
  924       FORMAT(' **ERROR** THE OBSERVED INSTANTANEOUS DISCHARGE ',
     1      'ADJUSTMENT TYPE MUST BE A 0 OR 1, VALUE READ WAS (',I0,')')
            CALL ERROR
         ENDIF
      ENDIF
C     DETERMINE NUMBER OF CARRYOVER VALUES REQUIRED.
      NCO=24/ITADJ+4
C     FILL PADJ ARRAY
 34   MM=0
      IF(NOROOM.EQ.1) GO TO 50
      PADJ(1)=1+.01
      DO 35 I=2,6
   35 PADJ(I)=ANAME(I-1)
      PADJ(7)=IOI+.01
      PADJ(8)=IOM+.01
      PADJ(9)=IDSQ(1)
      PADJ(10)=IDSQ(2)
      PADJ(11)=QSTYPE
      PADJ(12)=ITSQ+.01
      PADJ(13)=IDADJ(1)
      PADJ(14)=IDADJ(2)
      PADJ(15)=QATYPE
      PADJ(16)=ITADJ+.01
      PADJ(17)=NSTEPS+.01
      PADJ(18)=NCO+.01
      PADJ(19)=ICRY+.01
      PADJ(20)=0+.01
      PADJ(21)=0+.01
      PADJ(22)=0+.01
      PADJ(23)=0+.01
      PADJ(24)=0+.01
      MM=24
      IF(IOM.EQ.0) GO TO 40
      IF((MM+4).LE.LEFTP) GO TO 37
      WRITE(IPR,905) PARM
      CALL ERROR
      GO TO 50
   37 PADJ(MM+1)=TOL
      PADJ(MM+2)=IDQM(1)
      PADJ(MM+3)=IDQM(2)
      PADJ(MM+4)=QMTYPE
      MM=MM+4
   40 IF(IOI.EQ.0) GO TO 50
      IF((MM+5).LE.LEFTP) GO TO 45
      WRITE(IPR,905) PARM
      CALL ERROR
      GO TO 50
   45 PADJ(MM+1)=IDQI(1)
      PADJ(MM+2)=IDQI(2)
      PADJ(MM+3)=QITYPE
      PADJ(MM+4)=ITQI+.01
      PADJ(MM+5)=IOPT+.01
      MM=MM+5
   50 CONTINUE
C.......................................................................
C     PADJ ARRAY COMPLETE.
C     TOTAL SPACE USED BY PADJ
      IUSEP=MM
C.......................................................................
C.......................................................................
C             **CONTENTS OF PADJ ARRAY**
C
C     1              VERSION NUMBER
C     2-6     ANAME  GENERAL NAME OF POINT TO WHICH OPERATION APPLIES
C     7       IOI    =1 OBS. INSTANTANEOUS DISCHARGE AVAILABLE
C                    =0 NO
C     8       IOM    =1 OBS. MEAN DAILY DISCHARGE AVAILABLE
C                    =0 NO
C     9-10    IDSQ   IDENTIFIER FOR SIMULATED DISCHARGE TIME SERIES
C     11      QSTYPE DATA TYPE CODE FOR IDSQ T.S.
C     12      ITSQ   TIME INTERVAL FOR IDSQ T.S.
C     13-14   IDADJ  IDENTIFIER FOR ADJUSTED DISCHARGE TIME SERIES
C     15      QATYPE DATA TYPE CODE FOR IDADJ T.S.
C     16      ITADJ  TIME INTERVAL FOR IDADJ T.S.
C     17      NSTEPS NUMBER OF STEPS FOR BLENDING
C     18      NCO    NUMBER OF CARRYOVER VALUES IN CADJ ARRAY
C     19      ICRY   =1 READ IN INITIAL CARRYOVER VALUES
C                    =0 USE DEFAULT CARRYOVER VALUES
C     20-24             EXTRA SPACE FOR FUTURE ADDITIONS TO P ARRAY
C
C     IF IOM=1, NEXT 4 POSITIONS CONTAIN:
C             TOL    ERROR TOLERANCE FOR COMPARING MEAN DAILY VOLUMES
C             IDQM   IDENTIFIER FOR OBS. MEAN DAILY DISCHARGE TIME
C                    SERIES
C             QMTYPE DATA TYPE CODE FOR IDQM T.S.
C
C     IF IOI=1, NEXT 5 POSITIONS CONTAIN:
C             IDQI   IDENTIFIER FOR OBS. INSTANTANEOUS DISCHARGE TIME
C                    SERIES
C             QITYPE DATA TYPE CODE FOR IDQI T.S.
C             ITQI   TIME INTERVAL FOR IDQI T.S.
C             IOPT   =1 INSTANT. ADJUSTMENTS BASED ON DIFFERENCES
C                    =0 INSTANT. ADJUSTMENTS BASED ON RATIOS
C
C.......................................................................
C.......................................................................
      MM=NCO-3
C     READ IN INITIAL CARRYOVER VALUES OR USE DEFAULT VALUES
      IF(ICRY.EQ.0)GO TO 80
C     READ VALUES
      IF(LEFTC.LT.NCO)GO TO 70
C     READ IN DISCHARGE VALUES FOR INITIAL DAY(IDA) FROM 2400 TO 2400
C     HOURS. VALUES LATER THAN IHR ARE NOT USED AND CAN BE INPUT AS
C     ZEROS.
      IF(IOM.EQ.0)GO TO 72
      READ(IN,935) (CADJ(K),K=1,MM)
 935  FORMAT(7F10.1)
      GO TO 74
 72   DO 73 I=1,MM
 73   CADJ(I)=0.0
 74   IF(IOI.EQ.0)GO TO 75
      READ(IN,937) DQI,NBI,QBI
 937  FORMAT(F10.2,I5,F10.2)
      CADJ(MM+1)=DQI
      CADJ(MM+2)=NBI+.01
      CADJ(MM+3)=QBI
      GO TO 85
  75  CADJ(MM+1)=0.
      CADJ(MM+2)=0+.01
      CADJ(MM+3)=0.
      GO TO 85
   70 WRITE(IPR,905) CARY
      CALL ERROR
      GO TO 95
C     USE DEFAULT VALUES
 80   IF(LEFTC.LT.NCO)GO TO 70
      DO 82 I=1,NCO
  82  CADJ(I)=0.0
C
  85  CONTINUE
C     CHECK FOR NEGATIVE VALUES. IF NEGATIVE, CHANGE TO ZERO.
      NEG=0
      NN=NCO-2
      DO 90 I=1,NCO
      IF(CADJ(I).GE.0.0)GO TO 90
      IF(I.EQ.NN)GO TO 90
      NEG=1
      CADJ(I)=0.0
 90   CONTINUE
      IF(NEG.EQ.0)GO TO 95
      WRITE(IPR,940)
 940  FORMAT(1H0,10X,88H**WARNING** ONE OR MORE CARRYOVER VALUES WERE NE
     1GATIVE. THE VALUES WERE CHANGED TO ZERO.)
      CALL WARN
  95  CONTINUE
C.......................................................................
C     CADJ ARRAY COMPLETE
C     TOTAL SPACE USED BY CADJ
      IUSEC=NCO
C.......................................................................
C.......................................................................
C             **CONTENTS OF CADJ ARRAY**
C
C     FIRST N POSITIONS,WHERE N=24/DT+1, CONTAIN:              00019010
C     1 THRU N       SIMULATED DISCHARGE VALUES FOR IDA-2400 TO 2400.
C
C     N+1     DQI    DIFFERENCE BETWEEN SIM AND OBS Q AT LAST OBSERVED
C                    ORDINATE OF PREVIOUS RUN
C     N+2     NBI    NUMBER OF BLENDING STEPS COMPLETED IN THE BLEND
C                    OF THE PREVIOUS RUN
C     N+3     QBI    LAST OBSERVED DISCHARGE VALUE OF PREVIOUS RUN
C
C.......................................................................
C.......................................................................
C     DEBUG OUTPUT?
      IF(IBUG.EQ.0)GO TO 100
C     DEBUG OUTPUT REQUESTED - PRINT CONTENTS OF PADJ AND CADJ ARRAYS.
C
      WRITE(IODBUG,950) IUSEP
 950  FORMAT(1H0,23HCONTENTS OF PADJ ARRAY.,5X,23HNUMBER OF VALUES--PADJ
     1=,I3)
      WRITE(IODBUG,955) (PADJ(I),I=1,IUSEP)
 955  FORMAT(1H ,15F8.3)
C
      WRITE(IODBUG,960) IUSEC
 960  FORMAT(1H0,23HCONTENTS OF CADJ ARRAY.,5X,23HNUMBER OF VALUES--CADJ
     1=,I3)
      WRITE(IODBUG,955) (CADJ(I),I=1,IUSEC)
 100  CONTINUE
      RETURN
      END
