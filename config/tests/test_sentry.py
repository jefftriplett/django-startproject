import sentry_sdk
from django.conf import settings


def test_sentry_disabled_without_dsn():
    """Sentry is only initialized when SENTRY_DSN is set; the test env leaves it unset."""
    assert settings.SENTRY_DSN == ""
    assert not sentry_sdk.get_client().is_active()


def test_django_security_and_request_loggers_log_to_console():
    assert settings.LOGGING["loggers"]["django.request"]["handlers"] == ["console"]
    assert settings.LOGGING["loggers"]["django.security"]["handlers"] == ["console"]
