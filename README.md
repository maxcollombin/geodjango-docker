# Steps to run the project

## 1. Copy the .env.example file to .env and edit the variables

`cp .env.example .env`
## 2. Build the image and start the container

`source .env && ./start.sh`

## 3. Create the application

`docker compose exec web django-admin startapp <app_name>`
## 4. Access the application via a web browser

http://127.0.0.1:8000

## 5. Create the django application and play with it

`docker compose exec web django-admin startapp <app_name>`

## 6. Stop the containers and remove the volumes and images

`./stop.sh`

## Other useful commands

```shell
# Access the web container

docker exec -it django-docker-web-1 /bin/bash

# Access the python shell

docker compose exec web python manage.py shell

# Create a superuser

docker compose exec web python manage.py migrate && docker compose run web python manage.py createsuperuser
```