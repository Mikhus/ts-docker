# Minimalist TypeScript/Node Docker Example

This repo provides an example of building minimalist docker build for
TypeScript/NodeJS based microservice.

So the most interesting part is to observe:

 - [Dockerfile](https://github.com/Mikhus/ts-docker/blob/master/Dockerfile)
 - [package.json](https://github.com/Mikhus/ts-docker/blob/master/package.json)

`Dockerfile` represents 3-stage building process. First phase is to run
ts/node build under a target platform, which is based on Alpine Linux. Second
phase compress generated binary executable using `gzexe`. Third, and the last
phase creates a release image containing only minimalist Alpine image, pre-built
compressed binary of microservice and working gzip/gzexe commands.

`package.json` provides a basic command set to automate local and docker builds
of microservice.

With current docker build implementation it results into `27.1 MB` image
size production, which includes `18.4 MB` pre-built compressed ts/node 
microservice binary inside.

**Is it possible to have less?**

Author would be greatly appreciated for any suggestions and contributions
of further optimizations and improvements to this example. 

## License

[ISC License](https://github.com/Mikhus/ts-docker/blob/master/LICENSE)
