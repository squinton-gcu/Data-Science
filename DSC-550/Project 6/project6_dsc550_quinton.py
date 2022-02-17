# -*- coding: utf-8 -*-
"""Project6_DSC550_Quinton.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1WKLAN2C9FeVoyvE2Yl429VlUymiJRlTS
"""

from google.colab import drive

drive.mount('/content/gdrive')

from keras.preprocessing.image import array_to_img, img_to_array, load_img
#(Raikote, 2021)
img = load_img('/content/gdrive/MyDrive/project 6/Train/Normal/N1.jpg')
x = img_to_array(img)
x = x.reshape((1,) + x.shape)  
x.shape

#(Abadi et. al., 2015)
import tensorflow as tf

"""## Determine number of convolutional layers"""

# (Phan, 2020)
model3 = tf.keras.models.Sequential([
# This is the first convolution
tf.keras.layers.Conv2D(16, (3,3), activation='relu', input_shape=(1000, 1000, 3)),
tf.keras.layers.MaxPooling2D(2, 2),
# The second convolution
tf.keras.layers.Conv2D(32, (3,3), activation='relu'),
tf.keras.layers.MaxPooling2D(2,2),
# The third convolution
tf.keras.layers.Conv2D(64, (3,3), activation='relu'),
tf.keras.layers.MaxPooling2D(2,2),
# Flatten the results to feed into a DNN
tf.keras.layers.Flatten(),
# 512 neuron hidden layer
tf.keras.layers.Dense(512, activation='relu'),
tf.keras.layers.Dense(1, activation='sigmoid')])

# (Phan, 2020)
model4 = tf.keras.models.Sequential([
# This is the first convolution
tf.keras.layers.Conv2D(16, (3,3), activation='relu', input_shape=(1000, 1000, 3)),
tf.keras.layers.MaxPooling2D(2, 2),
# The second convolution
tf.keras.layers.Conv2D(32, (3,3), activation='relu'),
tf.keras.layers.MaxPooling2D(2,2),
# The third convolution
tf.keras.layers.Conv2D(64, (3,3), activation='relu'),
tf.keras.layers.MaxPooling2D(2,2),
# The fourth convolution
tf.keras.layers.Conv2D(64, (3,3), activation='relu'),
tf.keras.layers.MaxPooling2D(2,2),
# Flatten the results to feed into a DNN
tf.keras.layers.Flatten(),
# 512 neuron hidden layer
tf.keras.layers.Dense(512, activation='relu'),
tf.keras.layers.Dense(1, activation='sigmoid')])

# (Phan, 2020)
model5 = tf.keras.models.Sequential([
# This is the first convolution
tf.keras.layers.Conv2D(16, (3,3), activation='relu', input_shape=(1000, 1000, 3)),
tf.keras.layers.MaxPooling2D(2, 2),
# The second convolution
tf.keras.layers.Conv2D(32, (3,3), activation='relu'),
tf.keras.layers.MaxPooling2D(2,2),
# The third convolution
tf.keras.layers.Conv2D(64, (3,3), activation='relu'),
tf.keras.layers.MaxPooling2D(2,2),
# The fourth convolution
tf.keras.layers.Conv2D(64, (3,3), activation='relu'),
tf.keras.layers.MaxPooling2D(2,2),
# # The fifth convolution
tf.keras.layers.Conv2D(64, (3,3), activation='relu'),
tf.keras.layers.MaxPooling2D(2,2),
# Flatten the results to feed into a DNN
tf.keras.layers.Flatten(),
# 512 neuron hidden layer
tf.keras.layers.Dense(512, activation='relu'),
tf.keras.layers.Dense(1, activation='sigmoid')])

# (Phan, 2020)
model6 = tf.keras.models.Sequential([
# This is the first convolution
tf.keras.layers.Conv2D(16, (3,3), activation='relu', input_shape=(1000, 1000, 3)),
tf.keras.layers.MaxPooling2D(2, 2),
# The second convolution
tf.keras.layers.Conv2D(32, (3,3), activation='relu'),
tf.keras.layers.MaxPooling2D(2,2),
# The third convolution
tf.keras.layers.Conv2D(64, (3,3), activation='relu'),
tf.keras.layers.MaxPooling2D(2,2),
# The fourth convolution
tf.keras.layers.Conv2D(64, (3,3), activation='relu'),
tf.keras.layers.MaxPooling2D(2,2),
# # The fifth convolution
tf.keras.layers.Conv2D(64, (3,3), activation='relu'),
tf.keras.layers.MaxPooling2D(2,2),
# # The sixth convolution
tf.keras.layers.Conv2D(64, (3,3), activation='relu'),
tf.keras.layers.MaxPooling2D(2,2),
# Flatten the results to feed into a DNN
tf.keras.layers.Flatten(),
# 512 neuron hidden layer
tf.keras.layers.Dense(512, activation='relu'),
tf.keras.layers.Dense(1, activation='sigmoid')])

