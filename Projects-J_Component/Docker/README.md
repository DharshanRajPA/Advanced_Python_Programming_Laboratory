# Docker Production Setup for Flask Food Delivery App

A complete production-ready Docker setup for the Flask Food Delivery Application with PostgreSQL, Redis, and Nginx reverse proxy.

## Architecture

This Docker setup includes:

- **Flask Application**: Python web application with Gunicorn WSGI server
- **PostgreSQL**: Production database for persistent data storage
- **Redis**: Caching and session storage
- **Nginx**: Reverse proxy with load balancing, rate limiting, and static file serving

## Prerequisites

- Docker Engine 20.10 or higher
- Docker Compose 2.0 or higher
- At least 4GB of available RAM
- 10GB of free disk space

## Quick Start

### 1. Clone and Navigate

```bash
cd Projects-J_Component/Docker
```

### 2. Configure Environment Variables

Copy the example environment file and customize it:

```bash
cp env.example .env
```

Edit `.env` and update the following critical values:

- `SECRET_KEY`: Generate a strong random key (minimum 32 characters)
- `DB_PASSWORD`: Strong password for PostgreSQL
- `REDIS_PASSWORD`: Strong password for Redis

**Generate a secure SECRET_KEY:**
```bash
python -c "import secrets; print(secrets.token_urlsafe(32))"
```

### 3. Build and Start Services

**Development/Testing:**
```bash
docker-compose up -d --build
```

**Production:**
```bash
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build
```

### 4. Verify Services

Check that all services are running:

```bash
docker-compose ps
```

All services should show "healthy" status.

### 5. Access the Application

- **Web Application**: http://localhost
- **Health Check**: http://localhost/health
- **Admin Login**: 
  - Username: `admin`
  - Password: `admin123`

## Service Details

### Flask Application

- **Port**: 5000 (internal), exposed via Nginx
- **Workers**: 4 (development), 8 (production)
- **Health Check**: `/health` endpoint
- **Logs**: Available via `docker-compose logs flask`

### PostgreSQL Database

- **Port**: 5432 (internal)
- **Data Persistence**: Stored in `postgres_data` volume
- **Health Check**: Automatic connection verification
- **Access**: 
  ```bash
  docker-compose exec postgres psql -U foodapp_user -d food_order_db
  ```

### Redis Cache

- **Port**: 6379 (internal)
- **Data Persistence**: AOF (Append Only File) enabled
- **Health Check**: Automatic ping verification
- **Access**:
  ```bash
  docker-compose exec redis redis-cli -a <REDIS_PASSWORD>
  ```

### Nginx Reverse Proxy

- **Port**: 80 (external)
- **Features**:
  - Rate limiting (10 req/s general, 5 req/min for login)
  - Gzip compression
  - Security headers
  - Static file serving
  - Load balancing ready

## Common Commands

### View Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f flask
docker-compose logs -f nginx
docker-compose logs -f postgres
docker-compose logs -f redis
```

### Stop Services

```bash
docker-compose down
```

### Stop and Remove Volumes (⚠️ Deletes Data)

```bash
docker-compose down -v
```

### Restart a Service

```bash
docker-compose restart flask
```

### Execute Commands in Containers

```bash
# Flask container
docker-compose exec flask bash

# PostgreSQL container
docker-compose exec postgres psql -U foodapp_user -d food_order_db

# Redis container
docker-compose exec redis redis-cli
```

### Rebuild After Code Changes

```bash
docker-compose up -d --build flask
```

## Database Management

### Initialize Database

The database is automatically initialized on first startup. The admin user is created with:
- Username: `admin`
- Password: `admin123`

**⚠️ Change the admin password immediately in production!**

### Backup Database

```bash
docker-compose exec postgres pg_dump -U foodapp_user food_order_db > backup.sql
```

### Restore Database

```bash
docker-compose exec -T postgres psql -U foodapp_user food_order_db < backup.sql
```

### Reset Database

```bash
# Stop services
docker-compose down

# Remove database volume
docker volume rm docker_postgres_data

