FROM debian:12-slim AS build
RUN apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends --yes python3-venv gcc libpython3-dev && \
    python3 -m venv /venv && \
    /venv/bin/pip install --upgrade pip setuptools wheel

# Build the virtualenv as a separate step: Only re-execute this step when requirements.txt changes
FROM build AS build-venv
COPY requirements.txt /requirements.txt
RUN /venv/bin/pip install --disable-pip-version-check -r /requirements.txt

# Copy the virtualenv into a distroless image
FROM gcr.io/distroless/python3-debian12:nonroot
COPY --from=build-venv /venv /venv
USER nonroot
WORKDIR /home/nonroot
COPY app.py chainlit.md  ./
COPY .chainlit/config.toml ./.chainlit/config.toml
EXPOSE 8000
ENTRYPOINT ["/venv/bin/chainlit", "run", "--no-cache", "--headless", "--host", "0.0.0.0", "--port", "8000", "app.py"]
