WMBIND2 Client
==============

Client for the [WMBIND2 server](https://github.com/voldern/wmbind2)
interface.

Short explanation
-----------------
This client is installed onto every node that is going to be controlled
through WMBIND.

It runs in two modes: master or slave.

While in master mode it can do the following:
* Read existing zone files living on the client
* Saves new zones
* Update exisiting zones
* Verify zones
* Destroy zones

While in slave mode it does the following:
* Create new zone
* Destroy zone
* Force zone

