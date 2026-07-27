class Libravdbd < Formula
  desc "Local LibraVDB daemon for the OpenClaw memory plugin"
  homepage "https://github.com/xDarkicex/homebrew-openclaw-libravdb-memory"
  version "1.9.35"
  license "Proprietary"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xDarkicex/homebrew-openclaw-libravdb-memory/releases/download/v#{version}/libravdbd-darwin-arm64"
      sha256 "62c457361d99d99f1091ce433e746b16265aab98dc28c5ba4f8f6ebb7e2e9044"
    else
      url "https://github.com/xDarkicex/homebrew-openclaw-libravdb-memory/releases/download/v#{version}/libravdbd-darwin-amd64"
      sha256 "4578119ccf63039ac92dd6e6bc8fd02636575a8612c9d37adb02652aeb5a4cd2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xDarkicex/homebrew-openclaw-libravdb-memory/releases/download/v#{version}/libravdbd-linux-arm64"
      sha256 "4fc2126bcf5dfb184e17e6d83d91809247e2a3ffe82f39e9bf4d91e69f03b2d8"
    else
      url "https://github.com/xDarkicex/homebrew-openclaw-libravdb-memory/releases/download/v#{version}/libravdbd-linux-amd64"
      sha256 "18044a766f45bd570be94f5841cb5b099ddaf179b34af206eacd0cd74f937a78"
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
        sha256 "aac7f2f3e7f7b495d6c9948c9fecfe667837f72696027181d96e18b4591680ba"
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

  resource "nomic-embed-text-v1.5-gguf" do
    url "https://huggingface.co/nomic-ai/nomic-embed-text-v1.5-GGUF/resolve/main/nomic-embed-text-v1.5.Q8_0.gguf"
    sha256 "3e24342164b3d94991ba9692fdc0dd08e3fd7362e0aacc396a9a5c54a544c3b7"
  end


  resource "provision" do
    url "https://github.com/xDarkicex/homebrew-openclaw-libravdb-memory/releases/download/v1.9.35/provision.sh"
    sha256 "297b24e979de3fc70cda1dbdf3c47403c0ac178a7d1d1f402e8debb978b9d758"
  end

  resource "cognitive-scanner-model" do
    url "https://github.com/xDarkicex/homebrew-openclaw-libravdb-memory/releases/download/cognitive-scanner-v1/cognitive_scanner.bin"
    sha256 "f84f77a0dd19c2d8a118a226a08c78735141aa7567c14c2d9d55cd14eb3de2a4"
  end

  def install
    bin.install Dir["libravdbd*"].first => "libravdbd"

    models_dir = prefix/"models"

    # Install cognitive scanner model alongside embedding models
    cognitive_dir = models_dir/"cognitive"
    cognitive_dir.mkpath
    resource("cognitive-scanner-model").stage do
      cp "cognitive_scanner.bin", cognitive_dir/"cognitive_scanner.bin"
    end

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
      # The llama.cpp zips contain multiple .dylib/.so files.
      # Copy ALL of them so libllama.dylib is not missed.
      target_platform = if OS.mac?
                          Hardware::CPU.arm? ? "darwin-arm64" : "darwin-amd64"
                        else
                          Hardware::CPU.arm? ? "linux-arm64" : "linux-amd64"
                        end
      target_lib_dir = llama_dir/"llama-#{target_platform}/lib"
      target_lib_dir.mkpath
      Dir["**/*.dylib", "**/*.so"].each do |lib_file|
        cp lib_file, target_lib_dir/File.basename(lib_file)
      end
    end

    # Install GGUF model — searched in <exe>/models/<profile>/ by resolveGGUFModelPath
    resource("nomic-embed-text-v1.5-gguf").stage do
      cp "nomic-embed-text-v1.5.Q8_0.gguf", nomic_dir/"nomic-embed-text-v1.5.Q8_0.gguf"
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
      The daemon defaults to the ONNX embedding backend. A faster native GGUF /
      llama.cpp backend is also available. A GGUF model and libllama are
      provisioned alongside the ONNX assets during `brew install`.

      To enable the GGUF backend, set the environment variable:

        LIBRAVDB_EMBEDDING_BACKEND=gguf

      or add `embedding_backend: gguf` to your config YAML. A worked template:
        https://github.com/xDarkicex/openclaw-memory-libravdb/blob/main/docs/yaml/default-gguf.yaml

      To re-provision or repair assets manually:

        #{libexec}/provision.sh --target #{prefix}/models

      The required cognitive scanner model (about 488 MiB) is installed at:

        #{opt_prefix}/models/cognitive/cognitive_scanner.bin

      The Homebrew service configures this path automatically. When launching
      libravdbd under another supervisor, set LIBRAVDB_COGNITIVE_SCANNER_MODEL
      to that path. Homebrew verifies the model checksum during install and
      upgrade; the daemon does not download it at runtime.

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
    llama_lib = "#{opt_prefix}/models/llama/llama-#{target_platform}/lib/libllama.#{llama_lib_ext}"
    onnx_runtime = if OS.mac?
      "#{opt_prefix}/models/onnxruntime/lib/libonnxruntime.dylib"
    else
      "#{opt_prefix}/models/onnxruntime/lib/libonnxruntime.so"
    end
    environment_variables(
      LIBRAVDB_GRPC_ENDPOINT:           "unix:#{var}/libravdbd/run/libravdb.sock",
      LIBRAVDB_DB_PATH:                 "#{var}/libravdbd/data.libravdb",
      LIBRAVDB_ONNX_RUNTIME:            onnx_runtime,
      LIBRAVDB_LLAMA_LIB:               llama_lib,
      LIBRAVDB_COGNITIVE_SCANNER_MODEL: "#{opt_prefix}/models/cognitive/cognitive_scanner.bin",
    )
    keep_alive true
    working_dir var/"libravdbd"
    log_path var/"log/libravdbd.log"
    error_log_path var/"log/libravdbd.log"
  end

  test do
    scanner_model = prefix/"models/cognitive/cognitive_scanner.bin"
    assert_path_exists scanner_model
    assert_equal "f84f77a0dd19c2d8a118a226a08c78735141aa7567c14c2d9d55cd14eb3de2a4", scanner_model.sha256
    assert_includes service.to_systemd_unit,
                    "LIBRAVDB_COGNITIVE_SCANNER_MODEL=#{opt_prefix}/models/cognitive/cognitive_scanner.bin"
    assert_match "libravdbd", shell_output("#{bin}/libravdbd version")
  end
end
