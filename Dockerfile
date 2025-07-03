# 使用一個輕量級的 Node.js 18 映像檔作為基礎
FROM node:18-slim

# 在容器內建立一個 /app 資料夾作為工作目錄
WORKDIR /app

# 為了利用 Docker 的快取機制，我們先複製 package.json 檔案
# 這樣只有在依賴套件變更時，才會重新執行 npm install
COPY package*.json ./
COPY frontend/package*.json ./frontend/

# 執行我們的設定指令，這會安裝所有依賴並建置前端
# 這就是之前的 buildCommand
RUN npm run setup

# 複製專案的所有剩餘檔案到工作目錄
COPY . .

# 向 Docker 宣告我們的應用程式會使用 3001 連接埠
EXPOSE 3001

# 容器啟動時要執行的最終指令
# 這就是之前的 startCommand
CMD ["sh", "-c", "NODE_ENV=production npx tsx-esm server/index.ts"]