class Databasecli < Formula
  desc "PostgreSQL database connection manager"
  homepage "https://github.com/maximgorbatyuk/databasecli"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maximgorbatyuk/databasecli/releases/download/v0.1.4/databasecli-aarch64-apple-darwin.tar.xz"
      sha256 "3c57a4d687b6319f0b2c67f909e09fc57f399aed179dee5ba2f4345945b62b8b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maximgorbatyuk/databasecli/releases/download/v0.1.4/databasecli-x86_64-apple-darwin.tar.xz"
      sha256 "f1422309bc61b3e850e29dd354a5c60c8b75b8daaeb365517c2671705908877c"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/maximgorbatyuk/databasecli/releases/download/v0.1.4/databasecli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "e58e32341f9c3934d7011a4ce12cb25962a0a782b2d3a6b2ca0908585d905fbc"
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
