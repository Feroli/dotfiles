#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from time import sleep
import datetime
hostname = "google.com"

while True:

   response = os.system("ping -c 1 " + hostname + " > /dev/null")
   if response != 0:
      print hostname, 'WiFi Reset: ' + datetime.datetime.now().strftime("%d-%b-%Y %H:%M:%S.%f")
      os.system("networksetup -setairportpower en0 off && networksetup -setairportpower en0 on")

   sleep(10)

