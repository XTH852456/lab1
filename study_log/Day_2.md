#事件二 完成第二章的环境准备工作
根据文档提示在ch2目录下执行cargo build进行编译后，使用cargo run运行，
（
实际执行的 QEMU 命令等价于：

qemu-system-riscv64 \
    -machine virt \
    -nographic \
    -bios none \
    -kernel target/riscv64gc-unknown-none-elf/debug/tg-ch2

）
得到结果如下。
  ______                       __
  / ____/___  ____  _________  / /__
 / /   / __ \/ __ \/ ___/ __ \/ / _ \
/ /___/ /_/ / / / (__  ) /_/ / /  __/
\____/\____/_/ /_/____/\____/_/\___/
====================================
[TRACE] LOG TEST >> Hello, world!
[DEBUG] LOG TEST >> Hello, world!
[ INFO] LOG TEST >> Hello, world!
[ WARN] LOG TEST >> Hello, world!
[ERROR] LOG TEST >> Hello, world!

[ INFO] load app0 to 0x80400000
Hello, world from user mode program!
[ INFO] app0 exit with code 0

[ INFO] load app1 to 0x80400000
Into Test store_fault, we will insert an invalid store operation...
Kernel should kill this application!
[ERROR] app1 was killed because of Exception(StoreFault)

[ INFO] load app2 to 0x80400000
3^10000=5079(MOD 10007)
3^20000=8202(MOD 10007)
3^30000=8824(MOD 10007)
3^40000=5750(MOD 10007)
3^50000=3824(MOD 10007)
3^60000=8516(MOD 10007)
3^70000=2510(MOD 10007)
3^80000=9379(MOD 10007)
3^90000=2621(MOD 10007)
3^100000=2749(MOD 10007)
Test power OK!
[ INFO] app2 exit with code 0

[ INFO] load app3 to 0x80400000
Try to execute privileged instruction in U Mode
Kernel should kill this application!
[ERROR] app3 was killed because of Exception(IllegalInstruction)

[ INFO] load app4 to 0x80400000
Try to access privileged CSR in U Mode
Kernel should kill this application!
[ERROR] app4 was killed because of Exception(IllegalInstruction)

[ INFO] load app5 to 0x80400000
power_3 [10000/200000]
power_3 [20000/200000]
power_3 [30000/200000]
power_3 [40000/200000]
power_3 [50000/200000]
power_3 [60000/200000]
power_3 [70000/200000]
power_3 [80000/200000]
power_3 [90000/200000]
power_3 [100000/200000]
power_3 [110000/200000]
power_3 [120000/200000]
power_3 [130000/200000]
power_3 [140000/200000]
power_3 [150000/200000]
power_3 [160000/200000]
power_3 [170000/200000]
power_3 [180000/200000]
power_3 [190000/200000]
power_3 [200000/200000]
3^200000 = 871008973(MOD 998244353)
Test power_3 OK!
[ INFO] app5 exit with code 0

[ INFO] load app6 to 0x80400000
power_5 [10000/140000]
power_5 [20000/140000]
power_5 [30000/140000]
power_5 [40000/140000]
power_5 [50000/140000]
power_5 [60000/140000]
power_5 [70000/140000]
power_5 [80000/140000]
power_5 [90000/140000]
power_5 [100000/140000]
power_5 [110000/140000]
power_5 [120000/140000]
power_5 [130000/140000]
power_5 [140000/140000]
5^140000 = 386471875(MOD 998244353)
Test power_5 OK!
[ INFO] app6 exit with code 0

[ INFO] load app7 to 0x80400000
power_7 [10000/160000]
power_7 [20000/160000]
power_7 [30000/160000]
power_7 [40000/160000]
power_7 [50000/160000]
power_7 [60000/160000]
power_7 [70000/160000]
power_7 [80000/160000]
power_7 [90000/160000]
power_7 [100000/160000]
power_7 [110000/160000]
power_7 [120000/160000]
power_7 [130000/160000]
power_7 [140000/160000]
power_7 [150000/160000]
power_7 [160000/160000]
7^160000 = 667897727(MOD 998244353)
Test power_7 OK!
使用./test.sh检查tg-ch2内核是否通过基础测试，结果如下：
[PASS] found <Hello, world from user mode program!>
[PASS] found <Test power_3 OK!>
[PASS] found <Test power_5 OK!>
[PASS] found <Test power_7 OK!>
[PASS] not found <FAIL: T.T>

Test PASSED: 5/5

────────── 测试结果 ──────────
✓ ch2 基础测试通过
我们发现通过测试
#事件二  学习操作系统核心概念
.1 批处理操作系统
tg-ch2 实现的批处理系统工作流程：

内核启动
    │
    ▼
初始化（清零 BSS、初始化控制台和系统调用）
    │
    ▼
┌─→ 加载第 i 个用户程序
│       │
│       ▼
│   创建用户上下文（设置入口地址、用户栈、U-mode）
│       │
│       ▼
│   execute() → sret 切换到 U-mode 运行用户程序
│       │
│       ▼
│   用户程序触发 Trap（ecall 或异常）
│       │
│       ▼
│   内核处理 Trap（系统调用 / 杀死出错程序）
│       │
│       ├─ 系统调用 write → 输出数据，继续运行
│       ├─ 系统调用 exit  → 程序退出
│       └─ 异常            → 杀死程序
│       │
│       ▼
└── 加载下一个用户程序（i++）
        │
        ▼
    所有程序完成 → 关机
.2 RISC-V 特权级机制
特权级 	  	    缩写 		运行的软件 	能做什么
Machine Mode 	  M-mode 	SBI 固件 	访问所有硬件资源
Supervisor Mode   S-mode 	操作系统内核 	管理内存、处理 Trap
User Mode 	  U-mode 	用户程序 	仅能执行普通指令
.3 trap处理
Trap 是 CPU 从低特权级陷入高特权级的机制，触发原因包括：

    系统调用：用户程序执行 ecall 指令
    异常：非法指令、访存错误、页错误等
    中断：时钟中断、外部中断等
    Trap 处理流程：

用户程序执行 ecall
       │
       ▼
  ┌── 硬件自动完成 ──┐
  │ 1. sstatus.SPP ← U  │  （记录 Trap 前的特权级）
  │ 2. sepc ← ecall 地址  │  （记录 Trap 前的 PC）
  │ 3. scause ← 原因      │  （如 UserEnvCall）
  │ 4. PC ← stvec         │  （跳转到 Trap 入口）
  │ 5. 特权级 ← S-mode    │  （切换到内核态）
  └──────────────────────┘
       │
       ▼
  Trap 入口（__alltraps）
  ── 保存所有用户寄存器到内核栈（Trap 上下文）
  ── 跳转到 Rust 的 trap_handler
       │
       ▼
  trap_handler 处理
  ── 读取 scause 判断 Trap 类型
  ── 系统调用：处理后 sepc += 4（跳过 ecall 指令）
  ── 异常：杀死程序
       │
       ▼
  __restore
  ── 从内核栈恢复用户寄存器
  ── 执行 sret 返回 U-mode
       │
       ▼
  用户程序从 ecall 的下一条指令继续执行


