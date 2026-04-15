class Repolyze < Formula
  desc "Repository analytics for local and GitHub Git repositories"
  homepage "https://repolyze.app"
  version "0.1.15"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maximgorbatyuk/repolyze/releases/download/v0.1.15/repolyze-aarch64-apple-darwin.tar.xz"
      sha256 "b6edae04b31e9e7fdf030a9064450e33c517f16ce013aafb02485577a8b13db0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maximgorbatyuk/repolyze/releases/download/v0.1.15/repolyze-x86_64-apple-darwin.tar.xz"
      sha256 "d869911264a296e2efb9cbc6948685cdee4565dfc02fcc09de1403bd59caedcc"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/maximgorbatyuk/repolyze/releases/download/v0.1.15/repolyze-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "83681f7a96940d3776c40717668b27cd9fe069357fa413c3f2b8058686766f99"
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
