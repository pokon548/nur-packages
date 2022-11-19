{ lib
, fetchFromGitHub
, mkYarnPackage
, fetchYarnDeps
, buildGoModule
, makeWrapper
, v2ray
, v2ray-geoip
, v2ray-domain-list-community
, symlinkJoin
}:
let
  pname = "v2raya";
  version = "unstable-2022-11-17";
  src = fetchFromGitHub {
    owner = "v2rayA";
    repo = "v2rayA";
    rev = "d1d4afe27370ac6de74b991a1350d767b14d8807";
    sha256 = "sha256-da5fpbNQBRvXNUe0CRbW5CjLfxYRgLUX+nlsp1JnnmA=";
  };
  web = mkYarnPackage {
    inherit pname version;
    src = "${src}/gui";

    yarnLock = ./yarn.lock;
    packageJSON = ./package.json;

    # https://github.com/webpack/webpack/issues/14532
    buildPhase = ''
      export NODE_OPTIONS=--openssl-legacy-provider
      ln -s $src/postcss.config.js postcss.config.js
      OUTPUT_DIR=$out yarn build --skip-integrity-check
    '';
    distPhase = "true";
    dontInstall = true;
    dontFixup = true;
  };
in
buildGoModule {
  inherit pname version;
  src = "${src}/service";
  vendorSha256 = "sha256-Ud4pwS0lz7zSTowg3gXNllfDyj8fu33H1L20szxPcOA=";
  subPackages = [ "." ];
  nativeBuildInputs = [ makeWrapper ];
  preBuild = ''
    cp -a ${web} server/router/web
  '';
  postInstall = ''
    wrapProgram $out/bin/v2rayA \
      --prefix PATH ":" "${lib.makeBinPath [ v2ray ]}" \
      --prefix XDG_DATA_DIRS ":" ${symlinkJoin {
        name = "assets";
        paths = [ v2ray-geoip v2ray-domain-list-community ];
      }}/share
  '';
  meta = with lib; {
    description = "A Linux web GUI client of Project V which supports V2Ray, Xray, SS, SSR, Trojan and Pingtunnel";
    homepage = "https://github.com/v2rayA/v2rayA";
    mainProgram = "v2rayA";
    license = licenses.agpl3Only;
  };
}