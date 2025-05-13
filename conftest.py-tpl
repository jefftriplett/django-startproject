from __future__ import annotations

import logging

import pytest


logging.disable(logging.CRITICAL)


@pytest.fixture(autouse=True)
def use_test_settings(settings):
    settings.DEBUG = False

    settings.EMAIL_BACKEND = "django.core.mail.backends.locmem.EmailBackend"

    settings.MIDDLEWARE = [
        middleware for middleware in settings.MIDDLEWARE if middleware != "whitenoise.middleware.WhiteNoiseMiddleware"
    ]

    # User a faster password hasher
    settings.PASSWORD_HASHERS = ["django.contrib.auth.hashers.MD5PasswordHasher"]

    settings.STORAGES = {"staticfiles": {"BACKEND": "django.contrib.staticfiles.storage.StaticFilesStorage"}}

    settings.WHITENOISE_AUTOREFRESH = True
