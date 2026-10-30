class MarinaTheReviewer < Formula
  desc "Prepare and validate AI code and architecture reviews"
  homepage "https://github.com/maximgorbatyuk/marina-the-reviewer"
  url "https://github.com/maximgorbatyuk/marina-the-reviewer/releases/download/v0.1.1/marina-the-reviewer_0.1.1_source.tar.gz"
  sha256 "27b744b58b65742866455587a0920d3774d22098f2e77606517103031b22b71e"
  license "MIT"

  depends_on "go" => :build
  depends_on "git"

  def install
    buildinfo = "github.com/maximgorbatyuk/marina-the-reviewer/internal/buildinfo"
    ldflags = "-s -w -X #{buildinfo}.Version=#{version} -X #{buildinfo}.Commit=7c193a92bdf4feb0a51a6b787719d2ae0964e409"
    system "go", "build", *std_go_args(output: bin/"marinadoreview", ldflags: ldflags), "./cmd/marinadoreview"
  end

  test do
    identity = JSON.parse(shell_output("#{bin}/marinadoreview --version --json"))
    assert_equal "marina-the-reviewer", identity.fetch("tool")
    assert_equal version.to_s, identity.fetch("version")
    assert_match "marina-the-reviewer", shell_output("#{bin}/marinadoreview capabilities --json")
    mkdir "repo" do
      system "git", "init", "--initial-branch=dev"
      (testpath/"repo/main.go").write("package main\nfunc main() {}\n")
      system "git", "add", "main.go"
      system "git", "-c", "user.name=Test", "-c", "user.email=test@example.invalid", "commit", "-m", "base"
      (testpath/"repo/main.go").atomic_write("package main\nfunc main() { println(1) }\n")
      system "git", "add", "main.go"
      system "git", "-c", "user.name=Test", "-c", "user.email=test@example.invalid", "commit", "-m", "head"
      system bin/"marinadoreview", "prepare", "--repo", ".", "--base", "HEAD~1", "--head", "HEAD",
             "--output", "snapshot.json"
      assert_path_exists testpath/"repo/snapshot.json"
      system bin/"marinadoreview", "plan", "--input", "snapshot.json", "--base-url", "http://127.0.0.1:1",
             "--model", "offline-test", "--no-fallback", "--output", "plan.json"
      batch = JSON.parse((testpath/"repo/plan.json").read).fetch("prepared").fetch("batches").first
      (testpath/"repo/batch.json").write(JSON.generate(batch))
      ids = batch.fetch("input").fetch("batch").fetch("blocks").map { |block| block.fetch("id") }
      model = { checkedBlockIds: ids, findings: [], strengths: [], unconfirmedDependencies: [] }
      (testpath/"repo/model.json").write(JSON.generate(model))
      system bin/"marinadoreview", "validate", "--input", "batch.json", "--model-output", "model.json",
             "--format", "marina-v3", "--output", "validated.json"
      assert_equal true, JSON.parse((testpath/"repo/validated.json").read).fetch("isComplete")
    end
  end
end
