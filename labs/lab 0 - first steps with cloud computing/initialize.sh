
pip3 install Cython
sudo yum install -y python3-devel.x86_64
cd cython_code &&\
python3 setup.py build_ext --inplace
chmod -R 777 ./