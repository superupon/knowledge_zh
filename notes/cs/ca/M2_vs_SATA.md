# M.2 与 SATA 的区别

- 接口形态：SATA 用 7 针数据线 + 15 针供电线；M.2 是主板插槽（常见 key M 或 B+M），直接插卡无需线缆。
- 协议带宽：SATA 固定走 SATA 协议，最高 6 Gbps，实际 ~550 MB/s；M.2 可走 SATA 或 PCIe（常见 NVMe，x2/x4），PCIe 3.0 x4 理论 ~32 Gbps，PCIe 4.0 更高。
- 外观尺寸：SATA SSD 多为 2.5 英寸；M.2 是条形板卡，常见 2280（22mm×80mm）。
- 兼容性：SATA 口只接 SATA 盘；M.2 槽取决于主板支持的协议和 key 位——有的只支持 SATA，有的支持 NVMe，有的两者都行。
- 供电与线材：SATA 需要数据线与供电线；M.2 通过插槽直接供电。
- 性能与用途：同代产品下 NVMe（M.2 PCIe）远快于 SATA；SATA 仍适合机械硬盘或成本敏感的 SSD。

## Backlink
