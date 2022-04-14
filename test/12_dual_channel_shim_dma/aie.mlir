// (c) Copyright 2020 Xilinx Inc. All Rights Reserved.

module {
  %t70 = AIE.tile(7, 0)
  %t72 = AIE.tile(7, 2)
  %t74 = AIE.tile(7, 4)

  AIE.flow(%t70, "DMA" : 0, %t72, "DMA" : 0)
  AIE.flow(%t72, "DMA" : 0, %t70, "DMA" : 0)
  AIE.flow(%t70, "DMA" : 1, %t74, "DMA" : 0)
  AIE.flow(%t74, "DMA" : 0, %t70, "DMA" : 1)

  %buf72_0 = AIE.buffer(%t72) {sym_name = "buf72_0"} : memref<32xi32>
  %buf74_0 = AIE.buffer(%t74) {sym_name = "buf74_0"}: memref<32xi32>

  %l72_0 = AIE.lock(%t72, 0)
  %l74_0 = AIE.lock(%t74, 0)

  %m72 = AIE.mem(%t72) {
      %srcDma = AIE.dmaStart("S2MM0", ^bd0, ^dma0)
    ^dma0:
      %dstDma = AIE.dmaStart("MM2S0", ^bd2, ^end)
    ^bd0:
      AIE.useLock(%l72_0, "Acquire", 0)
      AIE.dmaBd(<%buf72_0 : memref<32xi32>, 0, 32>, 0)
      AIE.useLock(%l72_0, "Release", 1)
      cf.br ^bd0
    ^bd2:
      AIE.useLock(%l72_0, "Acquire", 1)
      AIE.dmaBd(<%buf72_0 : memref<32xi32>, 0, 32>, 0)
      AIE.useLock(%l72_0, "Release", 0)
      cf.br ^bd2
    ^end:
      AIE.end
  }

  %m74 = AIE.mem(%t74) {
      %srcDma = AIE.dmaStart("S2MM0", ^bd0, ^dma0)
    ^dma0:
      %dstDma = AIE.dmaStart("MM2S0", ^bd2, ^end)
    ^bd0:
      AIE.useLock(%l74_0, "Acquire", 0)
      AIE.dmaBd(<%buf74_0 : memref<32xi32>, 0, 32>, 0)
      AIE.useLock(%l74_0, "Release", 1)
      cf.br ^bd0
    ^bd2:
      AIE.useLock(%l74_0, "Acquire", 1)
      AIE.dmaBd(<%buf74_0 : memref<32xi32>, 0, 32>, 0)
      AIE.useLock(%l74_0, "Release", 0)
      cf.br ^bd2
    ^end:
      AIE.end
  }

}
