class Databasecli < Formula
  desc "PostgreSQL database connection manager"
  homepage "https://github.com/maximgorbatyuk/databasecli"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maximgorbatyuk/databasecli/releases/download/v0.1.6/databasecli-aarch64-apple-darwin.tar.xz"
      sha256 "1530f1d47bc76d565c37168285f1149c7c4c18717d2827fa2e174b3996c62e6c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maximgorbatyuk/databasecli/releases/download/v0.1.6/databasecli-x86_64-apple-darwin.tar.xz"
      sha256 "10ee9c4a5a600475b1898d6907166e6be1116c20991efb0c0af2ae235b31180f"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/maximgorbatyuk/databasecli/releases/download/v0.1.6/databasecli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "99189badb6b73510c9248d4c8ac8f95ecfb3f5a196cfdc01fd1cc1c75f6c24d3"
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
