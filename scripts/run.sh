#!/bin/sh
set -e

python manage.py collectstatic --noinput
python manage.py migrate
gunicorn -b :8080 --chdir /app app.wsgi:application
