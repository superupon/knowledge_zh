# 第一章 开始

## 1.1 安装

* 安装命令

```bash
$ curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
```

* 查看版本

```bash
rustc --version
```

* 更新以及卸载

```bash
rustup update
rustup self uninstall
```

## 1.2 Hello World

Rust的文件都是以.rs为扩展名. 如果多个单词，那么用下划线连接。

```rust
fn main() {
    println!("Hello, world!");
}
```