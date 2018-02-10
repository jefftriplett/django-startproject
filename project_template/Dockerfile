FROM python:3.6.4

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# ENV TINI_VERSION v0.16.1
# ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
# RUN chmod +x /tini

RUN set -ex \
    && pip install pipenv

WORKDIR /code

COPY Pipfile Pipfile.lock /code/

RUN set -ex \
    && pipenv install --deploy \
    && pipenv install --deploy --dev

COPY . /code/

EXPOSE 8000

# ENTRYPOINT ["pipenv", "run", "python", "manage.py"]
CMD ["pipenv", "run", "python", "manage.py", "runserver", "0.0.0.0:8000"]
