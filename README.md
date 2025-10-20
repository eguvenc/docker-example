
# Docker and Makefile Example Project

Example docker project to understanding dockerfile, makefile and docker images.

## 📁 1. Project Structure

Create the following folder structure:

```
my-docker-project/
├── Dockerfile
├── docker-compose.yml
├── Makefile
└── src/
    └── index.php
```

---

## 🐘 2. `Dockerfile`

This file will create a PHP-FPM-based image.
Content:

```dockerfile
# Use official PHP 8.2 FPM as base image
FROM php:8.2-fpm

# Set working directory
WORKDIR /var/www/html

# Install required PHP extensions
RUN docker-php-ext-install pdo pdo_mysql

# Copy source code into the container
COPY ./src /var/www/html

# Command to run when the container starts
CMD ["php-fpm"]
```

### 💡 Explanation:

* `FROM php:8.2-fpm` → base system
* `RUN docker-php-ext-install` → adds MySQL support
* `COPY ./src ...` → copies your PHP code into the container
* `CMD ["php-fpm"]` → starts PHP-FPM when the container runs

---

## 🐳 3. `docker-compose.yml`

This file will **build the PHP container** and run the web service with **Nginx**.

```yaml
version: "3.8"

services:
  app:
    build: .
    container_name: php_app
    volumes:
      - ./src:/var/www/html
    networks:
      - webnet

  web:
    image: nginx:latest
    container_name: nginx_web
    ports:
      - "8080:80"
    volumes:
      - ./src:/usr/share/nginx/html:ro
      - ./nginx.conf:/etc/nginx/conf.d/default.conf:ro
    depends_on:
      - app
    networks:
      - webnet

networks:
  webnet:
    driver: bridge
```

🧠 Nginx will act as the “frontend” and connect to PHP as the backend.

---

## ⚙️ 4. `nginx.conf`

Add one more file to the project (`my-docker-project/nginx.conf`):

```nginx
server {
    listen 80;
    server_name localhost;

    root /usr/share/nginx/html;
    index index.php index.html;

    location / {
        try_files $uri /index.php?$query_string;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass app:9000;
        fastcgi_param SCRIPT_FILENAME /var/www/html$fastcgi_script_name;
    }
}
```

💬 Important line here:

```
fastcgi_pass app:9000;
```

→ connects to the `app` service (PHP container) on port `9000`.

---

## 🧰 5. `Makefile`

Now you can manage everything with a single command 🎛️

```makefile
# Default target
.DEFAULT_GOAL := help

DC = docker compose

help:
	@echo ""
	@echo "🚀 Available commands:"
	@echo "  make build     → Rebuild the Docker image"
	@echo "  make up        → Start containers (in the background)"
	@echo "  make down      → Stop and remove containers"
	@echo "  make logs      → Follow logs live"
	@echo "  make clean     → Clean all caches and containers"
	@echo ""

build:
	$(DC) build

up:
	$(DC) up -d

down:
	$(DC) down

logs:
	$(DC) logs -f

clean:
	$(DC) down -v --rmi all --remove-orphans
```

---

## 🧪 6. `src/index.php`

```php
<?php
echo "<h1>Hello from Docker!</h1>";
echo "<p>PHP version: " . phpversion() . "</p>";
```

---

## 🚀 7. Running Steps

### 1️⃣ Build containers:

```bash
make build
```

### 2️⃣ Start:

```bash
make up
```

### 3️⃣ Open in browser:

👉 [http://localhost:8080](http://localhost:8080)

You should see something like:

```
Hello from Docker!
PHP version: 8.2.x
```

### 4️⃣ To follow logs:

```bash
make logs
```

### 5️⃣ To stop:

```bash
make down
```

---

## 🎯 What did you learn?

| File                   | Purpose                                              |
| ---------------------- | ---------------------------------------------------- |
| **Dockerfile**         | Defines how to build the PHP application image       |
| **docker-compose.yml** | Defines how to run services (PHP + Nginx)            |
| **nginx.conf**         | Routes web requests to the PHP container             |
| **Makefile**           | Lets you manage all operations with a single command |

---

If you want, the next step could be taking it further:

> Add a MySQL service, connect it to the PHP container, and define commands like `make db-shell` and `make seed`.

This way, you’ll have a real full-stack Docker environment.
Shall we continue to that version (MySQL + PHP connection)?
