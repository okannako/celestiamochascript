#!/bin/bash
echo -e "\033[0;37m"
echo "============================================================================================================"
echo " #####   ####        ####        ####  ####    ######    ##########  ####    ####  ###########   ####  ####"
echo " ######  ####       ######       #### ####    ########   ##########  ####    ####  ####   ####   #### ####"
echo " ####### ####      ###  ###      ########    ####  ####     ####     ####    ####  ####   ####   ########"   
echo " #### #######     ##########     ########   ####    ####    ####     ####    ####  ###########   ########"
echo " ####  ######    ############    #### ####   ####  ####     ####     ####    ####  ####  ####    #### ####"  
echo " ####   #####   ####      ####   ####  ####   ########      ####     ############  ####   ####   ####  ####"
echo " ####    ####  ####        ####  ####   ####    ####        ####     ############  ####    ####  ####   ####"
echo "============================================================================================================"
echo -e '\e[36mTwitter :\e[39m' https://twitter.com/NakoTurk
echo -e '\e[36mGithub  :\e[39m' https://github.com/okannako
echo -e '\e[36mYoutube :\e[39m' https://www.youtube.com/@CryptoChainNakoTurk
echo -e "\e[0m"
sleep 5

echo -e "\e[1m\e[32m Yapmak istediğin şey nedir ? \e[0m" && sleep 2
PS3='Select an action: '
options=(
"Validator Node Yüklemek"
"Validator Node Kontrol"
"Validator Oluşturmak"
"Light Node Yüklemek"
"Bridge Node Yüklemek"
"Full Storage Node Yüklemek"
"Light Node Data Sıfırla"
"Bridge Node Data Sıfırla"
"Full Storage Node Data Sıfırla"
"Light Node ID Nedir ?"
"Bridge Node ID Nedir ?"
"Full Storage Node ID Nedir ?"
"Çıkış")
select opt in "${options[@]}"
do
case $opt in

"Validator Node Yüklemek")

echo -e "\e[1m\e[32m Updates \e[0m" && sleep 2

sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git ncdu -y
sudo apt install make -y
sleep 1

echo -e "\e[1m\e[32m Go Yükleniyor \e[0m" && sleep 2
ver="1.21.1"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
go version && sleep 2

cd $HOME 
rm -rf celestia-app 
git clone https://github.com/celestiaorg/celestia-app.git 
cd celestia-app/ 
APP_VERSION=v1.11.0
git checkout tags/$APP_VERSION -b $APP_VERSION
make install
celestia-appd version && sleep 3

echo "NodeIsmi:"
read NodeIsmi
echo export NodeName=${NodeIsmi} >> $HOME/.bash_profile

celestia-appd init "$NodeIsmi" --chain-id mocha

SEEDS="5d0bf034d6e6a8b5ee31a2f42f753f1107b3a00e@celestia-testnet-seed.itrocket.net:11656"
PEERS="daf2cecee2bd7f1b3bf94839f993f807c6b15fbf@celestia-testnet-peer.itrocket.net:11656,d468354f164a374f9560d6ad46572668020a222e@195.14.6.178:26656,6ed983017167d96c62b166725250940deb783563@65.108.142.147:27656,23711b72518bf5ce249d3f06110858cefc5f294a@94.130.54.216:11656,a98484ac9cb8235bd6a65cdf7648107e3d14dab4@116.202.231.58:12056,ac4df0b6796aed28a3fae0e95f7828c88a341da4@217.160.102.31:26656,5a0de83958f2895cdc6265a441898a54e52a485f@72.46.84.33:26656,3b1e36486b319ab99e7e12a9d56d8031a46e9139@15.235.65.137:26656,8194b4f9c4d558a0a4d4242bce9274892cbfb386@20.250.38.245:26656,ad64e0055d33445ce4b2f953b7910ae63987aeb2@148.113.8.171:33656,edebca7508b70df9659c1293b0d8cbc05c77c91f@65.108.12.253:16007,3e30bcfc55e7d351f18144aab4b0973e9e9bf987@65.108.226.183:11656,85aef6d15d0197baff696b6e31c88e0f21073c59@162.55.245.144:2400,f07813ee16dabdeb370c7ffbdbbc73d9f4db48d5@139.45.205.58:28656,2c0c7aaeac21af6f6cd4f3c561b1a5ea22e39460@62.138.24.120:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.celestia-app/config/config.toml

wget -O $HOME/.celestia-app/config/genesis.json https://testnet-files.itrocket.net/celestia/genesis.json
wget -O $HOME/.celestia-app/config/addrbook.json https://testnet-files.itrocket.net/celestia/addrbook.json

sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.celestia-app/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.celestia-app/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"50\"/" $HOME/.celestia-app/config/app.toml

sed -i 's|minimum-gas-prices =.*|minimum-gas-prices = "0.002utia"|g' $HOME/.celestia-app/config/app.toml

