#!/bin/bash

/create-tematres-db.sh

exec supervisord -n
