class DatabasecliMcp < Formula
  desc "MCP server for databasecli — AI agent gateway to PostgreSQL"
  homepage "https://github.com/maximgorbatyuk/databasecli"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maximgorbatyuk/databasecli/releases/download/v0.1.1/databasecli-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "be7553f5eed2560e839d6be9003f456141ec7170ab5dedd3350485601f1884a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maximgorbatyuk/databasecli/releases/download/v0.1.1/databasecli-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "b388a1649a124d3b4e0e67ac304f78c667c11f07c546baa9c4b751199f1fd843"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/maximgorbatyuk/databasecli/releases/download/v0.1.1/databasecli-mcp-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "730b4e8e18842c41f8211479d0d2db228c289d551db337beae470047c72b2324"
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
