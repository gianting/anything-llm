# =================================================================
# Final Dockerfile for AnythingLLM on Zeabur
# This version downloads a pre-built frontend to bypass local build issues.
# =================================================================

# Part 1: Build the backend in a builder stage
# ---------------------------------------------
FROM node:18-slim AS builder

WORKDIR /app

# Copy only necessary files for backend dependencies
COPY package*.json ./

# Install backend dependencies
RUN npm install --omit=dev

# Part 2: Create the final image
# ---------------------------------------------
FROM node:18-slim

WORKDIR /app

# Copy backend dependencies from the builder stage
COPY --from=builder /app/node_modules ./node_modules

# Copy your backend server code and other root files
COPY . .

# --- THE MAGIC PART ---
# Remove your local (broken) frontend and download the official pre-built one
RUN rm -rf ./frontend && \
    curl -L -o anythingllm-frontend.zip https://github.com/Mintplex-Labs/anything-llm/releases/latest/download/anythingllm-frontend.zip && \
    unzip anythingllm-frontend.zip && \
    rm anythingllm-frontend.zip
# --- END OF MAGIC PART ---

# Expose the port the app runs on
EXPOSE 3001

# The command to start the application
CMD ["sh", "-c", "NODE_ENV=production npx tsx-esm server/index.ts"]