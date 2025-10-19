class Vem < Formula
  desc "Vim Environment Manager"
  homepage "https://github.com/ryo-arima/vem"
  version "0.1.0"
  
  # Use generic Linux binaries which should work on macOS for Go applications
  if Hardware::CPU.arm?
    url "https://github.com/ryo-arima/vem/releases/download/v0.1.0-202510191002/vem-linux-aarch64.tar.gz"
    sha256 "e8602af085c911c8a6e0e1f3a769e458ba77da647f6d5ed0ef02be0542ad025d"
  else
    url "https://github.com/ryo-arima/vem/releases/download/v0.1.0-202510191002/vem-linux-x86_64.tar.gz"
    sha256 "37b51d194a7513e45b56f6524f2d51f2"  # Placeholder - will update with correct hash
  end

  def install
    # Check system architecture
    system_arch = `uname -m`.strip
    ohai "Detected system architecture: #{system_arch}"
    
    # Ensure the source binary exists and is readable
    unless File.exist?("vem")
      raise "Binary 'vem' not found in archive"
    end
    
    # Set executable permissions before installing
    chmod 0755, "vem"
    system "chmod", "+x", "vem"
    
    # Verify source binary is executable
    source_info = `file vem`.strip
    ohai "Source binary info: #{source_info}"
    
    # Install binary to Homebrew's bin directory
    bin.install "vem"
    
    # Force executable permissions after installation
    system "chmod", "755", bin/"vem"
    system "chmod", "+x", bin/"vem"
    
    # Final verification
    binary_info = `file #{bin}/vem`.strip
    ohai "Installed binary info: #{binary_info}"
    
    # Test execution permissions
    system "ls", "-la", bin/"vem"
  end

  def post_install
    # Final check and fix permissions after installation
    system "chmod", "755", bin/"vem"
    system "chmod", "+x", bin/"vem"
    ohai "Post-install: Set executable permissions on #{bin}/vem"
  end

  def caveats
    <<~EOS
      VEM has been installed to:
        #{bin}/vem

      To use VEM, make sure Homebrew's bin directory is in your PATH:
        echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc
        source ~/.zshrc

      Or for bash users:
        echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.bash_profile
        source ~/.bash_profile

      Test your installation:
        vem --version
    EOS
  end

  test do
    system "#{bin}/vem", "--version"
  end
end
