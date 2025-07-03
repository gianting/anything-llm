# 使用一個更完整的 Node.js 18 映像檔，避免缺少系統工具
FROM node:18

# 設定環境變數，這對後續所有 npm 指令都有效
ENV NODE_OPTIONS="--max-old-space-size=4096"

# 建立工作目錄
WORKDIR /app

# 先複製所有 package.json 檔案，以利用快取
COPY package*.json ./
COPY frontend/package*.json ./frontend/

# 分步執行指令，第一步：安裝根目錄的依賴
RUN npm install

# 分步執行指令，第二步：安裝前端的依賴
RUN npm install --prefix frontend

# 現在複製所有剩餘的程式碼
COPY . .

# 分步執行指令，第三步：建置前端
# 我們使用 --verbose 來取得更詳細的錯誤輸出
# RUN npm run build:frontend --verbose
RUN npm run prod:frontend --verbose

# 宣告服務使用的連接埠
EXPOSE 3001

# 最終的啟動指令
CMD ["sh", "-c", "NODE_ENV=production npx tsx-esm server/index.ts"]