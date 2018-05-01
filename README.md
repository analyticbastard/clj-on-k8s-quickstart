# clj-on-k8s-quickstart

Minimal HttpKit web server compiled into a 10 MB dockerized native binary.

## Relevance

As somebody who used to be a hardcore systems guy but fell into the comfort
and nicety of the JVM and later on the joy of Clojure, I have always been
interested in a systems-oriented Clojure version (call it LLVM-Clojure,
Clojure to C, whatever), which in itself is somewhat contradictory since
the garbage collection and memory allocation that the JVM (very efficiently)
does for us must be reimplemented. Expectedly, maybe because of the previous
reason, no such Clojure systems implementation exists yet.

[Graal](https://github.com/oracle/graal) has made a way possible. And probably,
the best possible way.

No wonder Clojure communities are excited over this. Graal, with its `native-image`
tool compiles bytecode to native machine versions, embedding the JVM and your code
into a single binary native file that can be handled directly by the OS.

The next question is the need to reduce the size of the final executable. Enters
Java 10 and its modules. So I started working,
forked from [clj-on-k8s-quickstart](https://github.com/jwhitlark/clj-on-k8s-quickstart)
and built on top of it.

The product is a dockerized native webserver implemented in Clojure with
all the abstraction it provides which stats up with no down time.

## Instructions

* Build your Docker image

```bash
docker image build -t clj-on-k8s/hey:0.0.2 .
```

* Assuming you have a Kubernetes set up (and the image placed in the
correct ECR)

```bash
kubectl run hello-clj --image clj-on-k8s/hey:0.0.2 --port 3000 --env="MY_NAME=Clojure"
```

This works for Minikube. This should also work in vanilla Docker.

* Connect to the web server inside the container


## Goals and Rational

### [Original goals](https://github.com/jwhitlark/clj-on-k8s-quickstart)

It's an exciting time.

Clojure has always been a clean and powerful language with nice interop with the JVM

Clojure.spec has added exciting capabilities that are very relevant to microservices.

With JDK9, the JVM has become modular, allowing us to greatly shrink the size of our images.

With JDK10, the JVM has become a much better docker citizen.

With Kubernetes, we now have a great platform to build microservices on.

Istio on K8s gives us new ways to easily visualize, monitor and trace our traffic flows between services. It also simplifies many security tasks, and gives us new abilities to control traffic.

### Extra goals

Graal makes it possible extra-fast native Clojure programs


## Important changes

I needed to switch from Ring/Jetty to HttpKit because of an Eclipse project
class not found by Graal that I could not resolve. The class was indeed present
in the produced Jar, but it lools like Graal does not support something
related to it.

I needed to get rid of several signature checks that I had no time to fix.


## Thanks!

* [The original work](https://github.com/jwhitlark/clj-on-k8s-quickstart) and trainsitively those thanked there.
* [Graal team](https://github.com/oracle/graal)
* The guys on the [Clojure subreddit](https://www.reddit.com/r/Clojure/)
* ... and many more!!!