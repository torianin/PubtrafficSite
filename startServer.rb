#-*- coding: utf-8 -*-

require 'sinatra'
require 'haml'
require 'coffee-script'
require 'sass'
require 'json'
require 'data_mapper'

DataMapper.setup(:default, 'mysql://my3339_pt:h54gre34rfeq@localhost/my3339_pubtraffic')

class Pub
include DataMapper::Resource
  property :id, Serial, :key => true
  property :name, String
  property :discription, Text
  property :latlng, String
  property :users, String
  property :max, String
end

class User
  include DataMapper::Resource
  property :id, Integer
  property :nick, String
  property :card, String, :key => true
  property :gender, String
  property :email, String
  property :pub, String
  property :friends, Text
end

get '/' do
  haml :index
end

get '/app.js' do
  coffee :app
end

get '/contact' do
	haml :contact
end

get '/css/style.css' do
   sass :stylesheet, :style => :expanded
end

get '/api/pubs.json' do
  content_type :json
  pubs = Pub.all
  ids = Array.new
  pubs.each {|x| ids << x.id}
  names = Array.new
  pubs.each {|x| names << x.name}
  discriptions = Array.new
  pubs.each {|x| discriptions << x.discription}
  latlngs = Array.new
  pubs.each {|x| latlngs << x.latlng}
  users = Array.new
  for i in 0...pubs.count do
    users[i] = YAML.load(pubs[i].users)
  end
  maxs = Array.new
  pubs.each {|x| maxs << x.max}
  {:id => ids, :name => names, :discription => discriptions , :latlng => latlngs,:users => users, :max => maxs}.to_json
end


