# smithy-poc

OpenAPI 3.1 generator with Smithy for Software-Catalog

### Project structure

- **models** - contains Smithy model definition for OpenAPI spec definition
- **smithy-build.json** - Smithy build tool configuration

### Prerequisites

- Make sure that your environment has `smithy-cli` installed. Follow this [link]: https://smithy.io/2.0/guides/smithy-cli/cli_installation.html 
  for instructions.
- Make sure that your environment has `gradle` installed. Follow this [link]: https://gradle.org/install/ 
  for instructions.

### Spec generation

To generate OpenAPI 3.1 JSON specification run `make build`. The generated specification will be located
under `./build/smithyprojections/smithy-poc/source/openapi`.

If you would like to visualize the specification, you can use [Swagger web editor]: https://editor.swagger.io/.
Copy the content of the generated OpenAPI specification and paste it into the web editor.
