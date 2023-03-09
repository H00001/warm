# RUN: llvm-mc %s -triple=mips64-unknown-linux -show-encoding -mcpu=mips64r2 \
# RUN:   | FileCheck %s
# RUN: llvm-mc %s -triple=mips64-unknown-linux -show-encoding -mcpu=mips64r6 \
# RUN:   | FileCheck %s

la $5, 0x00000001 # CHECK: daddiu $5, $zero, 1      # encoding: [0x64,0x05,0x00,0x01]
la $5, 0x00000002 # CHECK: daddiu $5, $zero, 2      # encoding: [0x64,0x05,0x00,0x02]
la $5, 0x00004000 # CHECK: daddiu $5, $zero, 16384  # encoding: [0x64,0x05,0x40,0x00]
la $5, 0x00008000 # CHECK: ori    $5, $zero, 32768  # encoding: [0x34,0x05,0x80,0x00]
la $5, 0xffffffff # CHECK: lui    $5, 65535         # encoding: [0x3c,0x05,0xff,0xff]
                  # CHECK: dsrl32 $5, $5, 0         # encoding: [0x00,0x05,0x28,0x3e]
la $5, 0xfffffffe # CHECK: ori    $5, $zero, 65535  # encoding: [0x34,0x05,0xff,0xff]
                  # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                  # CHECK: ori    $5, $5, 65534     # encoding: [0x34,0xa5,0xff,0xfe]
la $5, 0xffffc000 # CHECK: ori    $5, $zero, 65535  # encoding: [0x34,0x05,0xff,0xff]
                  # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                  # CHECK: ori    $5, $5, 49152     # encoding: [0x34,0xa5,0xc0,0x00]
la $5, 0xffff8000 # CHECK: ori    $5, $zero, 65535  # encoding: [0x34,0x05,0xff,0xff]
                  # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                  # CHECK: ori    $5, $5, 32768     # encoding: [0x34,0xa5,0x80,0x00]

la $5, 0x00010000 # CHECK: lui  $5, 1               # encoding: [0x3c,0x05,0x00,0x01]
la $5, 0x00020000 # CHECK: lui  $5, 2               # encoding: [0x3c,0x05,0x00,0x02]
la $5, 0x40000000 # CHECK: lui  $5, 16384           # encoding: [0x3c,0x05,0x40,0x00]
la $5, 0x80000000 # CHECK: ori  $5, $zero, 32768    # encoding: [0x34,0x05,0x80,0x00]
                  # CHECK: dsll $5, $5, 16          # encoding: [0x00,0x05,0x2c,0x38]
la $5, 0xffff0000 # CHECK: ori  $5, $zero, 65535    # encoding: [0x34,0x05,0xff,0xff]
                  # CHECK: dsll $5, $5, 16          # encoding: [0x00,0x05,0x2c,0x38]
la $5, 0xfffe0000 # CHECK: ori  $5, $zero, 65534    # encoding: [0x34,0x05,0xff,0xfe]
                  # CHECK: dsll $5, $5, 16          # encoding: [0x00,0x05,0x2c,0x38]
la $5, 0xc0000000 # CHECK: ori  $5, $zero, 49152    # encoding: [0x34,0x05,0xc0,0x00]
                  # CHECK: dsll $5, $5, 16          # encoding: [0x00,0x05,0x2c,0x38]
la $5, 0x80000000 # CHECK: ori  $5, $zero, 32768    # encoding: [0x34,0x05,0x80,0x00]
                  # CHECK: dsll $5, $5, 16          # encoding: [0x00,0x05,0x2c,0x38]

la $5, 0x00010001 # CHECK: lui  $5, 1               # encoding: [0x3c,0x05,0x00,0x01]
                  # CHECK: ori  $5, $5, 1           # encoding: [0x34,0xa5,0x00,0x01]
la $5, 0x00020001 # CHECK: lui  $5, 2               # encoding: [0x3c,0x05,0x00,0x02]
                  # CHECK: ori  $5, $5, 1           # encoding: [0x34,0xa5,0x00,0x01]
la $5, 0x40000001 # CHECK: lui  $5, 16384           # encoding: [0x3c,0x05,0x40,0x00]
                  # CHECK: ori  $5, $5, 1           # encoding: [0x34,0xa5,0x00,0x01]
la $5, 0x80000001 # CHECK: ori  $5, $zero, 32768    # encoding: [0x34,0x05,0x80,0x00]
                  # CHECK: dsll $5, $5, 16          # encoding: [0x00,0x05,0x2c,0x38]
                  # CHECK: ori  $5, $5, 1           # encoding: [0x34,0xa5,0x00,0x01]
la $5, 0x00010002 # CHECK: lui  $5, 1               # encoding: [0x3c,0x05,0x00,0x01]
                  # CHECK: ori  $5, $5, 2           # encoding: [0x34,0xa5,0x00,0x02]
la $5, 0x00020002 # CHECK: lui  $5, 2               # encoding: [0x3c,0x05,0x00,0x02]
                  # CHECK: ori  $5, $5, 2           # encoding: [0x34,0xa5,0x00,0x02]
la $5, 0x40000002 # CHECK: lui  $5, 16384           # encoding: [0x3c,0x05,0x40,0x00]
                  # CHECK: ori  $5, $5, 2           # encoding: [0x34,0xa5,0x00,0x02]
la $5, 0x80000002 # CHECK: ori  $5, $zero, 32768    # encoding: [0x34,0x05,0x80,0x00]
                  # CHECK: dsll $5, $5, 16          # encoding: [0x00,0x05,0x2c,0x38] 
                  # CHECK: ori  $5, $5, 2           # encoding: [0x34,0xa5,0x00,0x02]