celestia-appd tendermint unsafe-reset-all --home $HOME/.celestia-app

sudo tee <<EOF >/dev/null /etc/systemd/system/celestia-appd.service
[Unit]
Description=Celestia node
After=network-online.target
[Service]
User=root
ExecStart=$(which celestia-appd) start --home $HOME/.celestia-app
Restart=on-failure
RestartSec=5
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable celestia-appd
sudo systemctl start celestia-appd

echo "CüzdanIsmi:"
read CüzdanIsmi
echo export CuzdanIsmi=${CuzdanIsmi} >> $HOME/.bash_profile
celestia-appd keys add $CuzdanIsmi

echo -e '\e[36mBu adımda cüzdanınızla ilgili bilgiler paylaşılır.. >>>LÜTFEN ANLATICI KELİMELERİ YEDEKLEYİN.<<< Yedekleme yaptıktan sonra Enter tuşuna basarak devam edebilirsiniz.\e[39m'
read Enter

echo -e '\e[36mIMPORTANT: Geçerli bloğa senkronizasyonu bekleyin. Kontrol etmek için betiği yeniden başlatın ve ilgili seçeneği seçin.\e[39m'
sleep 7
sudo journalctl -u celestia-appd -f

break
;;

"Validator Node Kontrol")

celestia-appd status 2>&1 | jq .SyncInfo
echo -e '\e[36mÖNEMLİ: "catching_up": false olduğunda, mevcut bloğa erişmişsinizdir ve betiği tekrar çalıştırıp Doğrulayıcı Oluşturabilirsiniz. Doğrulayıcı oluşturmadan önce Discord'da cüzdanınıza bir test jetonu talep ettiğinizden emin olun.\e[39m'
sleep 10

break
;;

"Validator Oluşturmak")

celestia-appd tx staking create-validator \
--amount=1000000utia \
--pubkey=$(celestia-appd tendermint show-validator) \
--moniker=$NodeIsmi \
--chain-id=mocha \
--commission-rate=0.05 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1 \
--from=$CuzdanIsmi \
--gas-adjustment=1.4 \
--gas=auto \
--gas-prices=0.01utia

echo -e '\e[36mÖNEMLİ: Doğrulayıcı oluşturma adımı tamamlandıktan sonra .celestia-appd klasöründeki config klasörünü yedeklediğinizden emin olun..\e[39m'
sleep 10

break
;;

"Light Node Yüklemek")

echo -e "\e[1m\e[32m Updates \e[0m" && sleep 2
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git ncdu -y
sudo apt install make -y
sleep 1

echo -e "\e[1m\e[32m Go Yüklemek \e[0m" && sleep 2
ver="1.21.1"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
go version && sleep 2

cd $HOME 
rm -rf celestia-node 
git clone https://github.com/celestiaorg/celestia-node.git 
cd celestia-node/ 
git checkout tags/v0.14.0 
make build 
make install 
make cel-key 
celestia version && sleep 3
celestia light init --core.ip rpc-mocha.pops.one:26657 --p2p.network mocha

echo -e '\e[36mBu adımda cüzdanınızla ilgili bilgiler paylaşılır.. >>>LÜTFEN ANLATICI KELİMELERİ YEDEKLEYİN.<<< Yedekleme yaptıktan sonra Enter tuşuna basarak devam edebilirsiniz.\e[39m'
read Enter

sudo tee <<EOF >/dev/null /etc/systemd/system/celestia-lightd.service
[Unit]
Description=celestia-light Cosmos daemon
After=network-online.target

[Service]
User=root
ExecStart=/usr/local/bin/celestia light start --core.ip rpc-mocha.pops.one:26657 --core.rpc.port 26657 --core.grpc.port 9090 --keyring.accname my_celes_key --metrics.tls=true --metrics --metrics.endpoint otel.celestia-mocha.com --p2p.network mocha
Restart=on-failure
RestartSec=3
LimitNOFILE=100000

[Install]
WantedBy=multi-user.target
EOF
systemctl enable celestia-lightd
systemctl start celestia-lightd

echo -e '\e[36mÖNEMLİ: /root/.celestia-light-mocha anahtarlar altındaki klasörün yedeklenmesi gerekir.\e[39m'
sleep 7

journalctl -u celestia-lightd.service -f

break
;;

"Bridge Node Yüklemek")

echo -e "\e[1m\e[32m Updates \e[0m" && sleep 2
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git ncdu -y
sudo apt install make -y
sleep 1

echo -e "\e[1m\e[32m Go Yüklemek \e[0m" && sleep 2
ver="1.21.1"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
go version && sleep 2

cd $HOME 
rm -rf celestia-node 
git clone https://github.com/celestiaorg/celestia-node.git 
cd celestia-node/ 
git checkout tags/v0.14.0 
make build 
make install 
make cel-key 
celestia version && sleep 3

