{ pkgs, ... }:{
  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "10.0.0.2/24" "fdc9:281f:04d7:9ee9::2/64" ];
      dns = [ "10.0.0.1" "fdc9:281f:04d7:9ee9::1" ];
      privateKeyFile = "/home/dan/wireguard-keys/private";
      
      peers = [
        {
          publicKey = "u+eaiU6StocT1FyiWMuae6a24eV8zm73xH+363b0BSs=";
          allowedIPs = [ "0.0.0.0/0" "::/0" ];
          endpoint = "192.168.1.16:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