la $5, 0x00014000 # CHECK: lui  $5, 1               # encoding: [0x3c,0x05,0x00,0x01]
                  # CHECK: ori  $5, $5, 16384       # encoding: [0x34,0xa5,0x40,0x00]
la $5, 0x00024000 # CHECK: lui  $5, 2               # encoding: [0x3c,0x05,0x00,0x02]
                  # CHECK: ori  $5, $5, 16384       # encoding: [0x34,0xa5,0x40,0x00]
la $5, 0x40004000 # CHECK: lui  $5, 16384           # encoding: [0x3c,0x05,0x40,0x00]
                  # CHECK: ori  $5, $5, 16384       # encoding: [0x34,0xa5,0x40,0x00]
la $5, 0x80004000 # CHECK: ori  $5, $zero, 32768    # encoding: [0x34,0x05,0x80,0x00]
                  # CHECK: dsll $5, $5, 16          # encoding: [0x00,0x05,0x2c,0x38]
                  # CHECK: ori  $5, $5, 16384       # encoding: [0x34,0xa5,0x40,0x00]
la $5, 0x00018000 # CHECK: lui  $5, 1               # encoding: [0x3c,0x05,0x00,0x01]
                  # CHECK: ori  $5, $5, 32768       # encoding: [0x34,0xa5,0x80,0x00]
la $5, 0x00028000 # CHECK: lui  $5, 2               # encoding: [0x3c,0x05,0x00,0x02]
                  # CHECK: ori  $5, $5, 32768       # encoding: [0x34,0xa5,0x80,0x00]
la $5, 0x40008000 # CHECK: lui  $5, 16384           # encoding: [0x3c,0x05,0x40,0x00]
                  # CHECK: ori  $5, $5, 32768       # encoding: [0x34,0xa5,0x80,0x00]
la $5, 0x80008000 # CHECK: ori  $5, $zero, 32768    # encoding: [0x34,0x05,0x80,0x00]
                  # CHECK: dsll $5, $5, 16          # encoding: [0x00,0x05,0x2c,0x38]
la $5, 0xffff4000 # CHECK: ori  $5, $5, 32768       # encoding: [0x34,0xa5,0x80,0x00]
                  # CHECK: ori  $5, $5, 16384       # encoding: [0x34,0xa5,0x40,0x00]
la $5, 0xfffe8000 # CHECK: ori  $5, $zero, 65534    # encoding: [0x34,0x05,0xff,0xfe]
                  # CHECK: dsll $5, $5, 16          # encoding: [0x00,0x05,0x2c,0x38]
                  # CHECK: ori  $5, $5, 32768       # encoding: [0x34,0xa5,0x80,0x00]
la $5, 0xc0008000 # CHECK: ori  $5, $zero, 49152    # encoding: [0x34,0x05,0xc0,0x00]
                  # CHECK: dsll $5, $5, 16          # encoding: [0x00,0x05,0x2c,0x38]
                  # CHECK: ori  $5, $5, 32768       # encoding: [0x34,0xa5,0x80,0x00]
la $5, 0x80008000 # CHECK: ori  $5, $zero, 32768    # encoding: [0x34,0x05,0x80,0x00]
                  # CHECK: dsll $5, $5, 16          # encoding: [0x00,0x05,0x2c,0x38]
                  # CHECK: ori  $5, $5, 32768       # encoding: [0x34,0xa5,0x80,0x00]

la $5, 0x0000000100008000 # CHECK: addiu  $5, $zero, 1      # encoding: [0x24,0x05,0x00,0x01]
                          # CHECK: dsll32 $5, $5, 0         # encoding: [0x00,0x05,0x28,0x3c]
                          # CHECK: ori    $5, $5, 32768     # encoding: [0x34,0xa5,0x80,0x00]
la $5, 0x0000000100014000 # CHECK: addiu  $5, $zero, 1      # encoding: [0x24,0x05,0x00,0x01]
                          # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                          # CHECK: ori    $5, $5, 1         # encoding: [0x34,0xa5,0x00,0x01]
                          # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                          # CHECK: ori    $5, $5, 16384     # encoding: [0x34,0xa5,0x40,0x00]
la $5, 0x0000000180008000 # CHECK: addiu  $5, $zero, 1      # encoding: [0x24,0x05,0x00,0x01]
                          # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                          # CHECK: ori    $5, $5, 32768     # encoding: [0x34,0xa5,0x80,0x00]
                          # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                          # CHECK: ori    $5, $5, 32768     # encoding: [0x34,0xa5,0x80,0x00]
la $5, 0x0000000200008000 # CHECK: addiu  $5, $zero, 2      # encoding: [0x24,0x05,0x00,0x02]
                          # CHECK: dsll32 $5, $5, 0         # encoding: [0x00,0x05,0x28,0x3c]
                          # CHECK: ori    $5, $5, 32768     # encoding: [0x34,0xa5,0x80,0x00]
la $5, 0x0000000200014000 # CHECK: addiu  $5, $zero, 2      # encoding: [0x24,0x05,0x00,0x02]
                          # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                          # CHECK: ori    $5, $5, 1         # encoding: [0x34,0xa5,0x00,0x01]
                          # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                          # CHECK: ori    $5, $5, 16384     # encoding: [0x34,0xa5,0x40,0x00]
la $5, 0x0000000280008000 # CHECK: addiu  $5, $zero, 2      # encoding: [0x24,0x05,0x00,0x02]
                          # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                          # CHECK: ori    $5, $5, 32768     # encoding: [0x34,0xa5,0x80,0x00]
                          # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                          # CHECK: ori    $5, $5, 32768     # encoding: [0x34,0xa5,0x80,0x00]
la $5, 0x0000400000008000 # CHECK: addiu  $5, $zero, 16384  # encoding: [0x24,0x05,0x40,0x00]
                          # CHECK: dsll32 $5, $5, 0         # encoding: [0x00,0x05,0x28,0x3c]
                          # CHECK: ori    $5, $5, 32768     # encoding: [0x34,0xa5,0x80,0x00]
