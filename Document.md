This is a document covers the following
- Install the prerequisites and download source code from debian package
- Add a testing.sh which will be executed after package unpacked.
- Build the package
- Upload the package to PPA
- Test result

---

## Install the prerequisites and download source code from debian package

### Install the prerequisites
```shell
$ sudo apt install ubuntu-dev-tools
$ sudo apt install debhelper
```

### Download source code from debian package
We use the pakage called `hello` as example in this document, please replace it with the package name that you want to clone.
```shell
$ pull-lp-source hello focal
```

Note: If you do not specify a release such as `focal`, it will automatically get the package from the development version.

---

## Add a testing.sh which will be executed after package unpacked

### Create testing.sh
After cloned the source code, you should be able to see the following files.

```shell
$ ls -l
total 728
drwxr-xr-x 13 root root   4096  六   9 16:13 hello-2.10
-rw-r--r--  1 root root   6560  六   9 16:13 hello_2.10-2ubuntu2.debian.tar.xz
-rw-r--r--  1 root root   1847  六   9 16:13 hello_2.10-2ubuntu2.dsc
-rw-r--r--  1 root root 725946  六   9 16:13 hello_2.10.orig.tar.gz
```

Move to the `hello-2.10` directory
```shell
$ cd hello-2.10
```

then we create the testing.sh
```shell
$ cat > testing.sh << EOF
#!/bin/bash

set -e -x

echo this is a test from WeiMing Chen
EOF
```

Make it able to be executed
```shell
$ chmod 755 testing.sh
```

### Edit debian/postinst
The `debian/postinst` is a maintainer scripts, it will be executed after package is unpacked, please refer to this [website](https://www.debian.org/doc/debian-policy/ch-maintainerscripts.html) for more information.

In this case, the `hello` package does not have a `debian/postinst` originally, so we can use the following command to create one.

```shell
$ cat > debian/postinst << EOF
#!/bin/bash

set -e

/usr/bin/testing.sh

exit 0

EOF
```

### Edit debian/install
This will copy the `testing.sh` to the place that we want when package installed.
```shell
$ echo "testing.sh /usr/bin" >> debian/install
```

---

## Build the package

### Commit the change
Use the following command to commit what we have changed.
```shell
$ dpkg-source --commit
```

### Edit debian/changelog
Prepend information about the changes to the `debian/changelog` to indicate what you have changed. For example:

```
hello (2.10-2ubuntu3) focal; urgency=low

 * Added a testing.sh which will print the message "this is
   a test from WeiMing Chen" after package is unpacked.

-- WeiMing Chen <wmchen.aristo@gmail.com>  Thu, 09 Jun 2022 14:43:12 +0800
```

### Build package
Use the following command to build package
```shell
$ debuild -S
```

If you haven't generate a GPG key for your account, please do it first before build the package.

```
$ gpg --full-generate-key
```

---

## Upload the package to PPA

### Upload key to ubuntu key server
 - Step 1 Open Passwords and Encryption Keys.

 - Step 2 Select the My Personal Keys tab, select your key.

 - Step 3 Select Remote > Sync and Publish Keys from the menu. Choose the Sync button. (You may need to add hkp://keyserver.ubuntu.com to your key servers if you are not using Ubuntu.)

It can take up to thirty minutes before your key is available to Launchpad. After that time, you're ready to import your new key into Launchpad!

Note: the above guide for uploading key was copied from [here](https://launchpad.net/+help-registry/openpgp-keys.html#publish).

### Import an OpenPGP key
Go to your launchpad personal homepage and click the edit button next to `OpenPGP keys`, then you will be asked to provide the fingerprint of your key. You can get it by using the following command.

```shell
$ gpg --fingerprint
```

### Upload the package
After build the package, you should be able to see these files in the parent directory.

```shell
$ ls -l
total 780
drwxr-xr-x 13 aristo aristo   4096  六   9 10:20 hello-2.10
-rw-r--r--  1 aristo aristo   6560  六   9 09:48 hello_2.10-2ubuntu2.debian.tar.xz
-rw-r--r--  1 aristo aristo    927  六   9 09:48 hello_2.10-2ubuntu2.dsc
-rw-r--r--  1 aristo aristo   1837  六   9 09:48 hello_2.10-2ubuntu2_source.build
-rw-r--r--  1 aristo aristo   5449  六   9 09:48 hello_2.10-2ubuntu2_source.buildinfo
-rw-r--r--  1 aristo aristo   1270  六   9 09:48 hello_2.10-2ubuntu2_source.changes
-rw-r--r--  1 aristo aristo   7180  六   9 14:54 hello_2.10-2ubuntu3.debian.tar.xz
-rw-r--r--  1 aristo aristo   1478  六   9 14:54 hello_2.10-2ubuntu3.dsc
-rw-r--r--  1 aristo aristo   2199  六   9 14:54 hello_2.10-2ubuntu3_source.build
-rw-r--r--  1 aristo aristo   6022  六   9 14:54 hello_2.10-2ubuntu3_source.buildinfo
-rw-r--r--  1 aristo aristo   1886  六   9 14:54 hello_2.10-2ubuntu3_source.changes
-rw-r--r--  1 aristo aristo 725946  六   9 09:42 hello_2.10.orig.tar.gz
```

then simply run `dput ppa:aristochen/ppa-myhello hello_2.10-2ubuntu3_source.changes`, then if everything is good, you should be able to receive an email regarding the upload result.

---

## Test Result

### Add the PPA to your system
```shell
$ sudo add-apt-repository ppa:aristochen/ppa-myhello
$ sudo apt update
```

Note: it may failed when you try to add the PPA to your system, and if the error message is like this `Error: signing key fingerprint does not exist`, then you may need to wait for a while and try again, because PPA will create a new key(Launchpad PPA for YOUR NAME) for you and signed the related files with this new key.

### Ready to download from your PPA and test

```shell
$ sudo apt install hello
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following package was automatically installed and is no longer required:
  libfwupdplugin1
Use 'sudo apt autoremove' to remove it.
The following NEW packages will be installed:
  hello
0 upgraded, 1 newly installed, 0 to remove and 4 not upgraded.
Need to get 52.3 kB of archives.
After this operation, 284 kB of additional disk space will be used.
Get:1 http://ppa.launchpad.net/aristochen/ppa-myhello/ubuntu focal/main amd64 hello amd64 2.10-2ubuntu3 [52.3 kB]
Fetched 52.3 kB in 1s (39.4 kB/s)
Selecting previously unselected package hello.
(Reading database ... 208020 files and directories currently installed.)
Preparing to unpack .../hello_2.10-2ubuntu3_amd64.deb ...
Unpacking hello (2.10-2ubuntu3) ...
Setting up hello (2.10-2ubuntu3) ...
+ echo this is a test from WeiMing Chen
this is a test from WeiMing Chen
Processing triggers for man-db (2.9.1-1) ...
Processing triggers for install-info (6.7.0.dfsg.2-5) ...


$ dpkg -S testing.sh; testing.sh
hello: /usr/bin/testing.sh
+ echo this is a test from WeiMing Chen
this is a test from WeiMing Chen
```



