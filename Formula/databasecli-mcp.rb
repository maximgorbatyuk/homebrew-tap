class DatabasecliMcp < Formula
  desc "MCP server for databasecli — AI agent gateway to PostgreSQL"
  homepage "https://github.com/maximgorbatyuk/databasecli"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maximgorbatyuk/databasecli/releases/download/v0.1.2/databasecli-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "995f4c7f0bc884529929f6330e9c723829b3d7fd97125657e7880d67a3c5577c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maximgorbatyuk/databasecli/releases/download/v0.1.2/databasecli-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "dc349c2ecd0763ee2b44881476987d81fa6fb35dd8f9feb783d6b33e20728808"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/maximgorbatyuk/databasecli/releases/download/v0.1.2/databasecli-mcp-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "62f1fffb5716ca064ff41b6d5ddc0c37eba595f0e26ec616f3dbda9beade3a34"
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
    bin.install "databasecli-mcp" if OS.mac? && Hardware::CPU.arm?
    bin.install "databasecli-mcp" if OS.mac? && Hardware::CPU.intel?
    bin.install "databasecli-mcp" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
