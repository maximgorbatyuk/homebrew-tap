class Repolyze < Formula
  desc "Repository analytics for local and GitHub Git repositories"
  homepage "https://repolyze.app"
  version "0.1.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maximgorbatyuk/repolyze/releases/download/v0.1.12/repolyze-aarch64-apple-darwin.tar.xz"
      sha256 "3a649b07ca4005a6b4897e166843a3b11e89a98131247238bfbec7f81bd96b47"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maximgorbatyuk/repolyze/releases/download/v0.1.12/repolyze-x86_64-apple-darwin.tar.xz"
      sha256 "adf2e13dd615ca210d6f45a1cec7560ed3cea6e60d6fe29b7f71f742015f9785"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/maximgorbatyuk/repolyze/releases/download/v0.1.12/repolyze-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "9e0cd212cb32a658e390f1c4b9764ca6dc20db2e20374d091c877005d621ce8f"
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
