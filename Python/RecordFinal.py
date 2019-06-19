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
import wave
import scipy.io
from threading import Timer

CHUNK = 38400
TOTAL_SEC = 30
RATE = 192000
CHANNELS = 2

NODE_ID = int(os.environ['ROS_NODE_ID'])
IP_ADDR = os.environ['ROS_IP']
multicast_group = '224.3.29.71'
server_address = ('', 10000)

class SignalRecorder:
  data = []
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

  def record(self):
    self.stream = self.p.open(format=pyaudio.paInt16,
                         channels=CHANNELS,
                         rate=RATE,
                         input=True,
                         frames_per_buffer=CHUNK,
                         input_device_index=self.device_info["index"])
    self.actualStartT = time.time()
    for _ in range(int(RATE / CHUNK * TOTAL_SEC)):
        audio = self.stream.read(CHUNK)
        self.data.append(audio)
    return None

  def stop(self):
    print("Finishing")
    self.stream.stop_stream()
    self.stream.close()
    self.p.terminate()
    self.filename = self.filename + "_I_" + str(self.intendedStartT) + "_A_" + str(self.actualStartT) + ".wav"
    waveFile = wave.open(self.filename, 'wb')
    waveFile.setnchannels(CHANNELS)
    waveFile.setsampwidth(self.p.get_sample_size(pyaudio.paInt16))
    waveFile.setframerate(RATE)
    waveFile.writeframes(b''.join(self.data))
    waveFile.close()

if __name__ == "__main__":
  streamer = SignalRecorder()
  sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
  sock.bind(server_address)
  group = socket.inet_aton(multicast_group)
  mreq = struct.pack('4sL', group, socket.INADDR_ANY)
  sock.setsockopt(socket.IPPROTO_IP, socket.IP_ADD_MEMBERSHIP, mreq)

  try:
    print('waiting for start signal:')
    data, address = sock.recvfrom(1024)

    sock.sendto(b'got', address)
    delay = int(data) - time.time()
    time.sleep(delay)
    streamer.intendedStartT = time.time()
    streamer.record()

  except KeyboardInterrupt:
    streamer.stop()

  print(time.time())
  print('intended start time ', streamer.intendedStartT)
  print('actual start time: ', streamer.actualStartT)
  streamer.stop()
