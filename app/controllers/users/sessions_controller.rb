# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # skip_before_action :verify_signed_out_user
  respond_to :json
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    wx_code = params[:wx_code]
    ret = HTTParty.get("https://api.weixin.qq.com/sns/jscode2session?appid=#{ENV['WECHAT_APP_ID']}&secret=#{ENV['WECHAT_APP_SECRET']}&js_code=#{wx_code}&grant_type=authorization_code").body
    ret = JSON.parse(ret)
    openid = ret['openid']
    return render_ok(false) unless openid.present?

    u = User.find_by_wx_openid(openid) || User.create(wx_openid: openid)
    return render_ok(false) unless u.present?

    token = Warden::JWTAuth::UserEncoder.new.call(u, :user, nil)
    response.set_header('Authorization', "Bearer #{token[0]}")
    render json: {
      ok: true,
      self: u
    }
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private

  def respond_with(resource, _opts = {})
    render json: resource
  end

  def respond_to_on_destroy
    head :no_content
  end
end
