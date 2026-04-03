class Libravdbd < Formula
  desc "Local LibraVDB daemon for the OpenClaw memory plugin"
  homepage "https://github.com/xDarkicex/openclaw-memory-libravdb"
  version "1.3.16"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xDarkicex/openclaw-memory-libravdb/releases/download/v#{version}/libravdbd-darwin-arm64"
      sha256 "22478e974aa280daeb5f63f3a5997ca8de37fc97e185c013014905bf3f3303f9"
    else
      url "https://github.com/xDarkicex/openclaw-memory-libravdb/releases/download/v#{version}/libravdbd-darwin-amd64"
      sha256 "a8343466900f30f12a25598c0ae760794ee150a01d7ffda69f79fcea92e0bfb4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xDarkicex/openclaw-memory-libravdb/releases/download/v#{version}/libravdbd-linux-arm64"
      sha256 "cd649dc88018ede44addbe957b134ba9aaf6f76d6f984c32dafdcc2ad5282882"
    else
      url "https://github.com/xDarkicex/openclaw-memory-libravdb/releases/download/v#{version}/libravdbd-linux-amd64"
      sha256 "684849334a4230f089ba0eb2b79c93edc123bc895c9b6025ae1e8fb150073d98"
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
