      SUBROUTINE STDMSG(CF)

C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C
C SUBPROGRAM:    STDMSG
C   PRGMMR: ATOR            ORG: NP12       DATE: 2004-08-18
C
C ABSTRACT: THIS SUBROUTINE IS USED TO SPECIFY WHETHER OR NOT BUFR
C   MESSAGES THAT WILL BE OUTPUT BY FUTURE CALLS TO ANY OF THE BUFR
C   ARCHIVE LIBRARY SUBROUTINES WHICH CREATE SUCH MESSAGES (E.G. WRITCP,
C   WRITSB, COPYMG, WRITSA, WRITCA, ETC.) ARE TO BE "STANDARDIZED".
C   SEE THE DOCUMENTATION BLOCK WITHIN BUFR ARCHIVE LIBRARY SUBROUTINE
C   STNDRD FOR AN EXPLANATION OF WHAT "STANDARDIZATION" MEANS.
C   THIS SUBROUTINE CAN BE CALLED AT ANY TIME AFTER THE FIRST CALL
C   TO BUFR ARCHIVE LIBRARY SUBROUTINE OPENBF, AND THE POSSIBLE VALUES
C   FOR CF ARE 'N' (= 'NO', WHICH IS THE DEFAULT) AND 'Y' (= 'YES').
C
C PROGRAM HISTORY LOG:
C 2004-08-18  J. ATOR    -- ORIGINAL AUTHOR
C
C USAGE:    CALL STDMSG (CF)
C   INPUT ARGUMENT LIST:
C     CF       - CHARACTER*1: FLAG INDICATING WHETHER BUFR MESSAGES
C                OUTPUT BY FUTURE CALLS TO WRITCP, WRITSB, COPYMG, ETC.
C                SHOULD BE "STANDARDIZED":
C                       'N' = 'NO' (THE DEFAULT)
C                       'Y' = 'YES'
C
C REMARKS:
C    THIS ROUTINE CALLS:        BORT     CAPIT
C    THIS ROUTINE IS CALLED BY: None
C                               Normally called only by application
C                               programs.
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN 77
C   MACHINE:  PORTABLE TO ALL PLATFORMS
C
C$$$

      COMMON /MSGSTD/ CSMF

      CHARACTER*128 BORT_STR
      CHARACTER*1   CSMF, CF

C-----------------------------------------------------------------------
C-----------------------------------------------------------------------

      CALL CAPIT(CF)
      IF(CF.NE.'Y'.AND. CF.NE.'N') GOTO 900
      CSMF = CF 

C  EXITS
C  -----

      RETURN
900   WRITE(BORT_STR,'("BUFRLIB: STDMSG - INPUT ARGUMENT IS ",A1,'//
     . '", IT MUST BE EITHER Y OR N")') CF
      CALL BORT(BORT_STR)
      END