la $5, 0x0000400000014000 # CHECK: addiu  $5, $zero, 16384  # encoding: [0x24,0x05,0x40,0x00]
                          # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                          # CHECK: ori    $5, $5, 1         # encoding: [0x34,0xa5,0x00,0x01]
                          # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                          # CHECK: ori    $5, $5, 16384     # encoding: [0x34,0xa5,0x40,0x00]
la $5, 0x0000400040008000 # CHECK: addiu  $5, $zero, 16384  # encoding: [0x24,0x05,0x40,0x00]
                          # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                          # CHECK: ori    $5, $5, 16384     # encoding: [0x34,0xa5,0x40,0x00]
                          # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                          # CHECK: ori    $5, $5, 32768     # encoding: [0x34,0xa5,0x80,0x00]
la $5, 0x8000800080008000 # CHECK: lui    $5, 32768         # encoding: [0x3c,0x05,0x80,0x00]
                          # CHECK: ori    $5, $5, 32768     # encoding: [0x34,0xa5,0x80,0x00]
                          # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                          # CHECK: ori    $5, $5, 32768     # encoding: [0x34,0xa5,0x80,0x00]
                          # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                          # CHECK: ori    $5, $5, 32768     # encoding: [0x34,0xa5,0x80,0x00]

la $5, 0x00000001($6) # CHECK: daddiu $5, $6, 1         # encoding: [0x64,0xc5,0x00,0x01]
la $5, 0x00000002($6) # CHECK: daddiu $5, $6, 2         # encoding: [0x64,0xc5,0x00,0x02]
la $5, 0x00004000($6) # CHECK: daddiu $5, $6, 16384     # encoding: [0x64,0xc5,0x40,0x00]
la $5, 0x00008000($6) # CHECK: ori    $5, $zero, 32768  # encoding: [0x34,0x05,0x80,0x00]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]
la $5, 0xffffffff($6) # CHECK: lui    $5, 65535         # encoding: [0x3c,0x05,0xff,0xff]
                      # CHECK: dsrl32 $5, $5, 0         # encoding: [0x00,0x05,0x28,0x3e]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]
la $5, 0xfffffffe($6) # CHECK: ori    $5, $zero, 65535  # encoding: [0x34,0x05,0xff,0xff]
                      # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                      # CHECK: ori    $5, $5, 65534     # encoding: [0x34,0xa5,0xff,0xfe]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]
la $5, 0xffffc000($6) # CHECK: ori    $5, $zero, 65535  # encoding: [0x34,0x05,0xff,0xff]
                      # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                      # CHECK: ori    $5, $5, 49152     # encoding: [0x34,0xa5,0xc0,0x00]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]
la $5, 0xffff8000($6) # CHECK: ori    $5, $zero, 65535  # encoding: [0x34,0x05,0xff,0xff]
                      # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                      # CHECK: ori    $5, $5, 32768     # encoding: [0x34,0xa5,0x80,0x00]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]

la $5, 0x00010000($6) # CHECK: lui    $5, 1             # encoding: [0x3c,0x05,0x00,0x01]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]
la $5, 0x00020000($6) # CHECK: lui    $5, 2             # encoding: [0x3c,0x05,0x00,0x02]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]
la $5, 0x40000000($6) # CHECK: lui    $5, 16384         # encoding: [0x3c,0x05,0x40,0x00]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]
la $5, 0x80000000($6) # CHECK: ori    $5, $zero, 32768  # encoding: [0x34,0x05,0x80,0x00]
                      # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]
la $5, 0xffff0000($6) # CHECK: ori    $5, $zero, 65535  # encoding: [0x34,0x05,0xff,0xff]
                      # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]
la $5, 0xfffe0000($6) # CHECK: ori    $5, $zero, 65534  # encoding: [0x34,0x05,0xff,0xfe]
                      # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]
la $5, 0xc0000000($6) # CHECK: ori    $5, $zero, 49152  # encoding: [0x34,0x05,0xc0,0x00]
                      # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]
la $5, 0x80000000($6) # CHECK: ori    $5, $zero, 32768  # encoding: [0x34,0x05,0x80,0x00]
                      # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]

la $5, 0x00010001($6) # CHECK: lui    $5, 1             # encoding: [0x3c,0x05,0x00,0x01]
                      # CHECK: ori    $5, $5, 1         # encoding: [0x34,0xa5,0x00,0x01]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]
la $5, 0x00020001($6) # CHECK: lui    $5, 2             # encoding: [0x3c,0x05,0x00,0x02]
                      # CHECK: ori    $5, $5, 1         # encoding: [0x34,0xa5,0x00,0x01]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]
la $5, 0x40000001($6) # CHECK: lui    $5, 16384         # encoding: [0x3c,0x05,0x40,0x00]
                      # CHECK: ori    $5, $5, 1         # encoding: [0x34,0xa5,0x00,0x01]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]
la $5, 0x80000001($6) # CHECK: ori    $5, $zero, 32768  # encoding: [0x34,0x05,0x80,0x00]
                      # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                      # CHECK: ori    $5, $5, 1         # encoding: [0x34,0xa5,0x00,0x01]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]
la $5, 0x00010002($6) # CHECK: lui    $5, 1             # encoding: [0x3c,0x05,0x00,0x01]
                      # CHECK: ori    $5, $5, 2         # encoding: [0x34,0xa5,0x00,0x02]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]
la $5, 0x00020002($6) # CHECK: lui    $5, 2             # encoding: [0x3c,0x05,0x00,0x02]
                      # CHECK: ori    $5, $5, 2         # encoding: [0x34,0xa5,0x00,0x02]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]
