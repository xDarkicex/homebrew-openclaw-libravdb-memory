class Libravdbd < Formula
  desc "Local LibraVDB daemon for the OpenClaw memory plugin"
  homepage "https://github.com/xDarkicex/homebrew-openclaw-libravdb-memory"
  version "1.4.61"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xDarkicex/homebrew-openclaw-libravdb-memory/releases/download/v#{version}/libravdbd-darwin-arm64"
      sha256 "28ebe7e7a6b73daf1881db1e87ffd961af3d811a795ce63c997e8e772899cd96"
    else
      url "https://github.com/xDarkicex/homebrew-openclaw-libravdb-memory/releases/download/v#{version}/libravdbd-darwin-amd64"
      sha256 "b2c54ff264e22c2bcc8832180dfbe1a9dc0648fb649d727e86bb462d48aa93e0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xDarkicex/homebrew-openclaw-libravdb-memory/releases/download/v#{version}/libravdbd-linux-arm64"
      sha256 "62b10c11907149817f8e21d975dfa879bd19271284f41aafafaf5c45319f449c"
    else
      url "https://github.com/xDarkicex/homebrew-openclaw-libravdb-memory/releases/download/v#{version}/libravdbd-linux-amd64"
      sha256 "70eb0e6f8ed15df5e2673d34950a8ba4fe30e9cf996f31e0fddd69b3c54a8458"
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
    url "https://github.com/xDarkicex/homebrew-openclaw-libravdb-memory/releases/download/v1.4.61/provision.sh"
    sha256 "9102a44e0f6e19928c67bcd2abffc4d16bb56d631200c8db299627e6e48ff6a7"
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
