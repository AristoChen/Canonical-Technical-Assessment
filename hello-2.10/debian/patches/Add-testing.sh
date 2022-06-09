Description: Add testing.sh to echo message after install

 .
 hello (2.10-2ubuntu3) eoan; urgency=low
 .
   * Added a testing.sh which will print the message "this is
     a test from WeiMing Chen" after package is installed.
Author: WeiMing Chen <wmchen.aristo@gmail.com>

---
The information above should follow the Patch Tagging Guidelines, please
checkout http://dep.debian.net/deps/dep3/ to learn about the format. Here
are templates for supplementary fields that you might want to add:

Origin: <vendor|upstream|other>, <url of original patch>
Bug: <url in upstream bugtracker>
Bug-Debian: https://bugs.debian.org/<bugnumber>
Bug-Ubuntu: https://launchpad.net/bugs/<bugnumber>
Forwarded: <no|not-needed|url proving that it has been forwarded>
Reviewed-By: <name and email of someone who approved the patch>
Last-Update: 2022-06-09

--- /dev/null
+++ hello-2.10/testing.sh
@@ -0,0 +1,5 @@
+#!/bin/bash
+
+set -e -x
+
+echo this is a test from WeiMing Chen
