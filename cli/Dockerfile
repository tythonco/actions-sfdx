FROM tythonco/docker-sfdx-cli

LABEL version = "1.0.0"
LABEL maintainer="Tython Devs <devs@tython.co>"
LABEL com.github.actions.name="GitHub Action for sfdx cli"
LABEL com.github.actions.description="Wraps the sfdx cli to enable sfdx commands."
LABEL com.github.actions.icon="cloud-lightning"
LABEL com.github.actions.color="blue"

COPY LICENSE README.md
COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
