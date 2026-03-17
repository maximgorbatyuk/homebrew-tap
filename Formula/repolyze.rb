class Repolyze < Formula
  desc "Repository analytics for local Git repositories"
  homepage "https://github.com/maximgorbatyuk/repolyze"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maximgorbatyuk/repolyze/releases/download/v0.1.3/repolyze-aarch64-apple-darwin.tar.xz"
      sha256 "e39b45a1764b6319f079a6d06d15b80bac298de0b4f7c14d3d3a2094117f386c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maximgorbatyuk/repolyze/releases/download/v0.1.3/repolyze-x86_64-apple-darwin.tar.xz"
      sha256 "c6ba5aa97d1acc4175335cd212f413deb5993d94bb7f5378614580dff05f8efd"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/maximgorbatyuk/repolyze/releases/download/v0.1.3/repolyze-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ecd848ed2a6109d64b28b7c054e6c09fa2ce43d780192556f210acfd1d8b510a"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
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
    bin.install "repolyze" if OS.mac? && Hardware::CPU.arm?
    bin.install "repolyze" if OS.mac? && Hardware::CPU.intel?
    bin.install "repolyze" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
