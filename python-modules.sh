#!/bin/bash -xe

#install needed packages
sudo pip3 install --only-binary :all: install pandas==1.2.5 aiobotocore==1.1.2 s3fs koalas==1.8.2 seaborn==0.11.2 boto3==1.20.24 logomaker==0.8 numpy==1.21.4
sudo yum remove python37-numpy -y
sudo pip3 uninstall numpy -y
sudo pip3 install numpy --upgrade