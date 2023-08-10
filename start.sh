#!/bin/bash

# Step 0: Source the .env file to load environment variables

source .env

# Step 1: Create the Django project using docker-compose

docker-compose run web django-admin startproject geodjango_project .

# Step 2: Start the Docker containers

docker-compose up -d

# Step 3: Change the database engine configuration

## Step 3.1: Create a function to update the database configuration 

function update_db_config() {
    sed -i "s/'ENGINE': 'django.db.backends.sqlite3',/'ENGINE': 'django.contrib.gis.db.backends.postgis',/" $1
    sed -i "s/'NAME': BASE_DIR \/ 'db.sqlite3',/'NAME': os.environ.get('POSTGRES_DB_NAME', 'postgres'),/" $1
    sed -i "/'ENGINE': 'django.contrib.gis.db.backends.postgis',/a\        'USER': os.environ.get('POSTGRES_USER', 'postgres'),\n        'PASSWORD': os.environ.get('POSTGRES_PASSWORD', 'postgres'),\n        'HOST': os.environ.get('POSTGRES_HOST', 'db'),\n        'PORT': os.environ.get('POSTGRES_PORT', '5432')," $1
}

## Step 3.2 import the os module in the settings.py file

docker exec -i geodjango-docker-web-1 sed -i "1s/^/import os\n/" geodjango_project/settings.py

# docker exec -i geodjango-docker-web-1 sed -i "/Django settings for geodjango_project project\./a\import os" geodjango_project/settings.py

## Step 3.3: Call the function to update the database configuration

update_db_config "geodjango_project/settings.py"

## Step 4: Change the timezone parameter value

docker exec -i geodjango-docker-web-1 sed -i "s|TIME_ZONE = 'UTC'|TIME_ZONE = '$TIME_ZONE'|g" geodjango_project/settings.py

# Step 5: Add django.contrib.gis to INSTALLED_APPS

docker exec -i geodjango-docker-web-1 sed -i "/^INSTALLED_APPS = \[/a\ \t'django.contrib.gis'," geodjango_project/settings.py

# Step 6: Make & apply migrations

docker-compose exec web python manage.py makemigrations
docker-compose exec web python manage.py migrate