la $5, 0x40000002($6) # CHECK: lui    $5, 16384         # encoding: [0x3c,0x05,0x40,0x00]
                      # CHECK: ori    $5, $5, 2         # encoding: [0x34,0xa5,0x00,0x02]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]
la $5, 0x80000002($6) # CHECK: ori    $5, $zero, 32768  # encoding: [0x34,0x05,0x80,0x00]
                      # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                      # CHECK: ori    $5, $5, 2         # encoding: [0x34,0xa5,0x00,0x02]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]
la $5, 0x00014000($6) # CHECK: lui    $5, 1             # encoding: [0x3c,0x05,0x00,0x01]
                      # CHECK: ori    $5, $5, 16384     # encoding: [0x34,0xa5,0x40,0x00]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]
la $5, 0x00024000($6) # CHECK: lui    $5, 2             # encoding: [0x3c,0x05,0x00,0x02]
                      # CHECK: ori    $5, $5, 16384     # encoding: [0x34,0xa5,0x40,0x00]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]
la $5, 0x40004000($6) # CHECK: lui    $5, 16384         # encoding: [0x3c,0x05,0x40,0x00]
                      # CHECK: ori    $5, $5, 16384     # encoding: [0x34,0xa5,0x40,0x00]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]
la $5, 0x80004000($6) # CHECK: ori    $5, $zero, 32768  # encoding: [0x34,0x05,0x80,0x00]
                      # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                      # CHECK: ori    $5, $5, 16384     # encoding: [0x34,0xa5,0x40,0x00]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]
la $5, 0x00018000($6) # CHECK: lui    $5, 1             # encoding: [0x3c,0x05,0x00,0x01]
                      # CHECK: ori    $5, $5, 32768     # encoding: [0x34,0xa5,0x80,0x00]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]
la $5, 0x00028000($6) # CHECK: lui    $5, 2             # encoding: [0x3c,0x05,0x00,0x02]
                      # CHECK: ori    $5, $5, 32768     # encoding: [0x34,0xa5,0x80,0x00]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]
la $5, 0x40008000($6) # CHECK: lui    $5, 16384         # encoding: [0x3c,0x05,0x40,0x00]
                      # CHECK: ori    $5, $5, 32768     # encoding: [0x34,0xa5,0x80,0x00]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]
la $5, 0x80008000($6) # CHECK: ori    $5, $zero, 32768  # encoding: [0x34,0x05,0x80,0x00]
                      # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                      # CHECK: ori    $5, $5, 32768     # encoding: [0x34,0xa5,0x80,0x00]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]
la $5, 0xffff4000($6) # CHECK: ori    $5, $zero, 65535  # encoding: [0x34,0x05,0xff,0xff]
                      # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                      # CHECK: ori    $5, $5, 16384     # encoding: [0x34,0xa5,0x40,0x00]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]
la $5, 0xfffe8000($6) # CHECK: ori    $5, $zero, 65534  # encoding: [0x34,0x05,0xff,0xfe]
                      # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                      # CHECK: ori    $5, $5, 32768     # encoding: [0x34,0xa5,0x80,0x00]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]
la $5, 0xc0008000($6) # CHECK: ori    $5, $zero, 49152  # encoding: [0x34,0x05,0xc0,0x00]
                      # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                      # CHECK: ori    $5, $5, 32768     # encoding: [0x34,0xa5,0x80,0x00]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]
la $5, 0x80008000($6) # CHECK: ori    $5, $zero, 32768  # encoding: [0x34,0x05,0x80,0x00]
                      # CHECK: dsll   $5, $5, 16        # encoding: [0x00,0x05,0x2c,0x38]
                      # CHECK: ori    $5, $5, 32768     # encoding: [0x34,0xa5,0x80,0x00]
                      # CHECK: daddu  $5, $5, $6        # encoding: [0x00,0xa6,0x28,0x2d]

la $6, 0x00000001($6) # CHECK: daddiu  $6, $6, 1        # encoding: [0x64,0xc6,0x00,0x01]
la $6, 0x00000002($6) # CHECK: daddiu  $6, $6, 2        # encoding: [0x64,0xc6,0x00,0x02]
la $6, 0x00004000($6) # CHECK: daddiu  $6, $6, 16384    # encoding: [0x64,0xc6,0x40,0x00]
la $6, 0x00008000($6) # CHECK: ori     $6, $zero, 32768 # encoding: [0x34,0x06,0x80,0x00]
                      # CHECK: daddu   $6, $6, $6       # encoding: [0x00,0xc6,0x30,0x2d]
la $6, 0xffffffff($6) # CHECK: lui     $1, 65535        # encoding: [0x3c,0x01,0xff,0xff]
                      # CHECK: dsrl32  $1, $1, 0        # encoding: [0x00,0x01,0x08,0x3e]
                      # CHECK: daddu   $6, $1, $6       # encoding: [0x00,0x26,0x30,0x2d]
la $6, 0xfffffffe($6) # CHECK: ori     $1, $zero, 65535 # encoding: [0x34,0x01,0xff,0xff]
                      # CHECK: dsll    $1, $1, 16       # encoding: [0x00,0x01,0x0c,0x38]
                      # CHECK: ori     $1, $1, 65534    # encoding: [0x34,0x21,0xff,0xfe]
                      # CHECK: daddu   $6, $1, $6       # encoding: [0x00,0x26,0x30,0x2d]
la $6, 0xffffc000($6) # CHECK: ori     $1, $zero, 65535 # encoding: [0x34,0x01,0xff,0xff]
                      # CHECK: dsll    $1, $1, 16       # encoding: [0x00,0x01,0x0c,0x38]
                      # CHECK: ori     $1, $1, 49152    # encoding: [0x34,0x21,0xc0,0x00]
                      # CHECK: daddu   $6, $1, $6       # encoding: [0x00,0x26,0x30,0x2d]
