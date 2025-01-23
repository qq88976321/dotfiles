# Neovim Config

基於 [lazy.nvim](https://github.com/folke/lazy.nvim) 的現代化 Neovim 設定，以 VS Code 主題為基礎，整合 LSP、自動補全、格式化等常用功能。

## 系統需求

| 工具 | 最低版本 | 說明 |
|------|---------|------|
| Neovim | 0.9+ | 必須 |
| Git | 任意 | 用於安裝插件 |
| Node.js | 16+ | 用於 `prettier` 格式化 |
| Python | 3.8+ | 用於 `ruff` 格式化 |
| [Nerd Font](https://www.nerdfonts.com/) | 任意 | 用於圖示顯示（推薦 JetBrainsMono Nerd Font） |

選配工具：
- `stylua` — Lua 格式化（`cargo install stylua` 或 `brew install stylua`）
- `ruff` — Python 格式化（`pip install ruff`）
- `prettier` — JS/TS/CSS/HTML 格式化（`npm install -g prettier`）

## 安裝

```bash
# 備份既有設定（如有）
mv ~/.config/nvim ~/.config/nvim.bak

# 複製此設定（以 chezmoi 管理）
chezmoi apply

# 或直接複製到目標位置
cp -r . ~/.config/nvim
```

首次啟動 Neovim 時，lazy.nvim 會自動下載並安裝所有插件：

```bash
nvim
```

安裝完成後重啟 Neovim 即可。

### 格式化工具安裝

```bash
# Prettier
npm install -g prettier

# Ruff
pip install ruff

# Stylua
cargo install stylua
# 或
brew install stylua
```

## 目錄結構

```
nvim/
├── init.lua              # 入口：載入 settings、keymaps、lazy
├── lazy-lock.json        # 插件版本鎖定
└── lua/
    ├── config/
    │   ├── lazy.lua      # lazy.nvim 初始化、mapleader 設定
    │   ├── settings.lua  # 編輯器選項（行號、縮排、剪貼簿…）
    │   └── keymaps.lua   # 全局按鍵對應
    └── plugins/
        ├── autopairs.lua   # 自動括號配對
        ├── cmp.lua         # 自動補全（nvim-cmp + LuaSnip）
        ├── colorizer.lua   # 顏色碼即時預覽
        ├── extras.lua      # 其他輔助插件
        ├── formatter.lua   # 格式化（conform.nvim）
        ├── gitsigns.lua    # Git 差異顯示
        ├── lualine.lua     # 狀態列
        ├── neotree.lua     # 檔案樹
        ├── telescope.lua   # 模糊搜尋
        └── treesitter.lua  # 語法高亮與解析
```

## 插件列表

| 插件 | 功能 |
|------|------|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | 插件管理器 |
| [vscode.nvim](https://github.com/Mofiqul/vscode.nvim) | VS Code 配色方案 |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP 設定 |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | LSP/工具安裝管理 |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | 自動補全框架 |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | 程式碼片段 |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | 格式化 |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | 語法高亮 |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | 模糊搜尋 |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | 檔案樹 |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git 行差異 |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | 狀態列 |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | 自動括號 |
| [nvim-colorizer](https://github.com/norcalli/nvim-colorizer.lua) | 顏色碼預覽 |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | 按鍵提示 |
| [treesj](https://github.com/Wansmer/treesj) | 展開/合併程式碼塊 |
| [dial.nvim](https://github.com/monaqa/dial.nvim) | 增強版 `<C-a>`/`<C-x>` |
| [dressing.nvim](https://github.com/stevearc/dressing.nvim) | 改善 UI 選單 |

## 按鍵對應

`<leader>` = `空白鍵 (Space)`

### 檔案操作

| 按鍵 | 模式 | 功能 |
|------|------|------|
| `<leader>w` | Normal | 存檔 |
| `<leader>q` | Normal | 關閉視窗 |
| `<leader>f` | Normal/Visual | 格式化檔案或選取範圍 |
| `jk` | Insert | 離開 Insert 模式 |

### 檔案搜尋（Telescope）

| 按鍵 | 功能 |
|------|------|
| `<leader>ff` | 搜尋檔案 |
| `<leader>fg` | 全文搜尋（Live Grep） |
| `<leader>fb` | 搜尋已開啟的 Buffer |
| `<leader>fs` | Git 狀態 |
| `<leader>fc` | Git Commits |

### 檔案樹（Neo-tree）

| 按鍵 | 功能 |
|------|------|
| `<leader>e` | 切換檔案樹 |
| `<leader>r` | 聚焦檔案樹 |

### 視窗管理

| 按鍵 | 功能 |
|------|------|
| `<leader>o` | 垂直分割 |
| `<leader>p` | 水平分割 |
| `<C-h/j/k/l>` | 切換視窗方向 |
| `<C-←/→/↑/↓>` | 調整視窗大小 |

### 自動補全（nvim-cmp）

| 按鍵 | 功能 |
|------|------|
| `<C-Space>` | 觸發補全選單 |
| `<CR>` | 確認選取 |
| `<C-e>` | 關閉補全選單 |
| `<C-d>` | 向上捲動文件 |
| `<C-f>` | 向下捲動文件 |

### Treesitter 選取

| 按鍵 | 功能 |
|------|------|
| `<C-Space>` | 初始化 / 擴大選取範圍 |
| `<BS>` | 縮小選取範圍 |

### 其他

| 按鍵 | 功能 |
|------|------|
| `J` | 展開/合併程式碼塊（treesj） |
| `<C-a>` | 增加（dial.nvim 增強版） |
| `<C-x>` | 減少（dial.nvim 增強版） |

## 常用指令

```vim
" 插件管理
:Lazy           " 開啟 lazy.nvim UI
:Lazy update    " 更新所有插件
:Lazy sync      " 同步插件（安裝/移除/更新）

" LSP 工具管理
:Mason          " 開啟 Mason UI（安裝 LSP server）

" Treesitter
:TSInstall <language>   " 安裝語言解析器
:TSUpdate               " 更新所有解析器

" 效能診斷
:StartupTime    " 量測啟動時間
```

## 新增 LSP

1. 執行 `:Mason` 開啟 Mason UI
2. 搜尋語言伺服器（例如 `pyright`、`tsserver`）
3. 按 `i` 安裝
4. 在 `lua/plugins/` 中新增 lspconfig 設定（或在既有的 LSP 設定檔中加入）

## 新增插件

在 `lua/plugins/` 目錄中建立新的 `.lua` 檔案，lazy.nvim 會自動載入：

```lua
-- lua/plugins/my-plugin.lua
return {
    "author/plugin-name",
    event = "VeryLazy",  -- 延遲載入
    config = function()
        require("plugin-name").setup({
            -- 設定選項
        })
    end,
}
```
