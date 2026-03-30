class Libravdbd < Formula
  desc "Local LibraVDB daemon for the OpenClaw memory plugin"
  homepage "https://github.com/xDarkicex/openclaw-memory-libravdb"
  version "1.3.11"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xDarkicex/openclaw-memory-libravdb/releases/download/v#{version}/libravdbd-darwin-arm64"
      sha256 "5f0bca5faa71324e5cfe2ec9ea0ab857a01fd24feabbc66600627158e874598e"
    else
      url "https://github.com/xDarkicex/openclaw-memory-libravdb/releases/download/v#{version}/libravdbd-darwin-amd64"
      sha256 "9eac61b90356780ab8ac68ba14515da6d38e2ae5e95aa61190352b905b537f48"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xDarkicex/openclaw-memory-libravdb/releases/download/v#{version}/libravdbd-linux-arm64"
      sha256 "149bb3785938bef037d2592db84f552444baa2d45257c4b97c48c41e942b06fd"
    else
      url "https://github.com/xDarkicex/openclaw-memory-libravdb/releases/download/v#{version}/libravdbd-linux-amd64"
      sha256 "68e470918c85ef2b0da90359085bd6c911308029396385e24babbab58f5aee87"
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
