{ stdenv
, lib
, fetchurl
}:
stdenv.mkDerivation {
  pname = "smartdns-rules-adrules";
  version = "20231115";

  src = fetchurl {
    url = "https://github.com/Cats-Team/AdRules/blob/f33359a5f2555c4a36df21e9d25af05b24f4fd08/smart-dns.conf";
    sha256 = "sha256-1rr79ADVyDJh4zitR29i9xWCMLAj2w3dHiACbztSpdQ=";
  };

  unpackPhase = ''
    runHook preUnpack
  '';

  installPhase = ''
    install -Dm644 $src $out/etc/smartdns/adrules-smartdns.conf
  '';

  meta = with lib; {
    description = "List for blocking ads in the Chinese region";
    homepage = "https://adrules.top";
    license = licenses.unlicense;
  };
}