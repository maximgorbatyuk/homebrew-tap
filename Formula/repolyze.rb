class Repolyze < Formula
  desc "Repository analytics for local Git repositories"
  homepage "https://repolyze.app"
  version "0.1.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maximgorbatyuk/repolyze/releases/download/v0.1.9/repolyze-aarch64-apple-darwin.tar.xz"
      sha256 "54311685e1add9a972e304ce6108dfb0418f7e46981dd69a3f660994a7f59930"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maximgorbatyuk/repolyze/releases/download/v0.1.9/repolyze-x86_64-apple-darwin.tar.xz"
      sha256 "3f28b037dfc8753799760b190db4fd04a6fa9aa0cac21793034fda2d3857ad4a"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/maximgorbatyuk/repolyze/releases/download/v0.1.9/repolyze-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "f61039e1592d02a9faae990746ae7f8cef0adf57c00678469b8554a1096e82f7"
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
