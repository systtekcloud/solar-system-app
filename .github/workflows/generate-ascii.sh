#/bin/bash
sudo apt-get install cowsay -y
cowsay -f lion "Run for cover, I am a LION....RAWR" >> lion.txt
grep -i "lion" lion.txt
cat lion.txt
ls -ltra
