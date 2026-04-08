class Repolyze < Formula
  desc "Repository analytics for local and GitHub Git repositories"
  homepage "https://repolyze.app"
  version "0.1.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maximgorbatyuk/repolyze/releases/download/v0.1.10/repolyze-aarch64-apple-darwin.tar.xz"
      sha256 "e0a968d403656a407803808d7dc1fc378be2aee043dae0e84cd3dc9d8fcf6542"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maximgorbatyuk/repolyze/releases/download/v0.1.10/repolyze-x86_64-apple-darwin.tar.xz"
      sha256 "22964aa4f4e821254dff9d574f8271b4a4d18b758d80367c6cc315f1af4c3078"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/maximgorbatyuk/repolyze/releases/download/v0.1.10/repolyze-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "32c3ab9c7862f67ddb00fbb8a97e829d219e2787b67e9824ec90b734bebba92c"
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
