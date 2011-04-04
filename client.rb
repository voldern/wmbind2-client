require 'bundler'
require 'sinatra/base'
require 'json'
require File.join(File.dirname(__FILE__), 'lib/wmbind')

class WMBINDClient < Sinatra::Base
  get '/' do
    content_type :json
    { 'hostname' => WMBIND::Server.hostname,
      'uname' => WMBIND::Server.uname,
      'bind' => WMBIND::Server.bind }.to_json
  end

  get '/zone/:zone' do
    content_type :json

    zone = WMBIND::Zone.new(File.join(File.dirname(__FILE__),
                                      'spec/data/' + params[:zone]))
    soa = zone.soa

    soa = { 'ttl' => soa.ttl, 'serial' => soa.serial,
      'refresh' => soa.refresh, 'retry' => soa.retry,
      'expire' => soa.expire, 'minimum' => soa.minimum,
      'ns' => domain_to_s(soa.mname), 'email' => soa.rname.to_s + '.' }
    
    { 'name' => zone.name, 'ttl' => zone.ttl, 'soa' => soa }.to_json
  end

  get '/zone/:zone/records' do
    content_type :json

    zone = WMBIND::Zone.new(File.join(File.dirname(__FILE__),
                                      'spec/data/' + params[:zone]))

    zone.records.to_json
  end

  private
  def domain_to_s(path)
    if path.absolute?
      path.to_s + '.'
    else
      path.to_s
    end
  end
end

