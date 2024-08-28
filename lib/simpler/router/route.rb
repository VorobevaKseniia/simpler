module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @path_pattern = path_pattern(path)
        @controller = controller
        @action = action
      end

      def match?(method, path, env)
        @method == method && path.match(@path_pattern)

        match = path.match(@path_pattern)
        return false unless match

        @params = match.named_captures.transform_keys(&:to_sym)
        env['simpler.params'] = @params
      end

      private
      def path_pattern(path)
        Regexp.new("^#{path.gsub(/:([\w_]+)/, '(?<\1>[^\/]+)')}$")
      end
    end
  end
end



