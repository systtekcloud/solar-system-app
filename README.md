# Solar System NodeJS Application

A simple HTML+MongoDB+NodeJS project to display Solar System and its planets.

---

## Table of Contents

- [Requirements](#requirements)
- [Local Development](#local-development)
- [Docker Deployment](#docker-deployment)
- [Environment Variables](#environment-variables)
- [CI/CD Pipeline](#cicd-pipeline)
- [Debugging](#debugging)

---

## Requirements

### For Local Development
- Node.js 18 or 20
- NPM
- MongoDB connection (Atlas or local)

### For Docker Deployment
- Docker
- Docker Compose (optional)

### Node Installation

#### Windows
Just go to the [official Node.js website](https://nodejs.org/) and download the installer.
Also, be sure to have `git` available in your PATH, `npm` might need it (You can find git [here](https://git-scm.com/)).

#### Ubuntu
```bash
sudo apt install nodejs
sudo apt install npm
```

#### Other Operating Systems
You can find more information on the [official Node.js website](https://nodejs.org/) and the [official NPM website](https://npmjs.org/).

Verify the installation:
```bash
node --version  # Should be v18.x or v20.x
npm --version
```

---

## Local Development

### 1. Install Dependencies
```bash
npm install
```

### 2. Configure Environment Variables

Create a `.env` file in the root directory (this file is gitignored for security):

```bash
MONGO_URI=your_mongodb_connection_string
MONGO_USERNAME=your_username
MONGO_PASSWORD=your_password
```

### 3. Run Unit Tests
```bash
npm test
```

### 4. Run Code Coverage
```bash
npm run coverage
```

### 5. Run Application
```bash
npm start
```

### 6. Access Application
Open your browser at: `http://localhost:3000/`

---

## Docker Deployment

This application uses a secure Dockerfile with the following best practices:
- ✅ Non-root user (nodejs)
- ✅ No hardcoded credentials
- ✅ Health checks enabled
- ✅ Minimal Alpine-based image
- ✅ Proper signal handling with dumb-init

### Option 1: Docker CLI

#### Build the Image
```bash
docker build -t solar-system-app:local .
```

#### Run with Environment Variables
```bash
docker run -d \
  --name solar-system-app \
  -p 3000:3000 \
  -e MONGO_URI="your_mongodb_uri" \
  -e MONGO_USERNAME="your_username" \
  -e MONGO_PASSWORD="your_password" \
  solar-system-app:local
```

#### Run with Environment File (Recommended)
Create a `.env.local` file:
```env
MONGO_URI=your_mongodb_uri
MONGO_USERNAME=your_username
MONGO_PASSWORD=your_password
```

Then run:
```bash
docker run -d \
  --name solar-system-app \
  -p 3000:3000 \
  --env-file .env.local \
  solar-system-app:local
```

### Option 2: Docker Compose

Create a `docker-compose.yml`:
```yaml
version: '3.8'

services:
  solar-system-app:
    build: .
    container_name: solar-system-app
    ports:
      - "3000:3000"
    env_file:
      - .env.local
    healthcheck:
      test: ["CMD", "node", "-e", "require('http').get('http://localhost:3000/live', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"]
      interval: 30s
      timeout: 3s
      retries: 3
      start_period: 5s
```

Run with:
```bash
docker-compose up -d
```

---

## Environment Variables

The application requires the following environment variables:

| Variable | Description | Required |
|----------|-------------|----------|
| `MONGO_URI` | MongoDB connection string | Yes |
| `MONGO_USERNAME` | MongoDB username | Yes |
| `MONGO_PASSWORD` | MongoDB password | Yes |

⚠️ **Security Note**:
- Never commit `.env` or `.env.local` files to the repository
- Never hardcode credentials in the Dockerfile
- Use GitHub Secrets for CI/CD pipelines

---

## CI/CD Pipeline

This project uses GitHub Actions for automated testing and deployment.

### Workflow Features
- Unit testing on Node.js 18 and 20
- Code coverage reporting
- Docker image building and testing
- Automated health checks
- Push to Docker Hub (when enabled)

### Required GitHub Secrets
Configure these in your repository settings:

- `MONGO_URI` - MongoDB connection string
- `MONGO_USERNAME` - MongoDB username
- `MONGO_PASSWORD` - MongoDB password
- `DOCKERHUB_PASSWORD` - Docker Hub password

### Required GitHub Variables
- `DOCKERHUB_USERNAME` - Docker Hub username

---

## Debugging

### Docker Container Debugging

#### View Running Containers
```bash
docker ps
```

#### View Container Logs
```bash
docker logs -f solar-system-app
```

#### Check Health Status
```bash
docker inspect --format='{{.State.Health.Status}}' solar-system-app
```

#### Execute Commands Inside Container
```bash
docker exec -it solar-system-app sh
```

#### View Environment Variables (inside container)
```bash
docker exec solar-system-app env | grep MONGO
```

#### Stop and Remove Container
```bash
docker stop solar-system-app
docker rm solar-system-app
```

#### Verify Image History (check for exposed secrets)
```bash
docker history solar-system-app:local
```

#### Inspect Image Details
```bash
docker inspect solar-system-app:local
```

### Application Debugging

#### Check Application Health Endpoint
```bash
curl http://localhost:3000/live
```

#### Test from Container IP (Linux)
```bash
IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' solar-system-app)
wget -q -O - http://$IP:3000/live
```

### Docker Compose Debugging

```bash
# View logs
docker-compose logs -f

# Restart service
docker-compose restart

# Stop and remove containers
docker-compose down

# Rebuild and restart
docker-compose up -d --build
```

---

## Security Best Practices

This project follows Docker security best practices:

1. **No Hardcoded Credentials**: Environment variables are passed at runtime
2. **Non-Root User**: Container runs as user `nodejs` (UID 1001)
3. **Minimal Base Image**: Uses Alpine Linux for smaller attack surface
4. **Health Checks**: Built-in health monitoring
5. **Clean .dockerignore**: Prevents sensitive files from being copied
6. **.env files are gitignored**: Credentials never committed to repository

---

## Project Structure

```
.
├── app.js                  # Main application file
├── app-controller.js       # Application controller
├── app-test.js            # Unit tests
├── Dockerfile             # Docker configuration
├── .dockerignore          # Files excluded from Docker build
├── docker-compose.yml     # Docker Compose configuration (optional)
├── package.json           # NPM dependencies
├── .github/
│   └── workflows/
│       └── solar-system.yml  # CI/CD pipeline
└── README.md              # This file
```

---

## License

This project is for educational purposes.

