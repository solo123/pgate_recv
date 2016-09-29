class RecvPostController < ApplicationController
  def notify_fun
    save_to_db(request, 'notify')
    render plain: 'true'
  end
  def callback_fun
    save_to_db(request, 'callback')
    render plain: 'true'
  end
  def save_to_db(request, method)
    header_text = request.headers["REQUEST_METHOD"] + ' '
      + request.headers["HTTP_HOST"] + request.headers["PATH_INFO"] + " "
      + request.headers["SERVER_PROTOCOL"].to_s + "\n"
      + "User-Agent: " + request.headers["User-Agent"].to_s + "\n"
      + "Accept: " + request.headers["Accept"] + "\n"
      + "Content-Type: " + request.headers['Content-Type'] + "\n"
      + "Content-Length: " + request.headers['Content-Length'] + "\n"

    rv = RecvPost.new
    rv.method = method
    rv.remote_host = request.headers['remote-addr']
    rv.header = header_text
    rv.params = request.params.to_s
    rv.detail = request.headers.to_h.ai(html: true)
    rv.status = 0
    rv.save

    case rv.remote_host
    when AppConfig.get('kaifu.host.notify')
      if rv.check_is_valid_notify
        Biz::WebBiz.notify_client(rv.kaifu_result)
      end
    when AppConfig.get('tfb.host.notify')
    end
  end


end
