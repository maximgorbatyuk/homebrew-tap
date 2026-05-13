class Databasecli < Formula
  desc "PostgreSQL database connection manager"
  homepage "https://github.com/maximgorbatyuk/databasecli"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maximgorbatyuk/databasecli/releases/download/v0.1.8/databasecli-aarch64-apple-darwin.tar.xz"
      sha256 "04af030d04475aa6110ba2598b967253f71627fa2d36fbf6b5a16edae2f9a72b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maximgorbatyuk/databasecli/releases/download/v0.1.8/databasecli-x86_64-apple-darwin.tar.xz"
      sha256 "ae203fdb4fcc9bc0ea8ab83a635d77eccc1f72ed259f4acbf6028d232f5e38dc"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/maximgorbatyuk/databasecli/releases/download/v0.1.8/databasecli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "afe509cecac7ab0d12baa1546cff67cebf2cc11a61ce315607d16276ebd41782"
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
