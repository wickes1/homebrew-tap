# typed: false
# frozen_string_literal: true

class UnattendedClaude < Formula
  desc "Demand-shifting unattended Claude Code runtime — uses your Claude Pro/Max subscription"
  homepage "https://github.com/wickes1/unattended-claude"
  url "https://github.com/wickes1/unattended-claude/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "40ac31028d82576ad54a39eee54d766e2d522372af0c1b078980a6cbd76a37b1"
  license "MIT"
  version "0.1.0"

  depends_on "oven-sh/bun/bun"
  depends_on "zellij"

  def install
    libexec.install Dir["*"]

    # The runtime's findRepoDir() walks up looking for .claude/skills/; expose
    # the source-tracked config/skills/ tree under that path.
    (libexec/".claude").mkpath
    ln_s libexec/"config/skills", libexec/".claude/skills"

    # Install runtime dependencies inside libexec.
    cd libexec do
      system "bun", "install", "--production", "--frozen-lockfile"
    end

    bun_bin = Formula["oven-sh/bun/bun"].opt_bin/"bun"

    # Wrapper: ensure install metadata points to this libexec, then exec the
    # entrypoint via bun. The metadata is rewritten when stale (e.g. after a
    # brew upgrade moves the libexec path).
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
      exec "#{bun_bin}" "$EXPECTED_REPO/src/index.ts" "$@"
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

      For Happy Coder integration (mobile / web monitoring), install Happy
      from https://happy.engineering then set `bin: happy` in ucl.yaml.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ucl --version")
  end
end