echo "NodeIsmi:"
read NodeIsmi
echo export NodeName=${NodeIsmi} >> $HOME/.bash_profile

celestia bridge init --core.ip rpc-mocha.pops.one:26657 --p2p.network mocha

sudo tee /etc/systemd/system/celestia-bridge.service > /dev/null <<EOF
[Unit]
Description=celestia-bridge Cosmos daemon
After=network-online.target

[Service]
User=root
ExecStart=/usr/local/bin/celestia bridge start --core.ip rpc-mocha.pops.one:26657 --core.rpc.port 26657 --core.grpc.port 9090 --keyring.accname my_celes_key --metrics.tls=true --metrics --metrics.endpoint otel.celestia-mocha.com --p2p.network mocha
Restart=on-failure
RestartSec=3
LimitNOFILE=100000

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable celestia-bridge
sudo systemctl start celestia-bridge

echo -e '\e[36mÖNEMLİ: /root/.celestia-bridge-mocha anahtarlar altındaki klasörün yedeklenmesi gerekir.\e[39m'
sleep 7

sudo journalctl -u celestia-bridge.service -f

break
;;

"Full Storage Node Yüklemek")

echo -e "\e[1m\e[32m Updates \e[0m" && sleep 2
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git ncdu -y
sudo apt install make -y
sleep 1

echo -e "\e[1m\e[32m Go Yüklemek \e[0m" && sleep 2
ver="1.21.1"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
go version && sleep 2

cd $HOME 
rm -rf celestia-node 
git clone https://github.com/celestiaorg/celestia-node.git 
cd celestia-node/ 
git checkout tags/v0.14.0 
make build 
make install 
make cel-key 
celestia version && sleep 3

celestia full init --p2p.network mocha

echo -e '\e[36mBu adımda cüzdanınızla ilgili bilgiler paylaşılır.. >>>LÜTFEN ANLATICI KELİMELERİ YEDEKLEYİN.<<< Yedekleme yaptıktan sonra Enter tuşuna basarak devam edebilirsiniz.\e[39m'
read Enter

sudo tee <<EOF >/dev/null /etc/systemd/system/celestia-fulld.service
[Unit]
Description=celestia-fulld Full Node
After=network-online.target

[Service]
User=$USER
ExecStart=/usr/local/bin/celestia full start --core.ip rpc-mocha.pops.one:26657 --core.rpc.port 26657 --core.grpc.port 9090 --keyring.accname my_celes_key --metrics.tls=true --metrics --metrics.endpoint otel.celestia-mocha.com --p2p.network mocha
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

systemctl enable celestia-fulld
systemctl start celestia-fulld


echo -e '\e[36mIMPORTANT: /root/.celestia-full-mocha-4 anahtarlar altındaki klasörün yedeklenmesi gerekir.\e[39m'
sleep 7

journalctl -u celestia-fulld.service -f

break
;;

"Light Node Data Sıfırla")

systemctl stop celestia-lightd
celestia light unsafe-reset-store --p2p.network mocha
systemctl restart celestia-lightd
journalctl -u celestia-lightd.service -f

break
;;

"Bridge Node Data Sıfırla")

sudo systemctl stop celestia-bridge
celestia bridge unsafe-reset-store --p2p.network mocha
sudo systemctl restart celestia-bridge
sudo journalctl -u celestia-bridge.service -f

break
;;

"Full Storage Node Data Sıfırla")

systemctl stop celestia-fulld
celestia full unsafe-reset-store --p2p.network mocha
systemctl restart celestia-fulld
journalctl -u celestia-fulld.service -f

break
;;

"Light Node ID Nedir ?")

AUTH_TOKEN=$(celestia light auth admin --p2p.network mocha)

curl -X POST \
     -H "Authorization: Bearer $AUTH_TOKEN" \
     -H 'Content-Type: application/json' \
     -d '{"jsonrpc":"2.0","id":0,"method":"p2p.Info","params":[]}' \
     http://localhost:26658

break
;;

"Bridge Node ID Nedir ?")

AUTH_TOKEN=$(celestia bridge auth admin --p2p.network mocha)

curl -X POST \
     -H "Authorization: Bearer $AUTH_TOKEN" \
     -H 'Content-Type: application/json' \
     -d '{"jsonrpc":"2.0","id":0,"method":"p2p.Info","params":[]}' \
     http://localhost:26658

break
;;

"Full Storage Node ID Nedir ?")

AUTH_TOKEN=$(celestia full auth admin --p2p.network mocha)

curl -X POST \
     -H "Authorization: Bearer $AUTH_TOKEN" \
     -H 'Content-Type: application/json' \
     -d '{"jsonrpc":"2.0","id":0,"method":"p2p.Info","params":[]}' \
     http://localhost:26658

break
;;

"Exit")
exit
;;
*) echo "invalid option";;
esac
done
done
