class DatabasecliMcp < Formula
  desc "MCP server for databasecli — AI agent gateway to PostgreSQL"
  homepage "https://github.com/maximgorbatyuk/databasecli"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maximgorbatyuk/databasecli/releases/download/v0.1.7/databasecli-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "73502b2c504eb85d6c604ca3eb25324b8c2da418a5a86f9d046f0de0c4ff1382"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maximgorbatyuk/databasecli/releases/download/v0.1.7/databasecli-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "290ab4c01e78fbde42380ac995d9cdae809c0892181ae8af00a1ade8b9fdab58"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/maximgorbatyuk/databasecli/releases/download/v0.1.7/databasecli-mcp-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "f549cde001592197d1b9c1b293bbf1f68259880b01ec23db086d7fb749990a38"
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
