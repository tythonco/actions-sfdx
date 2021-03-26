FROM salesforce/salesforcedx

LABEL version = "1.0.0"
LABEL maintainer="Tython Devs <devs@tython.co>"
LABEL com.github.actions.name="GitHub Action for CI/CD with sfdx"
LABEL com.github.actions.description="Uses sfdx to automate deployments and testing for Salesforce development projects."
LABEL com.github.actions.icon="cloud-lightning"
LABEL com.github.actions.color="blue"

COPY LICENSE README.md
COPY bin /usr/local/bin/
COPY entrypoint.sh /

ENV PATH="/usr/local/bin:${PATH}"

RUN chmod +x /entrypoint.sh
RUN chmod +x /usr/local/bin/deploy
RUN chmod +x /usr/local/bin/test
RUN chmod +x /usr/local/bin/validate
RUN apt-get update \
	&& apt-get install -y openssl \
	&& rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/entrypoint.sh"]