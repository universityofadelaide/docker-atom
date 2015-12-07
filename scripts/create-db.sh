#!/bin/bash
# Pour créer notre base de données

mysql -uroot -e "CREATE DATABASE atom CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
