LDmicro0.2
MICRO=Atmel AVR ATmega328 32-Pin packages
CYCLE=10000 us at Timer1, YPlcCycleDuty:0, ConfigurationWord(s):0xCCFC3E4800000000
CRYSTAL=16000000 Hz
BAUD=9600 Hz, RATE=1000000 Hz, SPEED=100000 Hz

PULL-UP LIST
    PB: 0xFFFFFFFF 
    PC: 0xFFFFFFFF 
    PD: 0xFFFFFFFF 
END

VAR LIST
    2 bytes T1 	Now no se usa!
    2 bytes T2 	Now no se usa!
    2 bytes TT2 	Now no se usa!
    2 bytes Tnew 	Now no se usa!
END

IO LIST
    XA at 32 0 0
    XB at 1 0 0
    YA1 at 9 0 0
    YA2 at 12 0 0
    YR1 at 2 0 0
    YR2 at 11 0 0
    YV1 at 10 0 0
    YV2 at 13 0 0
END

PROGRAM
RUNG 1
  COMMENT --Semaforo de 2 vias--\r\n
END
RUNG 2
  CONTACTS XA 0 0
  COIL RL1 0 0 0 0
END
RUNG 3
  CONTACTS XB 0 0
  COIL RL2 0 0 0 0
END
RUNG 4
  COMMENT --Rojo 1--\r\n
END
RUNG 5
  PARALLEL
    SERIES
      CONTACTS XA 1 0
      CONTACTS XB 1 0
    END
    SERIES
      CONTACTS XA 1 0
      CONTACTS XB 0 0
    END
  END
  COIL YR1 0 0 0 0
END
RUNG 6
  COMMENT --Amarillo 1--\r\n
END
RUNG 7
  CONTACTS XA 0 0
  CONTACTS XB 0 0
  COIL YA1 0 0 0 0
END
RUNG 8
  COMMENT --Vede 1--
END
RUNG 9
  CONTACTS XA 0 0
  CONTACTS XB 1 0
  COIL YV1 0 0 0 0
END
RUNG 10
  COMMENT --Rojo 2--
END
RUNG 11
  PARALLEL
    SERIES
      CONTACTS XA 0 0
      CONTACTS XB 1 0
    END
    SERIES
      CONTACTS XA 0 0
      CONTACTS XB 0 0
    END
  END
  COIL YR2 0 0 0 0
END
RUNG 12
  COMMENT --Amarillo 2--
END
RUNG 13
  CONTACTS XA 1 0
  CONTACTS XB 0 0
  COIL YA2 0 0 0 0
END
RUNG 14
  COMMENT --Verde 2--
END
RUNG 15
  CONTACTS XA 1 0
  CONTACTS XB 1 0
  COIL YV2 0 0 0 0
END
