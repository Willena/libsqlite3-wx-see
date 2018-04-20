libsqlite3-wx-see
=================

[![Build Status](https://travis-ci.org/Willena/libsqlite3-wx-see.svg?branch=master)](https://travis-ci.org/Willena/libsqlite3-wx-see)

This is the sqlite3 library with encryption and auth support. This repo is automaticaly updated once a week, if changes have been made.

This repository is based on the wxsqlite repository (https://github.com/utelle/wxsqlite3.git) and will follow updates that are made in the wxsqlite repo. You can find more info at https://github.com/utelle/wxsqlite3.git

How to build ?
==============

-	Install premake5
-	`premake5 --file=premake5-lin.lua gmake` On linux
-	Inside the build folder you should find Makefiles.
-	`make config=$TYPE verbose=1` on linux. $TYPE must be replaced with one of the following: release_aes128_linux32 release_aes128_linux64 release_aes256_linux32 release_aes256_linux64
-	It will build .so, .a, sqliteshell

Use of the Encryption API
=========================

PRAGMA usage
------------

From the shell or when using it in a project you can use PRAGMA to encrypt or decrypt the database.

##### PRAGMA key

-	example usage: `PRAGMA key='passphrase';`

##### PRAGMA rekey

-	example usage: `PRAGMA rekey='passphrase';`
-	example of decrypting: `PRAGMA rekey='';`

Instruction order to work with encrypted databases
--------------------------------------------------

##### Encrypting a new db

1.	open  
2.	key  
3.	use as usual

##### Opening an encrypted DB

1.	open  
2.	key  
3.	use as usual  

##### Changing the key

1.	open  
2.	key  
3.	rekey  
4.	use as usual  

##### Decrypting

1.	open  
2.	key  
3.	rekey with null  
4.	use as usual

Checking if key was correct
---------------------------

The only way to know if the entered key is the right one is to try some operation on the database. Try for example to select something in the "master" table:`sqlite
SELECT count(*) FROM sqlite_master;
` if it throw an error like "Not a database, the file is encrypted or not a databse" then it means that the key is wrong. If the key is good you should get the number of row in the table "sqlite_master"
