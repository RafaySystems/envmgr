#!/bin/bash

set -ex

code=`wget --server-response http://$url 2>&1 | grep "HTTP/" | awk '{print $2}'`
if [ $code -eq 200 ];
then
   echo -n "false" > rollback
   echo -n "true" > continue
else
   echo -n "true" > rollback
   echo -n "false" > continue
fi
