C MODULE SPSTBN
C-----------------------------------------------------------------------
C
C  PRINT STATE BOUNDARY PARAMETER RECORD
C
      SUBROUTINE SPSTBN (IVSTBN,UNUSED,MDRBND,STBNPT,ISTAT)
C
      CHARACTER*10 STRNG
      CHARACTER*133 LINE
C
      DIMENSION MDRBND(*),STBNPT(89,1),UNUSED(1)
C
      INCLUDE 'uiox'
      INCLUDE 'scommon/sudbgx'
      INCLUDE 'scommon/supagx'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/ppinit_print/RCS/spstbn.f,v $
     . $',                                                             '
     .$Id: spstbn.f,v 1.3 2002/02/11 20:56:23 dws Exp $
     . $' /
C    ===================================================================
C
C
      IF (ISTRCE.GT.0) THEN
         WRITE (IOSDBG,*) 'ENTER SPSTBN'
         CALL SULINE (IOSDBG,1)
         ENDIF
C
C  SET DEBUG LEVEL
      LDEBUG=ISBUG('STBN')
C
      ISTAT=0
C
      MLINE=LEN(LINE)
      MSTRNG=LEN(STRNG)/2
      ILSTRT=2
C
C  CHECK NUMBER OF LINES LEFT ON PAGE
      IF (ISLEFT(13+MDRBND(4)*3).GT.0) CALL SUPAGE
C
C  PRINT HEADING
      WRITE (LP,120)
      CALL SULINE (LP,2)
      WRITE (LP,130)
      CALL SULINE (LP,2)
      WRITE (LP,140)
      CALL SULINE (LP,2)
C
C  PRINT PARAMETER ARRAY VERSION NUMBER
      IF (LDEBUG.EQ.0) GO TO 10
         WRITE (LP,150) IVSTBN
         CALL SULINE (LP,2)
C
C  PRINT MDR SUBSET FOR WHICH STBN PARAMETERS DEFINED
10    WRITE (LP,160) MDRBND(1),MDRBND(2)
      CALL SULINE (LP,2)
      WRITE (LP,170) MDRBND(3),MDRBND(4)
      CALL SULINE (LP,1)
C
C  PRINT TITLE LINE
      WRITE (LP,180)
      CALL SULINE (LP,2)
      CALL UREPET (' ',LINE,MLINE)
      NCOL=MDRBND(2)
      MCOL=MDRBND(1)+MDRBND(2)-1
      ICENTR=(NCOL*3-10)/2+ILSTRT
      STRNG='MDR COLUMN'
      LSTRNG=LENSTR(STRNG)
      IF (ICENTR+LSTRNG.GT.MLINE) GO TO 90
      LINE(ICENTR:ICENTR+LSTRNG)=STRNG
      WRITE (LP,140)
      WRITE (LP,190) LINE
      CALL SULINE (LP,2)
      CALL UREPET (' ',LINE,MLINE)
C
C  PRINT MDR COLUMN NUMBER HEADING LINE
      INDENT=6
      CALL UINTCH (MDRBND(1),MSTRNG,STRNG,NFILL,IERR)
      IF (ILSTRT+INDENT.GT.MLINE) GO TO 90
      CALL SUBSTR (STRNG,1,MSTRNG,LINE,ILSTRT-MSTRNG+INDENT)
      INT1=(MDRBND(1)+9)/10*10
      INT2=(MCOL-9)/10*10
      NUM=(INT2-INT1)/10+1
      LCOL=(INT1-MDRBND(1))*3+ILSTRT-MSTRNG+INDENT
      DO 40 I=1,NUM
         INT=INT1+(I-1)*10
         CALL UINTCH (INT,MSTRNG,STRNG,NFILL,IERR)
         IF (LCOL+MSTRNG.GT.MLINE) GO TO 90
         CALL SUBSTR (STRNG,1,MSTRNG,LINE,LCOL)
         LCOL=LCOL+30
40       CONTINUE
      CALL UINTCH (MCOL,MSTRNG,STRNG,NFILL,IERR)
      LCOL=(NCOL-1)*3+ILSTRT-MSTRNG+INDENT
      IF (LCOL+MSTRNG.GT.MLINE) GO TO 90
      CALL SUBSTR (STRNG,1,MSTRNG,LINE,LCOL)
      WRITE (LP,190) LINE
      CALL SULINE (LP,1)
      CALL UREPET (' ',LINE,MLINE)
C
C  PRINT DASH/PLUS HEADING LINE
      LINE=' ROW'
      LCOL=INDENT
      DO 60 I=1,NCOL
         IF (LCOL.GT.MLINE) GO TO 90
         LINE(LCOL:LCOL)='-'
         IF (LCOL+1.GT.MLINE) GO TO 90
         LINE(LCOL:LCOL+1)='-'
         IF (LCOL+2.GT.MLINE) GO TO 90
         LINE(LCOL:LCOL+2)='-'
         LCOL=LCOL+3
60       CONTINUE
      WRITE (LP,190) LINE
      CALL SULINE (LP,1)
      CALL UREPET (' ',LINE,MLINE)
C
C  PRINT STATE BOUNDARY POINTS FOR MDR SUBSET
      IR=MDRBND(3)+MDRBND(4)-1
      NROW=MDRBND(4)
      IF (NCOL.GT.MLINE) GO TO 90
      DO 80 J=1,NROW
         IROW=IR-J+1
         WRITE (LP,200) IROW,(STBNPT(IROW,I),I=1,NCOL)
         CALL SULINE (LP,2)
         WRITE (LP,140)
         CALL SULINE (LP,1)
80       CONTINUE
C
C  PRINT UNUSED POSITIONS
      IF (LDEBUG.EQ.0) GO TO 100
         NUNSED=2
         WRITE (LP,210) NUNSED
         GO TO 100
C
C  ATTEMPT TO WRITE PAST END OF PRINT RECORD
90    WRITE (LP,220) MLINE
      CALL SUERRS (LP,2,-1)
C
100   WRITE (LP,120)
      CALL SULINE (LP,2)
C
      IF (ISTRCE.GT.0) THEN
         WRITE (IOSDBG,*) 'EXIT SPSTBN'
         CALL SULINE (IOSDBG,1)
         ENDIF
C
      RETURN
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
120   FORMAT ('0',132('-'))
130   FORMAT ('0*--> STBN PARAMETERS ',
     *   '(STATE BOUNDARIES)')
140   FORMAT (' ')
150   FORMAT ('0PARAMETER ARRAY VERSION NUMBER = ',I2)
160   FORMAT ('0MDR SUBSET :  WESTERN COLUMN=',I3,5X,
     *   'NUMBER OF COLUMNS=',I3)
170   FORMAT (T16,'SOUTHERN ROW=',I3,5X,'NUMBER OF ROWS=',I3)
180   FORMAT ('0STATE BOUNDARY POINTS')
190   FORMAT (133A1)
200   FORMAT ('0',I2,2X,42A3)
210   FORMAT ('0NUMBER OF UNUSED POSITIONS = ',I2)
220   FORMAT ('0*** ERROR - IN SPSTBN - ATTEMPT TO WRITE PAST END OF ',
     *   'PRINTER LINE. MAXIMUM CHARACTERS ALLOWED IS ',I3,'.')
C
      END
