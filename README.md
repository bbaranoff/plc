# plc

sudo pip install scapy
sudo pip install cryptography
git clone https://github.com/qca/open-plc-utils
cd open-plc-utils
make
sudo make install
sudo ldconfig
cd ~/plc
sudo chmod +x attack.sh
sudo chmod +x triggerSniff.py
sudo chmod +x listMacs.py
