require 'logger'
class SimplerLogger
  def initialize(app, **options)
    @app = app
    @logger = Logger.new(options[:logdev] || STDOUT)
  end

  def call(env)
    request = Rack::Request.new(env)
    response = @app.call(env)

    @logger.info(make_log(request))

    response
  end

  private
  def make_log(request)
    msg = [
      "\nRequest: #{request.request_method} #{request.path}\n",
      "Handler: #{controller}##{action}\n",
      "Parameters: #{params}\n",
      "Response: #{status} [#{content_type}] #{template}\n"
    ]
    msg.join('').to_s
  end

  def path
    @app.controller.request
  end

  def controller
    @app.controller.class.name
  end

  def action
    @app.controller.request.env['simpler.action']
  end

  def params
    @app.controller.params
  end

  def status
    @app.controller.response.status
  end

  def content_type
    @app.controller.response.content_type
  end

  def template
    template = @app.controller.request.env['simpler.template']
    "#{template}.html.erb" if template
  end

end