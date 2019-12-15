#!/usr/bin/env bash

# Zip the lambda functions
rm -r getLambda.zip postLambda.zip
cd get
zip -r ../getLambda.zip index.js
cd ../post
zip -r ../postLambda.zip index.js
cd ..
