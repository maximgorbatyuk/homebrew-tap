class Databasecli < Formula
  desc "PostgreSQL database connection manager"
  homepage "https://github.com/maximgorbatyuk/databasecli"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maximgorbatyuk/databasecli/releases/download/v0.1.3/databasecli-aarch64-apple-darwin.tar.xz"
      sha256 "e15dcd9ee9c2aac7109c2793eefb3eed56ec8ca43d4eba41b21f76e1d6d92727"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maximgorbatyuk/databasecli/releases/download/v0.1.3/databasecli-x86_64-apple-darwin.tar.xz"
      sha256 "0d1d1f302a157d626b0a971d29b09b13f306a09cf5a3e2be9353daedaf275d9d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/maximgorbatyuk/databasecli/releases/download/v0.1.3/databasecli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "3fe2e7d177a5b352aadd2b163861ffb7ab6f6181da94683c3867981ff2d904a9"
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
