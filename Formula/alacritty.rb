class Alacritty < Formula
  desc "A cross-platform, GPU-accelerated terminal emulator"
  homepage "https://github.com/jwilm/alacritty"
  version ""
  sha256 ""
  revision 1
  head "https://github.com/jwilm/alacritty.git",
    :revision => "31362dd3b84993f493b3f5ab0fdb00646a636276",
    :using => :git

  depends_on "rustup-init" => :build

  def install
    # Prepare
    system "rustup-init", "-y", "--no-modify-path"
    ENV.append_path "PATH", "#{ENV["CARGO_HOME"]}/bin"

    # Build
    system "make", "app"

    # Install
    prefix.install "target/release/osx/Alacritty.app"
    bin.install_symlink prefix/"Alacritty.app/Contents/MacOS/alacritty"
    pkgshare.install *Dir["alacritty*.yml"]
  end

  def caveats
    <<-EOS
    Allacritty has been installed in:
      #{prefix/"Alacritty.app"}

    You can create a symlink in the global Applications folder with the following command:
      ln -s #{prefix/"Alacritty.app"} /Applications/

    You can find a copy of the default configuration at:
      #{pkgshare/"alacritty_macos.yml"}
    EOS
  end

  test do
    (prefix/"Alacritty.app/Contents/MacOS/alacritty").executable?
    (bin/"alacritty").symlink?

    assert_equal "alacritty 0.2.0", `alacritty --version`.strip
  end
end