# (Phan, 2020)
model7 = tf.keras.models.Sequential([
# This is the first convolution
tf.keras.layers.Conv2D(16, (3,3), activation='relu', input_shape=(1000, 1000, 3)),
tf.keras.layers.MaxPooling2D(2, 2),
# The second convolution
tf.keras.layers.Conv2D(32, (3,3), activation='relu'),
tf.keras.layers.MaxPooling2D(2,2),
# The third convolution
tf.keras.layers.Conv2D(64, (3,3), activation='relu'),
tf.keras.layers.MaxPooling2D(2,2),
# The fourth convolution
tf.keras.layers.Conv2D(64, (3,3), activation='relu'),
tf.keras.layers.MaxPooling2D(2,2),
# # The fifth convolution
tf.keras.layers.Conv2D(64, (3,3), activation='relu'),
tf.keras.layers.MaxPooling2D(2,2),
# # The sixth convolution
tf.keras.layers.Conv2D(64, (3,3), activation='relu'),
tf.keras.layers.MaxPooling2D(2,2),
# # The seventh convolution
tf.keras.layers.Conv2D(64, (3,3), activation='relu'),
tf.keras.layers.MaxPooling2D(2,2),
# Flatten the results to feed into a DNN
tf.keras.layers.Flatten(),
# 512 neuron hidden layer
tf.keras.layers.Dense(512, activation='relu'),
tf.keras.layers.Dense(1, activation='sigmoid')])

model3.summary()

model4.summary()

model5.summary()

model6.summary()

model7.summary()

# (Phan, 2020)
model3.compile(loss='binary_crossentropy',
optimizer=tf.keras.optimizers.RMSprop(lr=0.001),
metrics='accuracy')

# (Phan, 2020)
model4.compile(loss='binary_crossentropy',
optimizer=tf.keras.optimizers.RMSprop(lr=0.001),
metrics='accuracy')

# (Phan, 2020)
model5.compile(loss='binary_crossentropy',
optimizer=tf.keras.optimizers.RMSprop(lr=0.001),
metrics='accuracy')

# (Phan, 2020)
model6.compile(loss='binary_crossentropy',
optimizer=tf.keras.optimizers.RMSprop(lr=0.001),
metrics='accuracy')

# (Phan, 2020)
model7.compile(loss='binary_crossentropy',
optimizer=tf.keras.optimizers.RMSprop(lr=0.001),
metrics='accuracy')

batch_size = 6
#(Sorokina, 2019)
# this is the augmentation configuration we will use for training
train_datagen = tf.keras.preprocessing.image.ImageDataGenerator(
        rescale=1./255)

# this is the augmentation configuration we will use for testing:
# only rescaling
test_datagen = tf.keras.preprocessing.image.ImageDataGenerator(rescale=1./255)

# this is a generator that will read pictures found in subfolers of 'data/train', and indefinitely generate
# batches of augmented image data
train_generator = train_datagen.flow_from_directory(
        '/content/gdrive/MyDrive/project 6/Train/',  # this is the target directory
        target_size=(1000,1000),  # all images will be resized to 300x300
        batch_size=batch_size,
        class_mode='binary')  # since we use binary_crossentropy loss, we need binary labels

# this is a similar generator, for validation data
validation_generator = test_datagen.flow_from_directory(
        '/content/gdrive/MyDrive/project 6/Validation/',
        target_size=(1000,1000),
        batch_size=batch_size,
        class_mode='binary')

#history = model3.fit(train_generator,
#steps_per_epoch=1,
#epochs=15,
#verbose=1,
#validation_data = validation_generator,
#validation_steps=8)

# (Phan, 2020)
history2 = model4.fit(train_generator,
steps_per_epoch=2,
epochs=15,
verbose=1,
validation_data = validation_generator,
validation_steps=8)

# (Phan, 2020)
history3 = model5.fit(train_generator,
steps_per_epoch=2,
epochs=15,
verbose=1,
validation_data = validation_generator,
validation_steps=8)

# (Phan, 2020)
history4 = model6.fit(train_generator,
steps_per_epoch=2,
epochs=15,
verbose=1,
validation_data = validation_generator,
validation_steps=8)

# (Phan, 2020)
history5 = model7.fit(train_generator,
steps_per_epoch=2,
epochs=15,
verbose=1,
validation_data = validation_generator,
validation_steps=8)

#result1 = model3.evaluate(validation_generator)
#result1

result2 = model4.evaluate(validation_generator)
result2

result3 = model5.evaluate(validation_generator)
result3

