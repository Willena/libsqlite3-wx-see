# **WARNING SQLite 3.31.1 is the last version of this repository. It will not be updated anymore. The repo has now moved to https://github.com/utelle/SQLite3MultipleCiphers**

libsqlite3-wx-see
=================

[![Build Status](https://travis-ci.org/Willena/libsqlite3-wx-see.svg?branch=master)](https://travis-ci.org/Willena/libsqlite3-wx-see)

This is the sqlite3 library with encryption and auth support. This repo is automaticaly updated once a week, if changes have been made.

This repository is based on the wxsqlite repository (https://github.com/utelle/wxsqlite3.git) and will follow updates that are made in the wxsqlite repo. You can find more info at https://github.com/utelle/wxsqlite3.git

How to build ?
==============

-	Install premake5 [from here] (https://premake.github.io/download.html)
-	`premake5 --file=premake5-linux.lua gmake` on "linux" systems. For windows builds use the initial premake5.lua file.
-	Inside the ```build``` folder you should find Makefiles.
-   If you want the default encryption scheme to be something else than CHACHA20 please read the [readme-2.md](readme-2.md) and make changes in the config.gcc file in the build folder
-	`make config=$TYPE verbose=1` on linux. `$TYPE` must be replaced with one of the following: `release_linux32` or `release_linux64` or `release_linux32`or `release_linux64`
-	It will build .so, .a and the sqliteshell. You can find the result in the ```bin-gcc``` folder

Use of the Encryption API
=========================

PRAGMA usage
------------

The basic usage with the default encryption scheme is discribed below. For more advanced usage and other encryption scheme, please read  [readme-2.md](readme-2.md)
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

The only way to know if the entered key is the right one is to try some operation on the database. Try for example to select something in the "master" table:
```sqlite
SELECT count(*) FROM sqlite_master;
```

 If it throw an error like "*Not a database, the file is encrypted or not a databse*" then it means that the key is wrong. If the key is good you should get the number of row in the table "sqlite_master"
