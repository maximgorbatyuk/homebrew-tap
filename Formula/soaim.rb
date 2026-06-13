class Soaim < Formula
  desc "Swearing on AI Meter — count swear words across your local AI-coding prompt history."
  homepage "https://github.com/maximgorbatyuk/swearing-on-ai-meter"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maximgorbatyuk/swearing-on-ai-meter/releases/download/v0.1.0/soaim-aarch64-apple-darwin.tar.xz"
      sha256 "89b21e0aca42169e1c2c45ae231806d0db67bc4b97d8e988ca9719a01eb1a5f8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maximgorbatyuk/swearing-on-ai-meter/releases/download/v0.1.0/soaim-x86_64-apple-darwin.tar.xz"
      sha256 "cf895ddb097dab0b920652b7a45aaff3fedda5a9dbd842c58035005f11746962"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/maximgorbatyuk/swearing-on-ai-meter/releases/download/v0.1.0/soaim-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "afac03560cd530aa558d98d3e756ae072406e4d6e81c94f42f74a6e5895bcc24"
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
    bin.install "soaim" if OS.mac? && Hardware::CPU.arm?
    bin.install "soaim" if OS.mac? && Hardware::CPU.intel?
    bin.install "soaim" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