la $6, 0xffff8000($6) # CHECK: ori     $1, $zero, 65535 # encoding: [0x34,0x01,0xff,0xff]
                      # CHECK: dsll    $1, $1, 16       # encoding: [0x00,0x01,0x0c,0x38]
                      # CHECK: ori     $1, $1, 32768    # encoding: [0x34,0x21,0x80,0x00]
                      # CHECK: daddu   $6, $1, $6       # encoding: [0x00,0x26,0x30,0x2d]

la $6, 0x00010000($6) # CHECK: lui    $1, 1             # encoding: [0x3c,0x01,0x00,0x01]
                      # CHECK: daddu  $6, $1, $6        # encoding: [0x00,0x26,0x30,0x2d]
la $6, 0x00020000($6) # CHECK: lui    $1, 2             # encoding: [0x3c,0x01,0x00,0x02]
                      # CHECK: daddu  $6, $1, $6        # encoding: [0x00,0x26,0x30,0x2d]
la $6, 0x40000000($6) # CHECK: lui    $1, 16384         # encoding: [0x3c,0x01,0x40,0x00]
                      # CHECK: daddu  $6, $1, $6        # encoding: [0x00,0x26,0x30,0x2d]
la $6, 0x80000000($6) # CHECK: ori    $1, $zero, 32768  # encoding: [0x34,0x01,0x80,0x00]
                      # CHECK: dsll   $1, $1, 16        # encoding: [0x00,0x01,0x0c,0x38]
                      # CHECK: daddu  $6, $1, $6        # encoding: [0x00,0x26,0x30,0x2d]
la $6, 0xffff0000($6) # CHECK: ori    $1, $zero, 65535  # encoding: [0x34,0x01,0xff,0xff]
                      # CHECK: dsll   $1, $1, 16        # encoding: [0x00,0x01,0x0c,0x38]
                      # CHECK: daddu  $6, $1, $6        # encoding: [0x00,0x26,0x30,0x2d]
la $6, 0xfffe0000($6) # CHECK: ori    $1, $zero, 65534  # encoding: [0x34,0x01,0xff,0xfe]
                      # CHECK: dsll   $1, $1, 16        # encoding: [0x00,0x01,0x0c,0x38]
                      # CHECK: daddu  $6, $1, $6        # encoding: [0x00,0x26,0x30,0x2d]
la $6, 0xc0000000($6) # CHECK: ori    $1, $zero, 49152  # encoding: [0x34,0x01,0xc0,0x00]
                      # CHECK: dsll   $1, $1, 16        # encoding: [0x00,0x01,0x0c,0x38]
                      # CHECK: daddu  $6, $1, $6        # encoding: [0x00,0x26,0x30,0x2d]
la $6, 0x80000000($6) # CHECK: ori    $1, $zero, 32768  # encoding: [0x34,0x01,0x80,0x00]
                      # CHECK: dsll   $1, $1, 16        # encoding: [0x00,0x01,0x0c,0x38]
                      # CHECK: daddu  $6, $1, $6        # encoding: [0x00,0x26,0x30,0x2d]

la $6, 0x00010001($6) # CHECK: lui    $1, 1             # encoding: [0x3c,0x01,0x00,0x01]
                      # CHECK: ori    $1, $1, 1         # encoding: [0x34,0x21,0x00,0x01]
                      # CHECK: daddu  $6, $1, $6        # encoding: [0x00,0x26,0x30,0x2d]
la $6, 0x00020001($6) # CHECK: lui    $1, 2             # encoding: [0x3c,0x01,0x00,0x02]
                      # CHECK: ori    $1, $1, 1         # encoding: [0x34,0x21,0x00,0x01]
                      # CHECK: daddu  $6, $1, $6        # encoding: [0x00,0x26,0x30,0x2d]
la $6, 0x40000001($6) # CHECK: lui    $1, 16384         # encoding: [0x3c,0x01,0x40,0x00]
                      # CHECK: ori    $1, $1, 1         # encoding: [0x34,0x21,0x00,0x01]
                      # CHECK: daddu  $6, $1, $6        # encoding: [0x00,0x26,0x30,0x2d]
la $6, 0x80000001($6) # CHECK: ori    $1, $zero, 32768  # encoding: [0x34,0x01,0x80,0x00]
                      # CHECK: dsll   $1, $1, 16        # encoding: [0x00,0x01,0x0c,0x38]
                      # CHECK: ori    $1, $1, 1         # encoding: [0x34,0x21,0x00,0x01]
                      # CHECK: daddu  $6, $1, $6        # encoding: [0x00,0x26,0x30,0x2d]
la $6, 0x00010002($6) # CHECK: lui    $1, 1             # encoding: [0x3c,0x01,0x00,0x01]
                      # CHECK: ori    $1, $1, 2         # encoding: [0x34,0x21,0x00,0x02]
                      # CHECK: daddu  $6, $1, $6        # encoding: [0x00,0x26,0x30,0x2d]
la $6, 0x00020002($6) # CHECK: lui    $1, 2             # encoding: [0x3c,0x01,0x00,0x02]
                      # CHECK: ori    $1, $1, 2         # encoding: [0x34,0x21,0x00,0x02]
                      # CHECK: daddu  $6, $1, $6        # encoding: [0x00,0x26,0x30,0x2d]
la $6, 0x40000002($6) # CHECK: lui    $1, 16384         # encoding: [0x3c,0x01,0x40,0x00]
                      # CHECK: ori    $1, $1, 2         # encoding: [0x34,0x21,0x00,0x02]
                      # CHECK: daddu  $6, $1, $6        # encoding: [0x00,0x26,0x30,0x2d]
