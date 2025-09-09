import numpy as np
import keras
import tensorflow as tf

import keras_cv
from keras_cv import bounding_box
from keras_cv import visualization

SPLIT_RATIO = 0.2
BATCH_SIZE = 4
LEARNING_RATE = 0.001
EPOCH = 5
GLOBAL_CLIPNORM = 10.0

# Picks Data to train on, creates train/test split
def loadData:
  # For now we will use FS0001 for train and FS0002 for test
  train_paths = []
  for image in os.listdir("./Data/FS0001/frames/"):
    train_paths.append({
      "path": "./Data/FS0001/",
      "image": image
      "box": []
    })
  test_paths = []
  for image in os.listdir("./Data/FS0002/frames/"):
    test_paths.append({
      "path": "./Data/FS0002/",
      "image": image
      "box": []
    })
  train_data = addBoxes(train_paths)
  test_data = addBoxes(test_paths)
  return train_data, test_data


# Given an array of dictionariers for data, for each fills out the bounding box information
def addBoxes(path_arr):
  for pdict in path_arr:
    frame_num = int(pdict["image"].removeSuffix(".jpg"))
    with open(pdict["path"] + "MC/frames.txt") as f:
      line_num = frame_num - int(next(f).strip()) + 1
    with open(pdict["path"] + "MC/boxes.txt") as f:
      for i in range(line_num - 1):
        next(f)
      pdict["box"] = int(next(f).strip())

def train:

def test:
  