# Start services (will recreate database)
docker-compose up -d
```

## Production Deployment

### 1. Security Checklist

- [ ] Change `SECRET_KEY` to a strong random value
- [ ] Change `DB_PASSWORD` to a strong password
- [ ] Change `REDIS_PASSWORD` to a strong password
- [ ] Change admin user password in application
- [ ] Set `FLASK_ENV=production` and `FLASK_DEBUG=false`
- [ ] Configure SSL/TLS certificates for HTTPS
- [ ] Set up firewall rules
- [ ] Configure backup strategy
- [ ] Set up monitoring and logging

### 2. SSL/HTTPS Configuration

1. Obtain SSL certificates (Let's Encrypt, etc.)
2. Place certificates in `nginx/ssl/` directory
3. Update `nginx/nginx.conf` with SSL configuration
4. Uncomment HTTPS port in `docker-compose.yml`
5. Update `docker-compose.prod.yml` with SSL volumes

### 3. Resource Limits

Production configuration includes resource limits. Adjust in `docker-compose.prod.yml` based on your server capacity.

### 4. Monitoring

Consider adding:
- Prometheus for metrics
- Grafana for visualization
- ELK stack for log aggregation
- Sentry for error tracking

## Troubleshooting

### Services Won't Start

1. Check logs: `docker-compose logs`
2. Verify environment variables in `.env`
3. Check port conflicts: `netstat -tulpn | grep :80`
4. Verify Docker has enough resources

### Database Connection Errors

1. Wait for PostgreSQL to be healthy: `docker-compose ps postgres`
2. Check database credentials in `.env`
3. Verify network connectivity: `docker-compose exec flask ping postgres`

### Application Not Accessible

1. Check Nginx logs: `docker-compose logs nginx`
2. Verify Flask is healthy: `docker-compose exec flask curl http://localhost:5000/health`
3. Check firewall rules
4. Verify port mapping: `docker-compose ps`

### Performance Issues

1. Increase Gunicorn workers in `docker-compose.prod.yml`
2. Adjust PostgreSQL settings in `docker-compose.prod.yml`
3. Monitor resource usage: `docker stats`
4. Check Redis memory usage: `docker-compose exec redis redis-cli INFO memory`

## File Structure

```
Docker/
├── Dockerfile                 # Flask application Dockerfile
├── docker-compose.yml         # Main compose file
├── docker-compose.prod.yml    # Production overrides
├── .dockerignore              # Files to exclude from build
├── env.example                # Environment variables template
├── README.md                  # This file
└── nginx/
    ├── Dockerfile            # Nginx Dockerfile
    └── nginx.conf            # Nginx configuration
```

## Environment Variables Reference

| Variable | Description | Default |
|----------|-------------|---------|
| `DB_HOST` | PostgreSQL hostname | `postgres` |
| `DB_PORT` | PostgreSQL port | `5432` |
| `DB_NAME` | Database name | `food_order_db` |
| `DB_USER` | Database user | `foodapp_user` |
| `DB_PASSWORD` | Database password | (required) |
| `REDIS_HOST` | Redis hostname | `redis` |
| `REDIS_PORT` | Redis port | `6379` |
| `REDIS_PASSWORD` | Redis password | (required) |
| `SECRET_KEY` | Flask secret key | (required) |
| `FLASK_ENV` | Flask environment | `production` |
| `FLASK_DEBUG` | Debug mode | `false` |
| `NGINX_PORT` | Nginx external port | `80` |

## Health Checks

All services include health checks:

- **Flask**: `GET /health` - Checks database connectivity
- **PostgreSQL**: `pg_isready` - Database readiness
- **Redis**: `redis-cli ping` - Cache connectivity
- **Nginx**: `wget /health` - Proxy functionality

View health status:
```bash
docker-compose ps
```

## Support

For issues and questions:
1. Check logs: `docker-compose logs`
2. Review this README
3. Check Docker and Docker Compose documentation
4. Verify all prerequisites are met

## License

This Docker setup is part of the Flask Food Delivery Application project.

