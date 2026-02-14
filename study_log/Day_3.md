#事件一 根据文档准备环境 
oslab@oslab-virtual-machine:~/lab/lab1$ rustc --version
rustc 1.93.1 (01f6ddf75 2026-02-11)
oslab@oslab-virtual-machine:~/lab/lab1$ cargo --version
cargo 1.93.1 (083ac5135 2025-12-15)
oslab@oslab-virtual-machine:~/lab/lab1$ rustup target add riscv64gc-unknown-none-elf
info: component 'rust-std' for target 'riscv64gc-unknown-none-elf' is up to date
oslab@oslab-virtual-machine:~/lab/lab1$ sudo apt update
sudo apt install qemu-system-misc
[sudo] oslab 的密码： 
获取:1 http://security.ubuntu.com/ubuntu jammy-security InRelease [129 kB]
获取:2 http://security.ubuntu.com/ubuntu jammy-security/main amd64 DEP-11 Metadata [54.5 kB]
获取:3 http://security.ubuntu.com/ubuntu jammy-security/restricted amd64 DEP-11 Metadata [208 B]
获取:4 http://security.ubuntu.com/ubuntu jammy-security/universe amd64 DEP-11 Metadata [126 kB]
获取:5 http://security.ubuntu.com/ubuntu jammy-security/multiverse amd64 DEP-11 Metadata [208 B]              
命中:6 http://mirrors.tuna.tsinghua.edu.cn/ubuntu jammy InRelease                                                                                                                                                                                
命中:7 http://mirrors.tuna.tsinghua.edu.cn/ubuntu jammy-updates InRelease                                                                                                                                                                        
命中:8 http://mirrors.tuna.tsinghua.edu.cn/ubuntu jammy-backports InRelease                                                                                                                                                                      
已下载 309 kB，耗时 11秒 (28.9 kB/s)                                                                                                                                                                                                             
正在读取软件包列表... 完成
正在分析软件包的依赖关系树... 完成
正在读取状态信息... 完成
有 613 个软件包可以升级。请执行 ‘apt list --upgradable’ 来查看它们。
正在读取软件包列表... 完成
正在分析软件包的依赖关系树... 完成
正在读取状态信息... 完成
qemu-system-misc 已经是最新版 (1:6.2+dfsg-2ubuntu6.27)。
升级了 0 个软件包，新安装了 0 个软件包，要卸载 0 个软件包，有 613 个软件包未被升级。
oslab@oslab-virtual-machine:~/lab/lab1$ qemu-system-riscv64 --version
QEMU emulator version 6.2.0 (Debian 1:6.2+dfsg-2ubuntu6.27)
Copyright (c) 2003-2021 Fabrice Bellard and the QEMU Project developers
oslab@oslab-virtual-machine:~/lab/lab1$ cargo install cargo-clone
    Updating crates.io index
     Ignored package `cargo-clone v1.2.4` is already installed, use --force to override
oslab@oslab-virtual-machine:~/lab/lab1$ cargo install cargo-binutils
    Updating crates.io index
     Ignored package `cargo-binutils v0.4.0` is already installed, use --force to override
     在没有出现意外的情况下，终端显示到此为止我们的环境已经完成了所有的基本配置的检验。
#事件二 实验的编译与运行
输入cargo build后 build.rs会自动完成的工作如下：
    .1生成链接脚本：使用 tg_linker::NOBIOS_SCRIPT 生成内核的内存布局
    .2下载用户程序：自动通过 cargo clone 获取 tg-user crate（包含用户测试程序）
    .3编译用户程序：根据 cases.toml 中的 ch3 或 ch3_exercise 配置，为每个用户程序交叉编译
    .4生成 APP_ASM：生成汇编文件，将所有用户程序的二进制数据内联到内核镜像中
使用cargo run启动抢占式调度的默认模式

