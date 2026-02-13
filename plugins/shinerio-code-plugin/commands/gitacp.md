---
description: 分析对话上下文生成提交摘要，备份changelog，执行git add、commit、push
---

# GitACP - Git Add Commit Push 自动化命令

此命令将执行以下操作：
1. 分析当前对话上下文，生成修改内容摘要`{{generated_summary}}`，和一句简单的修改主题`{{generated_title}}`，然后按以下格式写入changelog和git commit中
  ```
  ## {{generated_tile}}
  date: YYYY-MM-DD
  {{generated_summary}}
  ```
2. changelog备份地址为changelog/change_YYYYMM.md（每个月生成一个change log）。如果文件不存在，则按命名要求创建。
3. 执行 `git add -A`
4. 执行 `git commit -m`
5. 执行 `git push` 推送到远程仓库
