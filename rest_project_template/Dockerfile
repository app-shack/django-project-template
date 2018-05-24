FROM python:3.6
ENV PYTHONBUFFERED 1

RUN apt-get update
RUN apt-get install -y postgresql-client

RUN pip install uwsgi
ADD ./requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt

ADD uwsgi.ini /etc/uwsgi/app.ini

COPY docker/bin/*.sh /bin/
RUN chmod +x /bin/wait-for-postgres.sh

ADD ./src /app

ARG SOURCE_COMMIT
ENV SENTRY_RELEASE $SOURCE_COMMIT

WORKDIR /app

EXPOSE 3030 8000

CMD ["/usr/local/bin/uwsgi", "--ini", "/etc/uwsgi/app.ini"]
