#!/bin/sh
iverilog -g2012 -o decoder LDPC.v tb.v; ./decoder
