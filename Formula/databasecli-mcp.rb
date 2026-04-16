class DatabasecliMcp < Formula
  desc "MCP server for databasecli — AI agent gateway to PostgreSQL"
  homepage "https://github.com/maximgorbatyuk/databasecli"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maximgorbatyuk/databasecli/releases/download/v0.1.6/databasecli-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "99b7a8479c88a668cf99b9302b8590cc651f200cb32f348945483caaeed43f9d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maximgorbatyuk/databasecli/releases/download/v0.1.6/databasecli-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "0ec7973c6d86cab954955b0f3420a9ebdf4a45d5936c9f27b193a1d63a3d18ab"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/maximgorbatyuk/databasecli/releases/download/v0.1.6/databasecli-mcp-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "9a2da24e70d6cc1ed2da7dfa7472d0e57834e8e36ae6911a22950907b77fc930"
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
