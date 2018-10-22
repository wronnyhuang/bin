# -*- coding: utf-8 -*-
"""
Created on Wed Sep 19 17:39:43 2018

@author: Miguel + Anurag
"""

import imageio
import os
from glob import glob

# path = "C:/Users/pw476kz/Desktop/Research Works/Email - NLP - KGs/CNN_Graphs/WIP Decks/Idenitfying Graph Activity/Graph Pattern Vinnette/"
path = os.getcwd()

# list_images = [[x, int(x.split("_")[2].replace(".JPG",""))] for x in os.listdir(path) if x.endswith(".JPG")]
# list_images = sorted(list_images, key = lambda x: int(x[1]))
# list_images = [a[0] for a in list_images]

list_images = glob(path)
images = []
for filename in list_images:
    images.append(imageio.imread(filename))

imageio.mimsave(list_images[0][:list_images[0].find("_Qtr")]+'_movie_Final.gif', images, 'GIF', duration=2)