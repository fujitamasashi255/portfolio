#!/bin/bash

platex -halt-on-error -shell-escape -interaction=batchmode input && dvipdfmx input
