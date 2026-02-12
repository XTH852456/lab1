# os/src/entry.asm
.section .text.entry  # 将后续内容放到 .text.entry 段（优先执行）
.globl _start         # 声明 _start 为全局符号，作为内核入口

_start:               # 内核入口符号
    li x1, 100        # 核心指令：将立即数 100 加载到寄存器 x1
    loop: j loop      # 新增：无限循环（避免指令执行完后崩溃，文档里没提但必须加）