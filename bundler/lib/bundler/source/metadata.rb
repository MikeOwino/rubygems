# frozen_string_literal: true

module Bundler
  class Source
    class Metadata < Source
      def specs
        @specs ||= Index.build do |idx|
          idx << Gem::Specification.new("Ruby\0", RubyVersion.system.to_gem_version_with_patchlevel)
          idx << Gem::Specification.new("RubyGems\0", Gem::VERSION) do |s|
            s.required_rubygems_version = Gem::Requirement.default
          end

          if local_spec = Gem.loaded_specs["bundler"]
            idx << local_spec
          end

          idx.each {|s| s.source = self }
        end
      end

      def options
        {}
      end

      def install(spec, _opts = {})
        print_using_message "Using #{version_message(spec)}"
        nil
      end

      def to_s
        "the local ruby installation"
      end

      def ==(other)
        self.class == other.class
      end
      alias_method :eql?, :==

      def hash
        self.class.hash
      end

      def version_message(spec)
        "#{spec.name} #{spec.version}"
      end
    end
  end
end
