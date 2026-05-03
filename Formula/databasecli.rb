class Databasecli < Formula
  desc "PostgreSQL database connection manager"
  homepage "https://github.com/maximgorbatyuk/databasecli"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maximgorbatyuk/databasecli/releases/download/v0.1.7/databasecli-aarch64-apple-darwin.tar.xz"
      sha256 "2b83b7ebc45ba5bc16ef17df50786cec8bb05fefdb9374abaab844b0455a0bf7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maximgorbatyuk/databasecli/releases/download/v0.1.7/databasecli-x86_64-apple-darwin.tar.xz"
      sha256 "f2c4eb1f941641ceeb9bff514f55a3f4edb708e611e374df53f4b1131af89098"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/maximgorbatyuk/databasecli/releases/download/v0.1.7/databasecli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "2f3506e7171dcb6f30e7ca2aebd2a4b4571719ba75c186690c6055d6114235f4"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "databasecli" if OS.mac? && Hardware::CPU.arm?
    bin.install "databasecli" if OS.mac? && Hardware::CPU.intel?
    bin.install "databasecli" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
