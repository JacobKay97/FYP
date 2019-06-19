#!/usr/bin/env python3

import numpy as np
import time
import serial
import pyaudio
import sys
import os
import math
import struct
import socket
import scipy.io
from threading import Timer

CHUNK = 192000
RATE = 192000
CHANNELS = 2
#CHUNKCOUNT = 3

NODE_ID = int(os.environ['ROS_NODE_ID'])
IP_ADDR = os.environ['ROS_IP']
multicast_group = '224.3.29.71'
server_address = ('', 10000)


class SignalRecorder:
  data = np.array([])
  CHUNKCOUNT = 1
  intendedStartT = 0
  actualStartT = 0
  filename = "NODE_" + str(NODE_ID+1)
  def __init__(self):
    self.init_device()


  def init_device(self):
    self.p = pyaudio.PyAudio()
    device_found = False
    attempts = 1
    print("Searching for audio devices")
    while not device_found and attempts < 5:
      for i in range(self.p.get_device_count()):
        info = self.p.get_device_info_by_index(i)
        if "FUNcube" in info["name"]:
          print("Found FUNcube Dongle on index " + str(info["index"]) + ", registering device info")
          self.device_info = info
          return
      # Else device has not been found
      print("FUNcube Dongle has not been found, searching again in 5 seconds...")
      time.sleep(5)
      attempts += 1
    print("Cannot find FUNcube Dongle, exiting")
    sys.exit()

  def prepare_stream(self):
    self.stream = self.p.open(format=pyaudio.paInt16,
                         channels=CHANNELS,
                         rate=RATE,
                         input=True,
                         frames_per_buffer=CHUNK,
                         input_device_index=self.device_info["index"],
                         stream_callback=self.callback)
    print("PreparedStream")

  def start_stream(self):
    self.stream.start_stream()
    self.actualStartT = time.time()
    print("StartedStrem")

  def callback(self, in_data, frame_count, time_info, status):
    print("InHere")
    data = np.fromstring(in_data, dtype=np.int16)
    complex_data = [complex(d[0],d[1]) for d in data.reshape(int(len(data)/2),2)]
    self.data = np.append(self.data,complex_data)
    print(time_info)
    self.CHUNKCOUNT = self.CHUNKCOUNT - 1
    if self.CHUNKCOUNT < 1:
      status = pyaudio.paComplete
     ## self.stop()
    else:
      status = pyaudio.paContinue
    return (data, status)

  def stop(self):
    print("Finishing")
    #print(self.data[0:500])
    self.filename = self.filename + "_I_" + str(self.intendedStartT) + "_A_" + str(self.actualStartT)
    scipy.io.savemat(self.filename,dict(x=self.data))
    self.stream.stop_stream()
    self.stream.close()
    self.p.terminate()


if __name__ == "__main__":
  streamer = SignalRecorder()
  #CHUNKCOUNT = 5
  sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
  sock.bind(server_address)
  group = socket.inet_aton(multicast_group)
  mreq = struct.pack('4sL', group, socket.INADDR_ANY)
  sock.setsockopt(socket.IPPROTO_IP, socket.IP_ADD_MEMBERSHIP, mreq)


  try:
    print('waiting for start signal:')
    data, address = sock.recvfrom(1024)

    sock.sendto(b'ack', address)
    delay = int(data) - time.time()
    time.sleep(delay)
    streamer.intendedStartT = time.time()

    streamer.prepare_stream()
    streamer.start_stream()

  except KeyboardInterrupt:
    streamer.stop()

  while(streamer.CHUNKCOUNT > 0):
      time.sleep(1.1)
      print(streamer.CHUNKCOUNT)

  print('intended start time ', streamer.intendedStartT)
  print('actual start time: ', streamer.actualStartT)

  streamer.stop()
