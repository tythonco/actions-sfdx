FROM tythonco:docker-sfdx-cli

LABEL version = "1.0.0"
LABEL repository="https://github.com/tythonco/actions-sfdx"
LABEL homepage="https://github.com/tythonco/actions-sfdx"
LABEL maintainer="Tython Devs <devs@tython.co>"

LABEL com.github.actions.name="GitHub Action for sfdx"
LABEL com.github.actions.description="Wraps the sfdx cli to enable common sfdx commands."
LABEL com.github.actions.icon="cloud-lightning"
LABEL com.github.actions.color="blue"

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]