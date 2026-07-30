# 頭城小知識後台啟用方式

這個網站的公開頁是 `index.html`，管理入口是 `admin.html`。

## 1. 建立 Supabase 專案

1. 在 [Supabase](https://supabase.com) 建立新專案。
2. 進入 **SQL Editor**，貼上並執行 `database.sql` 的全部內容。
3. 點上方 **Connect**，複製 `Project URL` 和 `Publishable key`。
4. 打開 `supabase-config.js`，將兩個預留字串換成上述資訊。

> `Publishable key` 可以放在網站前端；請勿使用或公開 `sb_secret` 開頭的 Secret key。

## 2. 建立管理者

1. 到 **Authentication → Users**，新增管理者 Email 和密碼。
2. 到 **Authentication → Providers → Email**，關閉允許新使用者自行註冊的選項。
3. 使用新帳密開啟 `admin.html` 登入。

登入後可新增、修改、刪除、改變排序，或先存成不公開的草稿。按下儲存後，已發布內容會立即反映在 `index.html`。

## 3. 部署

將下列檔案一起部署到任一靜態網站主機（例如 Netlify、Cloudflare Pages 或 GitHub Pages）：

- `index.html`
- `admin.html`
- `admin.js`
- `supabase-config.js`

`database.sql` 與本說明檔不需要上傳。請避免把 `database.sql` 內含的管理資訊或任何私密金鑰放到公開位置。
