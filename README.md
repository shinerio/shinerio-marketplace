# 🧠 Overview

![mindmap](https://shinerio.oss-cn-beijing.aliyuncs.com/blog_images/README_2026_02_24_223800.png)

# ✨ Shinerio Claude Code Plugin

一个为 Claude Code 设计的功能增强插件，致力于提升开发效率和文档可视化能力。

## 🚀 主要功能

### 1. 🧠 Markmap 思维导图集成
通过此插件，你可以轻松地将 Markdown 文档转换为美观的思维导图。
- **自动生成**：利用 `markmap-mcp-server` 引擎生成思维导图。
- **视觉转换**：自动将生成的思维导图转为图片（PNG）。
- **图片上传**：内置 PicGO 客户端支持，自动上传图片到图床。
- **文档嵌入**：将生成的思维导图链接自动插入到 Markdown 文档末尾。

### 2. 🧪 自动化测试运行与分析 (Test Case Executor)
一个专门的 Agent 角色，用于在不修改代码的前提下，执行测试用例并深度分析失败原因。
- **自动执行**：一键运行项目中的测试套件。
- **深度分析**：针对每一个失败的测试用例，从断言失败、异常信息到环境因素进行全方位分析。
- **修复建议**：提供切实可行的修复建议（不直接修改代码，保证安全）。

### 4. 🗺️ Draw.io 图表分析 (Drawio Diagram Analyst)
一个专门的 Agent 角色，用于解析 Draw.io 文件并将其转换为结构化的文字描述。
- **智能解析**：读取 `.drawio` / `.xml` 文件的原始 XML 结构，识别所有形状、连接器、标签、分组和泳道。
- **架构提取**：识别系统架构、工作流序列、数据关系并生成可读的文字模型。
- **多图表类型**：支持架构图、流程图、时序图、ER 图、思维导图等多种图表类型。
- **图表操作**：集成 `@next-ai-drawio/mcp-server`，可直接启动会话、获取和分析图表内容。

### 3. 🔁 Git 一键提交推送 (GitACP)
通过 `/gitacp` 命令，结合对话上下文与 `git diff` 自动生成提交摘要，完成从暂存到推送的全流程。
- **智能摘要**：综合分析 git diff 实际变更和对话上下文，自动生成提交标题与摘要。
- **Changelog 备份**：按月自动写入 `changelog/change_YYYYMM.md`，沉淀变更记录。
- **全流程自动化**：一条命令完成 `git add -A` → `git commit` → `git push`。

---

## 📦 安装指南

### 方式一：一键安装（推荐） ⚡

在 Claude Code 对话中执行以下 slash 命令即可完成安装，**无需每次启动指定 `--plugin-dir`**：

```
/plugin marketplace add shinerio/shinerio-marketplace
/plugin install shinerio-code-plugin@shinerio-marketplace
/plugin install shinerio-note-plugin@shinerio-marketplace
```

安装完成后，直接启动 Claude Code 即可使用：
```bash
claude
```

### 方式二：🏗️ 本地插件目录调试（开发者模式）

适用于开发阶段临时调试，每次启动需要指定插件目录：
```bash
git clone https://github.com/shinerio/shinerio-marketplace.git
claude --plugin-dir ./shinerio-marketplace
```

---

## ⚙️ 环境配置

### 前置依赖（需手动安装）

| 依赖 | 用途 | 安装方式 |
|------|------|----------|
| [Node.js](https://nodejs.org/) | MCP 服务器运行环境（提供 `npx` 命令） | 从官网下载安装 |
| [Python 3](https://www.python.org/) + `requests` 库 | PicGO 图片上传脚本 | `pip install requests` |
| [PicGO](https://github.com/Molunerfinn/PicGo/releases) | 图床客户端，用于上传思维导图图片 | 下载桌面客户端，启用 HTTP 服务器（默认端口 36677） |

### 自动配置（插件自带，无需手动操作）

| 组件 | 说明 |
|------|------|
| MCP 服务器 | `markmap-mcp-server` 和 `chrome-devtools` 随插件自动注册 |
| 自定义命令 | `/shinerio-code-plugin:gitacp` 命令随插件自动加载 |

---

## 🛠 使用说明

### 🎨 生成思维导图
在对话中对 Claude 说：
- "帮我给这个 markdown 文档生成一个思维导图。"
- "Generate a mindmap for this README."

插件会自动调用相关技能：生成 HTML -> 截图 PNG -> 上传图床 -> 嵌入文档。

### 🔍 执行测试分析
在需要调试测试用例时，可以显式调用 `test-case-executor`：
- "@test-case-executor 运行并分析当前的单元测试。"
- "帮我分析一下为什么这个测试用例失败了。"

### 🗺️ 分析 Draw.io 图表
需要理解 Draw.io 文件内容时，调用 `drawio-diagram-analyst`：
- "@drawio-diagram-analyst 帮我分析这个架构图。"
- "I have this architecture.drawio file — can you help me understand what's going on in it?"

### 🔁 一键提交推送
在完成功能开发后，执行 slash 命令自动完成提交：
```
/gitacp
```
插件会自动运行 `git diff`，结合当前对话上下文生成提交摘要，写入 changelog 并推送到远程仓库。

---

## 🛠️ 插件管理

### 📋 查看已安装的插件
```
/plugin
```

### 🔄 更新插件

更新 marketplace 下所有已安装插件到最新版本：

**方式一：在对话中使用 slash 命令**
```
/plugin marketplace update shinerio-marketplace
```

**方式二：使用 CLI 命令（无需进入对话）**
```bash
claude plugin marketplace update shinerio-marketplace
```

**方式三：开启自动更新**

在对话中输入 `/plugin` → 选择 **Marketplaces** → 选择 `shinerio-marketplace` → **Enable auto-update**。

> 💡 如果关闭了全局自动更新，仍可单独强制启用插件自动更新：
> ```bash
> export FORCE_AUTOUPDATE_PLUGINS=true
> ```

### 🚫 禁用 / 启用插件
```
/plugin disable shinerio-code-plugin@shinerio-marketplace
/plugin disable shinerio-note-plugin@shinerio-marketplace
/plugin enable  shinerio-code-plugin@shinerio-marketplace
/plugin enable shinerio-note-plugin@shinerio-marketplace
```

### 🗑️ 卸载插件
```
/plugin uninstall shinerio-note-plugin@shinerio-marketplace
/plugin uninstall shinerio-code-plugin@shinerio-marketplace
```

---

## 📂 插件结构

```
shinerio-plugin/
├── .claude-plugin/
│   └── marketplace.json           # Marketplace 定义（支持一键安装）
├── plugins/
│   ├── shinerio-code-plugin/
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json        # 插件元数据
│   │   ├── agents/
│   │   │   └── test-case-executor.md  # 测试执行 Agent
│   │   └── commands/
│   │       └── gitacp.md          # 快捷命令（/shinerio-code-plugin:gitacp）
│   └── shinerio-note-plugin/
│       ├── .mcp.json                      # 插件自带 MCP 服务器配置
│       ├── .claude-plugin/
│       │   └── plugin.json        # 插件元数据
│       ├── agents/
│       │   └── drawio-diagram-analyst.md  # Draw.io 图表分析 Agent
│       └── skills/
│           └── embed-mindmap/
│               ├── SKILL.md       # Markmap 技能定义
│               ├── README.md      # 技能说明文档
│               └── scripts/
│                   └── picgo_client.py  # 图片上传脚本
└── README.md
```

## 📄 开源协议
[MIT License](LICENSE)