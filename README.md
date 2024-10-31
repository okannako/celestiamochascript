![(22)](https://github.com/okannako/celestiamochascript/assets/73176377/f005e199-f5f9-4002-a444-e683baa2f01b)

Celestia Mocha Testnet çok uzun zamandır devam ediyor ve Mainnet sonrası da çalışmaya durmadan devam etti. Celestia ekibi geliştirmelerine bu ağ üzerinden devam ediyor. Aşağıda oluşturdğum scriptin kodları var. Çalıştırdğınızda kurmak istediğiniz node'u seçenekler arasından seçip çok kısa sürede kurulmasını sağlayabilirsiniz. Validator, Bridge, Light ve Full Storage nodeların kurulumlarının yanı sıra diğer işlemler için de seçenekler bulunmaktadır.

```
curl -s https://raw.githubusercontent.com/okannako/celestiamochascript/main/nodescript.sh > nodescript.sh && chmod +x nodescript.sh && ./nodescript.sh
```

### bbr Aktif Hale Getirmek (Mutlaka Yapın)
- Aşağıdaki kodları girerek basit bir şekilde aktifleştirebilirsiniz.
```
cd celestia-app
make enable-bbr
```

- Eğer yukarıdaki kodlarda hata alırsanız aşağıdaki kodla aktif hale getirebilirsiniz.
```
sudo modprobe tcp_bbr; \
        echo "net.core.default_qdisc=fq" | sudo tee -a /etc/sysctl.conf; \
        echo "net.ipv4.tcp_congestion_control=bbr" | sudo tee -a /etc/sysctl.conf; \
        sudo sysctl -p; \
```

Kurulumn sırasında veya sonrasında bir şey sormak isterseniz bana Telegram, Mail ve Discord yoluyla ulaşabirsiniz.
