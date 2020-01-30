FROM salesforce/salesforcedx

LABEL version = "1.0.0"
LABEL maintainer="Tython Devs <devs@tython.co>"
LABEL com.github.actions.name="GitHub Action for CI/CD with sfdx"
LABEL com.github.actions.description="Uses sfdx to run check-only deploy for Salesforce development projects."
LABEL com.github.actions.icon="cloud-lightning"
LABEL com.github.actions.color="blue"

COPY LICENSE README.md
COPY bin /usr/local/bin/
COPY entrypoint.sh /

# ENV PATH="/usr/local/bin:${PATH}"

# RUN chmod +x /entrypoint.sh
# RUN apk update \
# 	&& apk add --no-cache openssl\
# 	&& rm -rf /var/lib/apt/lists/* \
# 	&& rm -rf /var/cache/apk/*

ENTRYPOINT ["/entrypoint.sh"]