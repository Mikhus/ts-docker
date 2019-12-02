# Minimalist TypeScript/Node Docker Example

This repo provides an example of building minimalist docker build for
TypeScript/NodeJS based microservice.

So the most interesting part is to observe:

 - [Dockerfile](https://github.com/Mikhus/ts-docker/blob/master/Dockerfile)
 - [package.json](https://github.com/Mikhus/ts-docker/blob/master/package.json)

`Dockerfile` represents 2-stage building process. First phase is to run
ts/node build under a target platform, which is based on Alpine Linux. Second
phase creates a release image containing only minimalist Alpine image and
pre-built binary of microservice, packed with pkg tool.

`package.json` provides a basic command set to automate local and docker builds
of microservice.

With current docker build implementation it results into `58.6 MB` image
size production, which includes `49.2 MB` pre-built ts/node microservice binary
inside.

**Is it possible to have less?**

Author would be greatly appreciated for any suggestions and contributions
of further optimizations and improvements to this example. 

## License

[ISC License](https://github.com/Mikhus/ts-docker/blob/master/LICENSE)
