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

    zone = WMBIND::Zone.new(File.join(File.dirname(__FILE__), 'spec/data/' + params[:zone]))
    soa = zone.soa

    soa = { 'ttl' => soa.ttl, 'serial' => soa.serial,
      'refresh' => soa.refresh, 'retry' => soa.retry,
      'expire' => soa.expire, 'minimum' => soa.minimum,
      'ns' => soa.mname.to_s + '.', 'email' => soa.rname.to_s + '.' }
    
    { 'name' => zone.name, 'ttl' => zone.ttl, 'soa' => soa }.to_json
  end
end

