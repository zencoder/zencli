module ZenCLI
  class Versionize

    def self.[](*version)
      self.new(*version)
    end

    def self.current
      file = "#{Dir.pwd}/VERSION.yml"
      if File.exist?(file)
        self.new(file)
      else
        ZenCLI::Log("No version file found (looking for #{file}).", :color => :red)
        exit(1)
      end
    end

    def initialize(*version)
      @version = case version.first
      when String
        YAML.load_file(version.first)
      when Hash
        version.first
      else
        {
          "major" => version[0],
          "minor" => version[1],
          "patch" => version[2],
          "pre"   => version[3]
        }
      end
    end

    def self.update(level=:patch)
      new_version = ZenCLI::Versionize.current.bump(level)
      new_version.save
      ZenCLI::Shell["git add VERSION.yml && git commit -m 'Bumping version to #{new_version}.'"]
      new_version
    end

    def bump(level)
      raise "Invalid version part" unless [:major, :minor, :patch].include?(level.to_sym)
      new_version = case level.to_sym
      when :major then [major+1, 0, 0]
      when :minor then [major, minor+1, 0]
      when :patch then [major, minor, patch+1]
      end
      Versionize[*new_version]
    end

    def major
      @version['major']
    end

    def minor
      @version['minor']
    end

    def patch
      @version['patch']
    end

    def pre
      @version['pre']
    end

    def to_hash
      @version.dup
    end

    def to_a
      [major, minor, patch, pre]
    end

    def to_s
      n = to_a[0..2]
      n << pre unless pre.nil?
      n.join(".")
    end

    def save(path="VERSION.yml")
      File.open(path, 'w') do |out|
        YAML.dump(@version, out)
      end
    end
  end
end
