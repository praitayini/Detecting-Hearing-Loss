# Detecting-Hearing-Loss

A feasible hardware for acquiring EEG Signals was designed. We used EEG-Analog ASM from Olimex and DAQ from National Instruments.

The wavelet.m file uses continuous wavelet transform and instantaneous energy techniques to detect wave V from EEG obtained. The wave V marker had been introduced as the most prominent and robust wave that has been used as indicator of hearing loss. 

The file main.py is artificial neural network was used. The database with normal ABR signal was trained. The test data was tested using the trained model. There was an accuracy of 98.2% accuracy with the trained model.

It was also tested with signals taken from phyisonet database. https://www.physionet.org/physiobank/database/earndb/
