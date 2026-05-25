class Libravdbd < Formula
  desc "Local LibraVDB daemon for the OpenClaw memory plugin"
  homepage "https://github.com/xDarkicex/homebrew-openclaw-libravdb-memory"
  version "1.4.89"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xDarkicex/homebrew-openclaw-libravdb-memory/releases/download/v#{version}/libravdbd-darwin-arm64"
      sha256 "21692bdb5b3a5dd72f72995eb04bad7afee14422190ac962ff62cf5fbb373bd7"
    else
      url "https://github.com/xDarkicex/homebrew-openclaw-libravdb-memory/releases/download/v#{version}/libravdbd-darwin-amd64"
      sha256 "47dcee7de686af7653b31ce4f2242d54bb890d4976bcf74d9d9685ae07ee571c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xDarkicex/homebrew-openclaw-libravdb-memory/releases/download/v#{version}/libravdbd-linux-arm64"
      sha256 "813bfc9a82f9edfbe7ec2582366479354595b340f8d276f69a97c58a09bf6e19"
    else
      url "https://github.com/xDarkicex/homebrew-openclaw-libravdb-memory/releases/download/v#{version}/libravdbd-linux-amd64"
      sha256 "300374470f4b49502226795e28cb4a4e6ad32d1780ff6a0966d749b0b4a852e2"
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

  if OS.mac?
    if Hardware::CPU.arm?
      resource "llama.cpp" do
        url "https://github.com/ggml-org/llama.cpp/releases/download/b6862/llama-b6862-bin-macos-arm64.zip"
        sha256 "8950d8f0714edbb6405ba860c24d101ec2163b4db0e68e404b901fc87a419266"
      end
    else
      resource "llama.cpp" do
        url "https://github.com/ggml-org/llama.cpp/releases/download/b6862/llama-b6862-bin-macos-x64.zip"
        sha256 "c026b27e85748805370d040776bd37c223a3f5a2e6f43e4beee005df8c5f5904"
      end
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      resource "llama.cpp" do
        url "https://github.com/xDarkicex/homebrew-openclaw-libravdb-memory/releases/download/llama-b6862-linux-arm64/llama-b6862-bin-ubuntu-arm64.zip"
        sha256 "3c026bb0b8319311dc0ba929252d3b4b6e77ff11ec5b7d5e93a345cd417705ec"
      end
    else
      resource "llama.cpp" do
        url "https://github.com/ggml-org/llama.cpp/releases/download/b6862/llama-b6862-bin-ubuntu-x64.zip"
        sha256 "39bdf1c5d0cc133b9b47e5b15bca7e8ce25176b6de1e3a650d53531b268f7739"
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
    url "https://github.com/xDarkicex/homebrew-openclaw-libravdb-memory/releases/download/v1.4.89/provision.sh"
    sha256 "c50647b31077488230284f0f0d44c4cc4435f056e7a7520884dda6afdd72ad43"
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

    llama_dir = models_dir/"llama"
    llama_dir.mkpath
    resource("llama.cpp").stage do
      # The llama.cpp zips contain a nested build/bin or just flat files depending on platform.
      # Homebrew extracts everything. We just need to find the library.
      lib_path = Dir["**/*.dylib", "**/*.so"].first
      if lib_path
        # Copy to the exact structure provision.sh creates so they match
        target_platform = if OS.mac?
                            Hardware::CPU.arm? ? "darwin-arm64" : "darwin-amd64"
                          else
                            Hardware::CPU.arm? ? "linux-arm64" : "linux-amd64"
                          end
        target_lib_dir = llama_dir/"llama-#{target_platform}/lib"
        target_lib_dir.mkpath
        cp lib_path, target_lib_dir/File.basename(lib_path)
      end
    end

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
    target_platform = if OS.mac?
                        Hardware::CPU.arm? ? "darwin-arm64" : "darwin-amd64"
                      else
                        Hardware::CPU.arm? ? "linux-arm64" : "linux-amd64"
                      end
    llama_lib_ext = OS.mac? ? "dylib" : "so"
    environment_variables LIBRAVDB_GRPC_ENDPOINT: "unix:#{var}/libravdbd/run/libravdb.sock",
                          LIBRAVDB_DB_PATH: "#{var}/libravdbd/data.libravdb",
                          LIBRAVDB_ONNX_RUNTIME: (OS.mac? ? "#{opt_prefix}/models/onnxruntime/lib/libonnxruntime.dylib" : "#{opt_prefix}/models/onnxruntime/lib/libonnxruntime.so"),
                          LIBRAVDB_LLAMA_LIB: "#{opt_prefix}/models/llama/llama-#{target_platform}/lib/libllama.#{llama_lib_ext}"
    keep_alive true
    working_dir var/"libravdbd"
    log_path var/"log/libravdbd.log"
    error_log_path var/"log/libravdbd.log"
  end

  test do
    assert_match "libravdbd", shell_output("#{bin}/libravdbd version")
  end
end
