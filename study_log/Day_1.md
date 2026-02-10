#事件一：阅读实验第一章 第二小节
使用 cargo new os --bin 创建一个可执行文件  其中 值得注意的是 --bin  告诉 cargo os为可执行文件
在
os
├── Cargo.toml
└── src
    └── main.rs 
的文件结构之下 .toml后缀文件为项目配置文件。
    无论用户使用何种编写方法 直接或间接的使用系统调用是极难避免的 ----->系统调用充当用户与系统内核之间的媒介。同是应注意，内核不仅提供系统调用的借口，还要对用户态软件的执行进行监控管理。
Rust通过使用目标三元组（CPU·操作系统·运行时库）控制Rust编译器可执行那个代码的生成
#事件二：第一章节第二小节 ----移除标准依赖库  添加能够支持应用的裸机级别的库操作系统（LibOS）
使用 rustup target add riscv64gc-unknown-none-elf 为  rustc 添加 target：riscv64gc-unknown-none-elf
随后在os/.cargo/config 中输入# os/.cargo/config
			    [build]
			    target = "riscv64gc-unknown-none-elf"
后，会默认使用riscv64gc作为平台而并非是原来的x86_64-unknown-linux-gnu。    （交叉编译）
具体的操作细节见os文件中。操作过程中发现对rust的理解还是不够，编译器的执行流程了解不够细致，代码编写熟练度还不够。
#计划：
尽量在1.11当天完成第一章节的实验部分
