#!/bin/bash

# Used to install initial set of packages on Travis CI server.

set -ex

# Lets install the dependencies that are not vendored in anymore.
go get -d golang.org/x/net/context
go get -d google.golang.org/grpc

pushd $GOPATH/src/google.golang.org/grpc
  git checkout v1.8.2
popd

expected="context
github.com/dgraph-io/dgraph/protos/api
github.com/dgraph-io/dgraph/y
github.com/dgraph-io/dgraph/vendor/github.com/gogo/protobuf/proto
github.com/dgraph-io/dgraph/vendor/github.com/pkg/errors
google.golang.org/grpc/codes
google.golang.org/grpc/status
math/rand
sync"

got=$(go list -f '{{ join .Imports "\n" }}' github.com/dgraph-io/dgraph/client)

if [ "$got" != "$expected" ]; then
  echo "Imports for Go client didn't match."
  echo -e "\nExpected, Got\n"
  diff -y <(echo "$expected") <(echo "$got")
  exit 1
fi
