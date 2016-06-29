## MessagePack Vapi

### Overview

This repository contains Vala language bindings for the MessagePack library as
well as examples to show its use.

The MessagePack library for binary serialization:
    <http://msgpack.org/>

The Vala langeuage:
    <http://live.gnome.org/Vala/>

For bug reports, or enhancement requests:
    <https://github.com/geoffjay/msgpack-vala/issues>

Usage
-----

To use `msgpack.vapi` simply include the `using MsgPack;` statement at the top
of your vala code and compile your application with `--pkg=msgpack` and the
vapi in either the configured system vapidir or using the
`--vapidir=/path/to/your/vapidir` option.

Example:

    valac --pkg=msgpack --vapidir=/path/to/vapidir mycode.vala

Licensing
---------

Please see the LICENSE file.
