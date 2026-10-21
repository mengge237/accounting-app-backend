# 数据库归档（accountingapp）

- 来源：本机 MySQL 8.0.44 上的旧库 `accountingapp`，2026-10-21 导出后已从实例里删除
- 导出命令：

```
mysqldump --single-transaction --routines --triggers \
  --default-character-set=utf8mb4 --databases accountingapp > 20261021-accountingapp.sql
```

- 文件：`20261021-accountingapp.sql`（38198 字节）
- 源文件 sha256：`c399e422adc9f5bfa96ffc0cc3c9e374165657a8fc16bfa3154773eb50e1024c`
- 已做回灌验证（导进临时库比表数与关键表行数一致）
