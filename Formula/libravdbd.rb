class Libravdbd < Formula
  desc "Local LibraVDB daemon for the OpenClaw memory plugin"
  homepage "https://github.com/xDarkicex/openclaw-memory-libravdb"
  version "1.3.10"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xDarkicex/openclaw-memory-libravdb/releases/download/v#{version}/libravdbd-darwin-arm64"
      sha256 "1bfdeb01bafff401b3bc9c2f9c7a16ae5854e2686076139880f053f7f4c5dde0"
    else
      url "https://github.com/xDarkicex/openclaw-memory-libravdb/releases/download/v#{version}/libravdbd-darwin-amd64"
      sha256 "2f35b3781b9e1b4a480c1d49ba5bb971324953c1c650a7b495e8b6ee1a93d2c9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xDarkicex/openclaw-memory-libravdb/releases/download/v#{version}/libravdbd-linux-arm64"
      sha256 "2e2da43bab1d21ec819edf2f013671b0c5a483d3cf092cd4ea3ba9590bc456bf"
    else
      url "https://github.com/xDarkicex/openclaw-memory-libravdb/releases/download/v#{version}/libravdbd-linux-amd64"
      sha256 "471d56273fb467aa4ffb05b582a553055c7b270917880c1c8ea955d464d7cf09"
    end
  end

  def install
    bin.install Dir["libravdbd*"].first => "libravdbd"
  end

  service do
    run [opt_bin/"libravdbd", "serve"]
    environment_variables LIBRAVDB_RPC_ENDPOINT: "unix:#{ENV["HOME"]}/.clawdb/run/libravdb.sock"
    keep_alive true
    working_dir ENV["HOME"]
  end

  test do
    assert_match "libravdbd", shell_output("#{bin}/libravdbd version")
  end
end
