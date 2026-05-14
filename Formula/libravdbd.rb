class Libravdbd < Formula
  desc "Local LibraVDB daemon for the OpenClaw memory plugin"
  homepage "https://github.com/xDarkicex/homebrew-openclaw-libravdb-memory"
  version "1.4.66"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xDarkicex/homebrew-openclaw-libravdb-memory/releases/download/v#{version}/libravdbd-darwin-arm64"
      sha256 "7b35894cecd13fa0656df7b064ac63d96fad3598ed62628320fdacef956268e0"
    else
      url "https://github.com/xDarkicex/homebrew-openclaw-libravdb-memory/releases/download/v#{version}/libravdbd-darwin-amd64"
      sha256 "2257eb50f97ff7cf5a12b03fbb706c1df6839bc09c32a16687f5cf74bae61839"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xDarkicex/homebrew-openclaw-libravdb-memory/releases/download/v#{version}/libravdbd-linux-arm64"
      sha256 "a5fc5e8db169abc6d062af5b9ffa8f003fd19d79a139c911292f4464007b16bf"
    else
      url "https://github.com/xDarkicex/homebrew-openclaw-libravdb-memory/releases/download/v#{version}/libravdbd-linux-amd64"
      sha256 "f42e2fa71dd33a9eb764a27c4b68e4dafcff4b60ceb7c858bcd3e026ae38c0d8"
    end
  end

  if OS.mac?
    if Hardware::CPU.arm?
      resource "onnxruntime" do
        url "https://github.com/microsoft/onnxruntime/releases/download/v1.25.1/onnxruntime-osx-arm64-1.25.1.tgz"
        sha256 "18987ec3187b5f29ba798109750f6135060560ad4e0a52678fcc753ee8fb3091"
      end
    else
      # Intel Mac: Microsoft dropped x86_64 macOS binaries after v1.23.0.
      # Hosted from our own build at a permanent release tag.
      resource "onnxruntime" do
        url "https://github.com/xDarkicex/homebrew-openclaw-libravdb-memory/releases/download/ort-darwin-amd64-v1.25.1/onnxruntime-osx-x86_64-1.25.1.tgz"
        sha256 "a6bbd18a17fbbd651cfa331e5361520684e7501da3b73f0a01c79c95433fa007"
      end
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      resource "onnxruntime" do
        url "https://github.com/microsoft/onnxruntime/releases/download/v1.25.1/onnxruntime-linux-aarch64-1.25.1.tgz"
        sha256 "daa71b56b00c4ab34798a3d96ca41a32ece4d3e302dc2386d3cca83fd4491214"
      end
    else
      resource "onnxruntime" do
        url "https://github.com/microsoft/onnxruntime/releases/download/v1.25.1/onnxruntime-linux-x64-1.25.1.tgz"
        sha256 "eb566a49cfc49ef0642f809b69340b5bb656c7c4905ba873526d226f2c005816"
      end
    end
  end

  resource "nomic-embed-text-v1.5-model" do
    url "https://huggingface.co/nomic-ai/nomic-embed-text-v1.5/resolve/main/onnx/model.onnx"
    sha256 "147d5aa88c2101237358e17796cf3a227cead1ec304ec34b465bb08e9d952965"
  end

  resource "nomic-embed-text-v1.5-tokenizer" do
    url "https://huggingface.co/nomic-ai/nomic-embed-text-v1.5/resolve/main/tokenizer.json"
    sha256 "d241a60d5e8f04cc1b2b3e9ef7a4921b27bf526d9f6050ab90f9267a1f9e5c66"
  end

  resource "bge-small-en-v1.5-model" do
    url "https://huggingface.co/BAAI/bge-small-en-v1.5/resolve/main/onnx/model.onnx"
    sha256 "828e1496d7fabb79cfa4dcd84fa38625c0d3d21da474a00f08db0f559940cf35"
  end

  resource "bge-small-en-v1.5-tokenizer" do
    url "https://huggingface.co/BAAI/bge-small-en-v1.5/resolve/main/tokenizer.json"
    sha256 "d241a60d5e8f04cc1b2b3e9ef7a4921b27bf526d9f6050ab90f9267a1f9e5c66"
  end


  resource "provision" do
    url "https://github.com/xDarkicex/homebrew-openclaw-libravdb-memory/releases/download/v1.4.66/provision.sh"
    sha256 "0d6fca56798807bdc8f34c94b4375bb74adcfce6f1427527b30b6a11e7c1f130"
  end

  def install
    bin.install Dir["libravdbd*"].first => "libravdbd"

    models_dir = prefix/"models"
    runtime_dir = models_dir/"onnxruntime"
    nomic_dir = models_dir/"nomic-embed-text-v1.5"
    bge_dir = models_dir/"bge-small-en-v1.5"

    runtime_dir.mkpath
    nomic_dir.mkpath
    bge_dir.mkpath

    resource("onnxruntime").stage do
      # Homebrew may auto-strip the top-level dir from the tgz
      subdir = Dir["onnxruntime-*"].first
      if subdir
        cp_r "#{subdir}/.", runtime_dir
      else
        cp_r ".", runtime_dir
      end
    end

    resource("nomic-embed-text-v1.5-model").stage do
      cp "model.onnx", nomic_dir/"model.onnx"
    end
    resource("nomic-embed-text-v1.5-tokenizer").stage do
      cp "tokenizer.json", nomic_dir/"tokenizer.json"
    end
    write_embedding_manifest(nomic_dir, "nomic-embed-text-v1.5", 768)

    resource("bge-small-en-v1.5-model").stage do
      cp "model.onnx", bge_dir/"model.onnx"
    end
    resource("bge-small-en-v1.5-tokenizer").stage do
      cp "tokenizer.json", bge_dir/"tokenizer.json"
    end
    write_embedding_manifest(bge_dir, "bge-small-en-v1.5", 384)

    resource("provision").stage do
      libexec.install "provision.sh"
    end
    chmod 0755, libexec/"provision.sh"
  end

  def post_install
    (var/"libravdbd").mkpath
    (var/"libravdbd/run").mkpath
  end

  def caveats
    <<~EOS
      libravdbd requires ONNX embedding models to function.  Models are
      automatically provisioned during `brew install`.  To re-provision
      or repair assets manually:

        #{libexec}/provision.sh --target #{prefix}/models

      Data directory:   #{var}/libravdbd
      Database file:    #{var}/libravdbd/data.libravdb
      Socket directory: #{var}/libravdbd/run
    EOS
  end

  private

  def write_embedding_manifest(dir, profile, dimensions)
    File.write(dir/"embedding.json", <<~JSON)
      {
        "backend": "onnx-local",
        "profile": "#{profile}",
        "family": "#{profile}",
        "model": "model.onnx",
        "tokenizer": "tokenizer.json",
        "dimensions": #{dimensions},
        "normalize": true,
        "inputNames": ["input_ids", "attention_mask", "token_type_ids"],
        "outputName": "last_hidden_state",
        "pooling": "mean",
        "addSpecialTokens": true
      }
    JSON
  end


  service do
    run [opt_bin/"libravdbd", "serve"]
    environment_variables LIBRAVDB_RPC_ENDPOINT: "unix:#{var}/libravdbd/run/libravdb.sock",
                          LIBRAVDB_DB_PATH: "#{var}/libravdbd/data.libravdb",
                          LIBRAVDB_ONNX_RUNTIME: (OS.mac? ? "#{opt_prefix}/models/onnxruntime/lib/libonnxruntime.dylib" : "#{opt_prefix}/models/onnxruntime/lib/libonnxruntime.so")
    keep_alive true
    working_dir var/"libravdbd"
  end

  test do
    assert_match "libravdbd", shell_output("#{bin}/libravdbd version")
  end
end
