class DatabasecliMcp < Formula
  desc "MCP server for databasecli — AI agent gateway to PostgreSQL"
  homepage "https://github.com/maximgorbatyuk/databasecli"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maximgorbatyuk/databasecli/releases/download/v0.1.5/databasecli-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "f05846d8b8b3739629ade13655107f6cb8a93cb35391cc2d108d680719ec858b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maximgorbatyuk/databasecli/releases/download/v0.1.5/databasecli-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "402af75e0deba032285d586bf062c66f8cf143afc0b4d4488a9c551466307a4c"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/maximgorbatyuk/databasecli/releases/download/v0.1.5/databasecli-mcp-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "e5dd1dffbdfdd71e774c8532dc61ed6d8ffce93a4cb919b3a2f3a47130cfdaeb"
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
