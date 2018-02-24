FROM krallin/ubuntu-tini:trusty as tini

# ----------------------------------------

FROM python:3.6.4-slim as base

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN set -ex \
    && pip install pipenv \
    && rm -rf /root/.cache/

WORKDIR /code

COPY Pipfile Pipfile.lock /code/

RUN set -ex \
    && pipenv install --deploy \
    && pipenv install --deploy --dev \
    && rm -rf /root/.cache/

COPY --from=tini /usr/local/bin/tini /usr/local/bin/tini

COPY . /code/

EXPOSE 8000

ENTRYPOINT ["/usr/local/bin/tini", "--"]

CMD ["pipenv", "run", "python", "manage.py", "runserver", "0.0.0.0:8000"]
