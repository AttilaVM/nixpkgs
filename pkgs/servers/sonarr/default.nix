{ stdenv, fetchurl, mono, libmediainfo, sqlite, curl, makeWrapper, ... }:

stdenv.mkDerivation rec {
  name = "sonarr-${version}";
  version = "2.0.0.5153";

  src = fetchurl {
    url = "http://download.sonarr.tv/v2/master/mono/NzbDrone.master.${version}.mono.tar.gz";
    sha256 = "1zdsba5bpi87dhsa62qbpj55wbakl6w380pijs8qxn80bvapv3xy";
  };

  buildInputs = [
    makeWrapper
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/bin/

    makeWrapper "${mono}/bin/mono" $out/bin/NzbDrone \
      --add-flags "$out/bin/NzbDrone.exe" \
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [
          curl sqlite libmediainfo ]}
  '';

  meta = {
    description = "Smart PVR for newsgroup and bittorrent users";
    homepage = https://sonarr.tv/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.fadenb ];
    platforms = stdenv.lib.platforms.all;
  };
}
