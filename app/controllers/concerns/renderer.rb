module Renderer
  include ActiveSupport::Concern

  def render_ok(ok_value = true, message = nil)
    body = { ok: ok_value }
    body[:message] = message if message
    render json: body
  end
end
