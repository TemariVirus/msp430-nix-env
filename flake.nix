{
  description = "Set up msp430 GCC toolchain and mspdebug";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable"; };

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      mspgccVersion = "9.3.1.2";
      msp430Gcc = pkgs.stdenvNoCC.mkDerivation rec {
        pname = "msp430-gcc";
        version = "9.3.1.11";
        src = pkgs.fetchzip {
          url =
            "https://dr-download.ti.com/software-development/ide-configuration-compiler-or-debugger/MD-LlCjWuAbzH/${mspgccVersion}/msp430-gcc-${version}_linux64.tar.bz2";
          sha256 = "sha256-wq81AtUoFx34VtvfaJM7Y3vIwQmJg08uGjpSmloL28k=";
        };
        buildInputs = with pkgs; [ bzip2 gnutar ];
        installPhase = ''
          mkdir -p $out
          cp -r $src/* $out/
        '';
      };
      msp430GccSupport = pkgs.stdenvNoCC.mkDerivation rec {
        pname = "msp430-gcc-support-files";
        version = "1.212";
        src = pkgs.fetchzip {
          url =
            "https://dr-download.ti.com/software-development/ide-configuration-compiler-or-debugger/MD-LlCjWuAbzH/${mspgccVersion}/msp430-gcc-support-files-${version}.zip";
          sha256 = "sha256-/M7g7wP+c2ul+qQ1WCp3sDPc8veSZlhyX5KAW3AyK20=";
        };
        buildCommand = ''
          find $src/include -name '*.ld' | xargs install -Dm0644 -t $out/lib
          find $src/include -name '*.h' | xargs install -Dm0644 -t $out/include
          install -Dm0644 -t $out/include $src/include/devices.csv

          # appease bintoolsWrapper_addLDVars, search path needed for ld scripts
          touch $out/lib/lib
        '';
      };
      msp430Flasher = pkgs.stdenvNoCC.mkDerivation rec {
        pname = "MSP430Flasher";
        version = "1.03.20.00";
        src = pkgs.fetchzip {
          url =
            "https://dr-download.ti.com/software-development/software-programming-tool/MD-szn5bCveqt/${version}/MSPFlasher-1_03_20_00-linux-x64-installer.zip";
          sha256 = "sha256-gzPbqymSnEVjlIU9StvWRkKcKIzgGIdE34YpDBMl+34=";
        };
        nativeBuildInputs = with pkgs; [ autoPatchelfHook ];
        buildInputs = with pkgs; [ stdenv.cc.cc.lib ];

        postUnpack = ''
          chmod +x $sourceRoot/MSPFlasher-1.3.20-linux-x64-installer.run
          mv $sourceRoot/MSPFlasher-1.3.20-linux-x64-installer.run $sourceRoot/installer.run
        '';
        buildPhase = ''
          ls ./installer.run
          ls -l ./installer.run

          autoPatchelf ./installer.run
          ./installer.run --mode unattended --prefix ./dist
        '';
        installPhase = ''
          mkdir -p $out/bin
          mv ./dist/MSP430Flasher $out/bin/MSP430Flasher

          mkdir -p $out/lib
          mv ./dist/libmsp430.so $out/lib/libmsp430.so
        '';
      };
    in {
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = with pkgs; [ less msp430Gcc msp430Flasher mspdebug pkgs.ncurses5];
        shellHook = ''
          # Use `-I $MSP_INC` to include msp430 headers
          export MSP_INC="${pkgs.lib.makeIncludePath [ msp430GccSupport ]}"
          export LD_LIBRARY_PATH="${
            pkgs.lib.makeLibraryPath [ msp430Flasher pkgs.ncurses5 ]
          }:$LD_LIBRARY_PATH"
        '';
      };
    };
}