la $6, 0x80000002($6) # CHECK: ori    $1, $zero, 32768  # encoding: [0x34,0x01,0x80,0x00]
                      # CHECK: dsll   $1, $1, 16        # encoding: [0x00,0x01,0x0c,0x38]
                      # CHECK: ori    $1, $1, 2         # encoding: [0x34,0x21,0x00,0x02]
                      # CHECK: daddu  $6, $1, $6        # encoding: [0x00,0x26,0x30,0x2d]
la $6, 0x00014000($6) # CHECK: lui    $1, 1             # encoding: [0x3c,0x01,0x00,0x01]
                      # CHECK: ori    $1, $1, 16384     # encoding: [0x34,0x21,0x40,0x00]
                      # CHECK: daddu  $6, $1, $6        # encoding: [0x00,0x26,0x30,0x2d]
la $6, 0x00024000($6) # CHECK: lui    $1, 2             # encoding: [0x3c,0x01,0x00,0x02]
                      # CHECK: ori    $1, $1, 16384     # encoding: [0x34,0x21,0x40,0x00]
                      # CHECK: daddu  $6, $1, $6        # encoding: [0x00,0x26,0x30,0x2d]
la $6, 0x40004000($6) # CHECK: lui    $1, 16384         # encoding: [0x3c,0x01,0x40,0x00]
                      # CHECK: ori    $1, $1, 16384     # encoding: [0x34,0x21,0x40,0x00]
                      # CHECK: daddu  $6, $1, $6        # encoding: [0x00,0x26,0x30,0x2d]
la $6, 0x80004000($6) # CHECK: ori    $1, $zero, 32768  # encoding: [0x34,0x01,0x80,0x00]
                      # CHECK: dsll   $1, $1, 16        # encoding: [0x00,0x01,0x0c,0x38]
                      # CHECK: ori    $1, $1, 16384     # encoding: [0x34,0x21,0x40,0x00]
                      # CHECK: daddu  $6, $1, $6        # encoding: [0x00,0x26,0x30,0x2d]
la $6, 0x00018000($6) # CHECK: lui    $1, 1             # encoding: [0x3c,0x01,0x00,0x01]
                      # CHECK: ori    $1, $1, 32768     # encoding: [0x34,0x21,0x80,0x00]
                      # CHECK: daddu  $6, $1, $6        # encoding: [0x00,0x26,0x30,0x2d]
la $6, 0x00028000($6) # CHECK: lui    $1, 2             # encoding: [0x3c,0x01,0x00,0x02]
                      # CHECK: ori    $1, $1, 32768     # encoding: [0x34,0x21,0x80,0x00]
                      # CHECK: daddu  $6, $1, $6        # encoding: [0x00,0x26,0x30,0x2d]
la $6, 0x40008000($6) # CHECK: lui    $1, 16384         # encoding: [0x3c,0x01,0x40,0x00]
                      # CHECK: ori    $1, $1, 32768     # encoding: [0x34,0x21,0x80,0x00]
                      # CHECK: daddu  $6, $1, $6        # encoding: [0x00,0x26,0x30,0x2d]
la $6, 0x80008000($6) # CHECK: ori    $1, $zero, 32768  # encoding: [0x34,0x01,0x80,0x00]
                      # CHECK: dsll   $1, $1, 16        # encoding: [0x00,0x01,0x0c,0x38]
                      # CHECK: ori    $1, $1, 32768     # encoding: [0x34,0x21,0x80,0x00]
                      # CHECK: daddu  $6, $1, $6        # encoding: [0x00,0x26,0x30,0x2d]
la $6, 0xffff4000($6) # CHECK: ori    $1, $zero, 65535  # encoding: [0x34,0x01,0xff,0xff]
                      # CHECK: dsll   $1, $1, 16        # encoding: [0x00,0x01,0x0c,0x38]
                      # CHECK: ori    $1, $1, 16384     # encoding: [0x34,0x21,0x40,0x00]
                      # CHECK: daddu  $6, $1, $6        # encoding: [0x00,0x26,0x30,0x2d]
la $6, 0xfffe8000($6) # CHECK: ori    $1, $zero, 65534  # encoding: [0x34,0x01,0xff,0xfe]
                      # CHECK: dsll   $1, $1, 16        # encoding: [0x00,0x01,0x0c,0x38]
                      # CHECK: ori    $1, $1, 32768     # encoding: [0x34,0x21,0x80,0x00]
                      # CHECK: daddu  $6, $1, $6        # encoding: [0x00,0x26,0x30,0x2d]
la $6, 0xc0008000($6) # CHECK: ori    $1, $zero, 49152  # encoding: [0x34,0x01,0xc0,0x00]
                      # CHECK: dsll   $1, $1, 16        # encoding: [0x00,0x01,0x0c,0x38]
                      # CHECK: ori    $1, $1, 32768     # encoding: [0x34,0x21,0x80,0x00]
                      # CHECK: daddu  $6, $1, $6        # encoding: [0x00,0x26,0x30,0x2d]
la $6, 0x80008000($6) # CHECK: ori    $1, $zero, 32768  # encoding: [0x34,0x01,0x80,0x00]
                      # CHECK: dsll   $1, $1, 16        # encoding: [0x00,0x01,0x0c,0x38]
                      # CHECK: ori    $1, $1, 32768     # encoding: [0x34,0x21,0x80,0x00]
                      # CHECK: daddu  $6, $1, $6        # encoding: [0x00,0x26,0x30,0x2d]

symbol:               # CHECK-LABEL: symbol:
.extern extern_sym
.option pic0

la $5, extern_sym

