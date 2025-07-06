# Configuration Files

This directory contains reference configuration files for the EDC deployment.

## Files

- `edc-standalone.properties` - Reference configuration for EDC standalone connector
- `edc-peer.properties` - Reference configuration for EDC peer connector

## Usage

These files serve as reference configurations. The actual deployment uses Helm charts with configuration defined in:

- `helm/edc-standalone/values.yaml` - EDC standalone and peer configuration
- `helm/edc-monitoring/values.yaml` - Monitoring stack configuration

## Configuration Properties

The EDC connectors use the following key configuration properties:

### Core Configuration
- `edc.connector.name` - Connector name
- `edc.connector.id` - Connector ID
- `edc.web.http.port` - HTTP port (8181)
- `edc.web.http.data.port` - Data plane port (8181)
- `edc.web.http.management.port` - Management port (8181)

### IAM Configuration
- `edc.iam.issuer.id` - IAM issuer ID
- `edc.iam.sts.oauth.client.id` - OAuth client ID
- `edc.iam.sts.oauth.client.secret.alias` - OAuth client secret alias
- `edc.iam.sts.oauth.token.url` - OAuth token URL

### Transfer Configuration
- `edc.transfer.type` - Transfer type (http)
- `edc.transfer.proxy.token.signer.privatekey.alias` - Token signer alias
- `edc.transfer.proxy.token.verifier.publickey.alias` - Token verifier alias

### Storage Configuration
- `edc.storage.type` - Storage type (in-memory)

## Helm Integration

The Helm charts automatically generate these configuration files from the values in `values.yaml` using the `edc-standalone.config.properties` template function.

To customize the configuration, edit the appropriate `values.yaml` file and redeploy with Helm. 