LDmicro0.2
CYCLE=10000 us at Timer1, YPlcCycleDuty:0, ConfigurationWord(s):0xF17982F700000000
CRYSTAL=16000000 Hz
BAUD=9600 Hz, RATE=1000000 Hz, SPEED=100000 Hz
COMPILED=C:\Users\YARELI\Documents\Compuertas_ED\Semaforo.hex
COMPILER=IHEX

PULL-UP LIST
END

VAR LIST
    2 bytes T1 	Now no se usa!
    2 bytes T2 	Now no se usa!
    2 bytes TT2 	Now no se usa!
    2 bytes Tnew 	Now no se usa!
END

IO LIST
    Xnew at 0 0 0
    Yamarillo1 at 0 0 0
    Yverde1 at 0 0 0
END

PROGRAM
RUNG 1
  COMMENT --Semaforo1: rojo1, amarillo1, rojo1--
END
RUNG 2
  CONTACTS Rencendido 0 0
  CONTACTS Xnew 1 0
  COIL Yverde1 0 0 0 0
END
RUNG 3
  PARALLEL
    CONTACTS Rencendido 0 0
    CONTACTS RT1 0 0
  END
  CONTACTS Reset 0 0
  RTO T1 15000000 0
  PARALLEL
    SERIES
      CONTACTS RT2 1 0
      COIL Yamarillo1 0 0 0 0
    END
    COIL RT1 0 0 0 0
  END
END
RUNG 4
  CONTACTS Xnew 0 0
  RTO T2 5000000 0
  PARALLEL
    COIL Yverde1 0 0 0 0
    COIL RT1 0 0 0 0
  END
END
RUNG 5
  COMMENT --Semaforo2: rojo2, amarillo2, verde2--
END
RUNG 6
  PLACEHOLDER
END