# CHECK:  lui     $5, %highest(extern_sym)    # encoding: [0x3c,0x05,A,A]
# CHECK:                                      #   fixup A - offset: 0, value: %highest(extern_sym), kind: fixup_Mips_HIGHEST
# CHECK:  lui     $1, %hi(extern_sym)         # encoding: [0x3c,0x01,A,A]
# CHECK:                                      #   fixup A - offset: 0, value: %hi(extern_sym), kind: fixup_Mips_HI16
# CHECK:  daddiu  $5, $5, %higher(extern_sym) # encoding: [0x64,0xa5,A,A]
# CHECK:                                      #   fixup A - offset: 0, value: %higher(extern_sym), kind: fixup_Mips_HIGHER
# CHECK:  daddiu  $1, $1, %lo(extern_sym)     # encoding: [0x64,0x21,A,A]
# CHECK:                                      #   fixup A - offset: 0, value: %lo(extern_sym), kind: fixup_Mips_LO16
# CHECK:  dsll32  $5, $5, 0                   # encoding: [0x00,0x05,0x28,0x3c]
# CHECK:  daddu   $5, $5, $1                  # encoding: [0x00,0xa1,0x28,0x2d]

la $5, extern_sym($8)

# CHECK:   lui     $5, %highest(extern_sym)     # encoding: [0x3c,0x05,A,A]
# CHECK:                                        #   fixup A - offset: 0, value: %highest(extern_sym), kind: fixup_Mips_HIGHEST
# CHECK:   lui     $1, %hi(extern_sym)          # encoding: [0x3c,0x01,A,A]
# CHECK:                                        #   fixup A - offset: 0, value: %hi(extern_sym), kind: fixup_Mips_HI16
# CHECK:   daddiu  $5, $5, %higher(extern_sym)  # encoding: [0x64,0xa5,A,A]
# CHECK:                                        #   fixup A - offset: 0, value: %higher(extern_sym), kind: fixup_Mips_HIGHER
# CHECK:   daddiu  $1, $1, %lo(extern_sym)      # encoding: [0x64,0x21,A,A]
# CHECK:                                        #   fixup A - offset: 0, value: %lo(extern_sym), kind: fixup_Mips_LO16
# CHECK:   dsll32  $5, $5, 0                    # encoding: [0x00,0x05,0x28,0x3c]
# CHECK:   daddu   $5, $5, $1                   # encoding: [0x00,0xa1,0x28,0x2d]
# CHECK:   daddu   $5, $5, $8                   # encoding: [0x00,0xa8,0x28,0x2d]

la $5, extern_sym($5)

# CHECK:   lui     $1, %highest(extern_sym)     # encoding: [0x3c,0x01,A,A]
# CHECK:                                        #   fixup A - offset: 0, value: %highest(extern_sym), kind: fixup_Mips_HIGHEST
# CHECK:   daddiu  $1, $1, %higher(extern_sym)  # encoding: [0x64,0x21,A,A]
# CHECK:                                        #   fixup A - offset: 0, value: %higher(extern_sym), kind: fixup_Mips_HIGHER
# CHECK:   dsll    $1, $1, 16                   # encoding: [0x00,0x01,0x0c,0x38]
# CHECK:   daddiu  $1, $1, %hi(extern_sym)      # encoding: [0x64,0x21,A,A]
# CHECK:                                        #   fixup A - offset: 0, value: %hi(extern_sym), kind: fixup_Mips_HI16
# CHECK:   dsll    $1, $1, 16                   # encoding: [0x00,0x01,0x0c,0x38]
# CHECK:   daddiu  $1, $1, %lo(extern_sym)      # encoding: [0x64,0x21,A,A]
# CHECK:                                        #   fixup A - offset: 0, value: %lo(extern_sym), kind: fixup_Mips_LO16
# CHECK:   daddu   $5, $1, $5                   # encoding: [0x00,0x25,0x28,0x2d]

la $5, extern_sym+8

# CHECK:   lui     $5, %highest(extern_sym+8)     # encoding: [0x3c,0x05,A,A]
# CHECK:                                          #   fixup A - offset: 0, value: %highest(extern_sym+8), kind: fixup_Mips_HIGHEST
# CHECK:   lui     $1, %hi(extern_sym+8)          # encoding: [0x3c,0x01,A,A]
# CHECK:                                          #   fixup A - offset: 0, value: %hi(extern_sym+8), kind: fixup_Mips_HI16
# CHECK:   daddiu  $5, $5, %higher(extern_sym+8)  # encoding: [0x64,0xa5,A,A]
# CHECK:                                          #   fixup A - offset: 0, value: %higher(extern_sym+8), kind: fixup_Mips_HIGHER
# CHECK:   daddiu  $1, $1, %lo(extern_sym+8)      # encoding: [0x64,0x21,A,A]
# CHECK:                                          #   fixup A - offset: 0, value: %lo(extern_sym+8), kind: fixup_Mips_LO16
# CHECK:   dsll32  $5, $5, 0                      # encoding: [0x00,0x05,0x28,0x3c]
# CHECK:   daddu   $5, $5, $1                     # encoding: [0x00,0xa1,0x28,0x2d]


la $5, extern_sym+8($8)

# CHECK:   lui     $5, %highest(extern_sym+8)     # encoding: [0x3c,0x05,A,A]
# CHECK:                                          #   fixup A - offset: 0, value: %highest(extern_sym+8), kind: fixup_Mips_HIGHEST
# CHECK:   lui     $1, %hi(extern_sym+8)          # encoding: [0x3c,0x01,A,A]
# CHECK:                                          #   fixup A - offset: 0, value: %hi(extern_sym+8), kind: fixup_Mips_HI16
# CHECK:   daddiu  $5, $5, %higher(extern_sym+8)  # encoding: [0x64,0xa5,A,A]
# CHECK:                                          #   fixup A - offset: 0, value: %higher(extern_sym+8), kind: fixup_Mips_HIGHER
# CHECK:   daddiu  $1, $1, %lo(extern_sym+8)      # encoding: [0x64,0x21,A,A]
# CHECK:                                          #   fixup A - offset: 0, value: %lo(extern_sym+8), kind: fixup_Mips_LO16
# CHECK:   dsll32  $5, $5, 0                      # encoding: [0x00,0x05,0x28,0x3c]
# CHECK:   daddu   $5, $5, $1                     # encoding: [0x00,0xa1,0x28,0x2d]
# CHECK:   daddu   $5, $5, $8                     # encoding: [0x00,0xa8,0x28,0x2d]

