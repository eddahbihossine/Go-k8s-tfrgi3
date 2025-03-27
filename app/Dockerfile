# Use official Golang image
FROM golang:1.22

WORKDIR /app

# Copy files
COPY go.mod go.sum ./
RUN go mod download

COPY . .

# Build the application
RUN go build -o main main.go

# Run the application
CMD [ "./main" ]
