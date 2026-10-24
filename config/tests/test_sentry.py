import copy
import importlib
import io
import logging
import logging.config

import sentry_sdk

from config import settings as settings_module

SENTRY_ENV_VARS = ("SENTRY_DSN", "SENTRY_ENVIRONMENT", "SENTRY_TRACES_SAMPLE_RATE", "SENTRY_SEND_DEFAULT_PII")


def _reload_settings(monkeypatch, **env):
    """Re-execute config.settings with a controlled Sentry environment."""
    for name in SENTRY_ENV_VARS:
        monkeypatch.delenv(name, raising=False)
    for name, value in env.items():
        monkeypatch.setenv(name, value)
    return importlib.reload(settings_module)


def test_sentry_not_initialized_without_dsn(monkeypatch):
    """With SENTRY_DSN cleared (so a developer's .env can't interfere), init is never called."""
    calls = []
    monkeypatch.setattr(sentry_sdk, "init", lambda **kwargs: calls.append(kwargs))

    module = _reload_settings(monkeypatch)

    assert module.SENTRY_DSN == ""
    assert calls == []


def test_sentry_initialized_with_dsn_and_pii_off_by_default(monkeypatch):
    calls = []
    monkeypatch.setattr(sentry_sdk, "init", lambda **kwargs: calls.append(kwargs))

    _reload_settings(monkeypatch, SENTRY_DSN="https://public@example.invalid/1")

    assert len(calls) == 1
    assert calls[0]["environment"] == "production"
    assert calls[0]["traces_sample_rate"] == 0.1
    assert calls[0]["send_default_pii"] is False


def test_sentry_pii_can_be_enabled(monkeypatch):
    calls = []
    monkeypatch.setattr(sentry_sdk, "init", lambda **kwargs: calls.append(kwargs))

    _reload_settings(
        monkeypatch,
        SENTRY_DSN="https://public@example.invalid/1",
        SENTRY_SEND_DEFAULT_PII="true",
    )

    assert calls[0]["send_default_pii"] is True


def test_django_request_warning_reaches_console_handler(monkeypatch):
    """Apply the real LOGGING config and confirm a django.request warning reaches the console.

    conftest.py calls logging.disable(CRITICAL), so logging is re-enabled for the
    duration of this test and restored afterward. The stream is redirected so the
    console handler's output can be inspected.
    """
    stream = io.StringIO()
    config = copy.deepcopy(settings_module.LOGGING)
    config["handlers"]["console"]["stream"] = stream

    logging.disable(logging.NOTSET)
    try:
        logging.config.dictConfig(config)
        logging.getLogger("django.request").warning("synthetic 500")
        logging.getLogger("django.security").warning("synthetic security event")
    finally:
        logging.disable(logging.CRITICAL)
        logging.config.dictConfig(settings_module.LOGGING)

    output = stream.getvalue()
    assert "synthetic 500" in output
    assert "synthetic security event" in output
