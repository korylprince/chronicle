#!/bin/bash

path=/tmp/$(uuidgen)

echo Using $path

mkdir $path

export GOPATH=$path

echo Go Getting github.com/korylprince/getpwd
go get "github.com/korylprince/getpwd"

echo Go Getting github.com/korylprince/macserial
go get "github.com/korylprince/macserial"

echo Go Getting github.com/kelseyhightower/envconfig
go get "github.com/kelseyhightower/envconfig"

echo Go Getting github.com/DHowett/go-plist
go get "github.com/DHowett/go-plist"

echo Building
go build -o chronicle ../client/*.go

echo Cleaning Up
rm -Rf $path
