FROM python:3.5
ENV PYTHONBUFFERED 1

RUN apt-get update
RUN pip install uwsgi

ADD uwsgi.ini /etc/uwsgi/app.ini
ADD . /app

RUN pip install -r /app/requirements/base.txt
WORKDIR /app
RUN STATIC_ROOT=/var/www/static python src/manage.py collectstatic --noinput

VOLUME /var/www/static
VOLUME /var/www/media

EXPOSE 3030 8000

CMD ["/usr/local/bin/uwsgi", "--ini", "/etc/uwsgi/app.ini"]