result4 = model6.evaluate(validation_generator)
result4

result5 = model7.evaluate(validation_generator)
result5

model4.metrics_names

result5[1]

from matplotlib import pyplot as py 
accuracy_list = [result2[1], result3[1], result4[1], result5[1]]
names = ["4 layers", "5 layers", "6 layers", "7 layers"]
py.bar(names, accuracy_list)
py.show()

"""## Test for optimum dense layer / hidden layer"""

# (Phan, 2020)
model8 = tf.keras.models.Sequential([
# This is the first convolution
tf.keras.layers.Conv2D(16, (3,3), activation='relu', input_shape=(1000, 1000, 3)),
tf.keras.layers.MaxPooling2D(2, 2),
# The second convolution
tf.keras.layers.Conv2D(32, (3,3), activation='relu'),
tf.keras.layers.MaxPooling2D(2,2),
# The third convolution
tf.keras.layers.Conv2D(64, (3,3), activation='relu'),
tf.keras.layers.MaxPooling2D(2,2),
# The fourth convolution
tf.keras.layers.Conv2D(64, (3,3), activation='relu'),
tf.keras.layers.MaxPooling2D(2,2),
# Flatten the results to feed into a DNN
tf.keras.layers.Flatten(),
# 512 neuron hidden layer
tf.keras.layers.Dense(64, activation='relu'),
tf.keras.layers.Dense(1, activation='sigmoid')])

# (Phan, 2020)
model9 = tf.keras.models.Sequential([
# This is the first convolution
tf.keras.layers.Conv2D(16, (3,3), activation='relu', input_shape=(1000, 1000, 3)),
tf.keras.layers.MaxPooling2D(2, 2),
# The second convolution
tf.keras.layers.Conv2D(32, (3,3), activation='relu'),
tf.keras.layers.MaxPooling2D(2,2),
# The third convolution
tf.keras.layers.Conv2D(64, (3,3), activation='relu'),
tf.keras.layers.MaxPooling2D(2,2),
# The fourth convolution
tf.keras.layers.Conv2D(64, (3,3), activation='relu'),
tf.keras.layers.MaxPooling2D(2,2),
# Flatten the results to feed into a DNN
tf.keras.layers.Flatten(),
# 512 neuron hidden layer
tf.keras.layers.Dense(128, activation='relu'),
tf.keras.layers.Dense(1, activation='sigmoid')])

# (Phan, 2020)
model10 = tf.keras.models.Sequential([
# This is the first convolution
tf.keras.layers.Conv2D(16, (3,3), activation='relu', input_shape=(1000, 1000, 3)),
tf.keras.layers.MaxPooling2D(2, 2),
# The second convolution
tf.keras.layers.Conv2D(32, (3,3), activation='relu'),
tf.keras.layers.MaxPooling2D(2,2),
# The third convolution
tf.keras.layers.Conv2D(64, (3,3), activation='relu'),
tf.keras.layers.MaxPooling2D(2,2),
# The fourth convolution
tf.keras.layers.Conv2D(64, (3,3), activation='relu'),
tf.keras.layers.MaxPooling2D(2,2),
# Flatten the results to feed into a DNN
tf.keras.layers.Flatten(),
# 512 neuron hidden layer
tf.keras.layers.Dense(256, activation='relu'),
tf.keras.layers.Dense(1, activation='sigmoid')])

# (Phan, 2020)
model8.compile(loss='binary_crossentropy',
optimizer=tf.keras.optimizers.RMSprop(lr=0.001),
metrics='accuracy')
model9.compile(loss='binary_crossentropy',
optimizer=tf.keras.optimizers.RMSprop(lr=0.001),
metrics='accuracy')
model10.compile(loss='binary_crossentropy',
optimizer=tf.keras.optimizers.RMSprop(lr=0.001),
metrics='accuracy')

# (Phan, 2020)
history8 = model8.fit(train_generator,
steps_per_epoch=2,
epochs=15,
verbose=1,
validation_data = validation_generator,
validation_steps=8)

# (Phan, 2020)
history9 = model9.fit(train_generator,
steps_per_epoch=2,
epochs=15,
verbose=1,
validation_data = validation_generator,
validation_steps=8)

# (Phan, 2020)
history10 = model10.fit(train_generator,
steps_per_epoch=2,
epochs=15,
verbose=1,
validation_data = validation_generator,
validation_steps=8)

result8 = model8.evaluate(validation_generator)
result8

result9 = model9.evaluate(validation_generator)
result9

result10 = model10.evaluate(validation_generator)
result10

from matplotlib import pyplot as py 
accuracy_list = [result2[1], result8[1], result9[1], result10[1]]
names = ["512", "64", "128", "256"]
py.bar(names, accuracy_list)
py.show()

result9[1]

