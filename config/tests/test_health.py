import pytest

from config import __version__


@pytest.mark.django_db
def test_health_check_reports_ok(client):
    """/health/ runs django-health-check's Database check and returns 200."""
    response = client.get("/health/", headers={"accept": "application/json"})

    assert response.status_code == 200
    # Keys are labels like "Database(alias='default')"; only Database is enabled.
    results = response.json()
    assert len(results) == 1
    assert list(results.values()) == ["OK"]


def test_version_endpoint(client):
    response = client.get("/apis/version/")

    assert response.status_code == 200
    assert response.json() == {"version": __version__}


def test_version_txt(client):
    """Plain-text version that `just check-versions` reads on live sites."""
    response = client.get("/version.txt")

    assert response.status_code == 200
    assert response["Content-Type"].startswith("text/plain")
    assert response.content.decode() == __version__
