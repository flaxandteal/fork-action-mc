FROM minio/mc:latest

LABEL maintainer="Christian Ulbrich <christian.ulbrich@zalari.de>"
LABEL repository="https://github.com/zalari/action-mc"
LABEL homepage="https://github.com/zalari/action-mc"

LABEL com.github.actions.name="MinIO Client"
LABEL com.github.actions.description="Expose MinIO Client"
LABEL com.github.actions.icon="upload-cloud"
LABEL com.github.actions.color="black"

COPY LICENSE README.md /

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
