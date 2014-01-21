#!/bin/sh

mkdir_if_missing() {
	test -d $1 || mkdir -p $1
}
