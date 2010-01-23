# modified version to remove dependancies from rufus-verb gem
# author: Nicolas Maisonneuve  n.maisonneuve@gmail.com

#--
# Copyright (c) 2008-2009, John Mettraux, jmettraux@gmail.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# Made in Japan.
#++


require 'rubygems'
require 'cgi'
require 'json'
require 'md5'

module Rufus
module RTM

  VERSION = '0.1.2'

  AUTH_ENDPOINT = "http://www.rememberthemilk.com/services/auth/"
  REST_ENDPOINT = "http://api.rememberthemilk.com/services/rest/"

  #
  # Signs the RTM request (sets the 'api_sig' parameter).
  #
  def self.sign (params, secret) #:nodoc:

    sig = MD5.md5(secret + params.sort.flatten.join)

    params['api_sig'] = sig.to_s

    params
  end

  #
  # Calls an API method (milk the cow).
  #
  def self.milk (params={}) #:nodoc:

    sleep 1

    endpoint = params.delete(:endpoint)
    endpoint = AUTH_ENDPOINT if endpoint == :auth
    endpoint = endpoint || REST_ENDPOINT

    ps = params.inject({}) { |r, (k, v)| r[k.to_s] = v; r }

    ps['api_key'] = params[:api_key] || ENV['RTM_API_KEY']

    raise 'API_KEY missing from environment or parameters, cannot proceed' \
      unless ps['api_key']

    ps['frob'] = params[:frob] || ENV['RTM_FROB']
    ps.delete('frob') if ps['frob'] == nil

    ps['auth_token'] = params[:auth_token] || ENV['RTM_AUTH_TOKEN']
    ps.delete('auth_token') if ps['auth_token'] == nil

    ps['format'] = 'json'

    secret = params[:shared_secret] || ENV['RTM_SHARED_SECRET']

    sign(ps, secret)

    res = get(endpoint,ps)

    JSON.parse(res)['rsp']
  end

  #
  # Requests a timeline from RTM.
  #
  def self.get_timeline #:nodoc:

    milk(:method => 'rtm.timelines.create')['timeline']
  end

  def self.get(endpoint, hash)
     query=hash.inject(""){|result, item|
       result+="#{item[0].to_s}=#{CGI.escape(item[1].to_s)}&"
     }
     url=endpoint+'?'+query[0..query.length-2]
     p url
     Net::HTTP.get(URI.parse(url))
  end

end
end

