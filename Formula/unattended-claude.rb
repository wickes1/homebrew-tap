# typed: false
# frozen_string_literal: true

class UnattendedClaude < Formula
  desc "Demand-shifting unattended Claude Code runtime — uses your Claude Pro/Max subscription"
  homepage "https://github.com/wickes1/unattended-claude"
  url "https://github.com/wickes1/unattended-claude/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "40ac31028d82576ad54a39eee54d766e2d522372af0c1b078980a6cbd76a37b1"
  license "MIT"
  version "0.1.0"

  # `zellij` is in Homebrew core, so Homebrew auto-installs it as a dependency.
  depends_on "zellij"

  # Bun is the runtime. We vendor it via the `resource` block (per-platform
  # official binaries) so end-users don't need `brew tap oven-sh/bun` first.
  # The vendored copy lives in `libexec/vendor/bun` and is only invoked by
  # the `ucl` wrapper — it does not pollute `$PATH` or affect any other
  # Bun installation the user might already have.
  resource "bun" do
    on_macos do
      if Hardware::CPU.arm?
        url "https://github.com/oven-sh/bun/releases/download/bun-v1.2.19/bun-darwin-aarch64.zip"
        sha256 "674a48378342efaadc3c291596b573010f3c2388958f7c44678d87f6fb759991"
      else
        url "https://github.com/oven-sh/bun/releases/download/bun-v1.2.19/bun-darwin-x64.zip"
        sha256 "dfd7e4c47311b5dbd38230b3cfd357f5d0beae8ef979962c5b41008fc41c25a0"
      end
    end

    on_linux do
      if Hardware::CPU.arm?
        url "https://github.com/oven-sh/bun/releases/download/bun-v1.2.19/bun-linux-aarch64.zip"
        sha256 "fcfd471cdbd5a78fd4a390e29cccd2bb7004a49d352ba037af3b61d4fd5d0b83"
      else
        url "https://github.com/oven-sh/bun/releases/download/bun-v1.2.19/bun-linux-x64.zip"
        sha256 "c3d3c14e9a5ec83ff67d0acfe76e4315ad06da9f34f59fc7b13813782caf1f66"
      end
    end
  end

  def install
    # Stage the bun binary into libexec/vendor/bun.
    resource("bun").stage do
      bun_dir = Pathname.glob("bun-*").first
      odie "Bun resource layout unexpected — no bun-* directory found" if bun_dir.nil?
      (libexec/"vendor").mkpath
      cp bun_dir/"bun", libexec/"vendor/bun"
      chmod 0755, libexec/"vendor/bun"
    end

    # Install the source tree into libexec.
    libexec.install Dir["*"]

    # The runtime's findRepoDir() walks up looking for `.claude/skills/`;
    # expose the source-tracked `config/skills/` tree under that path.
    (libexec/".claude").mkpath
    ln_s libexec/"config/skills", libexec/".claude/skills"

    # Install runtime dependencies inside libexec using the vendored bun.
    cd libexec do
      system libexec/"vendor/bun", "install", "--production", "--frozen-lockfile"
    end

    # Wrapper script: ensure install metadata points to this libexec, then
    # exec the entrypoint via the vendored bun. The metadata is rewritten
    # when stale (e.g. after a `brew upgrade` moves the libexec path).
    (bin/"ucl").write <<~SHELL
      #!/usr/bin/env bash
      set -euo pipefail
      META_DIR="$HOME/.local/share/unattended-claude"
      META_FILE="$META_DIR/install.json"
      EXPECTED_REPO="#{libexec}"
      if [ ! -f "$META_FILE" ] || ! grep -q "$EXPECTED_REPO" "$META_FILE" 2>/dev/null; then
        mkdir -p "$META_DIR"
        cat > "$META_FILE" <<JSON
      {
        "schema_version": 1,
        "repo_root": "$EXPECTED_REPO",
        "skills_dir": "$EXPECTED_REPO/.claude/skills",
        "binary_path": "#{bin}/ucl",
        "installed_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
        "version": "#{version}"
      }
      JSON
      fi
      exec "#{libexec}/vendor/bun" "$EXPECTED_REPO/src/index.ts" "$@"
    SHELL
    chmod 0755, bin/"ucl"
  end

  def caveats
    <<~EOS
      unattended-claude needs Anthropic's `claude` CLI (Claude Code) on your
      PATH. It is not available via Homebrew — install it from
      https://docs.anthropic.com/en/docs/claude-code .

      First-run setup:
        ucl init                    # writes ~/.config/unattended-claude/ucl.yaml

      Optional: Happy Coder integration (mobile / web monitoring of
      unattended tasks). Install Happy from https://happy.engineering, then
      set `bin: happy` in ucl.yaml.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ucl --version")
  end
end
