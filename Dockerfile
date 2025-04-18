# Stage 1: Build the Go application
FROM golang:1.21 AS builder

WORKDIR /app

# Copy go.mod and go.sum (both are required)
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the rest of the source code
COPY . .

# Build the application
RUN go build -o main .
# Optional: Show build output to help debugging
# RUN go build -v -o main .

##########################################################
# Stage 2: Create a minimal final image using distroless
FROM gcr.io/distroless/base

WORKDIR /

# Copy the Go binary and static files
COPY --from=builder /app/main /
COPY --from=builder /app/static /static

# Expose the application port
EXPOSE 8080

# Command to run the app
CMD ["/main"]