la $5, extern_sym-8($5)

# CHECK:   lui     $1, %highest(extern_sym-8)     # encoding: [0x3c,0x01,A,A]
# CHECK:                                          #   fixup A - offset: 0, value: %highest(extern_sym-8), kind: fixup_Mips_HIGHEST
# CHECK:   daddiu  $1, $1, %higher(extern_sym-8)  # encoding: [0x64,0x21,A,A]
# CHECK:                                          #   fixup A - offset: 0, value: %higher(extern_sym-8), kind: fixup_Mips_HIGHER
# CHECK:   dsll    $1, $1, 16                     # encoding: [0x00,0x01,0x0c,0x38]
# CHECK:   daddiu  $1, $1, %hi(extern_sym-8)      # encoding: [0x64,0x21,A,A]
# CHECK:                                          #   fixup A - offset: 0, value: %hi(extern_sym-8), kind: fixup_Mips_HI16
# CHECK:   dsll    $1, $1, 16                     # encoding: [0x00,0x01,0x0c,0x38]
# CHECK:   daddiu  $1, $1, %lo(extern_sym-8)      # encoding: [0x64,0x21,A,A]
# CHECK:                                          #   fixup A - offset: 0, value: %lo(extern_sym-8), kind: fixup_Mips_LO16
# CHECK:   daddu   $5, $1, $5                     # encoding: [0x00,0x25,0x28,0x2d]

la $5, extern_sym-8

# CHECK:   lui     $5, %highest(extern_sym-8)     # encoding: [0x3c,0x05,A,A]
# CHECK:                                          #   fixup A - offset: 0, value: %highest(extern_sym-8), kind: fixup_Mips_HIGHEST
# CHECK:   lui     $1, %hi(extern_sym-8)          # encoding: [0x3c,0x01,A,A]
# CHECK:                                          #   fixup A - offset: 0, value: %hi(extern_sym-8), kind: fixup_Mips_HI16
# CHECK:   daddiu  $5, $5, %higher(extern_sym-8)  # encoding: [0x64,0xa5,A,A]
# CHECK:                                          #   fixup A - offset: 0, value: %higher(extern_sym-8), kind: fixup_Mips_HIGHER
# CHECK:   daddiu  $1, $1, %lo(extern_sym-8)      # encoding: [0x64,0x21,A,A]
# CHECK:                                          #   fixup A - offset: 0, value: %lo(extern_sym-8), kind: fixup_Mips_LO16
# CHECK:   dsll32  $5, $5, 0                      # encoding: [0x00,0x05,0x28,0x3c]
# CHECK:   daddu   $5, $5, $1                     # encoding: [0x00,0xa1,0x28,0x2d]

la $5, extern_sym-8($8)

# CHECK:   lui     $5, %highest(extern_sym-8)     # encoding: [0x3c,0x05,A,A]
# CHECK:                                          #   fixup A - offset: 0, value: %highest(extern_sym-8), kind: fixup_Mips_HIGHEST
# CHECK:   lui     $1, %hi(extern_sym-8)          # encoding: [0x3c,0x01,A,A]
# CHECK:                                          #   fixup A - offset: 0, value: %hi(extern_sym-8), kind: fixup_Mips_HI16
# CHECK:   daddiu  $5, $5, %higher(extern_sym-8)  # encoding: [0x64,0xa5,A,A]
# CHECK:                                          #   fixup A - offset: 0, value: %higher(extern_sym-8), kind: fixup_Mips_HIGHER
# CHECK:   daddiu  $1, $1, %lo(extern_sym-8)      # encoding: [0x64,0x21,A,A]
# CHECK:                                          #   fixup A - offset: 0, value: %lo(extern_sym-8), kind: fixup_Mips_LO16
# CHECK:   dsll32  $5, $5, 0                      # encoding: [0x00,0x05,0x28,0x3c]
# CHECK:   daddu   $5, $5, $1                     # encoding: [0x00,0xa1,0x28,0x2d]
# CHECK:   daddu   $5, $5, $8                     # encoding: [0x00,0xa8,0x28,0x2d]

la $5, extern_sym-8($5)

# CHECK:   lui     $1, %highest(extern_sym-8)     # encoding: [0x3c,0x01,A,A]
# CHECK:                                          #   fixup A - offset: 0, value: %highest(extern_sym-8), kind: fixup_Mips_HIGHEST
# CHECK:   daddiu  $1, $1, %higher(extern_sym-8)  # encoding: [0x64,0x21,A,A]
# CHECK:                                          #   fixup A - offset: 0, value: %higher(extern_sym-8), kind: fixup_Mips_HIGHER
# CHECK:   dsll    $1, $1, 16                     # encoding: [0x00,0x01,0x0c,0x38]
# CHECK:   daddiu  $1, $1, %hi(extern_sym-8)      # encoding: [0x64,0x21,A,A]
# CHECK:                                          #   fixup A - offset: 0, value: %hi(extern_sym-8), kind: fixup_Mips_HI16
# CHECK:   dsll    $1, $1, 16                     # encoding: [0x00,0x01,0x0c,0x38]
# CHECK:   daddiu  $1, $1, %lo(extern_sym-8)      # encoding: [0x64,0x21,A,A]
# CHECK:                                          #   fixup A - offset: 0, value: %lo(extern_sym-8), kind: fixup_Mips_LO16
# CHECK:   daddu   $5, $1, $5                     # encoding: [0x00,0x25,0x28,0x2d]