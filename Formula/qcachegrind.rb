class Qcachegrind < Formula
  desc "Visualize data generated by Cachegrind and Calltree"
  homepage "https://kcachegrind.github.io/"
  url "https://download.kde.org/stable/release-service/21.12.1/src/kcachegrind-21.12.1.tar.xz"
  sha256 "325669fe0d33d819207b72e9b77c7c131d24685ee1586aeb54e1ecac6942a547"
  license "GPL-2.0-or-later"

  # We don't match versions like 19.07.80 or 19.07.90 where the patch number
  # is 80+ (beta) or 90+ (RC), as these aren't stable releases.
  livecheck do
    url "https://download.kde.org/stable/release-service/"
    regex(%r{href=.*?v?(\d+\.\d+\.(?:(?![89]\d)\d+)(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8619763947eaf693c010150aad23ab4c1b1e546cec7948c34b126e89e48db432"
    sha256 cellar: :any,                 arm64_big_sur:  "8619763947eaf693c010150aad23ab4c1b1e546cec7948c34b126e89e48db432"
    sha256 cellar: :any,                 monterey:       "8c1241689b6173bc6cae6a123b1db86328857bfd736b0e13fa06dd833de5f301"
    sha256 cellar: :any,                 big_sur:        "097a4341a2588f34c710791ea3e5135d45a9fe77745922f2ba566fa475f2dc33"
    sha256 cellar: :any,                 catalina:       "df370cd35ed1fe7a168a3d8937e69f5953b43c5f8a0f459697315649ee19c04a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a20772bb80ac52d434dd54acf9c364dd52dd063b51c0b62911d29b2d927f4e1a"
  end

  depends_on "graphviz"
  depends_on "qt@5"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    args = ["-config", "release", "-spec"]
    os = OS.mac? ? "macx" : OS.kernel_name.downcase
    compiler = ENV.compiler.to_s.start_with?("gcc") ? "g++" : ENV.compiler
    arch = Hardware::CPU.intel? ? "" : "-#{Hardware::CPU.arch}"
    args << "#{os}-#{compiler}#{arch}"

    system Formula["qt@5"].opt_bin/"qmake", *args
    system "make"

    if OS.mac?
      prefix.install "qcachegrind/qcachegrind.app"
      bin.install_symlink prefix/"qcachegrind.app/Contents/MacOS/qcachegrind"
    else
      bin.install "qcachegrind/qcachegrind"
    end
  end
end
